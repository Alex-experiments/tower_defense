class Banana{
  float x, y, dest_x, dest_y;
  int value;
  String type;
  static final float initial_speed = 10.;
  float rayon = 20;
  float speed, total_distance, direction;
  boolean deplacement_fini=false, being_collected = false, collected = false;
  float collect_time, text_on_screen_time = .5;
  
  //en gros yaura quatres états : en déplacement vers la pos, en attente de collecte, being_collected ou on se rapproche du curseur, collected ou on affiche la value

  Banana(float init_x, float init_y, float dest_x, float dest_y, int value, String type){
    this.x = init_x;
    this.y = init_y;
    this.dest_x = dest_x;
    this.dest_y = dest_y;
    this.value = value;
    this.type = type;
    set_rayon();
    this.total_distance = distance(new float[] {init_x, init_y}, new float[] {dest_x, dest_y});
    if(total_distance == 0)  deplacement_fini = true;
    else direction=atan2(dest_y-init_y, dest_x-init_x);
  }
  
  
  public void core(){
    update();
    if(collected && FAKE_TIME_ELAPSED - collect_time > text_on_screen_time){
      bananas.remove(this);
      return;
    }
    show();
  }
  
  private void set_rayon(){
    if(type.equals("supply drop"))  rayon = 50;
  }
  
  private void update(){
    if(!deplacement_fini){
      for(int i=0; i<joueur.game_speed; i++){    //on itère plusieurs fois pour faire des petits pas et ne pas dépasser de trop la destination
        float dist = distance(new float[] {x, y}, new float[] {dest_x, dest_y});
        speed=(0.5-initial_speed)*(total_distance-dist)/total_distance+initial_speed;
        //on commence à s = init_s et on arrive a s=0.5 lors de l'arrivée
        x+=speed*cos(direction);
        y+=speed*sin(direction);
        if(distance(new float[] {x, y}, new float[] {dest_x, dest_y}) < speed){
          x=dest_x;
          y=dest_y;
          deplacement_fini=true;
          speed = 0.;
          break;
        }
      }
    }
    else if(!being_collected && distance(new float[] {x, y}, new float[] {mouseX, mouseY}) < rayon) being_collected = true;
    else if(being_collected && !collected){
      for(int i=0; i<joueur.game_speed; i++){    //on itère plusieurs fois pour faire des petits pas et ne pas dépasser de trop la destination
        speed++;
        direction=atan2(mouseY-y, mouseX-x);
        x+=speed*cos(direction);
        y+=speed*sin(direction);
        if(distance(new float[] {x, y}, new float[] {mouseX, mouseY}) < speed){
          collected=true;
          collect();
          break;
        }
      }
    }
  }
  
  private void show(){
    if(collected){
      text(str(value), x, y - (FAKE_TIME_ELAPSED - collect_time)*60);;
    }
    else if(pos_coins_sprites.containsKey(type)){
      int[] pos_aff = pos_coins_sprites.get(type);
      image(all_sprites, x, y, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
    }
    else ellipse(x, y, rayon, rayon);
  }
  
  
  private void collect(){
    joueur.argent += value;
    collect_time = FAKE_TIME_ELAPSED;
  }
  
}
