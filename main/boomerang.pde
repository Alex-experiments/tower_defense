class Boomerang{
  float x;
  float y;
  float prev_x;
  float prev_y;
  
  float angle_dep;
  
  float size=10;
  
  int avancement=0;
  
  float centre_x;
  float centre_y;
  float rayon_cercle;
  Tower fired_from_tower;
  float speed;
  int dmg_done_this_frame;
  
  int pierce;
  int damage;
  
  boolean orbiting=false;
  
  ArrayList<Mob> already_dmged_mobs=new ArrayList<Mob>();
  
  StringList hit_exceptions;

  
  Boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle, float speed, int damage, int pierce, StringList hit_exceptions){
    this.centre_x=centre_x;
    this.centre_y=centre_y;
    this.rayon_cercle=rayon_cercle;
    this.fired_from_tower = fired_from_tower;
    this.speed=speed;
    this.damage=damage;
    this.pierce=pierce;
    this.hit_exceptions = hit_exceptions;
    angle_dep = atan2(fired_from_tower.y - centre_y, fired_from_tower.x - centre_x); 
    
    x=fired_from_tower.x;  //sinon ca chie avec collision() car sachant que prev_x n'a pas de valeur par défault ca sera 0...
    y=fired_from_tower.y;
    
    if(fired_from_tower.path_1_progression>=2)  size = 15;  //les projectiles sont des glaives
  }
  
  void core(){
    update();
    if(!orbiting && (ended_circle() || pierce<=0))  boomerangs.remove(this);
    else  show();
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
    int layers_popped=mob.pop_layers(damage, true, "boomerang", hit_exceptions);      //on tappe le mob
    dmg_done_this_frame+=layers_popped;
    
    for(Mob dmged_mob : mob.bloons_dmged()){
      already_dmged_mobs.add(dmged_mob);
    }
    
    
    if(mob.layers<=0)  enemis.remove(mob);
  }


}
