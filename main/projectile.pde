class Projectile{
  float x, y;
  float speed, size;
  float direction;

  float dmg_done_this_frame;
  float prev_x, prev_y;
  
  ArrayList<Mob> already_dmged_mobs=new ArrayList<Mob>();
  
  boolean has_max_range=false;
  float max_range;
  
  int damage;            // Correspond au nombre de layers max qu'on peut pop à un ballon
  boolean can_bounce;
  float max_bounce_distance;
  int pierce;            //  pierce correspond au nombre d'ennemis maximum touchable : indépendant du fait qu'on puisse rebondir ou pas
                         // Si on veut rebondir un maximum de 2 fois, il faut mettre can_bounce=true et pierce = 2
                         
  String damage_type, projectile_type;
  boolean explose = false;
  int explosion_diameter;
  color couleur;  
  boolean rotate=false;
  float rotation_angle=0, rotation_speed;
  
  Tower fired_from_tower;
   
  
  Projectile(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    x=x_dep;
    y=y_dep;
    this.direction=direction;
    this.fired_from_tower=fired_from_tower;
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
          explosions.add(new Explosion(fired_from_tower, mob.x, mob.y, explosion_diameter, damage, pierce, damage_type));
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
    int layers_popped=mob.pop_layers(damage, true, damage_type);      //on tappe le mob
    dmg_done_this_frame+=layers_popped;
    
    for(Mob dmged_mob : mob.bloons_dmged()){
      already_dmged_mobs.add(dmged_mob);
    }
    
    
    if(mob.layers<=0)  enemis.remove(mob);
  }
  
}


class Dart extends Projectile{
  static final float speed = 20., size=14.;
  static final int damage = 1, pierce = 1;
  static final String damage_type = "sharp", projectile_type = "dart";
  
