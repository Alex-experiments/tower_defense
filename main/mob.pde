static final int HALF_MAX_SIZE_MOB = ceil(42*1./2);  

class Mob{
  float x, y, px, py;
  float avancement;
  float base_speed=1.45 * round.speed_multiplier, speed=base_speed;
  int cell_id; 
  int layers, type_max_layers;
  String type;      //important pasque whites et blacks ont le meme nb de layers mais pas les memes carac ATTENTION : type == couleur (le type d'un red est le même que celui d'un red camo)
  
  //ArrayList<Mob> enfants;
  StringList enfants;
  
  boolean regrowth, camo, undirect_child_should_give_gold = true;
  boolean is_frozen=false, is_stunned=false, is_rooted=false, is_blown_away = false;    //stun est différent de rooted : quand on se fait tapper sous stun on repart, pas sous root
  float stun_time, stun_duration, root_time, root_duration;
  float blown_away_cos_dir, blown_away_sin_dir, blown_away_speed, blown_away_landing_avancement;
  float[] blown_away_landing_pos;
  ArrayList<String> past_types;
  float last_dmg_taken_time;
  int min_RBE_reached;
  
  //la sont des infos dont on a besoin pour pop_layers()
  ArrayList<Mob> list_of_bloons_dmged;
  
  ArrayList<Projectile> hurted_by_during_frame = new ArrayList<Projectile>();    //on va garder en mémoire tous les projectiles qui nous ont tappé durant cette frame
  
  ArrayList<Animator> sprites = new ArrayList<Animator>();
  Animator stun_overlay = new Animator("stunned overlay", 5);
  boolean freeze_rotation = true;
  float show_scale = 1., orientation;
  float size=42. * show_scale;                      //ATTENTION A CHANGER AUSSI DANS HALF_MAX_SIZE_MOB (pour la grid)
 
  
  Mob(String type, boolean regrowth, boolean camo, float avancement){ 
    this.avancement=avancement;
    update_pos();
    this.type=type;
    this.regrowth=regrowth;
    this.camo=camo;
    init_param_mob();
    init_regrowth();
    set_sprites();
  }
  
  void add_to_grid(){
    cell_id = grid.get_cell_id(x, y);
      grid.add_new_mob(this, cell_id);
  }
  
