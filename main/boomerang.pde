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
  boolean rotate=true;
  float rotation_angle=0., rotation_speed=PI/16;

  
  Boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle, String boomerang_type){
    this.centre_x=centre_x;
    this.centre_y=centre_y;
    this.rayon_cercle=rayon_cercle;
    this.fired_from_tower = fired_from_tower;
    this.boomerang_type = boomerang_type;
    angle_dep = atan2(fired_from_tower.y - centre_y, fired_from_tower.x - centre_x); 
    
    x=fired_from_tower.x;  //sinon ca chie avec collision() car sachant que prev_x n'a pas de valeur par défault ca sera 0...
    y=fired_from_tower.y;
    
    set_stats();
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

    int[] pos_aff;
    if(pos_coins_sprites.containsKey(boomerang_type)){
      pos_aff = pos_coins_sprites.get(boomerang_type);
      if(rotate){
        rotation_angle+=rotation_speed;
        pushMatrix();
        translate(x, y);
        rotate(HALF_PI+rotation_angle);
        image(all_sprites, 0, 0, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
        popMatrix();
      }
      else  image(all_sprites, x, y, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
    }
    else{
      fill(0, 0, 0);
      noStroke();
      ellipse(x, y, size, size);
      stroke(0);
      strokeWeight(1);
      line(prev_x, prev_y, x, y);
    }
    
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
    
    fired_from_tower.add_pop_count(dmg_done_this_frame);
  }
  
  
  void hit(Mob mob){
    int layers_popped=mob.pop_layers(damage, true, damage_type);      //on tappe le mob
    dmg_done_this_frame+=layers_popped;
    
    for(Mob dmged_mob : mob.bloons_dmged()){
      already_dmged_mobs.add(dmged_mob);
    }
    
    
    if(mob.layers<=0)  enemis.remove(mob);
  }


  void set_stats(){
    switch(boomerang_type){
      case "basic boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 3;
        damage_type = "sharp";
        break;
      case "sonic boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 3;
        damage_type = "shatter";
        break;
      case "red hot boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 3;
        damage_type = "normal";
        break;
      case "multi target boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 7;
        damage_type = "sharp";
        break;
      case "sonic multi target boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 7;
        damage_type = "shatter";
        break;
      case "red hot multi target boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 7;
        damage_type = "normal";
        break;
      case "glaive boomerang":
        speed = 15.; size=38.;
        damage = 1; pierce = 12;
        damage_type = "sharp";
        break;
      case "sonic glaive boomerang":
        speed = 15.; size=38.;
        damage = 1; pierce = 12;
        damage_type = "shatter";
        break; 
      case "red hot glaive boomerang":
        speed = 15.; size=38.;
        damage = 1; pierce = 12;
        damage_type = "normal";
        break;
      default:
        println("ERROR : Boomerang type ", boomerang_type, " not suitable for shooting boomerang");
        break;
    }
  }

}