  Dart(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Dart_ball extends Projectile{
  static final float speed = 20., size=28;
  static final int damage = 1, pierce = 18;
  static final String damage_type = "shatter", projectile_type = "dart ball";
  
  Dart_ball(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Huge_dart_ball extends Projectile{    //il faut implémenter le fait que ca fasse 5 dmg aux céramics
  static final float speed = 20., size=72;
  static final int damage = 1, pierce = 100;
  static final String damage_type = "normal", projectile_type = "huge dart ball";
  
  Huge_dart_ball(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Sharp_dart extends Projectile{
  static final float speed = 20., size=14.;
  static final int damage = 1, pierce = 2;
  static final String damage_type = "sharp", projectile_type = "sharp dart";
  
  Sharp_dart(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}
class Powerful_dart extends Projectile{
  static final float speed = 30., size=14.;
  static final int damage = 1, pierce = 3;
  static final String damage_type = "sharp", projectile_type = "powerful dart";
  
  Powerful_dart(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Razor_sharp_dart extends Projectile{
  static final float speed = 20., size=14.;
  static final int damage = 1, pierce = 4;
  static final String damage_type = "sharp", projectile_type = "razor sharp dart";
  
  Razor_sharp_dart(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Tack extends Projectile{
  static final float speed = 10., size=11.;
  static final int damage = 1, pierce = 1;
  static final String damage_type = "sharp", projectile_type = "tack";
  
  Tack(Tower fired_from_tower, float x_dep, float y_dep, float direction, float max_range){
    super(fired_from_tower, x_dep, y_dep, direction);
    this.has_max_range = true;
    this.max_range = max_range;
  } 
}

class Blade extends Projectile{
  static final float speed = 10., size=38.;
  static final int damage = 1, pierce = 2;
  static final String damage_type = "sharp", projectile_type = "blade";
  
  Blade(Tower fired_from_tower, float x_dep, float y_dep, float direction, float max_range){
    super(fired_from_tower, x_dep, y_dep, direction);
    this.has_max_range = true;
    this.max_range = max_range;
  } 
}

class Blade_maelstrom_proj extends Projectile{
  static final float speed = 10., size=38.;
  static final int damage = 1;
  int pierce = int(Float.POSITIVE_INFINITY);
  static final String damage_type = "sharp", projectile_type = "blade maelstrom";
  
  Blade_maelstrom_proj(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Glaive_ricochet extends Projectile{
  
  static final float speed = 15., size=50.;
  static final int damage = 1, pierce = 100;
  static final String damage_type = "sharp", projectile_type = "glaive ricochet" ;
  
  Glaive_ricochet(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
    this.can_bounce = true;
    this.max_bounce_distance = 130.;
  } 
  
}

class Sonic_glaive_ricochet extends Projectile{
  
  static final float speed = 15., size=50.;
  static final int damage = 1, pierce = 100;
  static final String damage_type = "shatter", projectile_type = "sonic glaive ricochet";
  
  Sonic_glaive_ricochet(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
    this.can_bounce = true;
    this.max_bounce_distance = 130.;
  } 
  
}

class Red_hot_glaive_ricochet extends Projectile{
  
  static final float speed = 15., size=50.;
  static final int damage = 1, pierce = 100;
  static final String damage_type = "normal", projectile_type = "red hot glaive ricochet";
  
  Red_hot_glaive_ricochet(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
    this.can_bounce = true;
    this.max_bounce_distance = 130.;
  } 
  
}

class Laser_cannon extends Projectile{
  
  static final float speed = 20., size=14.;
  static final int damage = 1, pierce = 13;
  static final String damage_type = "shatter", projectile_type = "laser cannon";
  
  Laser_cannon(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Bloontonium_laser_cannon extends Projectile{
  
  static final float speed = 20., size=14.;
  static final int damage = 1, pierce = 13;
  static final String damage_type = "normal", projectile_type = "bloontonium laser cannon";
  
  Bloontonium_laser_cannon(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Ray_of_doom extends Projectile{            // AAAATTENTION : a enlever des projectiles en vrai c'est pas comme ca que ca fonctionne
  
  static final float speed = 20., size=14.;
  static final int damage = 1, pierce = 100;
  static final String damage_type = "normal", projectile_type = "ray of doom";
  
  Ray_of_doom(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Bloontonium_dart extends Projectile{
  static final float speed = 30., size=14.;
  static final int damage = 1, pierce = 3;
  static final String damage_type = "normal", projectile_type = "bloontonium dart";
  
  Bloontonium_dart(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Hydra_rocket extends Projectile{
  static final float speed = 30., size=23.;
  static final int damage = 1, pierce = 3;
  static final String damage_type = "normal", projectile_type = "hydra rocket";
  
  Hydra_rocket(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
    this.explose = true;
    this.explosion_diameter = 60;
  } 
}

class Purple_ball extends Projectile{
  static final float speed = 10., size=20.;
  static final int damage = 1, pierce = 2;
  static final String damage_type = "normal", projectile_type = "purple ball";
  
  Purple_ball(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Huge_purple_ball extends Projectile{
  static final float speed = 10., size=46.;
  static final int damage = 1, pierce = 7;
  static final String damage_type = "normal", projectile_type = "huge purple ball";
  
  Huge_purple_ball(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Fireball extends Projectile{
  static final float speed = 20., size=26.;
  static final int damage = 1, pierce = 40;
  static final String damage_type = "normal", projectile_type = "fireball";
  
  Fireball(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
    this.explose = true;
    this.explosion_diameter = 60;
  } 
}

class Flame extends Projectile{
  static final float speed = 40., size=26.;
  static final int damage = 2, pierce = 1;
  static final String damage_type = "normal", projectile_type = "flame";
  
  Flame(Tower fired_from_tower, float x_dep, float y_dep, float direction, float max_range){
    super(fired_from_tower, x_dep, y_dep, direction);
    this.has_max_range = true;
    this.max_range = max_range;
  } 
}

class Shuriken extends Projectile{
  static final float speed = 20., size=27.;
  static final int damage = 1, pierce = 2;
  static final String damage_type = "sharp", projectile_type = "shuriken";
  
  Shuriken(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Sharp_shuriken extends Projectile{
  static final float speed = 20., size=27.;
  static final int damage = 1, pierce = 4;
  static final String damage_type = "sharp", projectile_type = "sharp shuriken";
  
  Sharp_shuriken(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
  } 
}

class Seeking_shuriken extends Projectile{
  static final float speed = 20., size=27.;
  static final int damage = 1, pierce = 4;
  static final String damage_type = "sharp", projectile_type = "seeking shuriken";
  
  Seeking_shuriken(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
    can_bounce=true;
    max_bounce_distance = 130;
  } 
}

class Flash_bomb extends Projectile{
  static final float speed = 20., size=27.;
  static final int damage = 1, pierce = 60;
  static final String damage_type = "normal", projectile_type = "flash bomb";
  
  Flash_bomb(Tower fired_from_tower, float x_dep, float y_dep, float direction){
    super(fired_from_tower, x_dep, y_dep, direction);
    explose=true;
    explosion_diameter = 330;
  } 
}
