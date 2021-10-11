class Ring_of_fire extends Projectile{

  
  float max_ray, ray;
  static final float epaisseur = 20., expansion_rate = 10., sprite_size=108.;
 
  Ring_of_fire(Tower fired_from_tower){
    super(fired_from_tower, fired_from_tower.x, fired_from_tower.y, 0., "ring of fire");
    ray = int(fired_from_tower.size/2);
    max_ray = int(fired_from_tower.range);
  }
  
  public void core(int i, int nb_proj){
    for(int k = 0; k<joueur.game_speed; k++){
      if(ray>max_ray){
        projectiles.remove(i);
        return;
      }
      ray += expansion_rate;
      if(pierce>0)  kill();        //sinon on le supprime pas, on continue de l'afficher comme pour ray of doom
    }
    show();
    for(Animator anim : sprites)  anim.update(true);
  }
  
  void set_stats(){
    damage = 1; pierce = 60;
    damage_type = "normal";
  }
  
  void show(){
    pushMatrix();
    translate(x, y);
    for(Animator anim : sprites){
      int[] pos_aff = anim.get_pos();
      float scale = ray/sprite_size;
      float size = pos_aff[2] * scale;
      
      image(all_sprites, pos_aff[4]-pos_aff[2]*scale/2, pos_aff[5]-pos_aff[3]*scale/2, size, size, pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
      image(all_sprites, pos_aff[4]+pos_aff[2]*scale/2, pos_aff[5]-pos_aff[3]*scale/2, size, size, pos_aff[0]+pos_aff[2], pos_aff[1], pos_aff[0], pos_aff[1]+pos_aff[3]);
      image(all_sprites, pos_aff[4]+pos_aff[2]*scale/2, pos_aff[5]+pos_aff[3]*scale/2, size, size, pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3], pos_aff[0], pos_aff[1]);
      image(all_sprites, pos_aff[4]-pos_aff[2]*scale/2, pos_aff[5]+pos_aff[3]*scale/2, size, size, pos_aff[0], pos_aff[1]+pos_aff[3], pos_aff[0]+pos_aff[2], pos_aff[1]);
    }
    popMatrix();
  }
  
  void kill(){  //AVEC LA GRID MAP ON EST OBLIGE D OVERRIDE (sinon on regarde pas tous les bloons qu'on peut tapper)
    dmg_done_this_frame=0;
    //on fait des degats aux enemis
   
     ArrayList<Mob> enemis_to_look_at = grid.get_enemis_to_look_at(fired_from_tower.x, fired_from_tower.y, ray+epaisseur/2.); //c'est ca le truc qui change
    for (int i = enemis_to_look_at.size() - 1; i >= 0; i--){
      Mob mob = enemis_to_look_at.get(i);
      if(can_detect(mob, fired_from_tower.detects_camo) && pierce>0 && collision(new float[] {mob.x, mob.y}, mob.size) && !already_dmged_mobs.contains(mob) && !mob.hurted_by_during_frame.contains(this)){//si on a pas déjà tappé ce mob (ou ses parents) durant les dernieres frames
        hit(mob);
        if(pierce<=0)  break;
      }
    }
        
    fired_from_tower.add_pop_count(dmg_done_this_frame);
  }
 
  boolean collision(float[] pos_mob, float size_mob){  //on prend ces params pour override
    
    float dist = distance(pos_mob, new float[] {fired_from_tower.x, fired_from_tower.y});
    
    return abs(dist-ray) < epaisseur/2.;
  }
  
}
