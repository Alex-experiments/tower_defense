/*************************************************************************/
//ENTIEREMENT DEVELOPPE PAR : Alexandre GAUTIER
//CONTACT : alexandre.gautier@student-cs.fr
//
static final float VERSION = 1.0;
//MIS A JOUR LE : 11/10/2021
//
//Le concept du jeu ainsi que l'immense majorité des graphismes
//sont la propriété de NinjaKiwi.
//A travers ce projet, j'ai voulu recréer moi même Bloons Tower Defense 5.
/*************************************************************************/

//reste à faire : napalm, visu napalm (+root ?), full moabs skins, menu difficulte

boolean auto_pass_levels=false;
boolean god_mode=false;

float FAKE_TIME_ELAPSED;//à chaque frame c'est une constante

PImage background, all_sprites, ability_sprites;

ArrayList<Mob> enemis;
ArrayList<Projectile> projectiles;
ArrayList<Laser> lasers;
ArrayList<Tower> towers;
ArrayList<Pop_animation> pop_animations;
ArrayList<Explosion> explosions;
ArrayList<Spikes> spikes;
ArrayList<Ability> abilities;
ArrayList<Banana> bananas;

Spatial_grid grid = new Spatial_grid(HALF_MAX_SIZE_MOB);

Game game;
Map map;
Joueur joueur;
Rounds round;
Info_panel info_panel;
Tower_panel tower_panel;

Upgrades upgrades = new Upgrades();

Stat_manager stat_manager;
Lost_menu lost_menu;
Stat_menu stat_menu;
Main_menu main_menu;
Map_menu map_menu;

HashMap<String,Integer> force_list = new HashMap<String,Integer>();
HashMap<String,Integer> intervall_multiplier = new HashMap<String,Integer>();
HashMap<String,int[]> pos_coins_sprites = new HashMap<String,int[]>();

PFont font, font_18px, font_32px, font_huge;


void setup(){
  load_sprites();
  imageMode(CENTER);
  frameRate(60);
  surface.setSize(1000, 750);
  surface.setLocation(300, 100);
  surface.setTitle("Bloons Tower Defense 5 more or less"); 
  
  StringList bloons_names = new StringList("red", "blue", "green", "yellow", "pink", "black", "white", "lead", "zebra", "rainbow", "ceramic", "MOAB", "BFB", "ZOMG");
  int black_seen = 0;
  for(int i = 0; i<bloons_names.size(); i++){
    force_list.put(bloons_names.get(i), i+1-black_seen);
    if(i<=6)  intervall_multiplier.put(bloons_names.get(i), 1);
    else if(i<=10)  intervall_multiplier.put(bloons_names.get(i), i-5);
    else if(i==11)  intervall_multiplier.put(bloons_names.get(i), 30);
    else if(i==12)  intervall_multiplier.put(bloons_names.get(i), 60);
    else if(i==13)  intervall_multiplier.put(bloons_names.get(i), 90);
    
    if(bloons_names.get(i).equals("black"))  black_seen=1;
  }
  
  ellipseMode(CENTER);
  rectMode(CORNERS);
  
  /*randomSeed(1111);                //pour tester la diff avec ou sans la spatial grid    résultats : pour 100 iter autour de 5400, 5550, 5300 //on passe à 4500 ! (avec tout l'affichage en prime)
  for(int i = 0; i<10000; i++){
    Mob temp = new Mob("red", false, false, random(map.longueur_map));
    enemis.add(temp);
  }
  for(int i =0; i<100; i++)  towers.add(new Dart_monkey("dart monkey", random(875), random(650)));
  noLoop();*/
    
  font = createFont("FONT.TTF", 12); font_18px = createFont("FONT.TTF", 18);  font_32px = createFont("FONT.TTF", 32); 
  
  stat_manager = new Stat_manager();  //ne pas le mettre en dehors de setup car appel un fichier et avant setup, le path n'est pas défini
  lost_menu = new Lost_menu();  
  stat_menu = new Stat_menu(25, 25, 975, 675);
  main_menu = new Main_menu();
  map_menu = new Map_menu(50, 100, 950, 600);
  main_menu.init();
  game = new Game();
}


void draw(){ 
  if(stat_menu.active)        stat_menu.core();
  else if(map_menu.active)    map_menu.core();
  else if(main_menu.active)   main_menu.core();
  else if(lost_menu.active)   lost_menu.core();
  else  game.core();
}

class Game{
  String difficulty;
  int map_number;
  boolean game_just_saved=false;


