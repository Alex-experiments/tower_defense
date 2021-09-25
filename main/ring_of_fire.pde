class Ring_of_fire{
  float x, y;
  float dmg_done_this_frame;
  ArrayList<Mob> already_dmged_mobs=new ArrayList<Mob>();
  int damage=1, pierce=60;
  String damage_type = "normal";
  ArrayList<int[]> sprites_pos;
  
  float max_ray, ray;
  static final float epaisseur = 20., expansion_rate = 10., sprite_size=108.;
  Tower fired_from_tower;
  
  
  Ring_of_fire(Tower fired_from_tower){
    this.x = fired_from_tower.x;
    this.y = fired_from_tower.y;
    sprites_pos = get_sprites_pos(new StringList("ring of fire"));
    this.ray = int(fired_from_tower.size/2);
    this.max_ray = int(fired_from_tower.range);
    this.fired_from_tower = fired_from_tower;
  }
  
  public void core(){
    for(int i = 0; i<joueur.game_speed; i++){
      if(ray>max_ray){
        rings_of_fire.remove(this);
        return;
      }
      ray += expansion_rate;
      if(pierce>0)  kill();        //sinon on le supprime pas, on continue de l'afficher comme pour ray of doom
      //println(pierce, FAKE_TIME_ELAPSED);
    }
    show();
  }
  
  private void show(){
    pushMatrix();
    translate(x, y);
    for(int[] pos_aff : sprites_pos){
      float scale = ray/sprite_size;
      float size = pos_aff[2] * scale;
      
      image(all_sprites, pos_aff[4]-pos_aff[2]*scale/2, pos_aff[5]-pos_aff[3]*scale/2, size, size, pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
      image(all_sprites, pos_aff[4]+pos_aff[2]*scale/2, pos_aff[5]-pos_aff[3]*scale/2, size, size, pos_aff[0]+pos_aff[2], pos_aff[1], pos_aff[0], pos_aff[1]+pos_aff[3]);
      image(all_sprites, pos_aff[4]+pos_aff[2]*scale/2, pos_aff[5]+pos_aff[3]*scale/2, size, size, pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3], pos_aff[0], pos_aff[1]);
      image(all_sprites, pos_aff[4]-pos_aff[2]*scale/2, pos_aff[5]+pos_aff[3]*scale/2, size, size, pos_aff[0], pos_aff[1]+pos_aff[3], pos_aff[0]+pos_aff[2], pos_aff[1]);
    }
    popMatrix();
  }
  
  private void kill(){
    dmg_done_this_frame=0;
    //on fait des degats aux enemis
    
    for (int i = enemis.size() - 1; i >= 0; i--){
      Mob mob = enemis.get(i);
      if(can_detect(mob, fired_from_tower.detects_camo) && pierce>0 && !already_dmged_mobs.contains(mob)){
        float dist = distance(new float[] {mob.x, mob.y}, new float[] {fired_from_tower.x, fired_from_tower.y});
        if( abs(dist-ray) < epaisseur/2.){
          hit(mob);
          pierce--;
          if(pierce<=0)  break;
        }
      }
    }
    
    fired_from_tower.pop_count+=dmg_done_this_frame;
    joueur.game_pop_count += dmg_done_this_frame;
  }
  
  private void hit(Mob mob){
    int layers_popped=mob.pop_layers(damage, true, damage_type);      //on tappe le mob
    dmg_done_this_frame+=layers_popped;
    
    for(Mob dmged_mob : mob.bloons_dmged()){
      already_dmged_mobs.add(dmged_mob);
    }
    
    
    if(mob.layers<=0)  enemis.remove(mob);
  }
  
}
