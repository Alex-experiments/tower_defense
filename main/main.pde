//police de charactère ravie ?, BerlinSansFB-Reg-48, Chiller-Regular-48, ForteMT-48, GoudyStout-48, MaturaMTScriptCapitals-48, ShowcardGothic-Reg-48, SnapITC-Regular-48


//reste à faire : napalm, visu napalm + stun (root ?), sprites spike factory, shooting offset, menu principal


boolean auto_pass_levels=true;
boolean god_mode=false;

float FAKE_TIME_ELAPSED;//à chaque frame c'est une constante

PImage background, all_sprites, bloons_sprites, ability_sprites, coin_sprite, coeur_sprite;

ArrayList<Mob> enemis=new ArrayList<Mob>();
ArrayList<Projectile> projectiles=new ArrayList<Projectile>();
ArrayList<Laser> lasers=new ArrayList<Laser>();
ArrayList<Tower> towers=new ArrayList<Tower>();
ArrayList<Pop_animation> pop_animations=new ArrayList<Pop_animation>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Spikes> spikes = new ArrayList<Spikes>();
ArrayList<Ability> abilities = new ArrayList<Ability>();
ArrayList<Banana> bananas = new ArrayList<Banana>();

Spatial_grid grid = new Spatial_grid(HALF_MAX_SIZE_MOB);

Map map = new Map(2);
Joueur joueur= new Joueur(200, 650);
Rounds round= new Rounds();
Info_panel info_panel;
Tower_panel tower_panel;
Upgrades upgrades = new Upgrades();
Stat_manager stat_manager;
Lost_menu lost_menu;
Stat_menu stat_menu;

HashMap<String,Integer> force_list = new HashMap<String,Integer>();
HashMap<String,Integer> intervall_multiplier = new HashMap<String,Integer>();
HashMap<String,int[]> pos_coins_sprites = new HashMap<String,int[]>();

PFont font, font_18px, font_32px, font_huge;