  boolean init(boolean use_save, String difficulty, int map_number){
    background=loadImage("map_"+str(map_number)+".png");
    this.difficulty = difficulty;
    this.map_number = map_number;
    
    game_just_saved = use_save;
    god_mode = false;
    
    FAKE_TIME_ELAPSED=0.;
    
    enemis=new ArrayList<Mob>();
    projectiles=new ArrayList<Projectile>();
    lasers=new ArrayList<Laser>();
    towers=new ArrayList<Tower>();
    pop_animations=new ArrayList<Pop_animation>();
    explosions = new ArrayList<Explosion>();
    spikes = new ArrayList<Spikes>();
    abilities = new ArrayList<Ability>();
    bananas = new ArrayList<Banana>();
    
    grid = new Spatial_grid(HALF_MAX_SIZE_MOB);
    
    map = new Map(this.map_number);
    joueur= new Joueur(200, 650);
    round= new Rounds();
    info_panel= new Info_panel();
    tower_panel = new Tower_panel(875, 0, 1000, 750, false);
    
    auto_pass_levels = false;
    
    if(use_save) return load_game();
    textFont(font);
    return true;
  }
  
  void core(){
    
    if(keyPressed && key == '$')  god_mode = true;
    if(keyPressed && key == ')')  save_game();
    
    if(god_mode){
      joueur.vies=100;
      joueur.argent=max(joueur.argent, 1000000);
    }
    else if(joueur.vies<=0){
      stat_manager.increment_stat("Games lost", "overview");
      stat_manager.save_all();
      lost_menu.init();
      return;
    }
    
    FAKE_TIME_ELAPSED = get_fake_time_elapsed(FAKE_TIME_ELAPSED);    //ATTENTION : NE PAS COMPTER LE TEMPS ENTRE LES ROUNDS
    image(background, 875/2, 650/2);  
    //map.show();
        
    round.update();
    round.spawn();
    
    grid.reset_pop_counter();
    
    for (int i = enemis.size() - 1; i >= 0; i--){    //a faire avant les proj
      enemis.get(i).core(i);
    }
  
    map.hide();
    
    //On update tous les spikes    (avant les tours sinon ca se met par dessus le phoenix et tout)
    int nb_spikes = spikes.size();
    for (int i = nb_spikes - 1; i >= 0; i--){
      //spikes.get(i).verif_damage_type();
      spikes.get(i).core(i, nb_spikes);
    }
  
    for(Tower tour : towers)  tour.core();

    for (int i = lasers.size() - 1; i >= 0; i--)   lasers.get(i).core();
    
    int nb_proj = projectiles.size();
    for (int i = nb_proj - 1; i >= 0; i--){
      //projectiles.get(i).verif_damage_type();
      projectiles.get(i).core(i, nb_proj);
    }
    
    for(int i=bananas.size()-1; i>=0; i--)      bananas.get(i).core();
    
    for (int i = pop_animations.size() - 1; i >= 0; i--)  pop_animations.get(i).core();
    
    for (int i = explosions.size() - 1; i >= 0; i--)  explosions.get(i).core();

    
    textAlign(CENTER, CENTER);
    for(Ability abi : abilities) abi.core();    
    
    tower_panel.interact();
    if(main_menu.active)   return;    //si on appuie sur le home button ca change la police sinon
    joueur.show_fps();
    joueur.interactions();
    joueur.select_existing_tower();
    joueur.show_selected_tower_range();
    
    tower_panel.show();    //permet d'afficher la selected_tower en dessous du tower panel
    
    info_panel.interact(joueur.selected_tower);
    info_panel.show(joueur.selected_tower);    
  }
  
  void save_game(){
    String[] save = new String[]{};
    save = append(save, str(VERSION)+";"+str(map_number)+";"+difficulty+";"+str(round.round_number)+";"+str(joueur.argent)+";"+str(joueur.vies)+";"+str(joueur.game_pop_count)+";");
    for(Tower tour : towers){
      if(tour.summoner!=null)  continue;
      String ligne = tour.type;
      ligne+=";"+str(tour.x)+";"+str(tour.y)+";"+tour.priority+";"+str(tour.path_1_progression)+";"+str(tour.path_2_progression)+";"+str(tour.pop_count)+";";
      if(tour.linked_ability != null){
        ligne += str(tour.linked_ability.get_remaining_cd_of_tower(tour))+";";
      }
      save = append(save, ligne);
    }
    saveStrings("/data/save.txt", save);
  }
  