  void set_sprites(){
    StringList sprites_names = new StringList();
    if(regrowth){
      sprites_names.append(type+" regrowth bloon");
      if(camo)  sprites_names.append("camo regrowth overlay");
    }
    else{
      sprites_names.append(type+" bloon");
      if(camo)  sprites_names.append("camo overlay");
    }
    if(type.equals("ZOMG"))  sprites_names.append("ZOMG nose");
    
    for(String sprite_name : sprites_names){
      sprites.add(new Animator(sprite_name, 1));
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
    /*int[] pos_aff;
    pos_aff = pos_coins_sprites.get(sprite_name);
    image(bloons_sprites, x, y, pos_aff[2], pos_aff[3], pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
    */
    if(!freeze_rotation){
      pushMatrix();
      translate(x, y);
      rotate(orientation+HALF_PI);
      for(Animator anim : sprites){
        int[] pos_aff = anim.get_pos();
        if(pos_aff[6]==4){  //side mirror
          image(all_sprites, (pos_aff[4]-pos_aff[2]/2)*show_scale,   pos_aff[5],              pos_aff[2]*show_scale, pos_aff[3]*show_scale, pos_aff[0],            pos_aff[1],            pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
          image(all_sprites, (-pos_aff[4]+pos_aff[2]/2)*show_scale,  pos_aff[5],              pos_aff[2]*show_scale, pos_aff[3]*show_scale, pos_aff[0]+pos_aff[2], pos_aff[1],            pos_aff[0],            pos_aff[1]+pos_aff[3]);
        }
        else  image(all_sprites, pos_aff[4]*show_scale, pos_aff[5]*show_scale, pos_aff[2]*show_scale, pos_aff[3]*show_scale, pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
      }
      popMatrix();
    }
    else{
      for(Animator anim : sprites){
        int[] pos_aff = anim.get_pos();
        if(pos_aff[6]==4){  //side mirror
          image(all_sprites, x+(pos_aff[4]-pos_aff[2]/2)*show_scale,   y+pos_aff[5],              pos_aff[2]*show_scale, pos_aff[3]*show_scale, pos_aff[0],            pos_aff[1],            pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
          image(all_sprites, x+(-pos_aff[4]+pos_aff[2]/2)*show_scale,  y+pos_aff[5],              pos_aff[2]*show_scale, pos_aff[3]*show_scale, pos_aff[0]+pos_aff[2], pos_aff[1],            pos_aff[0],            pos_aff[1]+pos_aff[3]);
        }
        else  image(all_sprites, x+pos_aff[4]*show_scale, y+pos_aff[5]*show_scale, pos_aff[2]*show_scale, pos_aff[3]*show_scale, pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
      }
      if(is_stunned){
        int[] pos_aff = stun_overlay.get_pos();
        image(all_sprites, x+pos_aff[4]*show_scale*1.5, y+pos_aff[5]*show_scale*1.5, pos_aff[2]*show_scale*1.5, pos_aff[3]*show_scale*1.5, pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
        stun_overlay.update(false);
      }
    }
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
      default:
        println(type+"IS NOT A PROPER MOB TYPE");
        return 1;
    }
  }
   
  void init_param_mob(){
    enfants=new StringList();
    switch(type){
      case "red":
        layers=1;
        speed=base_speed;
        break;
      case "blue":
        layers=1;
        speed=base_speed*1.4;
        enfants.append("red");
        break;
      case "green":
        layers=1;
        speed=base_speed*1.8;
        enfants.append("blue");
        break;
      case "yellow":
        layers=1;
        speed=base_speed*3.2;
        enfants.append("green");
        break;
      case "pink":
        layers=1;
        speed=base_speed*3.5;
        enfants.append("yellow");
        break;
      case "black":
        layers=1;
        speed=base_speed*1.8;
        enfants.append("pink");
        enfants.append("pink");
        break;
      case "white":
        layers=1;
        speed=base_speed*2;
        enfants.append("pink");
        enfants.append("pink");
        break;
      case "lead":
        layers=1;
        speed=base_speed*1;
        enfants.append("black");
        enfants.append("black");
        break;
      case "zebra":
        layers=1;
        speed=base_speed*1.8;
        enfants.append("black");
        enfants.append("white");        
        break;
      case "rainbow":
        layers=1;
        speed=base_speed*2.2;
        enfants.append("zebra");
        enfants.append("zebra");
        break;
      case "ceramic":
        layers=10;
        speed=base_speed*2.5;
        enfants.append("rainbow");
        enfants.append("rainbow");
        break;
      case "MOAB":
        layers=int(200 * round.health_multiplier);
        speed=base_speed;
        enfants.append("ceramic");
        enfants.append("ceramic");
        enfants.append("ceramic");
        enfants.append("ceramic");
        freeze_rotation = false;
        show_scale = .6;
        break;
      case "BFB":
        layers=int(700 * round.health_multiplier);
        speed=base_speed * 0.25;
        enfants.append("MOAB");
        enfants.append("MOAB");
        enfants.append("MOAB");
        enfants.append("MOAB");
        freeze_rotation = false;
        show_scale = .6;
        break;
      case "ZOMG":
        layers=int(4000 * round.health_multiplier);
        speed=base_speed * 0.18;
        enfants.append("BFB");
        enfants.append("BFB");
        enfants.append("BFB");
        enfants.append("BFB");
        freeze_rotation = false;
        show_scale = .6;
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
      joueur.hurt(get_RBE());
      delete(i);
    }
    else{
      show();
    }
  }
  
  void delete(int i){
    grid.remove_mob(this, cell_id);
    enemis.remove(i);
  }
  
  void delete(){
    grid.remove_mob(this, cell_id);
    enemis.remove(this);
  }
  
  void update(){
    for(Projectile proj : hurted_by_during_frame)  proj.already_dmged_mobs.add(this);
    hurted_by_during_frame.clear();
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
            set_sprites();   
            if(enfants.size()>1)  undirect_child_should_give_gold = false;  //on vient de passer à un type qui enfante deux ballons au moins
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
    if(is_rooted){
      if(FAKE_TIME_ELAPSED - root_time > root_duration)  is_rooted = false;
      else return;
    }    
    if(is_blown_away){
      for(int i=0; i<joueur.game_speed; i++){
        x += blown_away_cos_dir * blown_away_speed;
        y += blown_away_sin_dir * blown_away_speed;
        if(distance(new float[] {x, y}, blown_away_landing_pos) < blown_away_speed){
          x = blown_away_landing_pos[0];
          y = blown_away_landing_pos[1];
          is_blown_away = false;
          avancement = blown_away_landing_avancement;
          break;
        }
      }
      update_cell_id();
      return;
    }
    if(!freeze_rotation){
      px = x;
      py = y;
    }
    avancement += speed * joueur.game_speed;
    update_pos();
    update_cell_id();
    if(!freeze_rotation){
      orientation = atan2(y-py, x-px);
    }
  }
  
  void update_cell_id(){
    int new_cell_id = grid.get_cell_id(x, y);
    if(new_cell_id != cell_id){
      grid.change_cell(this, cell_id, new_cell_id);
      cell_id = new_cell_id;
    }
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
    else if(effect.indexOf("blow away")>=0){
      if(is_blown_away || get_RBE()>416)  return;    //n'affecte pas les MOABS
      is_blown_away = true;
      float[] percentage_of_map = new float[] {0.4, 0.7};    //dans le cas d'une whirlwind : on recule entre 40% et 70% de la longueur du track, contre 60% à 100% pour une tornado
      if(effect.equals("blow away far"))  percentage_of_map = new float[] {0.6, 1.};
      else if(effect.equals("blow away distraction"))  percentage_of_map = new float[] {0.15, .45};    //et de 25% à 60% pour un shuriken
      blown_away_landing_avancement = max(0., avancement-map.longueur_map * random(percentage_of_map[0], percentage_of_map[1]));
      blown_away_landing_pos = map.get_pos(blown_away_landing_avancement);
      blown_away_speed = 5.;                                          //ici la duration est utilisée pour passer la speed !
      float dir = atan2(blown_away_landing_pos[1] - y, blown_away_landing_pos[0]-x);
      blown_away_cos_dir = cos(dir);
      blown_away_sin_dir = sin(dir);
      
      if(distance(new float[] {x, y}, blown_away_landing_pos) <= blown_away_speed)   is_blown_away = false;  //sinon ca provoque des blown away quand un ballon est à 0, 0 et ca le fait parti n'imp avec le atan2
      
    }
    else  println("ERROR : effect", effect, "not implemented yet");
  }
  
  void transmit_effect(Mob parent, int fils_numero){
    if(parent.is_stunned){
      is_stunned = true;
      stun_duration = parent.stun_duration;
      stun_time = parent.stun_time;
    }
     
    if(parent.is_rooted){
      is_rooted = true;
      root_duration = parent.root_duration;
      root_time = parent.root_time;
    }
    
    if(parent.is_blown_away){
      is_blown_away = true;
      blown_away_landing_avancement = parent.blown_away_landing_avancement;
      blown_away_landing_pos = new float[] {parent.blown_away_landing_pos[0], parent.blown_away_landing_pos[1]};
      blown_away_speed = parent.blown_away_speed;
      blown_away_cos_dir = parent.blown_away_cos_dir;
      blown_away_sin_dir = parent.blown_away_sin_dir;
      x = parent.x + fils_numero * blown_away_cos_dir;
      y = parent.y + fils_numero * blown_away_sin_dir;
    }
  }
  
  
  boolean track_ended(){
    return avancement>map.longueur_map;
  }
  
  void add_one_gold(){
    //Différent du nombre de layers pop : on ne gagne 1 de gold qu'a chaque fois qu'un ballon change de type (ex céramic à rainbow)
    if( !regrowth || get_RBE() <= min_RBE_reached)    joueur.gain(1);
  }
  
  int pop_layers(int nb_layers_to_pop, boolean initial_hit, String damage_type){
    // Retourne le nb de layers détruites
        
    if(nb_layers_to_pop<=0)  return 0;
    
    
    if(initial_hit){
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
      if(type.equals("ceramic")){
        sprites.get(0).frame_count = -(ceil(layers/2.)-5);    //le 2. est important sinon div entiere !
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
          Mob fils = new Mob(enfants.get(i), regrowth, camo, avancement + 5*i);    //on l'ajoute direct à la grid
          fils.transmit_effect(this, i);
          if(regrowth){
            fils.past_types=ArrayList_of_string_copy(past_types);
            fils.min_RBE_reached=min( min_RBE_reached, fils.get_RBE());      // la RBE minimum consiste en le min entre celle atteinte et la RBE actuelle du fils
            if(!undirect_child_should_give_gold && i>=1)  fils.min_RBE_reached = -1;  //on empeche le regrow farming
          }
          if( !damage_type.equals("laser")){    //un laser ne peut tuer les enfants d'un ballon
            int temp=fils.pop_layers(nb_layers_to_pop, false, damage_type);    //pas besoin de créer de nouvelles explosions car on l'a deja fait
            layers_popped+=temp;
            nb_layers_to_pop -= temp;
          }
          
          if(fils.layers>0){
            fils.add_to_grid();
            fils.orientation = orientation;
            enemis.add(fils);
          }
        }
      }
      
      if(initial_hit){        
        pop_animations.add(new Pop_animation(x, y, size));
        for(int i=enemis_size; i<enemis.size(); i++){    //on ajoute tous les ballons enfantés qui ne sont pas morts    si aucun ballon enfanté (enemis_size==enemis.size() ) ca ne fait pas la boucle
          list_of_bloons_dmged.add(enemis.get(i));
          for(int index=0; index<hurted_by_during_frame.size(); index++){
            enemis.get(i).hurted_by_during_frame.add(hurted_by_during_frame.get(index));
          }
        }
      }
      
      add_one_gold();      //le ballon est passé à 0 layers : on gagne un de gold
      
      stat_manager.increment_stat(type+ (camo ? " camo":"") + (regrowth ? " regrowth":""), "bloons");
      if(camo || regrowth)  stat_manager.increment_stat(type, "bloons");    //on augmente aussi le compteur général (genre +1 red (dont camo +1))
      stat_manager.increment_stat("Bloons popped", "overview");
      
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
