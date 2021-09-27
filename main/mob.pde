class Mob{
  float x, y;
  float avancement;
  float base_speed=1.45, speed=base_speed;
  int layers, type_max_layers;
  float size=16;
  color couleur;
  String type;      //important pasque whites et blacks ont le meme nb de layers mais pas les memes carac
  
  //ArrayList<Mob> enfants;
  StringList enfants;
  
  boolean regrowth;
  boolean camo;
  boolean is_frozen=false, is_stunned=false, is_rooted=false, is_blown_away = false;    //stun est différent de rooted : quand on se fait tapper sous stun on repart, pas sous root
  float stun_time, stun_duration, root_time, root_duration;
  float blown_away_cos_dir, blown_away_sin_dir, blown_away_speed, blown_away_landing_avancement;
  float[] blown_away_landing_pos;
  ArrayList<String> past_types;
  float last_dmg_taken_time;
  int min_RBE_reached;
  
  //la sont des infos dont on a besoin pour pop_layers()
  ArrayList<Mob> list_of_bloons_dmged;
  
  String sprite_name;
 
  
  Mob(String type, boolean regrowth, boolean camo){
    x=10;
    y=0;
    avancement=0;
    this.type=type;
    this.regrowth=regrowth;
    this.camo=camo;
    this.type=type;
    init_param_mob();
    init_regrowth();
    init_sprite_name();
  }
  
  void init_sprite_name(){
    sprite_name = type;
    if(regrowth && camo){
      sprite_name+="camo + regrowth";
    }
    else if(regrowth){
      sprite_name+="regrowth";
    }
    else if(camo){
      sprite_name+="camo";
    }
    else{
      sprite_name+="basic";
    }
  }
  
  void init_regrowth(){
    if(regrowth){
      min_RBE_reached=get_RBE();
      past_types=new ArrayList<String>();
      last_dmg_taken_time=FAKE_TIME_ELAPSED;
    }
  }
  
  void show(){
    int[] pos_aff;
    pos_aff = pos_coins_sprites.get(sprite_name);
    //pos_aff = pos_coins_sprites.get("redbasic");
    
    image(bloons_sprites, x, y, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
  }
  
  int get_RBE(){
    switch(type){
      case "red":
        return 1;
      case "blue":
        return 2;
      case "green":
        return 3;
      case "yellow":
        return 4;
      case "pink":
        return 5;
      case "black":
        return 11;
      case "white":
        return 11;
      case "lead":
        return 23;
      case "zebra":
        return 23;
      case "rainbow":
        return 47;
      case "ceramic":
        return 94+layers;
      case "MOAB":
        return 416+layers;    //si changer, mettre dans apply_effect aussi
      case "BFB":
        return 2464+layers;
      case "ZOMG":
        return 12656+layers;
      case "DDT":
        return 416+layers;
      case "BAD":
        return 35760+layers;
      // attention après faudra faire un N - layers pour les bloons a plusieurs layers
    }
    return 1;    //pasque il faut bien return qqch
  }
  
  void init_param_mob(){
    enfants=new StringList();
    switch(type){
      case "red":
        layers=1;
        speed=base_speed;
        couleur=color(207, 0, 0);        
        break;
      case "blue":
        layers=1;
        speed=base_speed*1.4;
        couleur=color(44, 147, 215);
        enfants.append("red");
        break;
      case "green":
        layers=1;
        speed=base_speed*1.8;
        couleur=color(120, 182, 0);
        enfants.append("blue");
        break;
      case "yellow":
        layers=1;
        speed=base_speed*3.2;
        couleur=color(255, 226, 0);
        enfants.append("green");
        break;
      case "pink":
        layers=1;
        speed=base_speed*3.5;
        couleur=color(255, 96, 111);
        enfants.append("yellow");
        break;
      case "black":
        layers=1;
        speed=base_speed*1.8;
        couleur=color(25, 25, 25);
        enfants.append("pink");
        enfants.append("pink");
        break;
      case "white":
        layers=1;
        speed=base_speed*2;
        couleur=color(140, 239, 255);
        enfants.append("pink");
        enfants.append("pink");
        break;
      case "lead":
        layers=1;
        speed=base_speed*1;
        couleur=color(123, 123, 123);
        enfants.append("black");
        enfants.append("black");
        break;
      case "zebra":
        layers=1;
        speed=base_speed*1.8;
        couleur=color(190, 0, 190);              //modifier le design
        enfants.append("black");
        enfants.append("white");        
        break;
      case "rainbow":
        layers=1;
        speed=base_speed*2.2;
        couleur=color(255, 128, 64);
        enfants.append("zebra");
        enfants.append("zebra");
        break;
      case "ceramic":
        layers=10;
        speed=base_speed*2.5;
        couleur=color(189, 105, 24);
        enfants.append("rainbow");
        enfants.append("rainbow");
        break;
      case "MOAB":
        layers=200;
        speed=base_speed;
        couleur=color(0, 0, 255);
        enfants.append("ceramic");
        enfants.append("ceramic");
        enfants.append("ceramic");
        enfants.append("ceramic");
        break;
      case "BFB":
        layers=700;
        speed=base_speed * 0.25;
        couleur=color(0, 0, 128);
        enfants.append("MOAB");
        enfants.append("MOAB");
        enfants.append("MOAB");
        enfants.append("MOAB");
        break;
      case "ZOMG":
        layers=4000;
        speed=base_speed * 0.18;
        couleur=color(0, 0, 64);
        enfants.append("BFB");
        enfants.append("BFB");
        enfants.append("BFB");
        enfants.append("BFB");
        break;
      case "DDT":
        break;
      case "BAD":
        break;
      default:
        println("BLOON WITH NO TYPE");
        break;
    }
    
    type_max_layers=layers;
    
  }
  
  void core(int i){
    update();
    if(track_ended()){
      joueur.vies-=get_RBE();
      enemis.remove(i);
    }
    else{
      show();
    }
  }
  
  void update(){
    regrow();
    deplacement();
  }
  
  void regrow(){
    if(regrowth && layers>0){                              //seuleument si on a deja été touché
      if(FAKE_TIME_ELAPSED-last_dmg_taken_time >= 1.){
        last_dmg_taken_time = FAKE_TIME_ELAPSED;
        if( layers >= type_max_layers){  //si on a atteint le max des layers
          if(past_types.size()>0){ //on doit passer au type au dessus (si il y en a un)
            type=past_types.get(past_types.size()-1);
            past_types.remove(type);
            init_param_mob();                         //en faisant ca le ballon est direct au max de ses layers : ce n'est pas ce qu'on veut
            layers=1;                                 //on est du type d'au dessus avec juste une layer
            init_sprite_name();   
          }
        }
        else{                         //on est au type maximum donc on cap au max de layers
          layers++;
        } 
      }
    }
  }
  
  void deplacement(){
    if(is_stunned){
      if(FAKE_TIME_ELAPSED - stun_time > stun_duration)  is_stunned = false;
      else return;
    }
    if(is_blown_away){
      x += blown_away_cos_dir * blown_away_speed;
      y += blown_away_sin_dir * blown_away_speed;
      if(distance(new float[] {x, y}, blown_away_landing_pos) < blown_away_speed){
        x = blown_away_landing_pos[0];
        y = blown_away_landing_pos[1];
        is_blown_away = false;
        avancement = blown_away_landing_avancement;
      }
      return;
    }
    avancement += speed * joueur.game_speed;
    update_pos();
  }
  
  void update_pos(){
    float [] new_pos=map.get_pos(avancement);
    x=new_pos[0];
    y=new_pos[1];
  }
  
  
  void apply_effect(String effect, float duration){
    if(duration<0)  return;    //si la durée est négative ca veut dire que l'effet ne vise pas ce type de bloon (ex : cripple bullet qui target que les MOABS)
    if(effect.equals("stun")){
      is_stunned = true;
      stun_duration = duration;
      stun_time = FAKE_TIME_ELAPSED;
    }
    else if(effect.equals("root")){
      is_rooted = true;
      root_duration = duration;
      root_time = FAKE_TIME_ELAPSED;
    }
    else if(effect.equals("blow away")){
      if(get_RBE()>416)  return;    //n'affecte pas les MOABS
      is_blown_away = true;
      blown_away_landing_avancement = 0.;
      blown_away_landing_pos = map.get_pos(blown_away_landing_avancement);
      blown_away_speed = 5.;                                          //ici la duration est utilisée pour passer la speed !
      float dir = atan2(blown_away_landing_pos[1] - y, blown_away_landing_pos[0]-x);
      blown_away_cos_dir = cos(dir);
      blown_away_sin_dir = sin(dir);
    }
    else  println("ERROR : effect", effect, "not implemented yet");
  }
  
  
  boolean track_ended(){
    return avancement>map.longueur_map;
  }
  
  void add_one_gold(){
    //Différent du nombre de layers pop : on ne gagne 1 de gold qu'a chaque fois qu'un ballon change de type (ex céramic à rainbow)
    if( !regrowth || get_RBE() <= min_RBE_reached)    joueur.argent++;
  }
  
  int pop_layers(int nb_layers_to_pop, boolean initial_hit, String damage_type){
    // Retourne le nb de layers détruites
        
    if(nb_layers_to_pop<=0)  return 0;
    
    
    if(initial_hit){
      if(can_damage(this, damage_type))  pop_animations.add(new Pop_animation(x, y, size));
      list_of_bloons_dmged=new ArrayList<Mob>();
      list_of_bloons_dmged.add(this);  //on ajoute meme les mobs qu'on ne peut pas tapper pour éviter de gaspiller tout son pierce dessus en cas de rebonds possibles
    }
    
    if(!can_damage(this, damage_type))  return 0;
    //pas besoin de check si il détecte les camos vu que si il y a eu pop_layers, il y a eu can_detect()
    
    if(nb_layers_to_pop<layers){
      
      if(is_stunned && stun_time < FAKE_TIME_ELAPSED)  is_stunned = false;    //si on se fait tapper au moins une frame après le stun on est plus stun
      
      layers-=nb_layers_to_pop;
      if(regrowth){
        min_RBE_reached = min( get_RBE(), min_RBE_reached);
        last_dmg_taken_time=FAKE_TIME_ELAPSED;
      }
      return nb_layers_to_pop;
    }
    else{
      if(regrowth){
        if( !past_types.contains(type)){
          past_types.add(type);            //past_types contient tous les types de ballons qu'on a été (présent non compris)
        }
      }
      int layers_popped=layers;
      nb_layers_to_pop -= layers;
      layers=0;
      
      int enemis_size=enemis.size();
      
      if(enfants!=null){      //pourquoi pas faire en sorte de séparer les dégats sur les ballons sortants
        for(int i=0; i<enfants.size(); i++){
          Mob fils = new Mob(enfants.get(i), regrowth, camo);;
          fils.avancement = avancement + 5*i;
          fils.update_pos();                        //pour permettre aux autres de le tapper si il est dans leur range sans attendre la frame suivante pour update leur pos
          if(regrowth){
            fils.past_types=ArrayList_of_string_copy(past_types);
            fils.min_RBE_reached=min( min_RBE_reached, fils.get_RBE());      // la RBE minimum consiste en le min entre celle atteinte et la RBE actuelle du fils
          }
          /*if(i==0 || !can_bounce || bounces_left>0){    //on ne fait des degats à cet enfant que si : c'est lengeance directe ou si ya pas de rebonds ou si il en reste
            layers_popped+=fils.pop_layers(nb_layers_to_pop, false, bounces_left-1, can_bounce);    //pas besoin de créer de nouvelles explosions car on l'a deja fait
            bounces_made+=fils.get_bounces_made();
            bounces_left-=fils.get_bounces_made();
            nb_layers_to_pop-=layers_popped;
          }*/
          if( !damage_type.equals("laser")){    //un laser ne peut tuer les enfants d'un ballon
            int temp=fils.pop_layers(nb_layers_to_pop, false, damage_type);    //pas besoin de créer de nouvelles explosions car on l'a deja fait
            layers_popped+=temp;
            nb_layers_to_pop -= temp;
          }
          
          if(fils.layers>0)  enemis.add(fils);
        }
      }
      
      if(initial_hit){        
        for(int i=enemis_size; i<enemis.size(); i++){    //on ajoute tous les ballons enfantés qui ne sont pas morts    si aucun ballon enfanté (enemis_size==enemis.size() ) ca ne fait pas la boucle
          list_of_bloons_dmged.add(enemis.get(i));
        }
      }
      
      add_one_gold();      //le ballon est passé à 0 layers : on gagne un de gold
      
      return layers_popped;
    }
  }
  
  ArrayList<Mob> bloons_dmged(){
    //Pour ne pas faire de la merde avec already_dmged_mobs
    return list_of_bloons_dmged;
  }
  
  ArrayList<String> ArrayList_of_string_copy(ArrayList<String> s){
    //pour éviter les pbms de deepcopy
    ArrayList<String> res = new ArrayList<String>();
    for(String mot : s){
      res.add(mot);
    }
    return res;
  }
  
}
