class Panel{

  Button sell_button, upgrade_left, upgrade_right, priority_first, priority_last, priority_close, priority_strong;
  
  float top_left_x=0;
  float top_left_y=650;
  float bottom_right_x=875;
  float bottom_right_y=750;
  
  Tower last_selected_tower;

  void show(Tower selected_tower){
        
    stroke(0);
    strokeWeight(1);
    //noFill();
    fill(255);
    rect(top_left_x-1, top_left_y, bottom_right_x, bottom_right_y);
    
    if(selected_tower==null){
      textAlign(LEFT, TOP);
      fill(0);
      text("Total pop count : "+str(joueur.game_pop_count), 106, 653);
    }
    else{
      textAlign(LEFT, TOP);
      fill(0);
      text("Pop Count "+str(selected_tower.pop_count), 106, 653);
      
      upgrades.get_possible_upgrades(selected_tower.type, selected_tower.path_1_progression, selected_tower.path_2_progression);
      upgrade_left.unclickable = !(upgrades.can_purchase_1 && joueur.argent>=upgrades.price_1);
      upgrade_left.descr = upgrades.descr_1;
      upgrade_right.unclickable = !(upgrades.can_purchase_2 && joueur.argent>=upgrades.price_2);
      upgrade_right.descr = upgrades.descr_2;
      
      sell_button.show();
      upgrade_left.show();
      upgrade_right.show();
      if(selected_tower.uses_priority){
        priority_first.show();
        priority_last.show();
        priority_close.show();
        priority_strong.show();
      }
      
      upgrade_progression_show(selected_tower);
      
    }
  }
  
  void upgrade_progression_show(Tower selected_tower){
    stroke(0);
    strokeWeight(1);
    for(int i=0; i<4; i++){
      if(selected_tower.path_1_progression>i)  fill(155, 213, 0);    //vert mais couleur super belle bleutée avec fill(0, 155, 213);
      else fill(140);    //couleur grise
      rect(410 + 22*i, 650+92, 410+20 + 22*i, 650+98);
    }
    for(int i=0; i<4; i++){
      if(selected_tower.path_2_progression>i)  fill(155, 213, 0);
      else fill(140);
      rect(645 + 22*i, 650+92, 645+20 + 22*i, 650+98);
    }
  }
  
  void interact(Tower selected_tower){
    
    if(selected_tower==null){
      if(sell_button!=null){
        sell_button=null;
        upgrade_left=null;
        upgrade_right=null;
        priority_first=null;
        priority_last=null;
        priority_close=null;
        priority_strong=null;
      }
      last_selected_tower = null;
      return;
    }
    
    if(last_selected_tower != selected_tower){    //pour réafficher si on change de tour
      instantiate_all_buttons(selected_tower);
      last_selected_tower=selected_tower;
    }

    
    if(sell_button.is_cliqued()){
      selected_tower.sell();
    }
    if(selected_tower.uses_priority){
      if(priority_first.is_cliqued()){
        selected_tower.priority="first";
        priority_first.selected=true;
        priority_last.selected=false;
        priority_close.selected=false;
        priority_strong.selected=false;
        
      }
      if(priority_last.is_cliqued()){
        selected_tower.priority="last";
        priority_first.selected=false;
        priority_last.selected=true;
        priority_close.selected=false;
        priority_strong.selected=false;
      }
      if(priority_close.is_cliqued()){
        selected_tower.priority="close";
        priority_first.selected=false;
        priority_last.selected=false;
        priority_close.selected=true;
        priority_strong.selected=false;
      }
      if(priority_strong.is_cliqued()){
        selected_tower.priority="strong";
        priority_first.selected=false;
        priority_last.selected=false;
        priority_close.selected=false;
        priority_strong.selected=true;
      }
    }
    
    //Manque les boutons d'upgrade
    if(upgrade_left.is_cliqued()){
      upgrades.apply_upgrade(selected_tower, 1);
      upgrades.get_possible_upgrades(selected_tower.type, selected_tower.path_1_progression, selected_tower.path_2_progression);
      upgrade_left.text = upgrades.name_1;
      if(upgrades.price_1 != -1)  upgrade_left.text+="\nPrice : "+str(upgrades.price_1);
      upgrade_right.text = upgrades.name_2;
      if(upgrades.price_2 != -1)  upgrade_right.text+="\nPrice : "+str(upgrades.price_2);
      sell_button.text="Sell\n"+str(int(selected_tower.price * joueur.sell_percent));
    }
    if(upgrade_right.is_cliqued()){
      upgrades.apply_upgrade(selected_tower, 2);
      upgrades.get_possible_upgrades(selected_tower.type, selected_tower.path_1_progression, selected_tower.path_2_progression);
      upgrade_left.text = upgrades.name_1;
      if(upgrades.price_1 != -1)  upgrade_left.text+="\nPrice : "+str(upgrades.price_1);
      upgrade_right.text = upgrades.name_2;
      if(upgrades.price_2 != -1)  upgrade_right.text+="\nPrice : "+str(upgrades.price_2);
      sell_button.text="Sell\n"+str(int(selected_tower.price * joueur.sell_percent));
    }
    
  }
  
  
  
  void instantiate_all_buttons(Tower selected_tower){
    upgrades.get_possible_upgrades(selected_tower.type, selected_tower.path_1_progression, selected_tower.path_2_progression);
    sell_button =     new Button(310, 650+5, 400, 650+50, "Sell\n"+str(int(selected_tower.price * joueur.sell_percent)), 's');
    upgrade_left =    new Button(410, 650+5, 640, 650+90, upgrades.name_1, ':');    
    upgrade_right =   new Button(645, 650+5, 875, 650+90, upgrades.name_2, '!');
    if(upgrades.price_1 != -1)  upgrade_left.text+="\nPrice : "+str(upgrades.price_1);   //voir textLeading() pour l'interligne
    if(upgrades.price_2 != -1)  upgrade_right.text+="\nPrice : "+str(upgrades.price_2);
    if(selected_tower.uses_priority){
      priority_first =  new Button(100, 650+57, 175, 650+95, "First", '&');
      priority_last =   new Button(178, 650+57, 252, 650+95, "Last", 'é');
      priority_close =  new Button(254, 650+57, 329, 650+95, "Close", '"');
      priority_strong = new Button(331, 650+57, 406, 650+95, "Strong", '\'');
      
      if(selected_tower.priority=="first")  priority_first.selected=true;
      if(selected_tower.priority=="last")  priority_last.selected=true;
      if(selected_tower.priority=="close")  priority_close.selected=true;
      if(selected_tower.priority=="strong")  priority_strong.selected=true;
    }
  }


}
