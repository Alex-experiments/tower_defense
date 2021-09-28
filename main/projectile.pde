class Projectile{
  float x, y;
  float speed, size;
  float direction;

  int dmg_done_this_frame;
  float prev_x, prev_y;
  
  ArrayList<Mob> already_dmged_mobs=new ArrayList<Mob>();
  
  boolean has_max_range=false;
  float max_range;
  
  int damage;            // Correspond au nombre de layers max qu'on peut pop à un ballon
  boolean can_bounce=false, is_seeking=false;
  float max_bounce_distance, seeking_force_intensity, seeking_max_distance = 200.;
  int pierce;            //  pierce correspond au nombre d'ennemis maximum touchable : indépendant du fait qu'on puisse rebondir ou pas
                         // Si on veut rebondir un maximum de 2 fois, il faut mettre can_bounce=true et pierce = 2
                         
                         //pour l'instant lorsque que qqch explose, il explose dès qu'il rencontre un enemi et son pierce revient donc à son explosion !
                         
  String damage_type, projectile_type;
  boolean explose = false, explosion_stuns=false, blows_away = false;
  float explosion_stun_duration;
  int explosion_diameter;
  StringList stronger_against = new StringList();    //certains projectiles ont de meilleurs dégats selon le type d'enemis. (pas pris en compte dans explosion)
  int stronger_against_damage;
  
  color couleur;  
  boolean rotate=false;
  float rotation_angle=0., rotation_speed;
  ArrayList<int[]> sprites_pos;
  
  Tower fired_from_tower;
   
  
  Projectile(Tower fired_from_tower, float x_dep, float y_dep, float direction, String projectile_type){
    x=x_dep;
    y=y_dep;
    this.direction=direction;
    this.fired_from_tower=fired_from_tower;
    this.projectile_type = projectile_type;
    
    set_stats();
    sprites_pos = get_sprites_pos(new StringList(projectile_type));
    if(sprites_pos.size()==0)  sprites_pos = get_sprites_pos(new StringList("dart"));    //pour avoir un sprite dart de base
  }
  
  void core(int i, int nb_proj){
    this.deplacement();
    this.kill();
    if(this.out_of_map() || this.pierce<=0){
      projectiles.remove(i);
      return;
    }
    if(nb_proj - i<500) this.show();   //on affiche que les 300 derniers crées pour éviter tout lag
  }
    
  void verif_damage_type(){
    if(damage_type.equals(get_damage_type(projectile_type)))  return;
    println("NOT GOOD ! Projectile :", projectile_type, "gives", damage_type, "and", get_damage_type(projectile_type));
  }
  
  void show(){
    //fill(couleur);
    //noStroke();
    //ellipse(x, y, size, size);
    if(rotate)   rotation_angle+=rotation_speed;
    pushMatrix();
    translate(x, y);
    rotate(direction+HALF_PI+rotation_angle);
    for(int[] pos_aff : sprites_pos)    image(all_sprites, 0, 0, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
    popMatrix();

  }
  
  void deplacement(){
    prev_x=x;
    prev_y=y;
    if(is_seeking && enemis.size()>0){
      Mob target = get_closest_enemi();
      if(target == null || distance(new float[] {target.x, target.y}, new float[] {x, y}) > seeking_max_distance){
        x+=cos(direction)*speed * joueur.game_speed;  //on applique un déplacement normal si : target trop loin ou si on a deja tappe tous les mobs encore en vie et deja spawn
        y+=sin(direction)*speed * joueur.game_speed;
      }
      else{
        // a savoir : je ne constraint() pas la speed ici ce qui fait que cette derniere n'est pas constante, mais franchement pas grave c'est meme plutot sympa
        float force_dir = atan2(target.y-y, target.x-x);
        x += (cos(direction)*speed + cos(force_dir) * seeking_force_intensity) * joueur.game_speed;
        y += (sin(direction)*speed + sin(force_dir) * seeking_force_intensity) * joueur.game_speed;
        direction = atan2(y-prev_y, x-prev_x);
      }
    }
    else{
      x+=cos(direction)*speed * joueur.game_speed;
      y+=sin(direction)*speed * joueur.game_speed;
    }
  }
  
  Mob get_closest_enemi(){
    float dist, dist_min = Float.POSITIVE_INFINITY;
    Mob closest_mob = null;
    for(Mob mob : enemis){
      dist = distance(new float[] {mob.x, mob.y}, new float[] {x, y});
      if(dist < dist_min && !already_dmged_mobs.contains(mob)){
        closest_mob = mob;
        dist_min = dist;
      }
    }
    return closest_mob;
  }
  
  boolean out_of_map(){
    if(has_max_range && distance(new float[] {x, y}, new float[] {fired_from_tower.x, fired_from_tower.y})>max_range)  return true;    //si on a excédé la max range
    return (x+size)/2<0 || (x-size)/2>width || (y+size)/2<0 || (y-size)/2>height;
  }
  
  boolean collision(float[] pos_mob, float size_mob){
    
    //Lors de son déplacement, si le projectile a une trop grand vitesse, il a pu passer d'un coté à l'autre de l'enemi
    //C'est pourquoi on recherche le point le plus proche entre la ligne qu'il a parcouru et l'enemi
    
    myLine.x1=prev_x;
    myLine.x2=x;
    myLine.y1=prev_y;
    myLine.y2=y;
    
    return myLine.getDistance(pos_mob[0], pos_mob[1]).z < (size+size_mob)/2;    //Dans le cas des hitbox rondes
  }
  
  
  void kill(){
    dmg_done_this_frame=0;
    //on fait des degats aux enemis
    boolean hit_someone=false;
    float[] pos_of_enemi_hitted= new float[]{0, 0};    //ceci sert a repositionner le projectile pile la ou etait le mob pour éviter les trajectoires bizarres si il a dépassé le mob
    
    
    for (int i = enemis.size() - 1; i >= 0; i--){
      Mob mob = enemis.get(i);
      if(can_detect(mob, fired_from_tower.detects_camo) && pierce>0 && collision(new float[] {mob.x, mob.y}, mob.size) && !already_dmged_mobs.contains(mob)){
        if(explose){
          explosions.add(new Explosion(fired_from_tower, mob.x, mob.y, explosion_diameter, damage, pierce, damage_type, explosion_stuns, explosion_stun_duration));
          pierce=0;
          return;
        }
        pos_of_enemi_hitted=new float[] {mob.x, mob.y};
        hit(mob);
        pierce--;
        hit_someone=true;
        if(pierce<=0)  break;
      }
    }
    
    
    if(hit_someone && can_bounce && pierce>0 && enemis.size()>0){
      //si on peut ricocher (capacité+touché qqn pendant ce déplacement) et qu'il reste des enemis
      Mob closest_mob=enemis.get(0);
      float dist_min=max_bounce_distance+1;    
      for(Mob mob : enemis){
        if(can_detect(mob, fired_from_tower.detects_camo) && distance(new float[] {mob.x, mob.y}, new float[] {x, y})<dist_min && already_dmged_mobs.contains(mob)==false){
          closest_mob=mob;
          dist_min=distance(new float[] {mob.x, mob.y}, new float[] {x, y});
        }
      }
      if(dist_min<max_bounce_distance){      //si dist_min n'a pas bougé, closest_mob sera enemis.get(0), or cela veut dire qu'on la deja tappé
        x=pos_of_enemi_hitted[0];
        y=pos_of_enemi_hitted[1];
        //float[] collision_pos=map_1(closest_mob.avancement+closest_mob.speed);      //on vise la où la cible va etre  //INUTILE DE PREVOIR JUSTE UN COUP D'AVANCE
        //direction=atan2(collision_pos[1]-y, collision_pos[0]-x);              //on se redirige vers le mob le plus proche
        direction=atan2(closest_mob.y-y, closest_mob.x-x);
      }
      else{
        pierce = 0;              //tous les enemis sont trop loin
      }
    }
    
    if(hit_someone && can_bounce && enemis.size()==0)  pierce=0;    //pour faire disparaite les projectiles rebondissant
    
    fired_from_tower.add_pop_count(dmg_done_this_frame);
  }
  
  
  void hit(Mob mob){
    if(damage>0){
      int dmg_to_deal = damage;
      
      for(String type : stronger_against){
        if(type.indexOf(mob.type)>=0){        //oblige de mettre un indexOf pasque si on veut focus plus les ceramic, ca peut très bien etre des ceramicbasic ou ceramic regrow etc
          dmg_to_deal = stronger_against_damage;
          break;
        }
      }
      int layers_popped=mob.pop_layers(dmg_to_deal, true, damage_type);      //on tappe le mob
      dmg_done_this_frame+=layers_popped;
      
      for(Mob dmged_mob : mob.bloons_dmged()){
        already_dmged_mobs.add(dmged_mob);
        if(blows_away){
          if(projectile_type.equals("tornado"))  dmged_mob.apply_effect("blow away far", 0.);
          else if(projectile_type.indexOf("shuriken")>=0){
            if(random(0., 1.)<=.2)  dmged_mob.apply_effect("blow away distraction", 0.);    //les shuriken ayant la capacité distraction ont 20% de chance (piffé) de blow away
          }
          else println("ERROR : projectile", projectile_type, "blows away and does damage but not implemented");
        }
      }
      
      if(mob.layers<=0)  enemis.remove(mob);
    }
    else{  //c'est donc forcément qu'on blow_away avec une tornado qui fait 0 dégats
      mob.apply_effect("blow away", 0.);
    }
  }
  
  void set_stats(){
    switch(projectile_type){
      case "dart":
        speed = 20.; size=14.;
        damage = 1; pierce = 1;
        damage_type = "sharp";
        break;
      case "dart ball":
        speed = 20.; size=28;
        damage = 1; pierce = 18;
        damage_type = "shatter";
        break;
      case "sharp dart ball":
        speed = 20.; size=28;
        damage = 1; pierce = 19;
        damage_type = "shatter";
        break;
      case "razor sharp dart ball":
        speed = 20.; size=28;
        damage = 1; pierce = 21;
        damage_type = "shatter";
        break;
      case "huge dart ball":
        speed = 20.; size=72;
        damage = 1; pierce = 100;
        damage_type = "normal";
        stronger_against.append("ceramic");
        stronger_against_damage = 5;
        break;
      case "sharp huge dart ball":
        speed = 20.; size=72;
        damage = 1; pierce = 101;
        damage_type = "normal";
        stronger_against.append("ceramic");
        stronger_against_damage = 5;
        break;
      case "razor sharp huge dart ball":
        speed = 20.; size=72;
        damage = 1; pierce = 103;
        damage_type = "normal";
        stronger_against.append("ceramic");
        stronger_against_damage = 5;
        break;
      case "sharp dart":
        speed = 20.; size=14.;
        damage = 1; pierce = 2;
        damage_type = "sharp";
        break;
      case "powerful dart":
        speed = 30.; size=14.;
        damage = 1; pierce = 3;
        damage_type = "sharp";
        break;
      case "razor sharp dart":
        speed = 20.; size=14.;
        damage = 1; pierce = 4;
        damage_type = "sharp";
        break;
      case "tack":
        speed = 10.; size=11.;
        damage = 1; pierce = 1;
        damage_type = "sharp";
        has_max_range = true;
        max_range = fired_from_tower.range;
        break;
      case "blade":
        speed = 10.; size=38.;
        damage = 1; pierce = 2;
        damage_type = "sharp";
        has_max_range = true;
        max_range = fired_from_tower.range;
        break;
      case "maelstrom blade":
        speed = 20.; size=38.;
        damage = 1; pierce = int(Float.POSITIVE_INFINITY);
        damage_type = "sharp";
        break;
      case "glaive ricochet":
        speed = 15.; size=50.;
        damage = 1; pierce = 100;
        damage_type = "sharp";
        can_bounce = true;
        max_bounce_distance = 130.;
        rotate=true;
        rotation_speed = PI/16;
        break;
      case "sonic glaive ricochet":
        speed = 15.; size=50.;
        damage = 1; pierce = 100;
        damage_type = "shatter";
        can_bounce = true;
        max_bounce_distance = 130.;
        rotate=true;
        rotation_speed = PI/16;
        break;
      case "red hot glaive ricochet":
        speed = 15.; size=50.;
        damage = 1; pierce = 100;
        damage_type = "normal";
        can_bounce = true;
        max_bounce_distance = 130.;
        rotate=true;
        rotation_speed = PI/16;
        break;   
      case "laser cannon":
        speed = 20.; size=25.;
        damage = 1; pierce = 13;
        damage_type = "shatter";
        break;
      case "powerful laser cannon":
        speed = 20.; size=25.;
        damage = 1; pierce = 16;
        damage_type = "shatter";
        break;
      case "bloontonium laser cannon":
        speed = 20.; size=25.;
        damage = 1; pierce = 16;
        damage_type = "normal";
        break;
      case "bloontonium dart":
        speed = 30.; size=14.;
        damage = 1; pierce = 3;
        damage_type = "normal";
        break;
      case "hydra rocket":
        speed = 30.; size=23.;
        damage = 1; pierce = 40;
        damage_type = "normal";
        explose = true;
        explosion_diameter = 60;
        break;
      case "purple ball":
        speed = 10.; size=25.;
        damage = 1; pierce = 2;
        damage_type = "normal";
        break;
      case "huge purple ball":
        speed = 10.; size=31.;
        damage = 1; pierce = 7;
        damage_type = "normal";
        break;
      case "fireball":
        speed = 20.; size=26.;
        damage = 1; pierce = 40;
        damage_type = "normal";
        explose = true;
        explosion_diameter = 60;
        break;
      case "dragon's breath":
        speed = 15.; size=26.;
        damage = 2; pierce = 1;
        damage_type = "normal";
        has_max_range = true;
        max_range = fired_from_tower.range;
        break;
      case "whirlwind":
        speed = 10.; size = 30.;
        damage = 0; pierce = 25;
        damage_type = "normal";
        blows_away = true;
        has_max_range = true;
        max_range = fired_from_tower.range;    //dans le cas d'une whirlwind : on recule entre 40% et 70% de la longueur du track, contre 60% à 100% pour une tornado
        break;
      case "tornado":
        speed = 20.; size = 30.;
        damage = 1; pierce = 70;
        damage_type = "normal";
        blows_away = true;
        break;
      case "shuriken":
        speed = 20.; size=27.;
        damage = 1; pierce = 2;
        damage_type = "sharp";
        break;
      case "sharp shuriken":
        speed = 20.; size=27.;
        damage = 1; pierce = 4;
        damage_type = "sharp";
        break;
      case "seeking shuriken":
        speed = 15.; size=27.;
        damage = 1; pierce = 2;
        damage_type = "sharp";
        is_seeking = true;
        seeking_force_intensity = 6.;
        if(this.fired_from_tower.path_2_progression>=2)  blows_away = true;
        break;
      case "seeking sharp shuriken":
        speed = 15.; size=27.;
        damage = 1; pierce = 4;
        damage_type = "sharp";
        is_seeking = true;
        seeking_force_intensity = 6.;
        if(this.fired_from_tower.path_2_progression>=2)  blows_away = true;
        break;
      case "flash bomb":
        speed = 20.; size=40.;
        damage = 1; pierce = 60;
        damage_type = "normal";
        explose=true;
        explosion_diameter = 330;
        explosion_stuns = true;
        explosion_stun_duration = .75;
        break;
      default:
        println("ERROR : can't assign any projectile type with ", projectile_type);
        break;
    }  
  }
  
}
