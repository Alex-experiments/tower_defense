class Tower_panel{

  Button dart_monkey;
  Button wizard_monkey;
  Button sniper_monkey;
  Button tack_shooter;
  Button dartling_gun;
  Button boomerang_thrower;
  Button ninja_monkey;
  Button spike_factory;
  
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
    
    
    //at this moment we have to show the sprites of the different towers
    //the best is to add an option to buttons -> boolean as_sprite = false; et String sprite_name; et apres on fait "si oui go afficher le sprite au milieu du bouton"
    
    
    dart_monkey.show();
    tack_shooter.show();
    sniper_monkey.show();
    boomerang_thrower.show();
    ninja_monkey.show();
    wizard_monkey.show();
    dartling_gun.show();
    spike_factory.show();
    
    
  
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
    if(dart_monkey.is_cliqued()){
      joueur.placing_tower = "dart monkey";
    }
    if(tack_shooter.is_cliqued()){
      joueur.placing_tower = "tack shooter";
    }
    if(sniper_monkey.is_cliqued()){
      joueur.placing_tower = "sniper";
    }
    if(boomerang_thrower.is_cliqued()){
      joueur.placing_tower = "boomerang thrower";
    }
    if(ninja_monkey.is_cliqued()){
      joueur.placing_tower = "ninja monkey";
    }
    if(wizard_monkey.is_cliqued()){
      joueur.placing_tower = "wizard monkey";
    }
    if(dartling_gun.is_cliqued()){
      joueur.placing_tower = "dartling gun";
    }
    if(spike_factory.is_cliqued()){
      joueur.placing_tower = "spike factory";
    }
    
    
  }
  
  void instantiate_all_buttons(){
    dart_monkey =       new Button(875, 94, 875+62, 156, "");
    tack_shooter =      new Button(938, 94, 1000, 156, "");
    sniper_monkey =     new Button(875, 157, 875+62, 157+62, "");
    boomerang_thrower = new Button(938, 157, 1000, 157+62, "");
    ninja_monkey =      new Button(875, 220, 875+62, 282, "");
    //canon
    //ice
    //glue
    //boat
    //plane
    //superman
    wizard_monkey =     new Button(938, 220, 1000, 282, "");
    dartling_gun =      new Button(875, 283, 875+62, 283+62, "");
    spike_factory =     new Button(938, 283, 1000, 283+62, "");
    
    
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
    
  }
  
  int get_tower_price(String tower_type){
    Tower tour = get_new_tower(tower_type, 0, 0);
    return tour.price;
  }


}
