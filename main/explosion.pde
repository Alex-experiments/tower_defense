class Explosion{
  //ne peut pas toucher les ballons noirs

  float x;
  float y;
  float[] pos;
  float diametre;
  float explosion_time;
  static final float DURATION = 0.1;//la durée de visibilité de l'explosion en secondes
  int damage;
  int pierce;
  int dmg_done_this_frame;
  StringList hit_exceptions;
  Tower fired_from_tower;
  
  ArrayList<Mob> already_dmged_mobs=new ArrayList<Mob>();

  Explosion(Tower fired_from_tower, float x, float y, float diametre, int damage, int pierce, StringList hit_exceptions){
    this.fired_from_tower=fired_from_tower;
    this.x=x;
    this.y=y;
    pos=new float[] {x, y};
    this.diametre=diametre;
    this.damage=damage;
    this.pierce=pierce;
    this.hit_exceptions=hit_exceptions;
    explosion_time = FAKE_TIME_ELAPSED;
    
    kill();
  }
  
  void core(){
    if(FAKE_TIME_ELAPSED - explosion_time > DURATION){
      explosions.remove(this);
      return;
    }
    show();
  }
 
  
  void show(){
    float intensity= 255*(FAKE_TIME_ELAPSED - explosion_time)/DURATION;   
    stroke(255, 255-intensity, 255-intensity);            //to go from black to red
    fill(255, 255-intensity, 255-intensity);
    strokeWeight(2);
    //noFill();
    ellipse(x, y, diametre*intensity/255/1.5, diametre*intensity/255/1.5);    //explosion is expanding
  }
  
  void kill(){
  //instakill tous les ballons dans le diametre
    dmg_done_this_frame=0;
  
    for (int i = enemis.size() - 1; i >= 0; i--){
      Mob mob = enemis.get(i);
      if(distance(new float[] {mob.x, mob.y}, pos) <= (diametre + mob.size)/2 && !already_dmged_mobs.contains(mob) ){
        if(can_detect(mob, fired_from_tower.detects_camo)){
          hit(mob);
          pierce--;
          if(pierce<=0)  break;
        }
      }
    }
    
    fired_from_tower.pop_count+=dmg_done_this_frame;
    joueur.game_pop_count += dmg_done_this_frame;
  }
  
  void hit(Mob mob){
    int layers_popped=mob.pop_layers(damage, true, "explosion", hit_exceptions);      //on tappe le mob
    dmg_done_this_frame+=layers_popped;
    
    for(Mob dmged_mob : mob.bloons_dmged()){
      already_dmged_mobs.add(dmged_mob);
    }
    
    
    if(mob.layers<=0)  enemis.remove(mob);
  }
  

}
