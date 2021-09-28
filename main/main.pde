//police de charactère ravie ?

boolean auto_pass_levels=true;
boolean god_mode=true;

//Problème : les boomerangs touchent un ballon et peuvent faire demi tour pour toucher ses fils //semble pas etre le cas en fait

float FAKE_TIME_ELAPSED;//à chaque frame c'est une constante

PImage background;
PImage all_sprites;
PImage bloons_sprites;
PImage coin_sprite;
PImage coeur_sprite;

ArrayList<Mob> enemis=new ArrayList<Mob>();
ArrayList<Projectile> projectiles=new ArrayList<Projectile>();
ArrayList<Boomerang> boomerangs=new ArrayList<Boomerang>();
ArrayList<Laser> lasers=new ArrayList<Laser>();
ArrayList<Tower> towers=new ArrayList<Tower>();
ArrayList<Pop_animation> pop_animations=new ArrayList<Pop_animation>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
ArrayList<Spikes> spikes = new ArrayList<Spikes>();
ArrayList<Ability> abilities = new ArrayList<Ability>();
ArrayList<Banana> bananas = new ArrayList<Banana>();
ArrayList<Ring_of_fire> rings_of_fire = new ArrayList<Ring_of_fire>();
ArrayList<Ray_of_doom> rays_of_doom = new ArrayList<Ray_of_doom>();

Map map = new Map(2);
Joueur joueur= new Joueur(200, 650);
Rounds round= new Rounds();
Panel info_panel= new Panel();
Tower_panel tower_panel;
Upgrades upgrades = new Upgrades();

HashMap<String,Integer> force_list = new HashMap<String,Integer>();
HashMap<String,int[]> pos_coins_sprites = new HashMap<String,int[]>();

ArrayList<int[]> pos_coins_clous = new ArrayList<int[]>();
ArrayList<int[]> size_box_clous = new ArrayList<int[]>();

