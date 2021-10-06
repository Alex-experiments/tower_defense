class Tower_panel{

  Button dart_monkey;
  Button wizard_monkey;
  Button sniper_monkey;
  Button tack_shooter;
  Button dartling_gun;
  Button boomerang_thrower;
  Button ninja_monkey;
  Button spike_factory;
  
  Button unselect_tower;
  
  Button speed_button;
  
  float top_left_x=875;
  float top_left_y=0;
  float bottom_right_x=1000;
  float bottom_right_y=750;
  
  
  
  Tower_panel(){
    instantiate_all_buttons();
  }
  
  void show_infos(){
    //appelée depuis joueur.show_infos()
    fill(0, 102, 153);
    textAlign(LEFT, TOP);
    image(coin_sprite, 893, 18);
    text(str(joueur.argent), 910, 10); 
    image(coeur_sprite, 893, 48);
    text(str(max(0, joueur.vies)), 910, 40);
  }
  
  void show(){
    stroke(0);
    strokeWeight(1);
    fill(255);
    rect(top_left_x, top_left_y-1, bottom_right_x, bottom_right_y);
    
    update_clickability();
        
    
    dart_monkey.show();
    tack_shooter.show();
    sniper_monkey.show();
    boomerang_thrower.show();
    ninja_monkey.show();
    wizard_monkey.show();
    dartling_gun.show();
    spike_factory.show();
    
    speed_button.show();
    show_infos();  
  }
  
  void update_clickability(){
    dart_monkey.unclickable = joueur.argent<get_tower_price("dart monkey");
    tack_shooter.unclickable = joueur.argent<get_tower_price("tack shooter");
    sniper_monkey.unclickable = joueur.argent<get_tower_price("sniper");
    boomerang_thrower.unclickable = joueur.argent<get_tower_price("boomerang thrower");
    ninja_monkey.unclickable = joueur.argent<get_tower_price("ninja monkey");
    wizard_monkey.unclickable = joueur.argent<get_tower_price("wizard monkey");
    dartling_gun.unclickable = joueur.argent<get_tower_price("dartling gun");
    spike_factory.unclickable = joueur.argent<get_tower_price("spike factory");
  }
  
  void interact(){
    String tower_type=null;
    
    if(dart_monkey.is_cliqued()){
      tower_type = "dart monkey";
    }
    else if(tack_shooter.is_cliqued()){
      tower_type = "tack shooter";
    }
    else if(sniper_monkey.is_cliqued()){
      tower_type = "sniper";
    }
    else if(boomerang_thrower.is_cliqued()){
      tower_type = "boomerang thrower";
    }
    else if(ninja_monkey.is_cliqued()){
      tower_type = "ninja monkey";
    }
    else if(wizard_monkey.is_cliqued()){
      tower_type = "wizard monkey";
    }
    else if(dartling_gun.is_cliqued()){
      tower_type = "dartling gun";
    }
    else if(spike_factory.is_cliqued()){
      tower_type = "spike factory";
    }
    else if(unselect_tower.is_cliqued()){
      tower_type = "";
    }
    
    if(speed_button.is_cliqued()){
      joueur.game_speed*=2;
      if(joueur.game_speed>joueur.max_game_speed)  joueur.game_speed=1;
      speed_button.text = "speed : "+str(int(joueur.game_speed));
    }
    
    if(tower_type != null){
      if(tower_type.equals(""))  joueur.placing_tower = null;
      else joueur.placing_tower = get_new_tower(tower_type, mouseX, mouseY);
    }
    
    
  }
  
  void instantiate_all_buttons(){
    dart_monkey =       new Button(875, 94, 875+62, 156, "", 'q');
    dart_monkey.associated_tower = get_new_tower("dart monkey", 906, 125);
    tack_shooter =      new Button(938, 94, 1000, 156, "", 'r');
    tack_shooter.associated_tower = get_new_tower("tack shooter", 969, 125);
    tack_shooter.associated_tower.show_scale = .75;
    sniper_monkey =     new Button(875, 157, 875+62, 157+62, "", 'z');
    sniper_monkey.associated_tower = get_new_tower("sniper", 902, 196);
    sniper_monkey.associated_tower.show_scale = .7;
    sniper_monkey.associated_tower.orientation = QUARTER_PI;
    boomerang_thrower = new Button(938, 157, 1000, 157+62, "", 'w');
    boomerang_thrower.associated_tower = get_new_tower("boomerang thrower", 969, 188);
    ninja_monkey =      new Button(875, 220, 875+62, 282, "", 'd');
    ninja_monkey.associated_tower = get_new_tower("ninja monkey", 906, 251);
    //canon
    //ice
    //glue
    //boat
    //plane
    //superman
    wizard_monkey =     new Button(938, 220, 1000, 282, "", 'a');
    wizard_monkey.associated_tower = get_new_tower("wizard monkey", 969, 251);
    dartling_gun =      new Button(875, 283, 875+62, 283+62, "", 'm');
    dartling_gun.associated_tower = get_new_tower("dartling gun", 906, 314);
    dartling_gun.associated_tower.show_scale = .5;
    dartling_gun.associated_tower.orientation = QUARTER_PI;
    spike_factory =     new Button(938, 283, 1000, 283+62, "", 'j');
    spike_factory.associated_tower = get_new_tower("spike factory", 969, 314);
    spike_factory.associated_tower.show_scale = .7;
    
    
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
    
    unselect_tower = new Button(0, 0, 0, 0, "", ' ');
    
    speed_button = new Button(875, 650-80, 1000, 650, "speed : "+str(int(joueur.game_speed)), '*');
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
