class Laser{
  ArrayList<float[]> laser_path=new ArrayList<float[]>();
  float fired_time;
  static final float DURATION = 0.5;
  static final int max_targets = 25, damage = 1;
  int bounces_left;
  int dmg_done_this_frame;
  ArrayList<Mob> already_dmged_mobs=new ArrayList<Mob>();
  ArrayList<Mob> enemis_before_pops;
  Mob initial_target;
  
  Tower fired_from_tower;
  
  
  
  Laser(Tower fired_from_tower, float x_dep, float y_dep, Mob target){
    laser_path.add(new float[] {x_dep, y_dep});
    bounces_left=max_targets;
    initial_target=target;
    this.fired_from_tower=fired_from_tower;

    fired_time = FAKE_TIME_ELAPSED;
    
   
    kill();
  }
  
  void core(){
    if(FAKE_TIME_ELAPSED - fired_time > DURATION){
      lasers.remove(this);
      return;
    }
    show();
  }
  
  void show(){
    float intensity= 255*(1-(FAKE_TIME_ELAPSED-fired_time)/(DURATION));
    stroke(intensity, intensity, 0, intensity);  
    strokeWeight(2);
    float[] pos2=new float[2];
    for(int nb_laser=0; nb_laser<3; nb_laser++){
      float[] pos1=new float[2];
      arrayCopy(laser_path.get(0), pos1);
      for(int i=0; i<laser_path.size() - 1; i++){    //le -1 est important
        arrayCopy(laser_path.get(i+1), pos2);
        pos2[0]+=random(-10, 10);
        pos2[1]+=random(-10, 10);
        line(pos1[0], pos1[1], pos2[0], pos2[1]);
        arrayCopy(pos2, pos1);
      }
    }
  }
  
  ArrayList<Mob> target_list(int max_targets){
    ArrayList<Mob> list=new ArrayList<Mob>();
    
    list.add(initial_target);
    Mob latest_target=initial_target;
    
    for(int i=1; i<max_targets; i++){
      Mob closest_mob=enemis.get(0);
      float dist_min=width*height;    //on initialise a une distance impossible dans la map si jamais on a justement deja tappé enemis.get(0)
      for(Mob mob : enemis){
        if(can_detect(mob, fired_from_tower.detects_camo) && distance(new float[] {mob.x, mob.y}, new float[] {latest_target.x, latest_target.y})<dist_min && list.contains(mob)==false){
          closest_mob=mob;
          dist_min=distance(new float[] {mob.x, mob.y}, new float[] {latest_target.x, latest_target.y});
        }
      }
      if(list.contains(closest_mob)){      //cela signifie qu'on a deja tappé tous les mobs
        return list;
      }
      else{                                //on a trouvé un mob pas encore touché
        list.add(closest_mob);
        latest_target=closest_mob;
      }
    }
    return list;
  }

  void kill(){
    dmg_done_this_frame=0;
    
    for(Mob target : target_list(bounces_left)){
      laser_path.add(new float[] {target.x, target.y});
      hit(target); 
    }
        
    fired_from_tower.add_pop_count(dmg_done_this_frame);
    
  }
  
  
  void hit(Mob mob){
    bounces_left--;
    dmg_done_this_frame+=mob.pop_layers(damage, true, "laser");
    
    for(Mob dmged_mob : mob.bloons_dmged()){
      already_dmged_mobs.add(dmged_mob);
    }
        
    if(mob.layers<=0)  enemis.remove(mob);
  }


}
