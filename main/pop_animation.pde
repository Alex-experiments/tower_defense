class Pop_animation{
  float x;
  float y;
  float diametre;
  float pop_time;    //la durée de visibilité de l'explosion en secondes
  static final float DURATION = 0.2;

  Pop_animation(float x, float y, float diametre){
    this.x=x;
    this.y=y;
    this.diametre=5*diametre;
    pop_time = FAKE_TIME_ELAPSED;
  }
  
  void core(){
    if(FAKE_TIME_ELAPSED - pop_time > DURATION){
      pop_animations.remove(this);
      return;
    }
    show();
  }
  
  void show(){
    float intensity= 255*(FAKE_TIME_ELAPSED-pop_time)/DURATION;   
    stroke(intensity, intensity, intensity);            //to go from black to white
    strokeWeight(2);
    noFill();
    ellipse(x, y, diametre*intensity/255/1.5, diametre*intensity/255/1.5);    //explosion is expanding
  }

}
