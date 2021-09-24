class Rounds{
  
  //In Bloons TD 5, the speed multiplier can be calculated by this formula: max(6.6 * (waveNumber - 85) / (200 - 85),1)
  // voir part RAMPING https://bloons.fandom.com/wiki/Bloon : ya aussi la vie des mobs
  
  int round_number=300;
  boolean finished;
  float initial_intervall=0.865;
  float intervall;
  ArrayList<Mob> spawn_list=new ArrayList<Mob>();;
  boolean waiting_next_round=true;
  float last_spawn_time;
  

  void init_intervall_time(){
    intervall = initial_intervall * (1- 2*atan(float(round_number-1)/10)/PI);
  }
  
  void init_spawn_list(){
    switch(round_number){
      case 1:
        add_bloons(20, "red", false, false);
        break;
      case 2:
        add_bloons(30, "red", false, false);
        break;
      case 3:
        add_bloons(20, "red", false, false);
        add_bloons(5, "blue", false, false);
        break;
      case 4:
        add_bloons(30, "red", false, false);
        add_bloons(15, "blue", false, false);
        break;
      case 5:
        add_bloons(5, "red", false, false);
        add_bloons(25, "blue", false, false);
        break;
      case 6:
        add_bloons(15, "red", false, false);
        add_bloons(15, "blue", false, false);
        add_bloons(4, "green", false, false);
        break;
      case 7:
        add_bloons(20, "red", false, false);
        add_bloons(25, "blue", false, false);
        add_bloons(5, "green", false, false);
        break;
      case 8:
        add_bloons(10, "red", false, false);
        add_bloons(20, "blue", false, false);
        add_bloons(14, "green", false, false);
        break;
      case 9:
        add_bloons(30, "green", false, false);
        break;
      case 10:
        add_bloons(102, "blue", false, false);
        break;
      case 11:
        add_bloons(6, "red", false, false);
        add_bloons(10, "blue", false, false);
        add_bloons(12, "green", false, false);
        add_bloons(2, "yellow", false, false);
        break;
      case 12:
        add_bloons(15, "blue", false, false);
        add_bloons(10, "green", false, false);
        add_bloons(5, "yellow", false, false);
        break;
      case 13:
        add_bloons(100, "red", false, false);
        add_bloons(23, "blue", false, false);
        add_bloons(4, "green", false, false);
        break;
      case 14:
        add_bloons(50, "red", false, false);
        add_bloons(15, "blue", false, false);
        add_bloons(10, "green", false, false);
        add_bloons(9, "yellow", false, false);
        break;
      case 15:
        add_bloons(20, "red", false, false);
        add_bloons(12, "green", false, false);
        add_bloons(5, "yellow", false, false);
        add_bloons(3, "pink", false, false);
        break;
      case 16:
        add_bloons(20, "green", false, false);
        add_bloons(8, "yellow", false, false);
        add_bloons(4, "pink", false, false);
        break;
      case 17:
        add_bloons(8, "yellow", true, false);
        break;
      case 18:
        add_bloons(80, "green", false, false);
        break;
      case 19:
        add_bloons(10, "green", false, false);
        add_bloons(4, "yellow", false, false);
        add_bloons(5, "yellow", true, false);
        add_bloons(7, "pink", false, false);
        break;
      case 20:
        add_bloons(6, "black", false, false);
        break;
      case 21:
        add_bloons(14, "pink", false, false);
        break;
      case 22:
        add_bloons(8, "white", false, false);
        break;
      case 23:
        add_bloons(5, "black", false, false);
        add_bloons(4, "white", false, false);
        break;
      case 24:
        add_bloons(1, "green", false, true);
        break;
      case 25:
        add_bloons(31, "yellow", true, false);
        break;
      case 26:
        add_bloons(23, "pink", false, false);
        add_bloons(4, "zebra", false, false);
        break;
      case 27:
        add_bloons(120, "red", false, false);
        add_bloons(55, "blue", false, false);
        add_bloons(45, "green", false, false);
        add_bloons(45, "yellow", false, false);
        break;
      case 28:
        add_bloons(4, "lead", false, false);
        break;
     case 29:
       add_bloons(25, "yellow", false, false);
       add_bloons(12, "pink", true, false);
       break;
     case 30:
       add_bloons(9, "lead", false, false);
       break;
     default:
       add_bloons(round_number-10, "black", true, false);
       break;
     
    }
  }
 
  void update(){
    if(waiting_next_round){    
      if(keyPressed && key==ENTER || auto_pass_levels){
        waiting_next_round=false;
        round_number++;
        init_spawn_list();
        init_intervall_time();
        last_spawn_time=FAKE_TIME_ELAPSED;
        for(Tower tour : towers){    //on reset les attaques de toutes les tours pour pas que auto_pass désaventage le joueur
          for(int i=0; i<tour.time_before_next_attack_list.size(); i++){
            tour.time_before_next_attack_list.set(i, 0);
          }
        }
        println("let's go for round ", round_number);
      }
      return;
    }                
    if(spawn_list.size()==0 && enemis.size()==0){     //round cleared
      spikes = new ArrayList<Spikes>();
      joueur.argent+=round_number+99;
      waiting_next_round=true;
      joueur.game_speed=1;      //on reset la vitesse a 1
      joueur.speed_button.text = "speed : "+str(1);    //sinon pas encore init
    }
  }
  
  void spawn(){
    int decalage=0;
    while(spawn_list.size()>0 && FAKE_TIME_ELAPSED-last_spawn_time > intervall){    //le while est la si jamais on doit spawn plusieurs enemis a la meme frame
      spawn_list.get(0).avancement -= 2*decalage;
      enemis.add(spawn_list.get(0));
      spawn_list.remove(0);
      last_spawn_time+=intervall;
      decalage++;
    }
  }
  
  void add_bloons(int number, String type, boolean regrowth, boolean camo){
    for(int i=0; i<number; i++){
      spawn_list.add(new Mob(type, regrowth, camo));
    }
  }
  
}
