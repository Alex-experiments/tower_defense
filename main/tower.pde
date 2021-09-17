class dart_monkey extends Tower{
  
  dart_monkey(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur=color(0, 0, 255);
    price=200;
    size=base_size;
    range=128;
    
    shoots_list.append("dart");
    deviation_list.append(0);
    attack_speed_list.append(1.03);        
  }
}

class tack_shooter extends Tower{

  tack_shooter(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur=color(255, 128, 192);
    price=360;
    size=base_size*1.3;
    range=90;
    
    for(int i=0; i<8; i++){
      shoots_list.append("tack");
      deviation_list.append(i*PI/4);
      attack_speed_list.append(0.6);
    }
  }
}

class sniper extends Tower{

  sniper(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    priority="strong";
    couleur=color(0, 128, 64);
    price=350;
    size=base_size;
    range=24;                //c'est un sniper donc ca c'est juste pour la prévisu quand on sélectionne la tour
    
    shoots_list.append("bullet");
    deviation_list.append(0);
    attack_speed_list.append(0.45);
  }
  
  ArrayList<Mob> get_enemis_in_range(){
    ArrayList<Mob> liste= new ArrayList<Mob>();
    for(Mob mob : enemis){
      if(can_detect(mob, detects_camo))  liste.add(mob);       //on ne l'ajoute que si il n'est pas caché, il n'est pas camo ou alors on les détecte
    }
    return liste;
  }
  
}

class boomerang_thrower extends Tower{

  boomerang_thrower(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur = color(255, 242, 0);
    price = 400;
    size = base_size;
    range = 165;
    
    shoots_list.append("basic boomerang");
    deviation_list.append(0);
    attack_speed_list.append(0.75);
  }
  
}

class dartling_gun extends Tower{

  dartling_gun(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur = color(180, 230, 30);
    price = 950;
    size = base_size;
    detects_camo=true;
    max_dispersion = 0.4;   //en radians
    range=44;    //seuleument pour le visuel
    
    shoots_list.append("dart");
    deviation_list.append(0);
    attack_speed_list.append(5);
  }
  
  void shoot(){
    
    if(round.waiting_next_round)  return;      //sinon lance un projectile parasite
    
    FloatList directions_list=new FloatList();
    for(int i=0; i<shoots_list.size(); i++){
      String shoot_type = shoots_list.get(i);
      float deviation = deviation_list.get(i);
      float time_before_next_attack = time_before_next_attack_list.get(i);
      float attack_speed = attack_speed_list.get(i);
      
      int compteur_dir=0;
      while(time_before_next_attack<=0){
        float direction=atan2(mouseY-y, mouseX-x);
        if(i==0){
          direction += random(-max_dispersion/2, max_dispersion/2);
          directions_list.append(direction);
        }
        else{
          direction=directions_list.get(compteur_dir);
        }
        instantiate_new_proj(shoot_type, direction+deviation);
        
        time_before_next_attack += 1 / attack_speed;      //affecter la valeur reste utile pour le while (sinon il faut remplacer par un _list.get(i)<=0 )
        time_before_next_attack_list.set(i, time_before_next_attack);
        
        compteur_dir++;
      }
    }
  }
  
}

class wizard_monkey extends Tower{

  wizard_monkey(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur=color(209, 34, 234);
    price=550;
    size=base_size*1.5;
    range=152;
    shoots_list.append("purple ball");
    deviation_list.append(0);
    attack_speed_list.append(0.91);
  }
}


class ninja_monkey extends Tower{

  ninja_monkey(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur = color(255, 0, 0);
    price = 500;
    size = base_size;
    range = 152;
    detects_camo=true;
    
    shoots_list.append("shuriken");
    deviation_list.append(0);
    attack_speed_list.append(1.67);
  }
}


class spike_factory extends Tower{

  spike_factory(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur = color(0, 0, 0);
    price = 700;
    size = base_size;
    range = 134;
    detects_camo=true;
    
    shoots_list.append("spike");
    deviation_list.append(0);
    attack_speed_list.append(0.43);
  }
  
  void shoot(){
    if(round.waiting_next_round)  return;      //sinon lance un spike parasite
    for(int i=0; i<shoots_list.size(); i++){
      String shoot_type = shoots_list.get(i);
      float time_before_next_attack = time_before_next_attack_list.get(i);
      float attack_speed = attack_speed_list.get(i);
      
      while(time_before_next_attack <= 0){
        if(on_track_pos.size()==0)  return;
        int index = int(random(on_track_pos.size()));
        
        instantiate_new_spike(shoot_type, on_track_pos.get(index)[0], on_track_pos.get(index)[1]);
        
        time_before_next_attack += 1 / attack_speed;      //affecter la valeur reste utile pour le while (sinon il faut remplacer par un _list.get(i)<=0 )
        time_before_next_attack_list.set(i, time_before_next_attack);
      }
    }  
  }
}