  boolean load_game(){
    String[] lines = loadStrings("save.txt");
    if(lines == null){
      println("NO SAVE.TXT FILE DETECTED");
      return false;
    }
    if(lines.length==0){
      println("SAVE.TXT FILE EXISTS BUT IS EMPTY");
      return false;
    }
    String infos = lines[0];
    int sep = infos.indexOf(";");
    if(float(infos.substring(0,  sep)) != VERSION){
      println("LA VERSION DU JEU A ETE CHANGEE : INCOMPATIBLE");
      return false;
    }
    infos = infos.substring(sep+1, infos.length());
    sep = infos.indexOf(";");
    int loaded_map_number = int(infos.substring(0, sep));
    infos = infos.substring(sep+1, infos.length());
    sep = infos.indexOf(";");
    String loaded_difficulty = infos.substring(0, sep);
    infos = infos.substring(sep+1, infos.length());
    sep = infos.indexOf(";");
    int loaded_round_number = int(infos.substring(0, sep));
    infos = infos.substring(sep+1, infos.length());
    sep = infos.indexOf(";");
    int loaded_argent = int(infos.substring(0, sep));
    infos = infos.substring(sep+1, infos.length());
    sep = infos.indexOf(";");
    int loaded_vies = int(infos.substring(0, sep));
    infos = infos.substring(sep+1, infos.length());
    sep = infos.indexOf(";");
    int loaded_pop_count = int(infos.substring(0, sep));
    
    joueur.argent = loaded_argent;
    joueur.vies = loaded_vies;
    joueur.game_pop_count = loaded_pop_count;
    round.round_number = loaded_round_number;
    difficulty = loaded_difficulty;
    this.map_number = loaded_map_number;
    map = new Map(this.map_number);  //sinon ca foire avec les set_on_track_pos();
    background=loadImage("map_"+str(map_number)+".png");
    
    
    for(int i=1; i<lines.length; i++){
      String ligne = lines[i];
      sep = ligne.indexOf(";");
      String type = ligne.substring(0, sep);
      ligne = ligne.substring(sep+1, ligne.length());
      sep = ligne.indexOf(";");
      float x = float(ligne.substring(0, sep));
      ligne = ligne.substring(sep+1, ligne.length());
      sep = ligne.indexOf(";");
      float y = float(ligne.substring(0, sep));
      ligne = ligne.substring(sep+1, ligne.length());
      sep = ligne.indexOf(";");
      String priority = ligne.substring(0, sep);
      ligne = ligne.substring(sep+1, ligne.length());
      sep = ligne.indexOf(";");
      int path_1_progression = int(ligne.substring(0, sep));
      ligne = ligne.substring(sep+1, ligne.length());
      sep = ligne.indexOf(";");
      int path_2_progression = int(ligne.substring(0, sep));
      ligne = ligne.substring(sep+1, ligne.length());
      sep = ligne.indexOf(";");
      int pop_count = int(ligne.substring(0, sep));
      ligne = ligne.substring(sep+1, ligne.length());
      sep = ligne.indexOf(";");
      float ability_remaining_cd = 0.;
      if(sep>-1){  //la tour a une ability
        ability_remaining_cd = float(ligne.substring(0, sep));
      }
      println(ability_remaining_cd);
      
      Tower tour = get_new_tower(type, x, y);
      tour.set_on_track_pos();
      tour.priority = priority;
      tour.pop_count = pop_count;
      for(int k=0; k<path_1_progression; k++){
        upgrades.apply_upgrade(tour, 1, true, ability_remaining_cd);
      }
      for(int k=0; k<path_2_progression; k++){
        upgrades.apply_upgrade(tour, 2, true, ability_remaining_cd);
      }
      towers.add(tour);      
    }
    
    return true;
  }

}


float get_fake_time_elapsed(float last_time){    //va surement y avoir des erreurs d'arrondi mais osef
  if(round.waiting_next_round){
    return last_time;
  }
  return last_time + joueur.game_speed/60;
}

void outline_text(String text, float x, float y, color back_color, color font_color, int off){
    fill(back_color);
    for(float i = x-off; i<=x+off; i+=off){
      for(float j = y-off; j<=y+off; j+=off){
        text(text, i, j);
      }
    }    
    fill(font_color);
    text(text, x, y);
  }


float distance(float[] pos1, float[] pos2){
  return sqrt( pow(pos1[0]-pos2[0], 2) + pow(pos1[1]-pos2[1], 2));
}

float distance(float x1, float y1, float x2, float y2){
  return sqrt( (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) );
}

float distance_sqred(float x1, float y1, float x2, float y2){
  return  (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) ;
}

