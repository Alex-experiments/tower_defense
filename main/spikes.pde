class Spikes{
  
  //a optimiser grandement

  float x, y;
  float destination_x, destination_y;
  int damage, pierce;
  static final float rayon=20.;  //si on le modifie, le modifier aussi dans joueur -> place tower
  float speed, direction, initial_speed = 10.;
  String type, damage_type;
  float landing_time;       
  float duration = 70.;    //ca vit 70s
  Tower fired_from_tower;
  float total_distance;
  boolean deplacement_fini=false;
  boolean is_from_spike_storm = false;
  
  int dmg_done_this_frame;

  
  Spikes(Tower fired_from_tower, float destination_x, float destination_y, String spike_type){
    this.fired_from_tower=fired_from_tower;
    this.x=fired_from_tower.x;
    this.y=fired_from_tower.y;
    this.destination_x=destination_x;
    this.destination_y=destination_y;
    this.total_distance = distance(new float[] {x, y}, new float[] {destination_x, destination_y});
    if(total_distance == 0){
      deplacement_fini = true;
      landing_time = FAKE_TIME_ELAPSED;
    }
    else direction=atan2(destination_y-fired_from_tower.y, destination_x-fired_from_tower.x);
    
    int index_spike_storm = spike_type.indexOf(" spike storm");    //si c'est un pic de spike storm, on le note mais on ne change pas le type car les sprites et dmg sont les memes
    if(index_spike_storm>=0){
      is_from_spike_storm = true;
      this.type = spike_type.substring(0, index_spike_storm);
      this.duration = 5.;
      this.initial_speed = 50;
    }
    else this.type = spike_type;
        
    set_stats();
  }
  
  void core(int i, int nb_spikes){
    update();
    if(pierce<= 0 || deplacement_fini && FAKE_TIME_ELAPSED - landing_time > duration){
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
    if(type.equals("spike ball") || type.equals("spike mine"))  pos_aff = pos_coins_sprites.get("spike mine_"+str(min(pierce, 10)));    //normalement les spike balls n'ont pas de crane dessus
    else if(type.indexOf("hot")>=0)  pos_aff = pos_coins_sprites.get("hot spike_"+str(min(pierce, 10)));
    else pos_aff = pos_coins_sprites.get("spike_"+str(min(pierce, 10)));
    image(all_sprites, x+pos_aff[4], y+pos_aff[5], pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
  }
  
  
  void update(){
    if(!deplacement_fini){
      for(int i=0; i<joueur.game_speed; i++){    //on itère plusieurs fois pour faire des petits pas et ne pas dépasser de trop la destination
        float dist = distance(new float[] {x, y}, new float[] {destination_x, destination_y});
        speed=(0.5-initial_speed)*(total_distance-dist)/total_distance+initial_speed;
        //on commence à s = init_s et on arrive a s=0.5 lors de l'arrivée
        x+=speed*cos(direction);
        y+=speed*sin(direction);
        if(distance(new float[] {x, y}, new float[] {destination_x, destination_y}) < speed){
          x=destination_x;
          y=destination_y;
          deplacement_fini=true;
          landing_time = FAKE_TIME_ELAPSED;
          break;
        }
      }
    }
    else kill();
    
  }
  
  void kill(){
    dmg_done_this_frame=0;
    //on fait des degats aux enemis    
    
    for (int i = enemis.size() - 1; i >= 0; i--){
      Mob mob = enemis.get(i);
      if(can_detect(mob, true) && pierce>0 && distance(new float[] {mob.x, mob.y}, new float[] {x, y}) < rayon+ mob.size/2){
        
        if(is_from_spike_storm)    duration = 10.;  //un spike storm ne dure que 5sec, mais si il touche un enemi, il dure 5sec de plus

        hit(mob);
        pierce--;
        if(pierce<=0){
          if(type.equals("spike mine")){
            explosions.add(new Explosion(fired_from_tower, x, y, 120, 4, 60, damage_type, false, 0));      //A CHANGER POUR LE TYPE d'EXPLOSION
          }
          break;
        }
      }
    }
    
    fired_from_tower.add_pop_count(dmg_done_this_frame);
  }
  
  void hit(Mob mob){
    int layers_popped=mob.pop_layers(damage, true, damage_type);      //on tappe le mob
    dmg_done_this_frame+=layers_popped;
    
    if(mob.layers<=0)  enemis.remove(mob);
  }
  
  void set_stats(){
    switch(type){
      case "spike":
        damage = 1; pierce = 5;
        damage_type = "sharp";
        break;
      case "stack spike":
        damage = 1; pierce = 10;
        damage_type = "sharp";
        break;
      case "hot spike":
        damage = 1; pierce = 10;
        damage_type = "normal";
        break;
      case "spike ball":
        damage = 1; pierce = 16;
        damage_type = "normal";
        break;
      case "spike mine":
        damage = 1; pierce = 16;
        damage_type = "normal";
        break;
      default:
        println("ERROR : Spike type ", type, " not suitable for shooting spike");
        break;
    }
  }
}