class Tower{
  boolean highlight=false;
  float x, y;
  float range;
  String priority="first";
  float base_size=60;
  float size;
  float pop_count=0;
  String type;
 
  float max_dispersion;
  
  boolean detects_camo=false;
  
  color couleur;
  int price=0;
  
  int path_1_progression;
  int path_2_progression;
  
  StringList shoots_list;     
  FloatList  deviation_list;
  FloatList attack_speed_list;
  FloatList time_before_next_attack_list;
  ArrayList<float[]> on_track_pos;      //sert uniquement aux spikes factory
  
  ArrayList<Tower> towers_affected_by_ability = new ArrayList<Tower>();
  float ability_use_time, ability_cooldown_timer;
  Ability linked_ability;
  
  
  Tower(String type, float x, float y){
    this.x=x;
    this.y=y;
    this.type=type;
    init_param_tower();
    set_param_tower();
    init_time_before_next_attack_list();
  }
  
  //subclasses func
  void set_param_tower(){}
  
  void show(){
    fill(couleur);
    noStroke();
    ellipse(x, y, size, size);
    if(highlight)  show_range(true);
  }
  
  void show_range(boolean can_place_tower){
    strokeWeight(1);
    if(can_place_tower){
      fill(0, 0, 0, 50);
      stroke(0, 0, 0);
      
    }
    else{
      fill(255, 0, 0, 50);
      stroke(255, 0, 0);
    }
    ellipse(x, y, range*2, range*2);
  }
  
  void init_time_before_next_attack_list(){
    time_before_next_attack_list = new FloatList();
    for(int i=0; i<shoots_list.size(); i++){
      time_before_next_attack_list.append(0);      
    }
  }
  
  
  void init_param_tower(){
    shoots_list=new StringList();
    deviation_list=new FloatList();
    attack_speed_list = new FloatList();
    time_before_next_attack_list = new FloatList();
  }
  
  
  ArrayList<Mob> get_enemis_in_range(){
    ArrayList<Mob> liste= new ArrayList<Mob>();
    for(Mob mob : enemis){
      if(distance(new float[] {mob.x, mob.y}, new float[] {x, y})<=range+mob.size/2){    //je prefere reconstruire 1 a 1 : évite peut etre des prbms de copie
        if(can_detect(mob, detects_camo))  liste.add(mob);       //on ne l'ajoute que si il n'est pas caché, il n'est pas camo ou alors on les détecte
      }
    }
    return liste;
  }
    
 
  Mob get_target(ArrayList<Mob> detected_mobs){
    //donne la cible selon la priorité, necessite de détecter au moins un mob
    Mob target= detected_mobs.get(0);
    if(priority.equals("first")){
      float avancement_max=0;
      for(Mob mob : detected_mobs){
        if(mob.avancement>avancement_max){
          target=mob;
          avancement_max=mob.avancement;
        }
      }
    }
    else if(priority.equals("strong")){
      int max_priority=0;
      float avancement_max=0;
      for(Mob mob : detected_mobs){
        if(force_list.get(mob.type)>max_priority || force_list.get(mob.type)==max_priority && mob.avancement>avancement_max){
          target=mob;
          max_priority=force_list.get(mob.type);
          avancement_max=mob.avancement;
        }
      }
    }
    else if(priority.equals("last")){
      float avancement_min=map.longueur_map+1;
      for(Mob mob : detected_mobs){
        if(mob.avancement<avancement_min){
          target=mob;
          avancement_min=mob.avancement;
        }
      }
    }
    else if(priority.equals("close")){ 
      float dist_min=Float.POSITIVE_INFINITY;
      for(Mob mob : detected_mobs){
        if(distance(new float[] {x, y}, new float[] {mob.x, mob.y})<dist_min){
          target=mob;
          dist_min=distance(new float[] {x, y}, new float[] {mob.x, mob.y});
        }
      }
    }
    return target;
  }
  
  
  void update(){
    update_time_before_next_attack();      //a faire chaque frame
    shoot();
  }
  
