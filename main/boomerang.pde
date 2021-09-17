class Boomerang{
  float x, y, prev_x, prev_y;
  
  float angle_dep;
  float size=10;
  
  int avancement=0;
  
  float centre_x, centre_y, rayon_cercle;
  Tower fired_from_tower;
  float speed;
  int dmg_done_this_frame;
  
  int pierce, damage;
  
  boolean orbiting=false;
  
  ArrayList<Mob> already_dmged_mobs=new ArrayList<Mob>();
  
  String boomerang_type, damage_type;

  
  Boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle){
    this.centre_x=centre_x;
    this.centre_y=centre_y;
    this.rayon_cercle=rayon_cercle;
    this.fired_from_tower = fired_from_tower;
    angle_dep = atan2(fired_from_tower.y - centre_y, fired_from_tower.x - centre_x); 
    
    x=fired_from_tower.x;  //sinon ca chie avec collision() car sachant que prev_x n'a pas de valeur par défault ca sera 0...
    y=fired_from_tower.y;
  }
  
  void core(){
    update();
    if(!orbiting && (ended_circle() || pierce<=0))  boomerangs.remove(this);
    else  show();
  }
  
  void verif_damage_type(){
    if(damage_type.equals(get_damage_type(boomerang_type)))  return;
    println("NOT GOOD ! Projectile :", boomerang_type, "gives", damage_type, "and", get_damage_type(boomerang_type));
  }
  
  void update(){
    deplacement();
    kill();
  }
  
  void show(){
    fill(0, 0, 0);
    noStroke();
    ellipse(x, y, size, size);
    stroke(0);
    strokeWeight(1);
    line(prev_x, prev_y, x, y);
    //afficher les glaives differements
  }
  
  boolean ended_circle(){
    if(orbiting){
      avancement %= 2*PI*rayon_cercle;    //un boomerang orbitant depuis des années pourrait dépasser la limite des floats
      return false;
    }
    return avancement/rayon_cercle>=2*PI;
  }
  
  void deplacement(){
    avancement+=speed * joueur.game_speed;
    prev_x=x;
    prev_y=y;
    x = centre_x + rayon_cercle * cos(-avancement/rayon_cercle + angle_dep);
    y = centre_y + rayon_cercle * sin(-avancement/rayon_cercle + angle_dep);
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
    
    for (int i = enemis.size() - 1; i >= 0; i--){
      Mob mob = enemis.get(i);
      if(can_detect(mob, fired_from_tower.detects_camo) && pierce>0 && collision(new float[] {mob.x, mob.y}, mob.size) && !already_dmged_mobs.contains(mob)){
        hit(mob);
        if( !orbiting) pierce--;
        if(pierce<=0)  break;
      }
    }
    
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

class Basic_boomerang extends Boomerang{
  
  static final float speed = 15., size=10.;
  static final int damage = 1, pierce = 3;
  static final String damage_type = "sharp", boomerang_type = "basic boomerang";
  
  Basic_boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle){
    super(fired_from_tower, centre_x, centre_y, rayon_cercle);
  } 
  
}

class Multi_target_boomerang extends Boomerang{
  
  static final float speed = 15., size=10.;
  static final int damage = 1, pierce = 7;
  static final String damage_type = "sharp", boomerang_type = "multi target boomerang";
  
  Multi_target_boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle){
    super(fired_from_tower, centre_x, centre_y, rayon_cercle);
  } 
  
}

class Sonic_multi_target_boomerang extends Boomerang{
  
  static final float speed = 15., size=10.;
  static final int damage = 1, pierce = 7;
  static final String damage_type = "shatter", boomerang_type = "sonic multi target boomerang";
  
  Sonic_multi_target_boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle){
    super(fired_from_tower, centre_x, centre_y, rayon_cercle);
  } 
  
}

class Red_hot_multi_target_boomerang extends Boomerang{
  
  static final float speed = 15., size=10.;
  static final int damage = 1, pierce = 7;
  static final String damage_type = "normal", boomerang_type = "red hot multi target boomerang";
  
  Red_hot_multi_target_boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle){
    super(fired_from_tower, centre_x, centre_y, rayon_cercle);
  } 
  
}

class Glaive_boomerang extends Boomerang{
  
  static final float speed = 15., size=38.;
  static final int damage = 1, pierce = 12;
  static final String damage_type = "sharp", boomerang_type = "glaive boomerang";
  
  Glaive_boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle){
    super(fired_from_tower, centre_x, centre_y, rayon_cercle);
  } 
  
}

class Sonic_glaive_boomerang extends Boomerang{
  
  static final float speed = 15., size=38.;
  static final int damage = 1, pierce = 12;
  static final String damage_type = "shatter", boomerang_type = "sonic glaive boomerang";
  
  Sonic_glaive_boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle){
    super(fired_from_tower, centre_x, centre_y, rayon_cercle);
  } 
  
}
class Red_hot_glaive_boomerang extends Boomerang{
  
  static final float speed = 15., size=38.;
  static final int damage = 1, pierce = 12;
  static final String damage_type = "normal", boomerang_type = "red hot glaive boomerang";
  
  Red_hot_glaive_boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle){
    super(fired_from_tower, centre_x, centre_y, rayon_cercle);
  } 
  
}
