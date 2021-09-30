class Ray_of_doom{
  float x, y, direction;
  int dmg_done_this_frame;
  ArrayList<Mob> already_dmged_mobs=new ArrayList<Mob>();
  int damage=1, pierce, INIT_PIERCE=100;
  String damage_type = "normal";
  ArrayList<int[]> sprites_pos;
  
  static final float EPAISSEUR = 30., SHOW_OFFSET_y = -140.;
  float MAX_LEN_OF_RAY = sqrt(tower_panel.top_left_x * tower_panel.top_left_x + info_panel.top_left_y*info_panel.top_left_y);
  Tower fired_from_tower;
  
  Ray_of_doom(Tower fired_from_tower){
    x = fired_from_tower.x;
    y = fired_from_tower.y;
    sprites_pos = get_sprites_pos(new StringList("ray of doom 28px start", "ray of doom 28px"));
    this.fired_from_tower = fired_from_tower;
  }
  
  public void core(){
    if(round.waiting_next_round)  return;
    for(int i=0; i<joueur.game_speed; i++){
      renew();
      kill();
    }
    show();
  }
  
  private void renew(){
    direction = atan2(mouseY-y, mouseX-x);
    pierce = INIT_PIERCE;
    already_dmged_mobs = new ArrayList<Mob>();
  }
  
  private void kill(){
    dmg_done_this_frame=0;
    //on fait des degats aux enemis
    
    for (int i = enemis.size() - 1; i >= 0; i--){
      Mob mob = enemis.get(i);
      if(can_detect(mob, fired_from_tower.detects_camo) && pierce>0 && collision(new float[] {mob.x, mob.y}, mob.size) && !already_dmged_mobs.contains(mob)){
        hit(mob);
        pierce--;
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
  
  boolean collision(float[] pos_mob, float size_mob){
    //C'est pourquoi on recherche la distance entre le rayon et l'enemi. Pour pas se faire chier on prend un sengment de longueur max
    
    myLine.x1=x+cos(direction) * abs(SHOW_OFFSET_y);
    myLine.x2=x+cos(direction) * MAX_LEN_OF_RAY;
    myLine.y1=y+sin(direction) * abs(SHOW_OFFSET_y);
    myLine.y2=y+sin(direction) * MAX_LEN_OF_RAY;
    
    return myLine.getDistance(pos_mob[0], pos_mob[1]).z < (EPAISSEUR+size_mob)/2;    //Dans le cas des hitbox rondes
  }
  
  
  private void show(){
    pushMatrix();
    translate(x, y);
    rotate(direction+HALF_PI);
    int[] pos_aff = sprites_pos.get(0);
    image(all_sprites, pos_aff[4], SHOW_OFFSET_y + pos_aff[5], pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
    //float y_offset = -pos_aff[5]-pos_aff[3];
    float y_offset = 15. - 51.;
    //float sin_direc = sin(direction), cos_direc = cos(direction);
    //float pos_x = x;
    //float pos_y = y + sin_direc * (y_offset);
    pos_aff = sprites_pos.get(1);
    //int compteur = 0;
    //float len = y_offset;
    for(float i=y_offset/pos_aff[3]; i<MAX_LEN_OF_RAY/pos_aff[3]; i++){    //141 iter
    //while(pos_x > - pos_aff[0] && pos_x < tower_panel.top_left_x + pos_aff[0] && pos_y > - pos_aff[1] && pos_y < info_panel.top_left_y + pos_aff[1]){
    //while(compteur<10){
      image(all_sprites, 0, SHOW_OFFSET_y+2*y_offset - i * pos_aff[3], pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
      //pos_y += sin_direc * pos_aff[3];
      //pos_x += cos_direc * pos_aff[2];
      //len += pos_aff[3];
      //compteur++;
    }
    //println(pos_aff);
    popMatrix();
  }
  
  
}