  void shoot(){
      
    if(enemis.size() == 0)  return;
    
    ArrayList<Mob> detected_mobs = get_enemis_in_range();
    if(detected_mobs.size() == 0 )  return;                        //si on ne detecte aucun mob, pas la peine de continuer
    
    Mob target=get_target(detected_mobs);                          //on garde le meme mob
    
    
    for(int i=0; i<shoots_list.size(); i++){
      String shoot_type = shoots_list.get(i);
      float deviation = deviation_list.get(i);
      float time_before_next_attack = time_before_next_attack_list.get(i);
      float attack_speed = attack_speed_list.get(i);
      
      while(time_before_next_attack <= 0){

        if(shoot_type.equals("laser")){
          lasers.add(new Laser(this, x, y, target));
        }
        else if(shoot_type.indexOf("boomerang")>=0){
          shoot_boomerang(target, shoot_type);
        }
        else if(this.type.equals("sniper")){
          instantiate_new_bullet(shoot_type, target);
          if(target.layers<=0){
            detected_mobs = get_enemis_in_range();
            if(detected_mobs.size() == 0 ){ //si on ne detecte aucun mob, pas la peine de continuer
              time_before_next_attack += 1 / attack_speed;      //affecter la valeur reste utile pour le while (sinon il faut remplacer par un _list.get(i)<=0 )
              time_before_next_attack_list.set(i, time_before_next_attack);
              return;
            }                    
            target=get_target(detected_mobs);
          }
        }
        else{
          if(type.equals("tack shooter")){
            instantiate_new_proj(shoot_type, deviation);
          }
          else{
            float[] futur_pos = map.get_pos(target.avancement + target.speed);                              //on prévois juste un coup d'avance
            float direction=atan2(futur_pos[1]-y, futur_pos[0]-x);
            
            instantiate_new_proj(shoot_type, direction + deviation);
          }
        }
        time_before_next_attack += 1 / attack_speed;      //affecter la valeur reste utile pour le while (sinon il faut remplacer par un _list.get(i)<=0 )
        time_before_next_attack_list.set(i, time_before_next_attack);
      }
    }
  }
  
  void update_time_before_next_attack(){
    if(round.waiting_next_round)  return;        //on ne compte pas le temps entre les rounds
    for(int i=0; i<time_before_next_attack_list.size(); i++){
      float timer = time_before_next_attack_list.get(i);
      if(timer>0)  time_before_next_attack_list.set(i, timer - joueur.game_speed / 60.);
    }
  }
  
  void shoot_boomerang(Mob target, String boomerang_type){
    float[] pos1 = new float[2];
    float[] pos2 = new float[2];
    float[] pos_finale=new float[2];
    float[] pos_inutile=new float[2];
    
    float[] futur_pos = map.get_pos(target.avancement + target.speed);                              //on prévois juste un coup d'avance
    if(distance(futur_pos, new float[] {x, y})>range)  futur_pos=new float[] {target.x, target.y};  //sauf si cela nous empeche de tapper la cible (plus de cercle sécants...)
    float[] temp = find_intersection_cercles(x, y, range/2, futur_pos[0], futur_pos[1], range/2);
    
    pos1[0] = temp[0];
    pos1[1] = temp[1];
    pos2[0] = temp[2];
    pos2[1] = temp[3];
    
    //on determine la pos du centre tel que le boomerang tappe le ballon avant d'etre a la moitié de son cercle
    
    //retourne l'équation de la droite sous la forme y=ax+b
    float a=(futur_pos[1]-y)/(futur_pos[0]-x); 
    float b=y-a*x;
    
    if(pos1[1] <= a * pos1[0] + b){
      pos_finale=pos1;
      pos_inutile=pos2;
    }
    else{
      pos_finale=pos2;
      pos_inutile=pos1;
    }
    
    if(target.x <= x){                //il faut inverser les pos
      pos_finale=pos_inutile;
    }
    
    switch(boomerang_type){
      case "basic boomerang":
        boomerangs.add(new Basic_boomerang(this, pos_finale[0], pos_finale[1], range/2));
        break;
      case "multi target boomerang ":
        boomerangs.add(new Multi_target_boomerang(this, pos_finale[0], pos_finale[1], range/2));
        break;
      case "sonic multi target boomerang":
        boomerangs.add(new Sonic_multi_target_boomerang(this, pos_finale[0], pos_finale[1], range/2));
        break;
      case "red hot multi target boomerang":
        boomerangs.add(new Red_hot_multi_target_boomerang(this, pos_finale[0], pos_finale[1], range/2));
        break;
      case "glaive boomerang":
        boomerangs.add(new Glaive_boomerang(this, pos_finale[0], pos_finale[1], range/2));
        break;
      case "sonic glaive boomerang":
        boomerangs.add(new Sonic_glaive_boomerang(this, pos_finale[0], pos_finale[1], range/2));
        break;
        
      case "red hot glaive boomerang":
        boomerangs.add(new Red_hot_glaive_boomerang(this, pos_finale[0], pos_finale[1], range/2));
        break;
      default:
        println("ERROR : Shoot type ", boomerang_type, " not suitable for shooting boomerang");
        break;
    }
       
  }
  
