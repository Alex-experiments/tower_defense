class Spikes{
  
  //a optimiser grandement

  float rayon = 20; //si on le modifie, le modifier aussi dans joueur -> place tower
  float x;
  float y;
  float destination_x;
  float destination_y;
  int damage, pierce, initial_pierce;
  String type;
  StringList hit_exceptions;
  float fired_time;       
  static final float DURATION = 70.;    //ca vit 70s
  Tower fired_from_tower;
  float speed;
  float initial_speed;
  float total_distance;
  boolean deplacement_fini=false;
  
  int dmg_done_this_frame;
  float angle_decalage;

  
  Spikes(Tower fired_from_tower, float destination_x, float destination_y, int damage, int pierce, String type, StringList hit_exceptions, float initial_speed){
    this.fired_from_tower=fired_from_tower;
    this.x=fired_from_tower.x;
    this.y=fired_from_tower.y;
    this.destination_x=destination_x;
    this.destination_y=destination_y;
    this.damage=damage;
    this.pierce=pierce;
    this.initial_pierce=pierce;
    this.type=type;
    this.hit_exceptions=hit_exceptions;
    this.initial_speed=initial_speed;
    this.speed=initial_speed;
    this.total_distance = distance(new float[] {x, y}, new float[] {destination_x, destination_y});
    
    angle_decalage=random(2*PI);
    
    fired_time =  FAKE_TIME_ELAPSED;
  }
  
  void core(int i, int nb_spikes){
    update();
    if(pierce<= 0 || FAKE_TIME_ELAPSED - fired_time > DURATION){
      spikes.remove(i);
      return;
    }
    else if(nb_spikes-i<1200)  show();    //on affiche que les 1200 derniers crées pour éviter tout lag
  }
  
  void show(){
    int[] pos_aff;
    if(type.equals("spike ball"))  pos_aff = pos_coins_sprites.get("spike mine_"+str(min(pierce, 10)));    //normalement les spike balls n'ont pas de crane dessus
    else pos_aff = pos_coins_sprites.get(type+"_"+str(min(pierce, 10)));
    image(all_sprites, x, y, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
  }
  
  
  void update(){
    for(int i=0; i<joueur.game_speed; i++){    //on itère plusieurs fois pour faire des petits pas et ne pas dépasser de trop la destination
      if(!deplacement_fini){
        float dist = distance(new float[] {x, y}, new float[] {destination_x, destination_y});
        speed=(0.5-initial_speed)*(total_distance-dist)/total_distance+initial_speed;
        //on commence à s = init_s et on arrive a s=0.5 lors de l'arrivée
        float direction=atan2(destination_y-fired_from_tower.y, destination_x-fired_from_tower.x);
        x+=speed*cos(direction);
        y+=speed*sin(direction);
        if(distance(new float[] {x, y}, new float[] {destination_x, destination_y}) < speed){
          x=destination_x;
          y=destination_y;
          deplacement_fini=true;
        }
      }
      else{
        kill();
        break;
      }
    }
    
  }
  
  void kill(){
    dmg_done_this_frame=0;
    //on fait des degats aux enemis    
    
    for (int i = enemis.size() - 1; i >= 0; i--){
      Mob mob = enemis.get(i);
      if(can_detect(mob, true) && pierce>0 && distance(new float[] {mob.x, mob.y}, new float[] {x, y}) < rayon+ mob.size/2){
        hit(mob);
        pierce--;
        if(pierce<=0){
          if(type.equals("spike mine")){
            explosions.add(new Explosion(fired_from_tower, x, y, 120, 4, 60, hit_exceptions));
          }
          break;
        }
      }
    }
    
    fired_from_tower.pop_count+=dmg_done_this_frame;
    joueur.game_pop_count += dmg_done_this_frame;
  }
  
  void hit(Mob mob){
    int layers_popped=mob.pop_layers(damage, true, type, hit_exceptions);      //on tappe le mob
    dmg_done_this_frame+=layers_popped;
    
    if(mob.layers<=0)  enemis.remove(mob);
  }
}
