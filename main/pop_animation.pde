class Pop_animation{
  float x;
  float y;
  float diametre;
  float pop_time;    //la durée de visibilité de l'explosion en secondes
  static final float DURATION = 0.1;
  boolean first_frame = joueur.game_speed == 1;    //on ne dure 2 frames que si on est en vitesse *1

  Pop_animation(float x, float y, float diametre){
    this.x=x;
    this.y=y;
    this.diametre=5*diametre;
    pop_time = FAKE_TIME_ELAPSED;
  }
  
  void core(){
    /*if(FAKE_TIME_ELAPSED - pop_time > DURATION){  //c'était l'ancienne méthode, mtn ca dure plus qu'une frame et c'est une image
      pop_animations.remove(this);
      return;
    }*/
    show();
    if(first_frame)  first_frame = false;
    else pop_animations.remove(this);
  }
  
  void show(){
    int[] pos_aff = pos_coins_sprites.get("pop animation");
    image(all_sprites, x, y, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
    /*float intensity= 255*(FAKE_TIME_ELAPSED-pop_time)/DURATION;   
    stroke(intensity, intensity, intensity);            //to go from black to white
    strokeWeight(2);
    noFill();
    ellipse(x, y, diametre*intensity/255/1.5, diametre*intensity/255/1.5);    //explosion is expanding*/
  }

}