  void instantiate_new_bullet(String shoot_type, Mob target){
    Instant_projectile bull;
    switch(shoot_type){
      case "bullet":
        bull = new Bullet(this, target);  //bullet take action instantly, no need to add them to an ArrayList
        break;
      case "full metal bullet":
        bull = new Full_metal_bullet(this, target);
        break;
      case "point five bullet":
        bull = new Point_five_bullet(this, target);
        break;
      case "deadly bullet":
        bull = new Deadly_bullet(this, target);
        break;
      default:
        println("ERROR : Shoot type ", shoot_type, " not suitable for shooting bullet");
        break;
    } 
  }
  
  void instantiate_new_spike(String shoot_type, float dest_x, float dest_y){
    switch(shoot_type){
      case "spike":
        spikes.add(new Spike(this, dest_x, dest_y));
        break;
      case "stack spike":
        spikes.add(new Stack_spike(this, dest_x, dest_y));
        break;
      case "hot spike":
        spikes.add(new Hot_spike(this, dest_x, dest_y));
        break;
      case "spike ball":
        spikes.add(new Spike_ball(this, dest_x, dest_y));
        break;
      case "spike mine":
        spikes.add(new Spike_mine(this, dest_x, dest_y));
        break;
      default:
        println("ERROR : Shoot type ", shoot_type, " not suitable for shooting spike");
        break;
    }
  }
          
  
  void instantiate_new_proj(String shoot_type, float dir){
    switch(shoot_type){
      case "dart":
        projectiles.add(new Dart(this, x, y, dir));
        break;
      case "dart ball":
        projectiles.add(new Dart_ball(this, x, y, dir));
        break;
      case "huge dart ball":
        projectiles.add(new Huge_dart_ball(this, x, y, dir));
        break;
      case "sharp dart":
        projectiles.add(new Sharp_dart(this, x, y, dir));
        break;
      case "powerful dart":
        projectiles.add(new Powerful_dart(this, x, y, dir));
        break;
      case "razor sharp dart":
        projectiles.add(new Razor_sharp_dart(this, x, y, dir));
        break;
      case "tack":
        projectiles.add(new Tack(this, x, y, dir, range));
        break;
      case "blade":
        projectiles.add(new Blade(this, x, y, dir, range));
        break;        
      case "glaive ricochet":
        projectiles.add(new Glaive_ricochet(this, x, y, dir));
        break;
      case "sonic glaive ricochet":
        projectiles.add(new Sonic_glaive_ricochet(this, x, y, dir));
        break;
      case "red hot glaive ricochet":
        projectiles.add(new Red_hot_glaive_ricochet(this, x, y, dir));
        break;
      case "laser cannon":
        projectiles.add(new Laser_cannon(this, x, y, dir));
        break;
      case "bloontonium laser cannon":
        projectiles.add(new Bloontonium_laser_cannon(this, x, y, dir));
        break;
      case "ray of doom":
        projectiles.add(new Ray_of_doom(this, x, y, dir));
        break;
      case "bloontonium dart":
        projectiles.add(new Bloontonium_dart(this, x, y, dir));
        break;
      case "hydra rocket":
        projectiles.add(new Hydra_rocket(this, x, y, dir));
        break;
      case "purple ball":
        projectiles.add(new Purple_ball(this, x, y, dir));
        break;
      case "huge purple ball":
        projectiles.add(new Huge_purple_ball(this, x, y, dir));
        break;
      case "fireball":
        projectiles.add(new Fireball(this, x, y, dir));
        break;
      case "flame":
        projectiles.add(new Flame(this, x, y, dir, range));
        break;
      case "shuriken":
        projectiles.add(new Shuriken(this, x, y, dir));
        break;
      case "sharp shuriken":
        projectiles.add(new Sharp_shuriken(this, x, y, dir));
        break;
      case "seeking shuriken":
        projectiles.add(new Seeking_shuriken(this, x, y, dir));
        break;
      case "flash bomb":
        projectiles.add(new Flash_bomb(this, x, y, dir));
        break;
      default:
        println("ERROR : Shoot type ", shoot_type, " not suitable for shooting projectile");
        break;
    }
  }
  
}
