class Joueur{
  int vies;
  int argent;
  int game_pop_count;
  String placing_tower="";
  Tower selected_tower;
  
  float game_speed=1;
  float max_game_speed=16;
  Button speed_button;
  
  
  Joueur(int vies_depart, int argent_depart){
    vies=vies_depart;
    argent=argent_depart;    
  }
  
  void show_infos(){
    fill(0, 102, 153);
    textAlign(LEFT, TOP);
    text(str(round(frameRate)), 0, -3);
    tower_panel.show_infos();
  }

  void speed_controller(){
    if (speed_button==null){
      speed_button = new Button(875, 650-80, 1000, 650, "speed : "+str(game_speed));
    }
    speed_button.show();
    
    if(speed_button.is_cliqued()){
      game_speed*=2;
      if(game_speed>max_game_speed)  game_speed=1;
      speed_button.text = "speed : "+str(game_speed);
    }
    /*else if(keyPressed){    //rajouter un key_enfonce
      if( !speed_button.enfonce && (key=='s' || key=='S')){
        speed_button.enfonce=true;
        float previous_game_speed=game_speed;
        game_speed*=2;
        if(game_speed>max_game_speed)  game_speed=1;
        update_speed(previous_game_speed);
      }
    }*/
  }

  void interactions(){
    boolean can_place_tower= mouseX>=0 && mouseX<tower_panel.top_left_x && mouseY>=0 && mouseY<info_panel.top_left_y;      //il faut pas que le curseur soit hors map    //a changer ici aussi
    if(can_place_tower && !placing_tower.equals("")){    //si on a selectionné une tour
            
      Tower temp = null;
      
      switch(placing_tower){
        case "dart monkey":
          temp = new dart_monkey(placing_tower, mouseX, mouseY);
          break;
        case "wizard monkey":
          temp = new wizard_monkey(placing_tower, mouseX, mouseY);
          break;
        case "sniper":
          temp = new sniper(placing_tower, mouseX, mouseY);
          break;
        case "tack shooter":
          temp = new tack_shooter(placing_tower, mouseX, mouseY);
          break;
        case "dartling gun":
          temp = new dartling_gun(placing_tower, mouseX, mouseY);
          break;
        case "boomerang thrower":
          temp = new boomerang_thrower(placing_tower, mouseX, mouseY);
          break;
        case "ninja monkey":
          temp = new ninja_monkey(placing_tower, mouseX, mouseY);
          break;
        case "spike factory":
          temp = new spike_factory(placing_tower, mouseX, mouseY);
          break;       
      }
      
      //on regarde si la hitbox rencontre celle d'une tour deja placée
      for(Tower tour : towers){            
        if(distance(new float[] {tour.x, tour.y}, new float[] {mouseX, mouseY})<(tour.size+temp.size)/2){  
           can_place_tower=false;
           break;
        }
      }
      
      //on regarde si la hitbox rencontre le chemin
      if(can_place_tower && map.is_on_track(temp.x, temp.y, temp.size))  can_place_tower=false;
      
      
      if(can_place_tower && argent<temp.price)  can_place_tower=false;
      temp.show();
      temp.show_range(can_place_tower);
      
      
      if(can_place_tower && mousePressed && mouseButton==LEFT){
          
        if(placing_tower.equals("spike factory")){      //il calculer ses pos atteignables
          temp.on_track_pos = new ArrayList<float[]>();
          int pas = 5;
          
          for(float a=temp.x-temp.range; a<=temp.x+temp.range; a+=pas){
            for(float b=temp.y-temp.range; b<=temp.y+temp.range; b+=pas){
              if(map.is_on_track(a, b, 0) && distance(new float[] {a, b}, new float[] {temp.x, temp.y}) <= temp.range){
                temp.on_track_pos.add(new float[] {a, b});
              }
            }
          }
        } 
        
        towers.add(temp);
        argent-= temp.price;
        if( !god_mode){
          placing_tower="";
          selected_tower=temp;
        }
      }
    }
  }
  
  void select_existing_tower(){
    if( selected_tower!=null && (!placing_tower.equals("") || mousePressed && mouseButton==LEFT) ){  //si on place une nouvelle tour ou si on clique ailleurs en ayant une tour de selectionnée
      if(distance(new float[] {selected_tower.x, selected_tower.y}, new float[] {mouseX, mouseY})>selected_tower.size/2){
        if(!(mouseX>=info_panel.top_left_x && mouseX<=info_panel.bottom_right_x && mouseY>=info_panel.top_left_y && mouseY<=info_panel.bottom_right_y)){  //cliquer sur l'info bar ne change rien
          selected_tower.highlight=false;
          selected_tower=null;
        }
      }
    }
    if(!placing_tower.equals("") || selected_tower!=null)  return;    //si on est en train de placer une tour ou si on en a deja selectionnée une
    if(mousePressed && mouseButton==LEFT){
      for(Tower tour : towers){
        if( distance(new float[] {tour.x, tour.y}, new float[] {mouseX, mouseY})<=tour.size/2 ){
          selected_tower=tour;
          selected_tower.highlight=true;
          break;
        }
      }
    }
  }


  void tower_selection(){
    if(keyPressed){
      if(key=='a' || key=='A')  placing_tower="dart monkey";
      if(key=='z' || key=='Z')  placing_tower="wizard monkey";
      if(key=='e' || key=='E')  placing_tower="sniper";
      if(key=='r' || key=='R')  placing_tower="tack shooter";
      if(key=='t' || key=='T')  placing_tower="dartling gun";
      if(key=='y' || key=='Y')  placing_tower="boomerang thrower";
      if(key=='u' || key=='U')  placing_tower="ninja monkey";
      if(key=='i' || key=='I')  placing_tower="spike factory";
      if(key==' ')  placing_tower="";
    }
  }

}
