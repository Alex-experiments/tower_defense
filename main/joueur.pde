class Joueur{
  int vies, argent, game_pop_count;
  Tower placing_tower=null, selected_tower;
  
  float game_speed=1, max_game_speed=8;
  
  float sell_percent=0.8;
  
  float last_right_clic_x, last_right_clic_y;
  boolean right_clic_activated = false, right_clic_enfonce = false;
  
  
  Joueur(int vies_depart, int argent_depart){
    vies=vies_depart;
    argent=argent_depart;    
  }
  
  void hurt(int dmg){
    vies-=dmg;
    stat_manager.increment_stat(dmg, "Lives lost", "overview");
  }
  
  void pay(int price){
    argent -= price;
    stat_manager.increment_stat(price, "Money spent", "overview");
  }
  
  void gain(int amount){
    argent += amount;
    stat_manager.increment_stat(amount, "Money earned", "overview");
  }
  
  void show_fps(){
    fill(0);
    textAlign(LEFT, TOP);
    text(str(round(frameRate)), 0, -3);
  }

  void interactions(){
    if(mousePressed && mouseButton == RIGHT){
      if(!right_clic_enfonce){
        right_clic_activated = !right_clic_activated;
        right_clic_enfonce = true;
        last_right_clic_x = mouseX;
        last_right_clic_y = mouseY;
      }
    }
    else right_clic_enfonce = false;
    
    boolean can_place_tower= mouseX>=0 && mouseX<tower_panel.top_left_x && mouseY>=0 && mouseY<info_panel.top_left_y;      //il faut pas que le curseur soit hors map    //a changer ici aussi
    if(can_place_tower && placing_tower!=null){    //si on a selectionné une tour
            
      placing_tower.x = mouseX; placing_tower.y=mouseY;
      
      //on regarde si la hitbox rencontre celle d'une tour deja placée
      for(Tower tour : towers){            
        if(tour.selectable && distance(tour.x, tour.y, mouseX, mouseY)<(tour.size+placing_tower.size)/2){  
           can_place_tower=false;
           break;
        }
      }
      
      //on regarde si on a pas assez d'argent ou si la hitbox rencontre le chemin
      if(can_place_tower && (argent<placing_tower.price || map.is_on_track(placing_tower.x, placing_tower.y, placing_tower.size*3/4)))  can_place_tower=false;
      
      placing_tower.show();
      placing_tower.show_range(can_place_tower);
      
      if(can_place_tower && mousePressed && mouseButton==LEFT)   place_tower(placing_tower);
    }
  }
  
  void place_tower(Tower tour){
    tour.set_on_track_pos();
    towers.add(tour);
    pay(tour.price);
    stat_manager.increment_stat("Placed", tour.type);
    stat_manager.increment_stat("Towers bought", "overview");
    if( !god_mode){
      placing_tower=null;
      selected_tower=tour;
    }
    else   placing_tower = get_new_tower(placing_tower.type, mouseX, mouseY);
    
  }
  
  void select_existing_tower(){
    if( selected_tower!=null && (placing_tower!=null || mousePressed && mouseButton==LEFT) ){  //si on place une nouvelle tour ou si on clique ailleurs en ayant une tour de selectionnée
      if(distance(selected_tower.x, selected_tower.y, mouseX, mouseY)>selected_tower.size/2){
        if(!(mouseX>=info_panel.top_left_x && mouseX<=info_panel.bottom_right_x && mouseY>=info_panel.top_left_y && mouseY<=info_panel.bottom_right_y)){  //cliquer sur l'info bar ne change rien
          selected_tower=null;
        }
      }
    }
    if(placing_tower!=null || selected_tower!=null)  return;    //si on est en train de placer une tour ou si on en a deja selectionnée une
    if(mousePressed && mouseButton==LEFT){
      for(Tower tour : towers){
        if( tour.selectable && distance(tour.x, tour.y, mouseX, mouseY)<=tour.size/2 ){
          selected_tower=tour;
          break;
        }
      }
    }
  }
  
  void show_selected_tower_range(){
    if(selected_tower != null)  selected_tower.show_range(true);
  }

}

Tower get_new_tower(String tower_type, float x, float y){
  
  Tower temp=null;
  
  
  switch(tower_type){
      case "dart monkey":
        temp = new Dart_monkey(tower_type, x, y);
        break;
      case "super monkey fan":
        temp = new Super_monkey_fan(null, null, tower_type, x, y);  //si on l'appelle ici c'est qu'on vient du tower panel et donc qu'on a juste besoin du sprite
        break;
      case "wizard monkey":
        temp = new Wizard_monkey(tower_type, x, y);
        break;
      case "phoenix":
        temp = new Phoenix(null);  //si on l'appelle ici c'est qu'on vient du tower panel et donc qu'on a juste besoin du sprite
        break;
      case "sniper":
        temp = new Sniper(tower_type, x, y);
        break;
      case "tack shooter":
        temp = new Tack_shooter(tower_type, x, y);
        break;
      case "dartling gun":
        temp = new Dartling_gun(tower_type, x, y);
        break;
      case "boomerang thrower":
        temp = new Boomerang_thrower(tower_type, x, y);
        break;
      case "ninja monkey":
        temp = new Ninja_monkey(tower_type, x, y);
        break;
      case "spike factory":
        temp = new Spike_factory(tower_type, x, y);
        break;    
      default :
        println(tower_type, "is not a proper tower type !!");
        break;
    }
    
    return temp;
}