void load_sprites(){
  coin_sprite = loadImage("coin_sprite.png");
  coeur_sprite = loadImage("coeur_sprite.png");
  background=loadImage("map_3.png");
  
  all_sprites=loadImage("sprites_all.png");
  
  String[] lines = loadStrings("pos_sprites.txt");
  
  //peut etre pour les clous vu qu'ils doivent etre aligné ajouter 2 coord de centre histoire de pouvoir extraire la bonne pos
  
  int space_index, offset_index;
  int separateur_index;
  String name;
  int dx, dy, x, y, offset_x, offset_y;
  int half, quarter, eigth;
  
  for(String ligne : lines){
    space_index = ligne.indexOf(" : ");
    offset_index = ligne.indexOf(" offset ");
    half = ligne.indexOf(" half"); quarter = ligne.indexOf(" quarter"); eigth = ligne.indexOf(" eigth");
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
          offset_y = int(ligne.substring(separateur_index+2, end));
        }
        int last_param = half>-1 ? 1:0 + 2*(quarter>-1 ? 1:0) + 3*(eigth>-1 ? 1:0);  //vaut 1 si half, 2 si quarter et 3 si eigth
        pos_coins_sprites.put(name, new int[] {x, y, dx, dy, offset_x, offset_y, last_param});
     }
  }
  
  bloons_sprites=loadImage("bloons_sprites_transp.png");
  String[] y_ordre = {"zebra", "lead", "white", "black", "pink", "yellow", "green", "blue", "red"};
  String[] x_ordre = {"basic", "regrowth", "camo", "camo + regrowth"};
  
  //pour les normaux, la box est de 24x32 avec un offset de 13, 9 a chaque fois
  // regrow : 33x34 avec offset de 9, 8
  // pour white and black normaux/camos seulement : 16x20 avec offset de 17, 14
  // pour céramique : 29x38 avec offset de 10, 6
  // pour passer de l'un à l'autre selon y ajouter 0, 50
  // pour passer de l'un à l'autre selon x ajouter 50, 0
  
  
  for(int a=0; a<y_ordre.length; a++){
    for(int b=0; b<x_ordre.length; b++){
      name = y_ordre[a] + x_ordre[b];
      
      if( (x_ordre[b].equals("basic") || x_ordre[b].equals("camo")) && (y_ordre[a].equals("white") || y_ordre[a].equals("black"))){
        pos_coins_sprites.put(name, new int[] {50*b + 17, 50*a + 14, 16, 20});
      }
      else if(x_ordre[b].equals("basic") || x_ordre[b].equals("camo")){
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
  tower_panel = new Tower_panel();    //ne pas le mettre avant car quand tower panel crée ses boutons il a besoin des sprites
  imageMode(CENTER);
  frameRate(60);
  surface.setResizable(true);
  //surface.setSize(map.map_size_x, map.map_size_y);
  surface.setSize(1000, 750);
  surface.setLocation(300, 100);
  
  joueur.game_pop_count=0;

  force_list.put("red", 1);
  force_list.put("blue", 2);
  force_list.put("green", 3);
  force_list.put("yellow", 4);
  force_list.put("pink", 5);
  force_list.put("black", 6);
  force_list.put("white", 6);
  force_list.put("lead", 7);
  force_list.put("zebra", 8);
  force_list.put("rainbow", 9);
  force_list.put("ceramic", 10);
  force_list.put("MOAB", 11);
  force_list.put("BFB", 12);
  force_list.put("ZOMG", 13);
  force_list.put("DDT", 14);
  force_list.put("BAD", 15);
  
  ellipseMode(CENTER);
  rectMode(CORNERS);
  

}

void draw(){  
  FAKE_TIME_ELAPSED = get_fake_time_elapsed(FAKE_TIME_ELAPSED);    //ATTENTION : NE PAS COMPTER LE TEMPS ENTRE LES ROUNDS
  background(255);    //fond blanc
  image(background, 875/2, 650/2);  
  //map.show();
  
  if(god_mode){
    joueur.vies=100;
    joueur.argent=max(joueur.argent, 1000000);
  }
  if(joueur.vies<=0){
    stop();
  }
  
  
  
  round.update();
  round.spawn();
  
  //On update tous les enemis
  for (int i = enemis.size() - 1; i >= 0; i--){
    enemis.get(i).core(i);
  }
  
  map.hide();

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
    projectiles.get(i).verif_damage_type();
    projectiles.get(i).core(i, nb_proj);
  }
  
  //On update tous les boomerangs tirés
  for (int i = boomerangs.size() - 1; i >= 0; i--){
    boomerangs.get(i).core();
  }
  
  //On update tous les spikes
  int nb_spikes = spikes.size();
  for (int i = nb_spikes - 1; i >= 0; i--){
    spikes.get(i).core(i, nb_spikes);
  }
  
  for(int i=bananas.size()-1; i>=0; i--){
    bananas.get(i).core();
  }
  
  //On affiche toutes les explosions
  for (int i = explosions.size() - 1; i >= 0; i--){
    explosions.get(i).core();
  }
  
  for(int i=rings_of_fire.size()-1; i>=0; i--){
    rings_of_fire.get(i).core();
  }
  
  for(Ray_of_doom ray : rays_of_doom){
    ray.core();
  }
  
  //On affiche toutes les pop_animations
  for (int i = pop_animations.size() - 1; i >= 0; i--){
    pop_animations.get(i).core();
  }
  
  
  textAlign(CENTER, CENTER);
  for(Ability abi : abilities){
    abi.core();
  }
  
  tower_panel.show();
  tower_panel.interact();
  
  joueur.show_infos();
  joueur.speed_controller();
  joueur.tower_selection();
  joueur.interactions();
  joueur.select_existing_tower();
  
  info_panel.interact(joueur.selected_tower);
  info_panel.show(joueur.selected_tower);
  
  
  
}


float get_fake_time_elapsed(float last_time){    //va surement y avoir des erreurs d'arrondi mais osef
  if(round.waiting_next_round){
    return last_time;
  }
  return last_time + joueur.game_speed/60;
}


float distance(float[] pos1, float[] pos2){
  return sqrt( pow(pos1[0]-pos2[0], 2) + pow(pos1[1]-pos2[1], 2));
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
