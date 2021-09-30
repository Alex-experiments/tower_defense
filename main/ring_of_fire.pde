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
  }
  
  void set_stats(){
    damage = 1; pierce = 60;
    damage_type = "normal";
  }
  
  void show(){
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
 
  boolean collision(float[] pos_mob, float size_mob){  //on prend ces params pour override
    
    float dist = distance(pos_mob, new float[] {fired_from_tower.x, fired_from_tower.y});
    
    return abs(dist-ray) < epaisseur/2.;
  }
  
}