float[] find_intersection_cercles(float cercle1_x, float cercle1_y, float cercle1_rayon, float cercle2_x, float cercle2_y, float cercle2_rayon){
  //http://math.15873.pagesperso-orange.fr/IntCercl.html
  
  if(cercle1_y == cercle2_y){
    float x = (cercle2_rayon*cercle2_rayon - cercle1_rayon*cercle1_rayon + cercle1_x*cercle1_x - cercle2_x*cercle2_x) / (2 * (cercle1_x - cercle2_x));
    float B = -2*cercle2_y;
    float C = cercle2_x*cercle2_x + x*x - 2*cercle2_x * x + cercle2_y*cercle2_y - cercle2_rayon*cercle2_rayon;
    float sqr_delta = sqrt(B*B - 4*C);
    float y = (-B - sqr_delta)/2;
    float y2 = (-B + sqr_delta)/2;

    return new float[] {x, y, x, y2};
  }
  
  
  float N = (-cercle1_rayon*cercle1_rayon + cercle1_x*cercle1_x + cercle1_y*cercle1_y - (-cercle2_rayon*cercle2_rayon + cercle2_x*cercle2_x + cercle2_y*cercle2_y)) / (2*(cercle1_y - cercle2_y));
  float A = 1 + ( (cercle1_x - cercle2_x)/(cercle1_y - cercle2_y) ) * ( (cercle1_x - cercle2_x)/(cercle1_y - cercle2_y) );
  float B = 2*( cercle1_y - N ) * (cercle1_x - cercle2_x)/(cercle1_y - cercle2_y) - 2* cercle1_x;
  float C = cercle1_x*cercle1_x + cercle1_y*cercle1_y + N*N - cercle1_rayon*cercle1_rayon - 2*cercle1_y*N;
  float sqr_delta = sqrt(B*B - 4*A*C);
  
  float x = (-B - sqr_delta)/(2*A);
  float y = N - x*(cercle1_x - cercle2_x)/(cercle1_y - cercle2_y);  
  
  float x2 = (-B + sqr_delta)/(2*A);
  float y2 = N - x2*(cercle1_x - cercle2_x)/(cercle1_y - cercle2_y);
  
  return new float[] {x, y, x2, y2};
}

void load_sprites(){
  all_sprites=loadImage("sprites_all.png");
  ability_sprites=loadImage("ability_sprites.png");
  
  String[] lines = loadStrings("pos_sprites.txt");
    
  int space_index, offset_index, separateur_index;
  String name;
  int dx, dy, x, y, offset_x, offset_y;
  int half, quarter, eigth, hor_mirror, vert_mirror;
  
  int nb_sprites = 0;
  
  for(String ligne : lines){
    space_index = ligne.indexOf(" : ");
    offset_index = ligne.indexOf(" offset ");
    half = ligne.indexOf(" half"); quarter = ligne.indexOf(" quarter"); eigth = ligne.indexOf(" eigth"); hor_mirror = ligne.indexOf(" horizontal mirror"); vert_mirror = ligne.indexOf(" vertical mirror");
    //println(ligne);
      if(space_index!=-1){
        name = ligne.substring(0, space_index);
        separateur_index = ligne.indexOf('*', space_index);
        dx=int(ligne.substring(space_index+3, separateur_index));
        space_index=ligne.indexOf(" a ", separateur_index);
        dy=int(ligne.substring(separateur_index+1, space_index));
        separateur_index = ligne.indexOf(", ", space_index);
        x=int(ligne.substring(space_index+3, separateur_index));
        int end = max(max(half, quarter, eigth), hor_mirror, vert_mirror);
        if(end<0)  end = ligne.length();
        if(offset_index == -1){
          y=int(ligne.substring(separateur_index+2, end));
          offset_x=0;
          offset_y=0;
        }
        else{
          y=int(ligne.substring(separateur_index+2, offset_index));
          separateur_index = ligne.indexOf(';');
          offset_x = int(ligne.substring(offset_index+8, separateur_index));
          offset_y = int(ligne.substring(separateur_index+2, end));
        }
        int last_param = half>-1 ? 1:0 + 2*(quarter>-1 ? 1:0) + 3*(eigth>-1 ? 1:0) + 4*(hor_mirror>-1 ? 1:0) + 5*(vert_mirror>-1 ? 1:0);  //vaut 1 si half, 2 si quarter et 3 si eigth
        pos_coins_sprites.put(name, new int[] {x, y, dx, dy, offset_x, offset_y, last_param});
        nb_sprites++;
     }
  }
  
  println(nb_sprites, "sprites repertories");
}

ArrayList<int[]> get_sprites_pos(StringList sprites_names){
  ArrayList<int[]> pos = new ArrayList<int[]>();
  for(String sprite_name : sprites_names){
    if(pos_coins_sprites.containsKey(sprite_name)){
      pos.add(pos_coins_sprites.get(sprite_name));
    }
    else  println("couldn't find pos of ", sprite_name);
  }
  return pos;
}