void load_sprites(){
  coin_sprite = loadImage("coin_sprite.png");
  coeur_sprite = loadImage("coeur_sprite.png");
  background=loadImage("map_3.png");
  all_sprites=loadImage("sprites_all.png");
  ability_sprites=loadImage("ability_sprites.png");
  
  String[] lines = loadStrings("pos_sprites.txt");
    
  int space_index, offset_index;
  int separateur_index;
  String name;
  int dx, dy, x, y, offset_x, offset_y;
  int half, quarter, eigth, hor_mirror, vert_mirror;
  
  int nb_sprites = 0;
  
  for(String ligne : lines){
    space_index = ligne.indexOf(" : ");
    offset_index = ligne.indexOf(" offset ");
    half = ligne.indexOf(" half"); quarter = ligne.indexOf(" quarter"); eigth = ligne.indexOf(" eigth"); hor_mirror = ligne.indexOf(" horizontal mirror"); vert_mirror = ligne.indexOf(" vertical mirror");
    println(ligne);
      if(space_index!=-1){
        name = ligne.substring(0, space_index);
        separateur_index = ligne.indexOf('*', space_index);
        dx=int(ligne.substring(space_index+3, separateur_index));
        space_index=ligne.indexOf(" a ", separateur_index);
        dy=int(ligne.substring(separateur_index+1, space_index));
        separateur_index = ligne.indexOf(", ", space_index);
        x=int(ligne.substring(space_index+3, separateur_index));
        if(offset_index == -1){
          int end = ligne.length();
          if(half>-1)  end = half;
          else if(quarter>-1)  end = quarter;
          else if(eigth>-1)  end = eigth;
          else if(hor_mirror>-1)  end = hor_mirror;
          else if(vert_mirror>-1)  end = vert_mirror;
          y=int(ligne.substring(separateur_index+2, end));
          offset_x=0;
          offset_y=0;
        }
        else{
          y=int(ligne.substring(separateur_index+2, offset_index));
          separateur_index = ligne.indexOf(';');
          offset_x = int(ligne.substring(offset_index+8, separateur_index));
          int end = ligne.length();
          if(half>-1)  end = half;
          else if(quarter>-1)  end = quarter;
          else if(eigth>-1)  end = eigth;
          else if(hor_mirror>-1)  end = hor_mirror;
          else if(vert_mirror>-1)  end = vert_mirror;
          offset_y = int(ligne.substring(separateur_index+2, end));
        }
        int last_param = half>-1 ? 1:0 + 2*(quarter>-1 ? 1:0) + 3*(eigth>-1 ? 1:0) + 4*(hor_mirror>-1 ? 1:0) + 5*(vert_mirror>-1 ? 1:0);  //vaut 1 si half, 2 si quarter et 3 si eigth
        pos_coins_sprites.put(name, new int[] {x, y, dx, dy, offset_x, offset_y, last_param});
        nb_sprites++;
     }
  }
  
  println(nb_sprites, "sprites repertories");
  
  bloons_sprites=loadImage("bloons_sprites_transp.png");
  String[] y_ordre = {"zebra", "lead", "white", "black", "pink", "yellow", "green", "blue", "red"};
  String[] x_ordre = {"", " regrowth", " camo", " camo regrowth"};
  
  //pour les normaux, la box est de 24x32 avec un offset de 13, 9 a chaque fois
  // regrow : 33x34 avec offset de 9, 8
  // pour white and black normaux/camos seulement : 16x20 avec offset de 17, 14
  // pour céramique : 29x38 avec offset de 10, 6
  // pour passer de l'un à l'autre selon y ajouter 0, 50
  // pour passer de l'un à l'autre selon x ajouter 50, 0
  
  
  for(int a=0; a<y_ordre.length; a++){
    for(int b=0; b<x_ordre.length; b++){
      name = y_ordre[a] + x_ordre[b];
      
      if( (x_ordre[b].equals("") || x_ordre[b].equals(" camo")) && (y_ordre[a].equals("white") || y_ordre[a].equals("black"))){
        pos_coins_sprites.put(name, new int[] {50*b + 17, 50*a + 14, 16, 20});
      }
      else if(x_ordre[b].equals("") || x_ordre[b].equals(" camo")){
        pos_coins_sprites.put(name, new int[] {50*b + 13, 50*a + 9, 24, 32});
      }
      else{
        pos_coins_sprites.put(name, new int[] {50*b + 9, 50*a + 8, 33, 34});
      }
      
    }
  }
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


void setup(){
  load_sprites();
  tower_panel = new Tower_panel(875, 0, 1000, 750, false);    //ne pas le mettre avant car quand tower panel crée ses boutons il a besoin des sprites
  info_panel = new Info_panel();
  stat_manager = new Stat_manager();  //ne pas le mettre en dehors de setup car appel un fichier et avant setup, le path n'est pas défini
  imageMode(CENTER);
  frameRate(60);
  surface.setSize(1000, 750);
  surface.setLocation(300, 100);
  
  StringList bloons_names = new StringList("red", "blue", "green", "yellow", "pink", "black", "white", "lead", "zebra", "rainbow", "ceramic", "MOAB", "BFB", "ZOMG");
  int black_seen = 0;
  int mult = 1;
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
  
  /*randomSeed(1111);
  
  for(int i = 0; i<10000; i++){
    Mob temp = new Mob("red", false, false, random(map.longueur_map));
    //temp.avancement = ;
    enemis.add(temp);
  }
  
  for(int i =0; i<100; i++){
    towers.add(new Dart_monkey("dart monkey", random(875), random(650)));
  }
  noLoop();*/
  
  println(grid.n_cell_x, grid.n_cell_y);
  
  font = createFont("FONT.TTF", 12); font_18px = createFont("FONT.TTF", 18);  font_32px = createFont("FONT.TTF", 32); 
  
  lost_menu = new Lost_menu();  
  stat_menu = new Stat_menu(25, 25, 975, 725);
  
  
  textFont(font);
}


void draw(){ 
  //float t = millis();    //résultats autour de 5400, 5550, 5300 //on passe & 4500 !
  //for(int iter=0; iter<100; iter++){
  
  if(stat_menu.active){
    stat_menu.core();
  }
  else if(lost_menu.active){
    lost_menu.core();
    if(lost_menu.ended()){
      //gravity.mult(-1);  //faut pas oublier de la remettre normale
      gravity = new PVector(0, .1);
      lost_menu.active = false;
      if(lost_menu.go_to_menu){
        stat_menu.active = true;
        stat_menu.screen = get();
        //menu_principal.active = true;
      }
      else  init_new_game();
    }
  }
  else  game();
  
  //}
  //float t_end = millis();
  //println(t_end - t);
}

void init_new_game(){
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
  
  map = new Map(2);
  joueur= new Joueur(200, 650);
  round= new Rounds();
  info_panel= new Info_panel();
  tower_panel = new Tower_panel(875, 0, 1000, 750, false);
  
  textFont(font);
}

void game(){
  
  if(keyPressed && key == '$')      god_mode = true;
  
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
  joueur.vies-=10;
  
  FAKE_TIME_ELAPSED = get_fake_time_elapsed(FAKE_TIME_ELAPSED);    //ATTENTION : NE PAS COMPTER LE TEMPS ENTRE LES ROUNDS
  background(255);    //fond blanc A ENLEVER DES QUE LES PANNEAUX ONT UN SPRITE
  image(background, 875/2, 650/2);  
  //map.show();
  stat_manager.display("overview", width/2, 0, 15);
  
  //if(enemis.size() != grid.get_nb_enemis_stored())  println(round.round_number, enemis.size(), grid.get_nb_enemis_stored());
  
  round.update();
  round.spawn();
  
  grid.reset_pop_counter();
  
  //On update tous les enemis
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

  for(Tower tour : towers){
    tour.core();
  }
  
  //On affiche tous les lasers
  for (int i = lasers.size() - 1; i >= 0; i--){
    lasers.get(i).core();
  }
  
  //On update tous les projectiles tirés
  int nb_proj = projectiles.size();
  for (int i = nb_proj - 1; i >= 0; i--){
    //projectiles.get(i).verif_damage_type();
    projectiles.get(i).core(i, nb_proj);
  }
  
  for(int i=bananas.size()-1; i>=0; i--){
    bananas.get(i).core();
  }
  
  
  //On affiche toutes les pop_animations
  for (int i = pop_animations.size() - 1; i >= 0; i--){
    pop_animations.get(i).core();
  }
  
  //On affiche toutes les explosions
  for (int i = explosions.size() - 1; i >= 0; i--){
    explosions.get(i).core();
  }
  
  
  textAlign(CENTER, CENTER);
  for(Ability abi : abilities){
    abi.core();
  }
  
  
  tower_panel.interact();
  joueur.show_fps();
  joueur.interactions();
  joueur.select_existing_tower();
  joueur.show_selected_tower_range();
  
  tower_panel.show();    //permet d'afficher la selected_tower en dessous du tower panel
  
  info_panel.interact(joueur.selected_tower);
  info_panel.show(joueur.selected_tower);
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
