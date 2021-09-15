class Projectile{
  float x;
  float y;
  float speed;
  float direction;
  float size;

  float dmg_done_this_frame;
  float prev_x;
  float prev_y;
  
  ArrayList<Mob> already_dmged_mobs=new ArrayList<Mob>();
  
  boolean has_max_range=false;
  float max_range;
  
  int damage;            // Correspond au nombre de layers max qu'on peut pop à un ballon
  boolean can_bounce;
  float max_bounce_distance;
  int pierce;            //  pierce correspond au nombre d'ennemis maximum touchable : indépendant du fait qu'on puisse rebondir ou pas
                         // Si on veut rebondir un maximum de 2 fois, il faut mettre can_bounce=true et pierce = 2
                         
  String projectile_type;
  StringList hit_exceptions;
  boolean explose = false;
  int explosion_diameter;
  color couleur;  
  boolean rotate=false;
  float rotation_angle=0;
  float rotation_speed;
  
  Tower fired_from_tower;
   
  
  Projectile(Tower fired_from_tower, float x_dep, float y_dep, float speed, float direction, int damage, int pierce, boolean can_bounce, String projectile_type, StringList hit_exceptions){
    x=x_dep;
    y=y_dep;
    this.speed=speed;
    this.direction=direction;
    this.damage=damage;
    this.pierce=pierce;
    this.can_bounce=can_bounce;
    this.hit_exceptions=hit_exceptions;
    
    if(can_bounce)  max_bounce_distance=fired_from_tower.projectile_max_bounce_distance;
    
    this.projectile_type=projectile_type;          //ca servira pour plus tard
    
    this.fired_from_tower=fired_from_tower;
    
    set_size();
    if(projectile_type.equals("rocket") || projectile_type.equals("fireball") || projectile_type.equals("flash bomb")){
      explose=true;
      explosion_diameter=60;
      if(projectile_type.equals("flash bomb"))  explosion_diameter=330;
    }
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
  
  void show(){
    //fill(couleur);
    //noStroke();
    //ellipse(x, y, size, size);
    int[] pos_aff;
    if(pos_coins_sprites.containsKey(projectile_type)){
      pos_aff = pos_coins_sprites.get(projectile_type);
    }
    else{
      pos_aff = pos_coins_sprites.get("dart");
    }
    if(rotate)  rotation_angle+=rotation_speed;
    
    translate(x, y);
    rotate(direction+PI/2+rotation_angle);
    translate(-x, -y);
    image(all_sprites, x, y, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
    translate(x, y);
    rotate(-direction-PI/2-rotation_angle);
    translate(-x, -y);
  }
  
  void set_size(){
        
    switch(projectile_type){
      case "dart":
        size=6;
        couleur=color(0);
        break;
      case "blade":
        size=38;
        couleur=color(144);
        rotate=true;
        rotation_speed=PI/16;
        break;
      case "boomerang":
        //jamais detecté
        size=10;
        couleur=color(255, 242, 0);
        break;
      case "glaive":
        size=38;
        couleur=color(144);
        break;
      case "tack":
        size=5;
        couleur=color(0);
        break;
      case "huge spike ball":
        size=20;
        couleur=color(50);
        break;
      case "spike ball":
        size=15;
        couleur=color(50);
        break;
      case "purple ball":
        size=9;
        couleur=color(0, 155, 213);
        break;
      case "huge purple ball":
        size=14;
        couleur=color(255, 0, 255);
        break;
      case "flame":
        size = 15;
        couleur=color(255, 0, 0);
        break;
      case "shuriken":
        size=7;
        couleur=color(100);
        rotate=true;
        rotation_speed=PI/16;
        break;
      default:
        size=6;
        couleur=color(0);
        break;
    }
  }
  
  void deplacement(){
    prev_x=x;
    prev_y=y;
    x+=cos(direction)*speed * joueur.game_speed;
    y+=sin(direction)*speed * joueur.game_speed;
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
          explosions.add(new Explosion(fired_from_tower, mob.x, mob.y, explosion_diameter, damage, pierce, hit_exceptions));
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
    
    fired_from_tower.pop_count+=dmg_done_this_frame;
    joueur.game_pop_count += dmg_done_this_frame;
  }
  
  
  void hit(Mob mob){
    int layers_popped=mob.pop_layers(damage, true, projectile_type, hit_exceptions);      //on tappe le mob
    dmg_done_this_frame+=layers_popped;
    
    for(Mob dmged_mob : mob.bloons_dmged()){
      already_dmged_mobs.add(dmged_mob);
    }
    
    
    if(mob.layers<=0)  enemis.remove(mob);
  }
  
}
