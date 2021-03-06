class Tower_panel{

  Button dart_monkey, wizard_monkey, sniper_monkey, tack_shooter, dartling_gun, boomerang_thrower, ninja_monkey, spike_factory;
  
  Button unselect_tower, speed_button, next_round_button, home_button, auto_pass_button, save_button;
  
  ArrayList<Button> buttons;
  
  float top_left_x=875, top_left_y=0, bottom_right_x=1000, bottom_right_y=750;
  
  PImage bg = loadImage("tower_panel_bg.png");
  boolean for_stat_menu;
  
  int[] pos_aff_piece, pos_aff_coeur;
  
  
  
  Tower_panel(float top_left_x, float top_left_y, float bottom_right_x, float bottom_right_y, boolean for_stat_menu){
    this.top_left_x=top_left_x;
    this.top_left_y=top_left_y;
    this.bottom_right_x=bottom_right_x;
    this.bottom_right_y=bottom_right_y;
    this.for_stat_menu = for_stat_menu;
    instantiate_all_buttons();
    pos_aff_piece = pos_coins_sprites.get("piece sprite");
    pos_aff_coeur = pos_coins_sprites.get("coeur sprite");
  }
  
  void show_infos(){
    //appelée depuis joueur.show_infos()
    fill(0, 102, 153);
    textAlign(LEFT, TOP);
    image(all_sprites, 893, 18, pos_aff_piece[2], pos_aff_piece[3], pos_aff_piece[0], pos_aff_piece[1], pos_aff_piece[0]+pos_aff_piece[2], pos_aff_piece[1]+pos_aff_piece[3]);
    textFont(font_18px);
    outline_text(str(joueur.argent), 910, 8, color(0), color(255), 1); 
    image(all_sprites, 893, 48, pos_aff_coeur[2], pos_aff_coeur[3], pos_aff_coeur[0], pos_aff_coeur[1], pos_aff_coeur[0]+pos_aff_coeur[2], pos_aff_coeur[1]+pos_aff_coeur[3]);
    outline_text(str(max(0, joueur.vies)), 910, 38, color(0), color(255), 1); 
    textFont(font);
  }
  
  void show(){
    //stroke(0);
    //strokeWeight(1);
    //fill(255);
    //rect(top_left_x, top_left_y-1, bottom_right_x, bottom_right_y);
    
    if(!for_stat_menu){
      image(bg, (top_left_x+bottom_right_x)/2, (top_left_y+bottom_right_y)/2);
      update_clickability();
      textAlign(CENTER, CENTER);
    }

    
    for(Button button : buttons){
      //ce bouton n'est pas dans la liste si for_stat_menu == true
      if(button == unselect_tower && joueur.placing_tower != null)   unselect_tower.show_image_from_pos_aff(unselect_tower.mouse_on_button()? 1.1 : 1);
      else if(button == speed_button){
        if(!round.waiting_next_round)  button.show();
      }
      else if(button == next_round_button){
        if(round.waiting_next_round){
          button.show();
          textFont(font_18px);
          outline_text("GO", 938, 610, color(0), color(255), 1);
          textFont(font);
        }
      }
      else if(button != unselect_tower)  button.show();
    }
    
    if(!for_stat_menu){
      home_button.show();
      home_button.show_associated_image();
      auto_pass_button.show();
      auto_pass_button.show_associated_image();
      save_button.show();
      if(!game.game_just_saved)  save_button.show_associated_image();
      else  outline_text("GAME SAVED!", (save_button.top_left_x+save_button.bottom_right_x)/2, (save_button.top_left_y+save_button.bottom_right_y)/2, color(0), color(50, 255, 30), 1);
      show_infos();
    }
      
  }
  
  void update_clickability(){
    for(Button button : buttons){
      if(button.associated_tower != null)   button.unclickable = joueur.argent < get_tower_price(button.associated_tower.type);
    }
  }
  
  void interact(){
    String tower_type=null;
    
    for(Button button : buttons){
      if(button.is_cliqued()){
        if(button == speed_button){
          if(!round.waiting_next_round){
            joueur.game_speed*=2;
            if(joueur.game_speed>joueur.max_game_speed)  joueur.game_speed=1;
            speed_button.text = "speed : "+str(int(joueur.game_speed));
          }
        }
        else if(button == next_round_button) continue;
        else if(button == unselect_tower)  tower_type = "";
        else  tower_type = button.associated_tower.type;
      }
    }
    
    if(tower_type != null){
      if(tower_type.equals(""))  joueur.placing_tower = null;
      else joueur.placing_tower = get_new_tower(tower_type, mouseX, mouseY);
    }
    
    if(!for_stat_menu){
      if(home_button.is_cliqued()){
        stat_manager.save_all();
        main_menu.init();
      }
      if(auto_pass_button.is_cliqued()){
        if(auto_pass_levels){
          auto_pass_levels = false;
          auto_pass_button.associated_image = loadImage("pass_icon.png");
          auto_pass_button.descr = "Enable rounds auto pass";
        }
        else{
          auto_pass_levels = true;
          auto_pass_button.associated_image = loadImage("pass_activated_icon.png");
          auto_pass_button.descr = "Disable rounds auto pass";
        }
      }
      if(save_button.is_cliqued()){
        game.save_game();
        save_button.unclickable = true;
        game.game_just_saved = true;
      }
    }
    
  }
  
  void update_selection(){
    //for stat_menu only
    for(Button button : buttons){
      if(button.is_cliqued()){
        for(Button temp : buttons){
          temp.selected = temp == button;
        }
      }
    }
  }
  
  String get_selected_tower_name(){
    //for stat_menu only
    
    for(Button button : buttons){
      if(button.selected)  return button.associated_tower.type;
    }
    return "NO TOWER NAME FOUND : PROBLEM NO BUTTON SELECTED";
  }
  
  void instantiate_all_buttons(){
    buttons = new ArrayList<Button>();
    
    dart_monkey =       new Button(top_left_x, top_left_y+94, top_left_x+62, top_left_y+156, "", 'q');
    dart_monkey.associated_tower = get_new_tower("dart monkey", top_left_x+31, top_left_y+125);
    tack_shooter =      new Button(top_left_x+63, top_left_y+94, bottom_right_x, top_left_y+156, "", 'r');
    tack_shooter.associated_tower = get_new_tower("tack shooter", bottom_right_x-31, top_left_y+125);
    tack_shooter.associated_tower.show_scale = .75;
    sniper_monkey =     new Button(top_left_x, top_left_y+157, top_left_x+62, top_left_y+157+62, "", 'z');
    sniper_monkey.associated_tower = get_new_tower("sniper", top_left_x+27, top_left_y+196);
    sniper_monkey.associated_tower.show_scale = .7;
    sniper_monkey.associated_tower.orientation = QUARTER_PI;
    boomerang_thrower = new Button(top_left_x+63, top_left_y+157, bottom_right_x, top_left_y+157+62, "", 'w');
    boomerang_thrower.associated_tower = get_new_tower("boomerang thrower", bottom_right_x-31, top_left_y+188);
    ninja_monkey =      new Button(top_left_x, top_left_y+220, top_left_x+62, top_left_y+282, "", 'd');
    ninja_monkey.associated_tower = get_new_tower("ninja monkey", top_left_x+31, top_left_y+251);
    //canon
    //ice
    //glue
    //boat
    //plane
    //superman
    wizard_monkey =     new Button(top_left_x+63, top_left_y+220, bottom_right_x, top_left_y+282, "", 'a');
    wizard_monkey.associated_tower = get_new_tower("wizard monkey", bottom_right_x-31, top_left_y+251);
    dartling_gun =      new Button(top_left_x, top_left_y+283, top_left_x+62, top_left_y+283+62, "", 'm');
    dartling_gun.associated_tower = get_new_tower("dartling gun", top_left_x+31, top_left_y+314);
    dartling_gun.associated_tower.show_scale = .5;
    dartling_gun.associated_tower.orientation = QUARTER_PI;
    spike_factory =     new Button(top_left_x+63, top_left_y+283, bottom_right_x, top_left_y+283+62, "", 'j');
    spike_factory.associated_tower = get_new_tower("spike factory", bottom_right_x-31, top_left_y+314);
    spike_factory.associated_tower.show_scale = .7;
   
    
    buttons.add(dart_monkey);
    buttons.add(tack_shooter);
    buttons.add(sniper_monkey);
    buttons.add(boomerang_thrower);
    buttons.add(ninja_monkey);
    buttons.add(wizard_monkey);
    buttons.add(dartling_gun);
    buttons.add(spike_factory);
    
    if(for_stat_menu){
      dart_monkey.selected = true;
      for(Button button : buttons){
        button.couleur = color(255, 255, 255, 40);
        button.use_shortcut_key = false;
      }
      
      /*Button smf = new Button(top_left_x, top_left_y + 346, top_left_x + 62, top_left_y+346+62, "", char(-1)); 
      smf.associated_tower = get_new_tower("super monkey fan", top_left_x + 31, top_left_y + 377);
      buttons.add(smf);
      Button phoenix = new Button(top_left_x + 63, top_left_y + 346, bottom_right_x, top_left_y+346+62, "", char(-1));
      phoenix.associated_tower = get_new_tower("phoenix", bottom_right_x - 31, top_left_y + 377);
      buttons.add(phoenix);*/
      return;
    }
    
    dart_monkey.descr = "Dart Monkey\n"+str(get_tower_price("dart monkey"));
    wizard_monkey.descr = "Wizard Monkey\n"+str(get_tower_price("wizard monkey"));
    sniper_monkey.descr = "Sniper Monkey\n"+str(get_tower_price("sniper"));
    tack_shooter.descr = "Tack Shooter\n"+str(get_tower_price("tack shooter"));
    dartling_gun.descr = "Dartling Gun\n"+str(get_tower_price("dartling gun"));
    boomerang_thrower.descr = "Boomerang Thrower\n"+str(get_tower_price("boomerang thrower"));
    ninja_monkey.descr = "Ninja Monkey\n"+str(get_tower_price("ninja monkey"));
    spike_factory.descr = "Spike Factory\n"+str(get_tower_price("spike factory"));
    
    dart_monkey.show_descr_above=false;
    wizard_monkey.show_descr_above=false;
    sniper_monkey.show_descr_above=false;
    tack_shooter.show_descr_above=false;
    dartling_gun.show_descr_above=false;
    boomerang_thrower.show_descr_above=false;
    ninja_monkey.show_descr_above=false;
    spike_factory.show_descr_above=false;
    
    unselect_tower = new Button(875-91, 650-97, 875-10, 650-10, "", ' ');
    unselect_tower.pos_aff = pos_coins_sprites.get("poubelle");
    buttons.add(unselect_tower);
    
    speed_button = new Button(875, 650-80, 1000, 650, "speed : "+str(int(joueur.game_speed)), '*');
    buttons.add(speed_button);
    
    next_round_button = new Button(875, 650-80, 1000, 650, "", char(-1));
    next_round_button.use_shortcut_key = false;
    buttons.add(next_round_button);
    
    home_button = new Button(875+20, 700, 875+60, 740, "", char(-1));
    home_button.use_shortcut_key = false;
    home_button.associated_image = loadImage("home_icon.png");
    home_button.descr = "Go back to main menu";
    home_button.width_descr = 100;
    
    
    auto_pass_button = new Button(1000-60, 700, 1000-20, 740, "", 'ù');
    auto_pass_button.associated_image = loadImage("pass_icon.png");
    auto_pass_button.descr = "Enable rounds auto pass";
    auto_pass_button.width_descr = 100;
    
    save_button = new Button(875, 665, 1000, 694, "", char(-1));
    save_button.use_shortcut_key = false;
    save_button.associated_image = loadImage("save_icon.png");
    save_button.descr = "Save game";
    save_button.width_descr = 100;
    
  }
}

int get_tower_price(String tower_type){
  switch(tower_type){
    case "dart monkey":
      return 200;
    case "super monkey fan":
      return 0;
    case "tack shooter":
      return 360;
    case "sniper":
      return 350;
    case "boomerang thrower":
      return 400;
    case "ninja monkey":
      return 500;
    case "wizard monkey":
      return 550;
    case "phoenix":
      return 0;
    case "dartling gun":
      return 950;
    case "spike factory":
      return 700;
    default :
      println("ERROR : coulnd't get the price of", tower_type);
      return 0;
  }
}
