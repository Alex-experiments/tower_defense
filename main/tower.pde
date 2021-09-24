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
  
  void set_sprites(){
    sprites_names = new StringList();
    if(path_2_progression == 4)  sprites_names.append("super monkey fan club");
    else if(path_1_progression<3 && path_2_progression<4)  sprites_names.append("dart monkey");
    else sprites_names.append("dart monkey");
        
    if(max(path_1_progression, path_2_progression)==1)  sprites_names.append("bandana vert");
    else if(max(path_1_progression, path_2_progression)==2)  sprites_names.append("bandana rouge");
    else if(path_2_progression == 3){
      sprites_names.append("triple dart bandana");
      sprites_names.append("carquois");
    }
    
    
    sprites_pos = get_sprites_pos(sprites_names);
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
  
  void set_sprites(){
    sprites_names = new StringList();
    
    if(max(path_1_progression, path_2_progression)==0)  sprites_names.append("tack shooter sorties");
    else if(max(path_1_progression, path_2_progression)<=2)  sprites_names.append("tack shooter sorties big");
    else if(path_2_progression >= 3)  sprites_names.append("blade shooter sorties");
    else if(path_1_progression == 3)  sprites_names.append("tack sprayer sorties");
    
    if(path_2_progression == 3)  sprites_names.append("blade shooter body");
    else if(path_2_progression == 4)  sprites_names.append("blade maelstrom body");
    else if(path_1_progression == 4)  sprites_names.append("ring of fire");
    else sprites_names.append("tack shooter body");
    
    if(max(path_1_progression, path_2_progression)<=1)  sprites_names.append("two tacks");
    else if(path_1_progression <= 3 && path_2_progression<=2)  sprites_names.append("three tacks");
    
    sprites_pos = get_sprites_pos(sprites_names);
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
  
  void set_sprites(){
    sprites_names = new StringList();
    
    sprites_names.append("dart monkey");
      
    if(path_2_progression >= 2)  sprites_names.append("sniper monkey googles");
    
    if(path_1_progression == 0 && path_2_progression==0)  sprites_names.append("sniper monkey green hat");
    else if(path_1_progression == 3)  sprites_names.append("sniper monkey black hat");
    else if(path_2_progression == 3)  sprites_names.append("sniper monkey target hat");
    else if(path_1_progression == 2)  sprites_names.append("sniper monkey purple hat");      //le purple a la prio sur le blue qui a la prio sur le red
    else if(path_2_progression == 1 || path_2_progression==2)  sprites_names.append("sniper monkey blue hat");
    else if(path_1_progression == 1)  sprites_names.append("sniper monkey red hat");
    
    
    sprites_names.append("sniper monkey gachette");
    sprites_names.append("sniper monkey gun");
    if(path_1_progression>=3)  sprites_names.append("sniper monkey green ray");
    else if(path_2_progression>=3)  sprites_names.append("sniper monkey grand silencieux");
    else sprites_names.append("sniper monkey silencieux");
    
    if(path_1_progression == 4)  sprites_names.append("sniper monkey green camo");
    else if(path_2_progression==4)  sprites_names.append("sniper monkey black camo");
    
    sprites_pos = get_sprites_pos(sprites_names);
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
        projectiles.add(new Projectile(this, x, y, direction+deviation, shoot_type));
        
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
        
        spikes.add(new Spikes(this, on_track_pos.get(index)[0], on_track_pos.get(index)[1], shoot_type));
        
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
  
  StringList sprites_names = new StringList();
  ArrayList<int[]> sprites_pos = new ArrayList<int[]>();
  float orientation;
  
  
  Tower(String type, float x, float y){
    this.x=x;
    this.y=y;
    this.type=type;
    init_param_tower();
    set_param_tower();
    init_time_before_next_attack_list();
    set_sprites();
  }
  
  //subclasses func
  void set_param_tower(){}
  void set_sprites(){};
  
  void show(){
    if(sprites_names.size()==0){
      fill(couleur);
      noStroke();
      ellipse(x, y, size, size);
    }
    else{
      pushMatrix();
      translate(x, y);
      rotate(orientation);
      for(int[] pos_aff : sprites_pos){
        if(pos_aff[7]==1){
          image(all_sprites, pos_aff[4]-pos_aff[2]/2, pos_aff[5]-pos_aff[3]/2, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
          image(all_sprites, pos_aff[4]+pos_aff[2]/2, pos_aff[5]-pos_aff[3]/2, pos_aff[2], pos_aff[3], pos_aff[0]+pos_aff[2], pos_aff[1], pos_aff[0], pos_aff[1]+pos_aff[3]);
          image(all_sprites, pos_aff[4]+pos_aff[2]/2, pos_aff[5]+pos_aff[3]/2, pos_aff[2], pos_aff[3], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3], pos_aff[0], pos_aff[1]);
          image(all_sprites, pos_aff[4]-pos_aff[2]/2, pos_aff[5]+pos_aff[3]/2, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1]+pos_aff[3], pos_aff[0]+pos_aff[2], pos_aff[1]);
        }
        else if(pos_aff[6]==1){
          image(all_sprites, pos_aff[4]-pos_aff[2]/2, pos_aff[5], pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
          image(all_sprites, pos_aff[4]+pos_aff[2]/2, pos_aff[5], pos_aff[2], pos_aff[3], pos_aff[0]+pos_aff[2], pos_aff[1], pos_aff[0], pos_aff[1]+pos_aff[3]);
        }
        else  image(all_sprites, pos_aff[4], pos_aff[5], pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
      }
      popMatrix();
    }
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
          Instant_projectile bullet = new Instant_projectile(this, target, shoot_type);    //bullet take action instantly, no need to add them to an ArrayList
          this.orientation = atan2(target.y-y, target.x-x)+HALF_PI;
          
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
            projectiles.add(new Projectile(this, x, y, deviation, shoot_type));
          }
          else{
            float[] futur_pos = map.get_pos(target.avancement + target.speed);                              //on prévois juste un coup d'avance
            float direction=atan2(futur_pos[1]-y, futur_pos[0]-x);
            this.orientation = direction+HALF_PI;
            
            projectiles.add(new Projectile(this, x, y, direction+deviation, shoot_type));
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
    
      boomerangs.add(new Boomerang(this, pos_finale[0], pos_finale[1], range/2, boomerang_type));
       
  }

  
}
