class Pop_animation{
  float x, y;
  float diametre;
  float pop_time;    //la durée de visibilité de l'explosion en secondes
  boolean first_frame = joueur.game_speed == 1;    //on ne dure 2 frames que si on est en vitesse *1
  boolean must_show = true;
  
  static final int MAX_POP_PER_CELL = 1;    //permet d'éviter d'en afficher 500 par frame au meme endroit...
  
  int pos_aff[];

  Pop_animation(float x, float y, float diametre){
    
    int cell_id = grid.get_cell_id(x, y);
    if(grid.cells.get(cell_id).pop_counter>=MAX_POP_PER_CELL)  must_show = false;
    else grid.cells.get(cell_id).pop_counter++;
    
    this.x=x;
    this.y=y;
    this.diametre=5*diametre;
    pop_time = FAKE_TIME_ELAPSED;
    
    pos_aff = pos_coins_sprites.get("pop animation");
  }
  
  void core(){
    if(must_show){
      show();
      if(first_frame){
        first_frame = false;
        return;
      }
    }
    pop_animations.remove(this);
  }
  
  void show(){
    
    image(all_sprites, x, y, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
    
    /*float intensity= 255*(FAKE_TIME_ELAPSED-pop_time)/DURATION;   
    stroke(intensity, intensity, intensity);            //to go from black to white
    strokeWeight(2);
    noFill();
    ellipse(x, y, diametre*intensity/255/1.5, diametre*intensity/255/1.5);    //explosion is expanding*/
  }

}
