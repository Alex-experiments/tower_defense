class Rounds{
  
  //In Bloons TD 5, the speed multiplier can be calculated by this formula: max(6.6 * (waveNumber - 85) / (200 - 85),1)
  // voir part RAMPING https://bloons.fandom.com/wiki/Bloon : ya aussi la vie des mobs
  
  int round_number=0;
  boolean finished;
  float initial_intervall=0.865, intervall;
  ArrayList<Mob> spawn_list=new ArrayList<Mob>();  
  boolean waiting_next_round=true;
  float last_spawn_time;
  
  float speed_multiplier = 1, health_multiplier;
    
  boolean spawn_at_half_speed = false;
  int nb_of_sabotage_in_use = 0;  

  void init_intervall_time(){
    intervall = initial_intervall * (1- 2*atan((round_number-1.)/10.)/PI);
  }
  
  void init_spawn_list(){
    switch(round_number){
      case 1:
        add_bloons(20, "red");
        break;
      case 2:
        add_bloons(30, "red");
        break;
      case 3:
        add_bloons(20, "red");
        add_bloons(5, "blue");
        break;
      case 4:
        add_bloons(30, "red");
        add_bloons(15, "blue");
        break;
      case 5:
        add_bloons(5, "red");
        add_bloons(25, "blue");
        break;
      case 6:
        add_bloons(15, "red");
        add_bloons(15, "blue");
        add_bloons(4, "green");
        break;
      case 7:
        add_bloons(20, "red");
        add_bloons(25, "blue");
        add_bloons(5, "green");
        break;
      case 8:
        add_bloons(10, "red");
        add_bloons(20, "blue");
        add_bloons(14, "green");
        break;
      case 9:
        add_bloons(30, "green");
        break;
      case 10:
        add_bloons(102, "blue");
        break;
      case 11:
        add_bloons(6, "red");
        add_bloons(10, "blue");
        add_bloons(12, "green");
        add_bloons(2, "yellow");
        break;
      case 12:
        add_bloons(15, "blue");
        add_bloons(10, "green");
        add_bloons(5, "yellow");
        break;
      case 13:
        add_bloons(100, "red");
        add_bloons(23, "blue");
        add_bloons(4, "green");
        break;
      case 14:
        add_bloons(50, "red");
        add_bloons(15, "blue");
        add_bloons(10, "green");
        add_bloons(9, "yellow");
        break;
      case 15:
        add_bloons(20, "red");
        add_bloons(12, "green");
        add_bloons(5, "yellow");
        add_bloons(3, "pink");
        break;
      case 16:
        add_bloons(20, "green");
        add_bloons(8, "yellow");
        add_bloons(4, "pink");
        break;
      case 17:
        add_bloons(8, "yellow", true, false);
        break;
      case 18:
        add_bloons(80, "green");
        break;
      case 19:
        add_bloons(10, "green");
        add_bloons(4, "yellow");
        add_bloons(5, "yellow", true, false);
        add_bloons(7, "pink");
        break;
      case 20:
        add_bloons(6, "black");
        break;
      case 21:
        add_bloons(14, "pink");
        break;
      case 22:
        add_bloons(8, "white");
        break;
      case 23:
        add_bloons(5, "black");
        add_bloons(4, "white");
        break;
      case 24:
        add_bloons(1, "green", false, true);
        break;
      case 25:
        add_bloons(31, "yellow", true, false);
        break;
      case 26:
        add_bloons(23, "pink");
        add_bloons(4, "zebra");
        break;
      case 27:
        add_bloons(120, "red");
        add_bloons(55, "blue");
        add_bloons(45, "green");
        add_bloons(45, "yellow");
        break;
      case 28:
        add_bloons(4, "lead");
        break;
     case 29:
       add_bloons(25, "yellow");
       add_bloons(12, "pink", true, false);
       break;
     case 30:
       add_bloons(9, "lead");
       break;
     case 31 :
       add_bloons(8, "zebra");
       add_bloons(2, "zebra", true, false);
       break;
     case 32:
       add_bloons(25, "black");
       add_bloons(28, "white");
       add_bloons(8, "lead");
       break;
     case 33:
       add_bloons(20, "yellow", false, true);
       break;
     case 34:
       add_bloons(140, "yellow");
       add_bloons(5, "zebra");
       break;
     case 35:
       add_bloons(35, "pink");
       add_bloons(25, "white");
       add_bloons(5, "rainbow");
       break;
     case 36:
       add_bloons(81, "pink");
       break;
     case 37:
       add_bloons(20, "black");
       add_bloons(20, "white");
       add_bloons(7, "white", false, true);
       add_bloons(15, "lead");
       add_bloons(10, "zebra");
       break;
     case 38:
       add_bloons(42, "pink", true, false);
       add_bloons(17, "white");
       add_bloons(14, "lead");
       add_bloons(10, "zebra");
       add_bloons(4, "rainbow");
       break;
     case 39:
       add_bloons(10, "black");
       add_bloons(10, "white");
       add_bloons(20, "lead");
       add_bloons(20, "zebra");
       add_bloons(18, "rainbow");
       break;
     case 40:
       add_bloons(10, "rainbow");
       add_bloons(4, "ceramic");
       break;
     case 41:
       add_bloons(60, "black");
       add_bloons(60, "zebra");
       break;
     case 42:
       add_bloons(6, "rainbow", false, true);
       add_bloons(6, "rainbow", true, false);
       break;
     case 43:
       add_bloons(10, "rainbow");
       add_bloons(7, "ceramic");
       break;
     case 44:
       add_bloons(50, "zebra");
       break;
     case 45:
       add_bloons(200, "pink");
       add_bloons(9, "lead");
       add_bloons(25, "rainbow");
       break;
     case 46:
       add_bloons(1, "MOAB");
       break;
     case 47:
       add_bloons(70, "pink", false, true);
       add_bloons(12, "ceramic");
       break;
     case 48:
       add_bloons(120, "pink", true, false);
       add_bloons(50, "rainbow");
       break;
     case 49:
       add_bloons(343, "green");
       add_bloons(20, "zebra");
       add_bloons(20, "rainbow");
       add_bloons(10, "rainbow", true, false);
       add_bloons(18, "ceramic");
       break;
     case 50:
       add_bloons(20, "red");
       add_bloons(8, "lead");
       add_bloons(20, "ceramic");
       add_bloons(2, "MOAB");
       break;
     case 51:
       add_bloons(10, "rainbow", true, false);
       add_bloons(28, "ceramic");
       break;
     case 52:
       add_bloons(25, "rainbow");
       add_bloons(10, "ceramic");
       add_bloons(2, "MOAB");
       break;
     case 53:
       add_bloons(80, "pink", false, true);
       add_bloons(3, "MOAB");
       break;
     case 54:
       add_bloons(35, "ceramic");
       add_bloons(2, "MOAB");
       break;
     case 55:
       add_bloons(45, "ceramic");
       add_bloons(1, "MOAB");
       break;
     case 56:
       add_bloons(40, "rainbow", true, false);
       add_bloons(1, "MOAB");
       break;
     case 57:
       add_bloons(40, "rainbow");
       add_bloons(4, "MOAB");
       break;
     case 58:
       add_bloons(29, "ceramic");
       add_bloons(5, "MOAB");
       break;
     case 59:
       add_bloons(28, "lead", false, true);
       add_bloons(50, "ceramic");
       break;
     case 60:
       add_bloons(1, "BFB");
       break;
     case 61:
       add_bloons(150, "zebra", true, false);
       add_bloons(5, "MOAB");
       break;
     case 62:
       add_bloons(300, "pink", false, true);
       add_bloons(15, "rainbow", true, true);
       add_bloons(6, "MOAB");
       break;
     case 63:
       add_bloons(75, "lead");
       add_bloons(122, "ceramic");
       break;
     case 64:
       add_bloons(9, "MOAB");
       break;
     case 65:
       add_bloons(100, "zebra");
       add_bloons(70, "rainbow");
       add_bloons(50, "ceramic");
       add_bloons(3, "MOAB");
       add_bloons(2, "BFB");
       break;
     case 66:
       add_bloons(12, "MOAB");    //2 groups of 2, 2 groups of 4
       break;
     case 67:
       add_bloons(15, "ceramic");
       add_bloons(10, "MOAB");  //2 groups of 5
       break;
     case 68:
       add_bloons(4, "MOAB");
       add_bloons(1, "BFB");
       break;
     case 69:
       add_bloons(60, "lead");
       add_bloons(70, "ceramic", true, false);
       break;
     case 70:
       add_bloons(200, "rainbow", false, true);
       add_bloons(4, "MOAB");
       break;
     case 71:
       add_bloons(30, "ceramic");
       add_bloons(10, "MOAB");
       break;
     case 72:
       add_bloons(38, "ceramic", true, false);
       add_bloons(2, "BFB");
       break;
     case 73:
       add_bloons(9, "MOAB");
       add_bloons(2, "BFB");
       break;
     case 74:
       add_bloons(200, "ceramic");
       add_bloons(1, "BFB");
       break;
     case 75:
       add_bloons(28, "lead");
       add_bloons(4, "MOAB");
       add_bloons(3, "BFB");
       break;
     case 76:
       add_bloons(60, "ceramic", true, false);
       break;
     case 77:
       add_bloons(14, "MOAB");
       add_bloons(5, "BFB");
       break;
     case 78:
       add_bloons(150, "rainbow");
       add_bloons(75, "ceramic");
       add_bloons(72, "ceramic", false, true);
       add_bloons(1, "BFB");
       break;
     case 79:
       add_bloons(500, "rainbow", true, false);
       add_bloons(7, "BFB");
       break;
     case 80:
       add_bloons(31, "MOAB");
       break;
     case 81:
       add_bloons(9, "BFB");
       break;
     case 82:
       add_bloons(400, "rainbow", true, true);
       add_bloons(10, "BFB");
       break;
     case 83:
       add_bloons(150, "ceramic");
       add_bloons(30, "MOAB");
       break;
     case 84:
       add_bloons(50, "MOAB");
       add_bloons(10, "BFB");
       break;
     case 85:
       add_bloons(1, "ZOMG");    //5 in Impoppable Difficulty
       break;
     
     
     
     default:
       println("default round");
       int round_rbe = 60000 + 5000*(round_number-85);
       float r;
       while(round_rbe > 0){
         r = random(1.);
         if(r<.2){
           add_bloons(15, "ceramic");
           round_rbe -= 5* spawn_list.get(spawn_list.size()-1).get_RBE();
         }
         else if(r<.4){
           add_bloons(3, "MOAB");
           round_rbe -= 3* spawn_list.get(spawn_list.size()-1).get_RBE();
         }
         else if(r<.7){
           add_bloons(1, "BFB");
           round_rbe -= 1* spawn_list.get(spawn_list.size()-1).get_RBE();
         }
         else{
           add_bloons(1, "ZOMG");
           round_rbe -= 1* spawn_list.get(spawn_list.size()-1).get_RBE(); 
         }
       }
       break;
     
    }
  }
 
  void update(){
    if(waiting_next_round){
      if(tower_panel.next_round_button.is_cliqued() || keyPressed && key==ENTER || auto_pass_levels){
        tower_panel.speed_button.enfonce = true;
        waiting_next_round=false;
        tower_panel.save_button.unclickable = true;
        if(round_number == 0)  stat_manager.increment_stat("Games started", "overview");
        round_number++;
        speed_multiplier = max(6.6 * (round_number - 85) / (200 - 85),1);
        if(round_number > 85)  health_multiplier += .15;
        init_spawn_list();
        init_intervall_time();
        last_spawn_time=FAKE_TIME_ELAPSED;
        for(Tower tour : towers){    //on reset les attaques de toutes les tours pour pas que auto_pass désaventage le joueur
          for(int i=0; i<tour.time_before_next_attack_list.size(); i++){
            tour.time_before_next_attack_list.set(i, 0);
          }
          //il faut pas que le nouveau round commence avec des spawns lents
          if(tour.linked_ability instanceof Sabotage_supply_lines && tour.ability_use_time>=0)  tour.linked_ability.end_effect(tour);  //on end effect que si l'abilite est active
          //sinon ca fais nb_sabo_actif -- ce qu'on veut pas
        }
        println("let's go for round ", round_number);
      }
      return;
    }                
    if(spawn_list.size()==0 && enemis.size()==0){     //round just cleared
      spikes = new ArrayList<Spikes>();
      joueur.gain(round_number+99);
      stat_manager.increment_stat("Rounds cleared", "overview");
      stat_manager.save_all();
      waiting_next_round=true;
      tower_panel.save_button.unclickable = false;
      game.game_just_saved = false;
      joueur.game_speed=1;      //on reset la vitesse a 1
      tower_panel.speed_button.text = "speed : "+str(1);    //sinon pas encore init
    }
  }
  
  void spawn(){
    int decalage=0;
    while(spawn_list.size()>0 && FAKE_TIME_ELAPSED-last_spawn_time > intervall){    //le while est la si jamais on doit spawn plusieurs enemis a la meme frame
      Mob mob = spawn_list.get(0);
      mob.avancement -= decalage*mob.speed;
      mob.update_pos();
      mob.add_to_grid();
      if(spawn_at_half_speed)  mob.speed /= 2.;
      enemis.add(mob);
      spawn_list.remove(0);
      last_spawn_time+=intervall * intervall_multiplier.get(mob.type);
      decalage++;
    }
  }
  
  void add_bloons(int number, String type, boolean regrowth, boolean camo){
    for(int i=0; i<number; i++){
      spawn_list.add(new Mob(type, regrowth, camo, 0));
    }
  }
  
  void add_bloons(int number, String type){
    add_bloons(number, type, false, false);
  }
  
}
