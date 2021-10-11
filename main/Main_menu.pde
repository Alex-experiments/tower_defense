class Main_menu extends Menu_pancarte{
  
  PImage bg = loadImage("main_menu_bg.png"), panneau_1 = loadImage("menu panneau 1.png"), panneau_2 = loadImage("menu panneau 2.png");
    
  boolean freeze = false, active = false, choice_made = false, go_to_play = false, go_to_stats = false, go_quit = false, transition = false, mouse_still_pressed = true;
  
  Point top_left_play, top_left_stats, top_left_quit;
  float play_x, play_y, stats_x, stats_y, quit_x, quit_y;
  int panel_width=420, panel_height=100, panel_offset_y=10;
  
  Button play, stats, quit;
  
  color outline_color_2 = color(40, 255, 20, 100);

  
  void init(){
    points = new ArrayList<Point>();
    links = new ArrayList<Link>();
    ropes_extremity_links = new IntList();
    buttons_top_left_corner = new ArrayList<Point>();
    
    active = true; freeze = false; choice_made = false; go_to_play = false; go_to_stats = false; go_quit = false; transition = false; mouse_still_pressed = true;
    
    create_pancarte(3, 285, -30, 100, panel_width, panel_height, 25);
    top_left_play = links.get(ropes_extremity_links.get(1)).ptA;
    play_x = top_left_play.pos.x; play_y = top_left_play.pos.y;
    top_left_stats = links.get(ropes_extremity_links.get(5)).ptA;
    stats_x = top_left_stats.pos.x; stats_y = top_left_stats.pos.y;
    top_left_quit = links.get(ropes_extremity_links.get(9)).ptA;
    quit_x = top_left_quit.pos.x; quit_y = top_left_quit.pos.y;
    play   = new Button(play_x, play_y+panel_offset_y, play_x + panel_width, play_y+panel_height+panel_offset_y,     "", 'P');
    play.associated_image = loadImage("menu panneau 2.png");
    stats   = new Button(stats_x, stats_y+panel_offset_y, stats_x + panel_width, stats_y+panel_height+panel_offset_y,     "", 'S');
    stats.associated_image = loadImage("menu panneau 1.png");
    quit   = new Button(quit_x, quit_y+panel_offset_y, quit_x + panel_width, quit_y+panel_height+panel_offset_y,     "", 'Q');
    quit.associated_image = loadImage("menu panneau 2.png");
    textAlign(CENTER, CENTER);
    textFont(font_32px);
  }
  
  void core(){
    background(bg);
    if(choice_made || !freeze){    //si on a fait un choix on reprend la physique
      for(int i = 0; i<3; i++) update();
      freeze = PVector.sub(top_left_quit.pos, top_left_quit.prev_pos).mag()<.002;
    }
    update_pos_boutons();
    if(!choice_made && !mouse_still_pressed) interact();
    if(!mousePressed)  mouse_still_pressed = false;
    show_chain();
    show();
    if(ended()){
      active = false;
      if(go_to_play)  map_menu.init();
      else if(go_to_stats)  stat_menu.init();
      else exit();
    }
  }
  
  void interact(){
    if(play.is_cliqued()){
      choice_made = true;
      go_to_play = true;
      cut_rope(2);
      cut_rope(3);
      return;
    }
    if(stats.is_cliqued()){
      choice_made = true;
      go_to_stats = true;
      cut_rope(5);
      cut_rope(4);
      return;
    }
    if(quit.is_cliqued()){
      choice_made = true;
      go_quit = true;
      return;
    }
  }
  
  boolean ended(){
    return (go_to_play && stats_y > height + 50) || (go_to_stats &&  quit_y > height + 50)  || go_quit;
  }
  
  void update_pos_boutons(){
    play_x = top_left_play.pos.x; play_y = top_left_play.pos.y;
    stats_x = top_left_stats.pos.x; stats_y = top_left_stats.pos.y;
    quit_x = top_left_quit.pos.x; quit_y = top_left_quit.pos.y;
    
    play.update_pos(play_x, play_y+panel_offset_y, panel_width, panel_height);
    stats.update_pos(stats_x, stats_y+panel_offset_y, panel_width, panel_height);
    quit.update_pos(quit_x, quit_y+panel_offset_y, panel_width, panel_height);
  }
  
  void show(){
    outline_text("V1.0 by Alexandre GAUTIER", width/2, 725, color(0), color(255), 1);
    play.show_associated_image();
    outline_text("PLAY", play_x+panel_width/2, play_y+panel_offset_y+panel_height/2, play.mouse_on_button()? outline_color_2:color(255), color(0), 1);
    stats.show_associated_image();
    outline_text("STATS", stats_x+panel_width/2, stats_y+panel_offset_y+panel_height/2, stats.mouse_on_button()? outline_color_2:color(255), color(0), 1);
    quit.show_associated_image();
    outline_text("QUIT", quit_x+panel_width/2, quit_y+panel_offset_y+panel_height/2, quit.mouse_on_button()? outline_color_2:color(255), color(0), 1);
    /*
    strokeWeight(1);
    stroke(255);
    for(Link zelda : links){
      zelda.show();
    }*/
    
    
    
  }
}
