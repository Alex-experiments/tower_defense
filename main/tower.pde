class Dart_monkey extends Tower{
  
  Dart_monkey(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur=color(0, 0, 255);
    price=200;
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

class Super_monkey_fan extends Tower{
  Tower ability_casted_by_tour;
  
  Super_monkey_fan(Tower linked_tower, Tower ability_casted_by_tour, String type, float x, float y){
    super(type, x, y);
    selectable = false;
    summoner = linked_tower;
    this.ability_casted_by_tour = ability_casted_by_tour;
    detects_camo = summoner.detects_camo;  //obligé de le faire la est pas dans set_param_tower() car super() appelle set_param_tower()
  }
  
  void set_param_tower(){
    couleur=color(0, 0, 255);
    price=0;
    //range=162;    //ca c'est le super monkey de base mais la on est a range de supermonkey x/1
    range=230;
    
    shoots_list.append("razor sharp dart");
    deviation_list.append(0);
    attack_speed_list.append(30);    //deux fois plus vite que les super monkey !
  }
}

class Tack_shooter extends Tower{

  Tack_shooter(String type, float x, float y){
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
    else if(path_1_progression == 4){
      sprites_names.append("ring of fire sorties flame");
      sprites_names.append("ring of fire body");
    }
    else sprites_names.append("tack shooter body");
    
    if(max(path_1_progression, path_2_progression)<=1)  sprites_names.append("two tacks");
    else if(path_1_progression <= 3 && path_2_progression<=2)  sprites_names.append("three tacks");
    
    sprites_pos = get_sprites_pos(sprites_names);
  }
  
}

class Sniper extends Tower{

  Sniper(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    priority="strong";
    couleur=color(0, 128, 64);
    price=350;
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

class Boomerang_thrower extends Tower{

  Boomerang_thrower(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur = color(255, 242, 0);
    price = 400;
    range = 165;
    
    shoots_list.append("basic boomerang");
    deviation_list.append(0);
    attack_speed_list.append(0.75);
  }
  
  void set_sprites(){
    sprites_names = new StringList();
    
    if(path_2_progression>=3)  sprites_names.append("boomerang shooter bionic arm");
    
    if(path_1_progression <= 1 && path_2_progression <= 2)  sprites_names.append("boomerang shooter body");
    else if(path_2_progression>=3)  sprites_names.append("dart monkey");
    else if(path_1_progression == 2)  sprites_names.append("boomerang shooter red body");
    else if(path_1_progression == 3)  sprites_names.append("boomerang shooter purple body");
    else if(path_1_progression == 4){
      sprites_names.append("dart monkey");
      sprites_names.append("boomerang shooter white suit");
    }
    
    if(path_2_progression>=3)  sprites_names.append("boomerang shooter bionic eye");
    
    if(path_1_progression == 0){
      if(path_2_progression==0)  sprites_names.append("boomerang shooter triangle");
      else if(path_2_progression == 1)  sprites_names.append("boomerang shooter circle");
      else if(path_2_progression == 2)  sprites_names.append("boomerang shooter cross");
    }
    else if(path_1_progression == 1){
      if(path_2_progression==0)  sprites_names.append("boomerang shooter triple triangle");
      else if(path_2_progression == 1)  sprites_names.append("boomerang shooter triple circle");
      else if(path_2_progression == 2)  sprites_names.append("boomerang shooter cross");
    }
   
    sprites_pos = get_sprites_pos(sprites_names);
  }
  
}

class Ninja_monkey extends Tower{

  Ninja_monkey(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur = color(255, 0, 0);
    price = 500;
    range = 152;
    detects_camo=true;
    
    shoots_list.append("shuriken");
    deviation_list.append(0);
    attack_speed_list.append(1.67);
  }
  
  void set_sprites(){
    sprites_names = new StringList();
    
    if(path_1_progression == 0 && path_2_progression == 0)  sprites_names.append("ninja monkey red body");
    else if(path_1_progression == 4)  sprites_names.append("ninja monkey white body suit");
    else if(path_1_progression>=path_2_progression){
      sprites_names.append("ninja monkey white body");
      if(path_1_progression == 3)  sprites_names.append("bandana rouge");
      else if(path_1_progression == 2)  sprites_names.append("bandana violet");
      else if(path_1_progression == 1)  sprites_names.append("bandana noir");
    }
    else if(path_1_progression < path_2_progression){
      sprites_names.append("ninja monkey black body");
      if(path_2_progression == 4)  sprites_names.append("ninja monkey googles");
      else if(path_2_progression == 3)  sprites_names.append("bandana rouge");
      else if(path_2_progression == 2)  sprites_names.append("bandana bleu");
      else if(path_2_progression == 1)  sprites_names.append("bandana blanc");
    }
    
    sprites_pos = get_sprites_pos(sprites_names);
  }
}


class Wizard_monkey extends Tower{

  Wizard_monkey(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur=color(209, 34, 234);
    price=550;
    range=152;
    shoots_list.append("purple ball");
    deviation_list.append(0);
    attack_speed_list.append(0.91);
  }
  
  void set_sprites(){
    sprites_names = new StringList();
    if(max(path_1_progression, path_2_progression) == 0)  sprites_names.append("wizard monkey body");
    else if(max(path_1_progression, path_2_progression) == 1)  sprites_names.append("wizard monkey google body");
    else if(max(path_1_progression, path_2_progression) == 2)  sprites_names.append("wizard monkey hat");
    else if(path_1_progression == 3){
      sprites_names.append("wizard monkey blue hat");
      sprites_names.append("blue straight wand");
    }
    else if(path_2_progression == 3){
      sprites_names.append("wizard monkey red hat");
      sprites_names.append("red straight wand");
    }
    else if(path_1_progression == 4){
      sprites_names.append("wizard monkey socle nuage");
      sprites_names.append("wizard monkey tornado body");
      sprites_names.append("blue bent wand");
    }
    else if(path_2_progression == 4){
      sprites_names.append("wizard monkey socle napalm flame");
      sprites_names.append("wizard monkey socle solaire");
      sprites_names.append("wizard monkey phoenix summoner body");
      sprites_names.append("red bent wand");
    }
    
    
    sprites_pos = get_sprites_pos(sprites_names);
  }
  
}

class Phoenix extends Tower{
  static final float ORBIT_RAYON = 250, ANGULAR_SPEED = .01;
  
  Phoenix(Tower summoner){
    super("phoenix", 0, 0);
    this.summoner = summoner;
    set_orientation_when_shoot = false;
    selectable = false;
    orientation = PI;
  }
  
  void set_param_tower(){
    couleur=color(209, 34, 234);
    price=0;
    range=160;
    shoots_list.append("dragon's breath");
    deviation_list.append(0);
    attack_speed_list.append(15);    //pas mal piffé
    detects_camo = true;
  }
  
  void set_sprites(){
    sprites_names = new StringList();
    sprites_names.append("phoenix body");
    sprites_names.append("phoenix wing");
    sprites_pos = get_sprites_pos(sprites_names);
  }
  
  void update(){
    moove();
    update_time_before_next_attack();
    shoot();
  }
  
  void moove(){
    orientation+=ANGULAR_SPEED * joueur.game_speed % TWO_PI;
    x = tower_panel.top_left_x/2 - cos(orientation) * ORBIT_RAYON;
    y = info_panel.top_left_y/2 - sin(orientation) * ORBIT_RAYON;    
  }
  
}


class Dartling_gun extends Tower{

  Dartling_gun(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur = color(180, 230, 30);
    price = 950;
    detects_camo=true;
    max_dispersion = 0.4;   //en radians
    range=44;    //seuleument pour le visuel
    
    shoots_list.append("dart");
    deviation_list.append(0);
    attack_speed_list.append(5);
  }
  
  void set_sprites(){
    sprites_names = new StringList();
    
    if(path_1_progression >= 3)  sprites_names.append("dartling gun red body");
    else sprites_names.append("dartling gun body");
    
    
    if(path_2_progression == 4){
      sprites_names.append("dartling gun rocket storm barrels");
      sprites_names.append("dartling gun rocket storm gun");
      sprites_names.append("dartling gun red hat");
    }
    else{
      sprites_names.append("dartling gun barrels");
      if(path_2_progression == 3){
        sprites_names.append("dartling gun hydra rocket gun");
        sprites_names.append("dartling gun red hat");
      }
      else if(path_1_progression == 4)  sprites_names.append("dartling gun ray of doom gun");
      else if(path_1_progression == 3)  sprites_names.append("dartling gun laser canon gun");
      else if(path_2_progression == 2){
        sprites_names.append("dartling gun purple gun");
        sprites_names.append("dartling gun purple hat");
      }
      else if(path_1_progression == 2){
        sprites_names.append("dartling gun blue gun");
        sprites_names.append("dartling gun blue hat");
      }
      else if(max(path_1_progression, path_2_progression) <= 1){
        sprites_names.append("dartling gun green hat");
        if(max(path_1_progression, path_2_progression) == 1)  sprites_names.append("dartling gun hat target");
        sprites_names.append("dartling gun basic gun");
      }
    }
   
    
    
    sprites_pos = get_sprites_pos(sprites_names);
  }
  
  void shoot(){
    
    if(round.waiting_next_round)  return;      //sinon lance un projectile parasite
    
    float direction = atan2(mouseY-y, mouseX-x);
    orientation = direction+HALF_PI;
    
    if(path_1_progression == 4)  return;    //on a deja un ray_of_doom
    
    FloatList directions_list=new FloatList();
    
    for(int i=0; i<shoots_list.size(); i++){
      String shoot_type = shoots_list.get(i);
      float deviation = deviation_list.get(i);
      float time_before_next_attack = time_before_next_attack_list.get(i);
      float attack_speed = attack_speed_list.get(i);
      
      int compteur_dir=0;
      while(time_before_next_attack<=0){
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


class Spike_factory extends Tower{

  Spike_factory(String type, float x, float y){
    super(type, x, y);
  }
  
  void set_param_tower(){
    couleur = color(0, 0, 0);
    price = 700;
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
  float base_size=60, size = base_size;
  int pop_count=0;
  String type;
 
  float max_dispersion;
  
  boolean detects_camo=false;
  
  color couleur;
  int price=0;
  
  int path_1_progression, path_2_progression;
  
  StringList shoots_list;     
  FloatList deviation_list, attack_speed_list, time_before_next_attack_list;
  ArrayList<float[]> on_track_pos;      //sert uniquement aux spikes factory
  
  float ability_use_time, ability_cooldown_timer;
  int ability_state;
  Ability linked_ability;
  
  StringList sprites_names = new StringList();
  ArrayList<int[]> sprites_pos = new ArrayList<int[]>();
  
  float orientation;
  boolean set_orientation_when_shoot = true;
  boolean selectable = true;
  Tower summoner;
  boolean active = true;    //c'est par exemple quand une abilite remplace une tour par une autre temporairement : on update ni ne show() la tour remplacée
  
  Tower(String type, float x, float y){
    this.x=x;
    this.y=y;
    this.type=type;
    init_param_tower();
    set_param_tower();
    init_time_before_next_attack_list();
    set_sprites();
  }
  
  void core(){
    if(!active)  return;
    update();
    show();
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
        if(pos_aff[6]==3){
          for(int i=0; i<8; i++){
            rotate(QUARTER_PI);
            image(all_sprites, pos_aff[4], pos_aff[5], pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
          }
        }
        if(pos_aff[6]==2){
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
      float dist = distance(new float[] {mob.x, mob.y}, new float[] {x, y});
      //pour shoot un boomerang, on a besoin de ne pas prendre en compte la taille du mob (sinon inter cercles renvoie des NaN
      if(dist <= range || shoots_list.get(0).indexOf("boomerang")<0 && dist<=range+mob.size/2){    //je prefere reconstruire 1 a 1 : évite peut etre des prbms de copie
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
        else if(shoot_type.equals("ring of fire")){
          projectiles.add(new Ring_of_fire(this));
        }
        else if(shoot_type.indexOf("boomerang")>=0){
          if(set_orientation_when_shoot)  this.orientation = atan2(target.y-y, target.x-x)+HALF_PI;
          shoot_boomerang(target, shoot_type);
        }
        else if(this.type.equals("sniper")){
          Instant_projectile bullet = new Instant_projectile(this, target, shoot_type);    //bullet take action instantly, no need to add them to an ArrayList
          if(set_orientation_when_shoot)  this.orientation = atan2(target.y-y, target.x-x)+HALF_PI;
          
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
            //float[] futur_pos = map.get_pos(target.avancement + target.speed);                              //on prévois juste un coup d'avance
            //faut pas faire ca car quand les mobs sont blow_away (par ex avec tornado), ca fait tirer la tour n'importe ou
            float direction=atan2(target.y-y, target.x-x);
            if(set_orientation_when_shoot)  this.orientation = direction+HALF_PI;
            
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
  
  void add_pop_count(int dmg_done_this_frame){
    pop_count+=dmg_done_this_frame;
    if(summoner != null)  summoner.pop_count+=dmg_done_this_frame;
    joueur.game_pop_count += dmg_done_this_frame;
  }
  
  void shoot_boomerang(Mob target, String boomerang_type){
    float[] pos1 = new float[2];
    float[] pos2 = new float[2];
    float[] pos_finale=new float[2];
    float[] pos_inutile=new float[2];
    
    float[] temp = find_intersection_cercles(x, y, range/2, target.x, target.y, range/2);    
    
    pos1[0] = temp[0];
    pos1[1] = temp[1];
    pos2[0] = temp[2];
    pos2[1] = temp[3];
    
    //on determine la pos du centre tel que le boomerang tappe le ballon avant d'etre a la moitié de son cercle
    
    //retourne l'équation de la droite sous la forme y=ax+b
    float a=(target.y-y)/(target.x-x); 
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
    
    projectiles.add(new Boomerang(this, pos_finale[0], pos_finale[1], range/2, boomerang_type));
       
  }

  
}
