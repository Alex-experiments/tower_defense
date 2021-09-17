class Spikes{
  
  //a optimiser grandement

  float x, y;
  float destination_x, destination_y;
  int damage, pierce;
  static final float initial_speed = 10., rayon=20.;  //si on le modifie, le modifier aussi dans joueur -> place tower
  float speed;
  String type, damage_type;
  float fired_time;       
  static final float DURATION = 70.;    //ca vit 70s
  Tower fired_from_tower;
  float total_distance;
  boolean deplacement_fini=false;
  
  int dmg_done_this_frame;
  float angle_decalage;

  
  Spikes(Tower fired_from_tower, float destination_x, float destination_y){
    this.fired_from_tower=fired_from_tower;
    this.x=fired_from_tower.x;
    this.y=fired_from_tower.y;
    this.destination_x=destination_x;
    this.destination_y=destination_y;
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
  
  void verif_damage_type(){
    if(damage_type.equals(get_damage_type(type)))  return;
    println("NOT GOOD ! Spike :", type, "gives", damage_type, "and", get_damage_type(type));
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
            explosions.add(new Explosion(fired_from_tower, x, y, 120, 4, 60, type));      //A CHANGER POUR LE TYPE d'EXPLOSION
          }
          break;
        }
      }
    }
    
    fired_from_tower.pop_count+=dmg_done_this_frame;
    joueur.game_pop_count += dmg_done_this_frame;
  }
  
  void hit(Mob mob){
    int layers_popped=mob.pop_layers(damage, true, damage_type);      //on tappe le mob
    dmg_done_this_frame+=layers_popped;
    
    if(mob.layers<=0)  enemis.remove(mob);
  }
}

class Spike extends Spikes{
  
  static final int damage = 1, pierce = 5;
  static final String damage_type = "sharp", type = "spike";
  Spike(Tower fired_from_tower, float destination_x, float destination_y){
    super(fired_from_tower, destination_x, destination_y);
  }
}

class Stack_spike extends Spikes{
  
  static final int damage = 1, pierce = 10;
  static final String damage_type = "sharp", type = "stack spike";
  Stack_spike(Tower fired_from_tower, float destination_x, float destination_y){
    super(fired_from_tower, destination_x, destination_y);
  }
}

class Hot_spike extends Spikes{
  
  static final int damage = 1, pierce = 10;
  static final String damage_type = "normal", type = "hot spike";
  Hot_spike(Tower fired_from_tower, float destination_x, float destination_y){
    super(fired_from_tower, destination_x, destination_y);
  }
}

class Spike_ball extends Spikes{    //ajouter le fait que ca fasse 3* les degats aux ceramics
  
  static final int damage = 1, pierce = 16;
  static final String damage_type = "normal", type = "spike ball";
  Spike_ball(Tower fired_from_tower, float destination_x, float destination_y){
    super(fired_from_tower, destination_x, destination_y);
  }
}

class Spike_mine extends Spikes{    //ajouter le fait que ca fasse 3* les degats aux ceramics et //explosion donne un effet napalm  The napalm pops bloons every 2 seconds for 6 seconds. The explosions pop 4 layers
  
  static final int damage = 1, pierce = 16;
  static final String damage_type = "normal", type = "spike mine";
  Spike_mine(Tower fired_from_tower, float destination_x, float destination_y){
    super(fired_from_tower, destination_x, destination_y);
  }
}
