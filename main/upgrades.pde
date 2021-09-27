class Upgrades{
  
  int price_1, price_2;
  String name_1, name_2, descr_1, descr_2;
  boolean can_purchase_1, can_purchase_2;
  

  void change_attack_speed(Tower tour, float multiplicateur){
    for(int i=0; i<tour.attack_speed_list.size(); i++){
      tour.attack_speed_list.set(i, tour.attack_speed_list.get(i) * multiplicateur);
    }
  }
  
  void set_attack_speed(Tower tour, float as){
    for(int i=0; i<tour.attack_speed_list.size(); i++){
      tour.attack_speed_list.set(i, as);
    }
  }
 
  
  void change_shooting_type(Tower tour, String new_type){
    for(int i=0; i<tour.shoots_list.size(); i++){
      tour.shoots_list.set(i, new_type);
    }
  }
  
  
  
  void apply_upgrade(Tower tour, int path_to_upgrade){
    
    if(path_to_upgrade==1 && !can_purchase_1 || path_to_upgrade==2 && !can_purchase_2)  return;
    
    
    if(tour.type.equals("dart monkey")){
      String temp_shooting_type;
      if(path_to_upgrade==1){
        switch(tour.path_1_progression){
          case 0:
            tour.range = int(tour.range * 1.25);
            break;
          case 1:
            tour.range = int(tour.range * 1.20);
            tour.detects_camo=true;
            break;
          case 2:
            temp_shooting_type = "dart ball";
            if(tour.shoots_list.get(0).equals("sharp dart"))  temp_shooting_type="sharp dart ball";
            else if(tour.shoots_list.get(0).equals("razor sharp dart"))  temp_shooting_type="razor sharp dart ball";
            change_shooting_type(tour, temp_shooting_type);
            set_attack_speed(tour,  0.63);
            break;
          case 3:
            tour.range = int(tour.range*1.15);
            temp_shooting_type = "huge dart ball";
            if(tour.shoots_list.get(0).equals("sharp dart ball"))  temp_shooting_type="sharp huge dart ball";
            else if(tour.shoots_list.get(0).equals("razor sharp dart ball"))  temp_shooting_type="razor sharp huge dart ball";
            change_shooting_type(tour, temp_shooting_type);
            break;          
        }
      }
      if(path_to_upgrade==2){
        switch(tour.path_2_progression){
          case 0:            
            temp_shooting_type = "sharp dart";
            if(tour.shoots_list.get(0).equals("dart ball"))  temp_shooting_type="sharp dart ball";
            else if(tour.shoots_list.get(0).equals("huge dart ball"))  temp_shooting_type="sharp huge dart ball";
            change_shooting_type(tour, temp_shooting_type);
            break;
          case 1:
            temp_shooting_type = "razor sharp dart";
            if(tour.shoots_list.get(0).equals("sharp dart ball"))  temp_shooting_type="razor sharp dart ball";
            else if(tour.shoots_list.get(0).equals("sharp huge dart ball"))  temp_shooting_type="razor sharp huge dart ball";
            change_shooting_type(tour, temp_shooting_type);
            break;
          case 2:
            tour.deviation_list.append(-0.216);
            tour.deviation_list.append(0.216);
            for(int i=0; i<2; i++){
              tour.shoots_list.append("razor sharp dart");
              tour.time_before_next_attack_list.append(tour.time_before_next_attack_list.get(0));
              tour.attack_speed_list.append(tour.attack_speed_list.get(0));
            }
            break;
          case 3:
            //implémenter CORRECTEMENT les abilities
            
            boolean already_have_one = false;
            for(Ability abi : abilities){
              if(abi instanceof Super_monkey_fan_club){
                already_have_one = true;
                abi.towers_having_this_ability.add(tour);
                abi.add_one_use(true);
                tour.linked_ability = abi;
                break;
              }
            }
            if( !already_have_one){
              abilities.add(new Super_monkey_fan_club(tour, 50., 15.));
              tour.linked_ability = abilities.get(abilities.size()-1);
            }
            
            break;          
        }
      }
    }
    
    if(tour.type.equals("tack shooter")){
      if(path_to_upgrade==1){
        switch(tour.path_1_progression){
          case 0:
            change_attack_speed(tour, 1.33);
            break;
          case 1:
            change_attack_speed(tour, 1.8);
            break;
          case 2:
            float as=tour.attack_speed_list.get(0);
            float timer=tour.time_before_next_attack_list.get(0);
            tour.shoots_list=new StringList();
            tour.deviation_list=new FloatList();
            tour.attack_speed_list = new FloatList();
            tour.time_before_next_attack_list = new FloatList();

            
            for(int i=0; i<16; i++){
              tour.shoots_list.append("tack");
              tour.deviation_list.append(i*PI/8);
              tour.attack_speed_list.append(as);
              tour.time_before_next_attack_list.append(timer);
            }
            break;
          case 3:
            float temp=tour.time_before_next_attack_list.get(0);
            tour.range = int(tour.range * 1.2);      //on passe de 90 de range de base à 108
            tour.shoots_list=new StringList("ring of fire");
            tour.deviation_list=new FloatList(0.);
            tour.attack_speed_list = new FloatList(2.3);
            tour.time_before_next_attack_list = new FloatList(temp);
            break;          
        }
      }
      if(path_to_upgrade==2){
        switch(tour.path_2_progression){
          case 0:
            tour.range = int(tour.range * 1.15);
            break;
          case 1:
            tour.range = int(tour.range * 1.15);
            break;
          case 2:
            change_shooting_type(tour, "blade");
            break;
          case 3:
            boolean already_have_one = false;
            for(Ability abi : abilities){
              if(abi instanceof Blade_maelstrom){
                already_have_one = true;
                abi.towers_having_this_ability.add(tour);
                abi.add_one_use(true);
                tour.linked_ability = abi;
                break;
              }
            }
            if( !already_have_one){
              abilities.add(new Blade_maelstrom(tour, 20., 6.));    //ca dure moins de 6 sec mais c'est pas grave on gère le cas avec le nb de frame dans continue_use
              tour.linked_ability = abilities.get(abilities.size()-1);
            }
            break;          
        }
      }
    }
    
    if(tour.type.equals("sniper")){
      if(path_to_upgrade==1){
        switch(tour.path_1_progression){
          case 0:
            change_shooting_type(tour, "full metal bullet");
            break;
          case 1:
            change_shooting_type(tour, "point five bullet");
            break;
          case 2:
            change_shooting_type(tour, "deadly bullet");
            break;
          case 3:
            change_shooting_type(tour, "cripple MOAB bullet");
            break;          
        }
      }
      if(path_to_upgrade==2){
        switch(tour.path_2_progression){
          case 0:
            change_attack_speed(tour, 1.4);
            break;
          case 1:
            tour.detects_camo = true;
            break;
          case 2:
            change_attack_speed(tour, 3);   
            break;
          case 3:
            boolean already_have_one = false;
            for(Ability abi : abilities){
              if(abi instanceof Supply_drop){
                already_have_one = true;
                abi.towers_having_this_ability.add(tour);
                abi.add_one_use(true);
                tour.linked_ability = abi;
                abi.initial_cd(tour);    //cette abilité a un cd initial
                break;
              }
            }
            if( !already_have_one){
              abilities.add(new Supply_drop(tour, 60., 0.));
              tour.linked_ability = abilities.get(abilities.size()-1);
            }
            break;       
        }
      }
    }
    
    
    if(tour.type.equals("boomerang thrower")){
      if(path_to_upgrade==1){
        switch(tour.path_1_progression){
          case 0:
            if(tour.shoots_list.get(0).indexOf("sonic")>=0)  change_shooting_type(tour, "sonic multi target boomerang");
            else if (tour.shoots_list.get(0).indexOf("red hot")>=0)  change_shooting_type(tour, "red hot multi target boomerang");
            else change_shooting_type(tour, "multi target boomerang");
            break;
          case 1:
            if(tour.shoots_list.get(0).indexOf("sonic")>=0)  change_shooting_type(tour, "sonic glaive boomerang");
            else if (tour.shoots_list.get(0).indexOf("red hot")>=0)  change_shooting_type(tour, "red hot glaive boomerang");
            else change_shooting_type(tour, "glaive boomerang");
            change_attack_speed(tour, 1.064);
            break;
          case 2:
            if(tour.shoots_list.get(0).indexOf("sonic")>=0)  change_shooting_type(tour, "sonic glaive ricochet");
            else if (tour.shoots_list.get(0).indexOf("red hot")>=0)  change_shooting_type(tour, "red hot glaive ricochet");
            else change_shooting_type(tour, "glaive ricochet");
            break;
          case 3:
            tour.detects_camo=true;        
            Boomerang temp;
            String temp_boomer_type;
            if(tour.shoots_list.get(0).indexOf("sonic")>=0)  temp_boomer_type = "sonic glaive boomerang";
            else if (tour.shoots_list.get(0).indexOf("red hot")>=0)  temp_boomer_type = "red hot glaive boomerang";
            else temp_boomer_type = "glaive boomerang";
            for(int i=0; i<2; i++){
              temp = new Boomerang(tour, tour.x, tour.y, 65., temp_boomer_type);    //Les 2 nouveaux boomerangs doivent pop les memes choses que les autres : FAUT LES UPDATE SI JAMAIS UP LE PATH2 APRES CA
              temp.speed = 5.;
              temp.orbiting=true;
              if(i==1)  temp.angle_dep=PI;
              temp.deplacement();  //pour éviter qu'il y ait un prev_x sur la tour et déclancer des collisions qui ne doivent pas avoir lieu
              temp.deplacement();
              boomerangs.add(temp);
            }
            break;          
        }
      }
      if(path_to_upgrade==2){
        String temp_shooting_type;
        switch(tour.path_2_progression){
          case 0:
            temp_shooting_type = "sonic boomerang";
            if(tour.shoots_list.get(0).indexOf("multi target")>=0)  temp_shooting_type = "sonic multi target boomerang";
            else if(tour.shoots_list.get(0).indexOf("ricochet")>=0)  temp_shooting_type = "sonic glaive ricochet";
            else if(tour.shoots_list.get(0).indexOf("glaive")>=0)  temp_shooting_type = "sonic glaive boomerang";
            change_shooting_type(tour, temp_shooting_type);
            //Si on a max left_path, les boomerangs orbitants doivent aussi pouvoir péter les frozen
            for(Boomerang boomer : boomerangs){
              if(boomer.orbiting && boomer.fired_from_tower == tour)  boomer.boomerang_type = "sonic glaive boomerang";
            }
            break;
          case 1:
            temp_shooting_type = "red hot boomerang";
            if(tour.shoots_list.get(0).indexOf("multi target")>=0)  temp_shooting_type = "red hot multi target boomerang";
            else if(tour.shoots_list.get(0).indexOf("ricochet")>=0)  temp_shooting_type = "red hot glaive ricochet";
            else if(tour.shoots_list.get(0).indexOf("glaive")>=0)  temp_shooting_type = "red hot glaive boomerang";
            change_shooting_type(tour, temp_shooting_type);
            //Si on a max left_path, les boomerangs orbitants doivent aussi pouvoir péter les lead
            for(Boomerang boomer : boomerangs){
              if(boomer.orbiting && boomer.fired_from_tower == tour)  boomer.boomerang_type = "red hot glaive boomerang";
            }
            break;
          case 2:
            change_attack_speed(tour, 3.2);   
            break;
          case 3:
            boolean already_have_one = false;
            for(Ability abi : abilities){
              if(abi instanceof Turbo_charge){
                already_have_one = true;
                abi.towers_having_this_ability.add(tour);
                abi.add_one_use(true);
                tour.linked_ability = abi;
                break;
              }
            }
            if( !already_have_one){
              abilities.add(new Turbo_charge(tour, 45., 10.));
              tour.linked_ability = abilities.get(abilities.size()-1);
            }
            break;          
        }
      }
    }
    
    
    if(tour.type.equals("dartling gun")){
      String temp_shooting_type;
      if(path_to_upgrade==1){
        switch(tour.path_1_progression){
          case 0:
            tour.max_dispersion=0.14;
            break;
          case 1:
            change_attack_speed(tour, 1.75);
            break;
          case 2:
            change_attack_speed(tour, 1.15);
            temp_shooting_type = "laser cannon";
            if(tour.shoots_list.get(0).equals("powerful dart"))  temp_shooting_type = "powerful laser cannon";
            else if(tour.shoots_list.get(0).equals("bloontonium dart"))  temp_shooting_type = "bloontonium laser cannon";
            change_shooting_type(tour, temp_shooting_type);
            break;
          case 3:
            rays_of_doom.add(new Ray_of_doom(tour));
            break;          
        }
      }
      if(path_to_upgrade==2){
        switch(tour.path_2_progression){
          case 0:
            if(tour.shoots_list.get(0).equals("ray of doom"))  break;    //en gros ca sert à rien d'ajouter du pierce vu que ray of doom est pas destiné à etre avec du pierce
            if(tour.shoots_list.get(0).equals("laser cannon"))  change_shooting_type(tour, "powerful laser cannon");
            else  change_shooting_type(tour, "powerful dart");
            break;
          case 1:
            temp_shooting_type = "bloontonium dart";
            if(tour.shoots_list.get(0).equals("ray of doom"))  break;    //en gros ca sert à rien d'ajouter du pierce vu que ray of doom est pas destiné à etre avec du pierce
            if(tour.shoots_list.get(0).equals("powerful laser cannon"))  temp_shooting_type = "bloontonium laser cannon";
            change_shooting_type(tour, temp_shooting_type);
            break;
          case 2:
            for(int i=0; i<tour.shoots_list.size(); i++){
              tour.shoots_list.set(i, "hydra rocket");  
            }
            
            break;
          case 3:
            tour.deviation_list.append(-0.22);
            tour.deviation_list.append(0.22);
            for(int i=0; i<2; i++){
              tour.shoots_list.append("hydra rocket");
              tour.time_before_next_attack_list.append(tour.time_before_next_attack_list.get(0));
              tour.attack_speed_list.append(tour.attack_speed_list.get(0));
            }
            boolean already_have_one = false;
            for(Ability abi : abilities){
              if(abi instanceof Rocket_storm){
                already_have_one = true;
                abi.towers_having_this_ability.add(tour);
                abi.add_one_use(true);
                tour.linked_ability = abi;
                break;
              }
            }
            if( !already_have_one){
              abilities.add(new Rocket_storm(tour, 30., 10.));
              tour.linked_ability = abilities.get(abilities.size()-1);
            }
            break;          
        }
      }
    }
    
    
    if(tour.type.equals("wizard monkey")){
      if(path_to_upgrade==1){
        switch(tour.path_1_progression){
          case 0:
            tour.shoots_list.set(0, "huge purple ball");
            break;
          case 1:
            tour.shoots_list.append("laser");
            tour.deviation_list.append(0);
            tour.attack_speed_list.append(0.43);
            tour.time_before_next_attack_list.append(0);
            break;
          case 2:
            //Whirlwinds and Tornadoes cannot blow away Lead Bloons but the Tornadoes from Tempest Tornado Monkey Apprentices can pop Lead Bloons.
            //Sprite sur le site
            // removes ice and glue from the bloons.
            tour.shoots_list.append("whirlwind");
            tour.deviation_list.append(0);
            tour.attack_speed_list.append(0.31);
            tour.time_before_next_attack_list.append(0);
            break;
          case 3:
            //removes ice and glue from the bloons.
            //Blows tornado FASTER, FURTHER AND MORE OFTEN
            int index;      //on doit remplacer la whirlwind avec la tornado
            for(index = tour.shoots_list.size()-1; index>=0; index--){    //on commence par le bout c'est plus opti
              if(tour.shoots_list.get(index).equals("whirlwind"))   break;
            }
            tour.shoots_list.set(index, "tornado");
            tour.deviation_list.set(index, 0);
            tour.attack_speed_list.set(index, 0.6);    //le 0.6 est mesuré plus ou moins avec la version flash
            break;          
        }
      }
      if(path_to_upgrade==2){
        switch(tour.path_2_progression){
          case 0:
            //The fireball can pop Black and Zebra Bloons despite exploding
            tour.shoots_list.append("fireball");
            tour.deviation_list.append(0);
            tour.attack_speed_list.append(0.47);
            tour.time_before_next_attack_list.append(0);
            break;
          case 1:
            tour.detects_camo=true;
            break;
          case 2:
            //FIRE ATTACKS UNFREEZE BALLONS
            tour.shoots_list.append("dragon's breath");
            tour.deviation_list.append(0);
            tour.attack_speed_list.append(10);
            tour.time_before_next_attack_list.append(0);            
            break;
          case 3:
            boolean already_have_one = false;
            for(Ability abi : abilities){
              if(abi instanceof Summon_phoenix){
                already_have_one = true;
                abi.towers_having_this_ability.add(tour);
                abi.add_one_use(true);
                tour.linked_ability = abi;
                break;
              }
            }
            if( !already_have_one){
              abilities.add(new Summon_phoenix(tour, 60., 20.));
              tour.linked_ability = abilities.get(abilities.size()-1);
            }
            break;          
        }
      }
    }
    
    
    if(tour.type.equals("ninja monkey")){
      if(path_to_upgrade==1){
        String temp_shooting_type;
        switch(tour.path_1_progression){
          case 0:
            change_attack_speed(tour, 1.2);
            tour.range = int(tour.range * 1.16);
            break;
          case 1:
            if(tour.shoots_list.get(0).indexOf("seeking")>=0)  tour.shoots_list.set(0, "seeking sharp shuriken");
            else tour.shoots_list.set(0, "sharp shuriken");
            break;
          case 2:
            temp_shooting_type = tour.shoots_list.get(0);
            tour.shoots_list.append(temp_shooting_type);
            tour.deviation_list.append(0.1);
            tour.attack_speed_list.append(tour.attack_speed_list.get(0));
            tour.time_before_next_attack_list.append(tour.time_before_next_attack_list.get(0));
            break;
          case 3:
            tour.deviation_list.append(0.2);
            tour.deviation_list.append(-0.1);
            tour.deviation_list.append(-0.2);
            temp_shooting_type = tour.shoots_list.get(0);
            for(int i=0; i<3; i++){
              tour.shoots_list.append(temp_shooting_type);
              tour.attack_speed_list.append(tour.attack_speed_list.get(0));
              tour.time_before_next_attack_list.append(tour.time_before_next_attack_list.get(0));
            }
            break;          
        }
      }
      if(path_to_upgrade==2){
        switch(tour.path_2_progression){
          case 0:
                                //change to do on seeking shuriken ?
            if(tour.shoots_list.get(0).indexOf("sharp")>=0)  change_shooting_type(tour, "seeking sharp shuriken");
            else change_shooting_type(tour, "seeking shuriken");
            break;
          case 1:
            //implémenter la distraction -> fonctionne exactement comme la tornade
            break;
          case 2:
            tour.shoots_list.append("flash bomb");
            tour.deviation_list.append(0);
            if(tour.path_1_progression>0)  tour.attack_speed_list.append(0.504);
            else tour.attack_speed_list.append(0.42);
            tour.time_before_next_attack_list.append(0);            
            break;
          case 3:
            boolean already_have_one = false;
            for(Ability abi : abilities){
              if(abi instanceof Sabotage_supply_lines){
                already_have_one = true;
                abi.towers_having_this_ability.add(tour);
                abi.add_one_use(true);
                tour.linked_ability = abi;
                break;
              }
            }
            if( !already_have_one){
              abilities.add(new Sabotage_supply_lines(tour, 60., 15.));
              tour.linked_ability = abilities.get(abilities.size()-1);
            }
            break;
        }
      }
    }
    
    if(tour.type.equals("spike factory")){
      String temp_shooting_type;
      if(path_to_upgrade==1){
        switch(tour.path_1_progression){
          case 0:
            temp_shooting_type = "stack spike";
            if(tour.shoots_list.get(0).equals("MOAB-SHREDR Spikes"))  temp_shooting_type = "stack MOAB-SHREDR Spikes";
            change_shooting_type(tour, temp_shooting_type);
            break;
          case 1:
            temp_shooting_type = "hot spike";
            if(tour.shoots_list.get(0).equals("stack MOAB-SHREDR Spikes"))  temp_shooting_type = "hot MOAB-SHREDR Spikes";
            change_shooting_type(tour, temp_shooting_type);
            break;
          case 2:
            change_shooting_type(tour, "spike ball");    //ajouter le fait que ca fasse 3* les degats aux ceramics
            break;
          case 3:
            change_attack_speed(tour, 2.325);
            change_shooting_type(tour, "spike mine");    //explosion donne un effet napalm  The napalm pops bloons every 2 seconds for 6 seconds. The explosions pop 4 layers
            break;          
        }
      }
      if(path_to_upgrade==2){
        switch(tour.path_2_progression){
          case 0:
            change_attack_speed(tour, 1.62);
            break;
          case 1:
            change_attack_speed(tour, 1.65);
            break;
          case 2:
            change_attack_speed(tour, 1.62);
            temp_shooting_type = "MOAB-SHREDR Spikes";
            if(tour.shoots_list.get(0).indexOf("stack")>=0)  temp_shooting_type = "stack MOAB-SHREDR Spikes";
            else if(tour.shoots_list.get(0).indexOf("hot")>=0)  temp_shooting_type = "hot MOAB-SHREDR Spikes";
            change_shooting_type(tour, temp_shooting_type);
            break;
          case 3:
            boolean already_have_one = false;
            for(Ability abi : abilities){
              if(abi instanceof Spike_storm){
                already_have_one = true;
                abi.towers_having_this_ability.add(tour);
                abi.add_one_use(true);
                tour.linked_ability = abi;
                break;
              }
            }
            if( !already_have_one){
              abilities.add(new Spike_storm(tour, 60., 0.));
              tour.linked_ability = abilities.get(abilities.size()-1);
            }
            break;
        }
      }
    }
    
    
    
    if(path_to_upgrade==1){
      tour.price+=price_1;
      tour.path_1_progression++;
      joueur.argent-=price_1;
    }
    else{
      tour.price+=price_2;
      tour.path_2_progression++;
      joueur.argent-=price_2;
    }
    tour.set_sprites();
    
  }
  
  
  void get_possible_upgrades(String type, int path_1_progression, int path_2_progression){
    
    if(type.equals("dart monkey")){
      switch(path_1_progression){
        case 0:
          name_1 = "Long Range Darts";
          price_1 = 90;
          descr_1 = "Makes the Dart Monkey shoot further than normal.";  //augmente la range de 25%
          break;
        
        case 1:
          name_1 = "Enhanced Eyesight";
          price_1= 120;
          descr_1= "Further increases attack range and allows Dart Monkey to see Camo Bloons.";  //augmente de 20% la range et détecte les camos
          break;
          
        case 2:
          name_1 = "Spike-O-Pult";
          price_1 = 500;
          descr_1 = "Converts the Dart Monkey into a Spike-O-Pult, a powerful tower that hurls a large spiked ball instead of darts. Increases range even more, albeit slightly, but has slower attack speed. Each ball can pop 18 bloons.";
          break;
        
        case 3:
          name_1 = "Juggernaut";
          price_1 = 1500;
          descr_1 = "Hurls a giant unstoppable killer spiked ball that can pop lead bloons and excels at crushing ceramic bloons. Deals 100 pierce, 5 damage to ceramics.";
          break; 
      }
      
      
      switch(path_2_progression){
        case 0:
          name_2 = "Sharp Shots";
          price_2 = 140;
          descr_2 = "Can pop 1 extra bloon per shot.";
          break;
        
        case 1:
          name_2 = "Razor Sharp Shots";
          price_2= 170;
          descr_2= "Can pop 2 extra bloons per shot (4 in total).";
          break;
          
        case 2:
          name_2 = "Triple Darts";
          price_2 = 330;
          descr_2 = "Throws 3 darts at a time instead of 1.";
          break;
        
        case 3:
          name_2 = "Super Monkey Fan Club";
          price_2 = 8000;
          descr_2 = "Super Monkey Fan Club Ability: Converts up to 10 nearby dart monkeys into Super Monkeys for 15 seconds.";
          break; 
      }
    }
    
    if(type.equals("tack shooter")){
      switch(path_1_progression){
        case 0:
          name_1 = "Faster Shooting";
          price_1 = 210;
          descr_1 = "Shoots tacks faster.";
          break;
        
        case 1:
          name_1 = "Even Faster Shooting";
          price_1= 300;
          descr_1= "Further increases attack speed.";
          break;
          
        case 2:
          name_1 = "Tack Sprayer";
          price_1 = 500;
          descr_1 = "Sprays out 16 tacks per volley instead of the usual 8.";
          break;
        
        case 3:
          name_1 = "Ring of Fire";
          price_1 = 2500;
          descr_1 = "Upgrades to a fast firing burst tower that shoots a deadly ring of flame instead of tacks. Also increases range.";
          break; 
      }
      
      
      switch(path_2_progression){
        case 0:
          name_2 = "Extra Range Tacks";
          price_2 = 100;
          descr_2 = "Tacks have increased range.";
          break;
        
        case 1:
          name_2 = "Super Range Tacks";
          price_2= 225;
          descr_2= "Tacks have further increased range.";
          break;
          
        case 2:
          name_2 = "Blade Shooter";
          price_2 = 680;
          descr_2 = "Converts the tower into a blade shooter that shoots out razor sharp blades that are harder for bloons to avoid.";
          break;
        
        case 3:
          name_2 = "Blade Maelstrom";
          price_2 = 2700;
          descr_2 = "Blade Maelstrom Ability: covers the area in an unstoppable storm of blades.";
          break; 
      }
    }
    
    
    if(type.equals("sniper")){
      switch(path_1_progression){
        case 0:
          name_1 = "Full Metal Jacket";
          price_1 = 350;
          descr_1 = "Shots can pop through 4 layers of bloon - and can pop lead and frozen bloons.";
          break;
        
        case 1:
          name_1 = "Point Five Oh";
          price_1= 2200;
          descr_1= "Shots can pop through 7 layers of bloon.";
          break;
          
        case 2:
          name_1 = "Deadly Precision";
          price_1 = 4000;
          descr_1 = "Extreme accuracy and muzzle velocity cause up to 18 layers of bloon to be popped per shot.";
          break;
        
        case 3:
          name_1 = "Cripple MOAB";
          price_1 = 12500;
          descr_1 = "Bullets from this tower temporarily take out propulsion systems of MOAB-class bloons, immobilizing them for a short time.";
          break; 
      }
      
      
      switch(path_2_progression){
        case 0:
          name_2 = "Faster Firing";
          price_2 = 400;
          descr_2 = "Allows Sniper to shoot 40% faster.";
          break;
        
        case 1:
          name_2 = "Night Vision Goggles";
          price_2= 300;
          descr_2= "Allows Sniper to detect and shoot Camo bloons.";
          break;
          
        case 2:
          name_2 = "Semi-Automatic Rifle";
          price_2 = 3500;
          descr_2 = "Allows Sniper to take multiple shots and attack 3x as fast.";
          break;
        
        case 3:
          name_2 = "Supply Drop";
          price_2 = 12000;
          descr_2 = "Supply Drop Ability: Drops a crate giving between $500 and $1500.";
          break; 
      }
    }
    
    
    if(type.equals("boomerang thrower")){
      switch(path_1_progression){
        case 0:
          name_1 = "Multi-Target";
          price_1 = 250;
          descr_1 = "Boomerangs can now pop 7 bloons each.";
          break;
        case 1:
          name_1 = "Glaive Thrower";
          price_1= 280;
          descr_1= "Throws glaives instead of boomerangs - they're sharper and faster (can pop 12 bloons each).";
          break;
        case 2:
          name_1 = "Glaive Ricochet";
          price_1 = 1400;
          descr_1 = "The glaives from this tower will automatically bounce from bloon to bloon as long as there is one close by.";
          break;
        case 3:
          name_1 = "Glaive Lord";
          price_1 = 9000;
          descr_1 = "Creates two permanent glaives that orbit round the tower, shredding almost anything that touches them. Glaive Lord can attack Camo Bloons.";
          break; 
      }
      switch(path_2_progression){
        case 0:
          name_2 = "Sonic Boom";
          price_2 = 100;
          descr_2 = "Sonic boomerangs can smash through frozen bloons.";
          break;
        case 1:
          name_2 = "Red Hot 'Rangs";
          price_2= 150;
          descr_2= "Red hot boomerangs can melt through lead bloons.";
          break;
        case 2:
          name_2 = "Bionic Boomer";
          price_2 = 1600;
          descr_2 = "This tower replaces its arm with a super strong bionic arm. The Bionic Boomer throws boomerangs twice as fast.";
          break;
        case 3:
          name_2 = "Turbo Charge";
          price_2 = 3000;
          descr_2 = "Turbo Charge Ability: Increases attack speed to hypersonic for 10 seconds.";
          break; 
      }
    }
    
     if(type.equals("dartling gun")){
      switch(path_1_progression){
        case 0:
          name_1 = "Focused Firing";
          price_1 = 250;
          descr_1 = "Greatly reduces the spread of the gun.";
          break;
        case 1:
          name_1 = "Faster Barrel Spin";
          price_1= 1200;
          descr_1= "Makes gun fire much faster.";
          break;
        case 2:
          name_1 = "Laser Cannon";
          price_1 = 6000;
          descr_1 = "Converts the gun into a super powerful laser cannon. Blasts from this cannon can pop 13 bloons each, can pop frozen bloons, and have increased attack rate.";
          break;
        case 3:
          name_1 = "Ray of Doom";
          price_1 = 55000;
          descr_1 = "The Ray of Doom is a persistent solid beam of bloon destruction";
          break; 
      }
      switch(path_2_progression){
        case 0:
          name_2 = "Powerful Darts";
          price_2 = 600;
          descr_2 = "Makes darts shoot with greater velocity. Darts move faster and can pop 3 bloons each.";
          break;
        case 1:
          name_2 = "Depleted Bloontonium Darts";
          price_2= 1000;
          descr_2= "Shoots specially modified darts that can hurt any bloon type.";
          break;
        case 2:
          name_2 = "Hydra Rocket Pods";
          price_2 = 7000;
          descr_2 = "Shoots vicious little missiles instead of darts. Hydra rockets have sharp tips that can pop black bloons.";
          break;
        case 3:
          name_2 = "Bloon Area Denial System";
          price_2 = 20000;
          descr_2 = "The BADS covers a wide area with each shot. Enables the Rocket Storm Ability: Rocket Storm shoots out a missile towards the nearest 100 bloons on screen. Ouch.";
          break; 
      }
    }
    
    
    if(type.equals("wizard monkey")){
      switch(path_1_progression){
        case 0:
          name_1 = "Intense Magic";
          price_1 = 300;
          descr_1 = "Shoots larger and more powerful magical bolts.";
          break;
        case 1:
          name_1 = "Lightning Bolt";
          price_1= 1200;
          descr_1= "Unleashes the power of lightning to zap all bloons at once in a chain.";
          break;
        case 2:
          name_1 = "Summon Whirlwind";
          price_1 = 2000;
          descr_1 = "Whirlwind blows bloons off the path away from the exit. However, removes ice and glue from the bloons.";
          break;
        case 3:
          name_1 = "Tempest Tornado";
          price_1 = 8000;
          descr_1 = "The tempest blows more bloons faster, further, and more often. Also pops bloons once before blowing. However, removes ice and glue from the bloons.";
          break; 
      }
      switch(path_2_progression){
        case 0:
          name_2 = "Fireball";
          price_2 = 300;
          descr_2 = "The Apprentice adds a powerful fireball attack to its arsenal.";
          break;
        case 1:
          name_2 = "Monkey Sense";
          price_2= 300;
          descr_2= "Allows the Monkey Apprentice to target and pop camo bloons.";
          break;
        case 2:
          name_2 = "Dragon's Breath";
          price_2 = 4200;
          descr_2 = "Spews endless flames at nearby bloons, roasting and popping them with ease.";
          break;
        case 3:
          name_2 = "Summon Phoenix";
          price_2 = 5000;
          descr_2 = "Summon Phoenix Ability: Creates a super powerful flying phoenix that flies around wreaking bloon havoc for 20 seconds.";
          break; 
      }
    }
    
    if(type.equals("ninja monkey")){
      switch(path_1_progression){
        case 0:
          name_1 = "Ninja Discipline";
          price_1 = 300;
          descr_1 = "Increases attack range and attack speed.";
          break;
        case 1:
          name_1 = "Sharp Shurikens";
          price_1= 350;
          descr_1= "Shurikens can pop 4 bloons each.";
          break;
        case 2:
          name_1 = "Double Shot";
          price_1 = 850;
          descr_1 = "Extreme Ninja skill enables him to throw 2 shurikens at once.";
          break;
        case 3:
          name_1 = "Bloonjitsu";
          price_1 = 2750;
          descr_1 = "The art of bloonjitsu allows Ninjas to throw 5 deadly shurikens at once !";
          break; 
      }
      switch(path_2_progression){
        case 0:
          name_2 = "Seeking Shuriken";
          price_2 = 250;
          descr_2 = "Infuses bloon hatred into the weapons themselves - they will seek out and pop bloons automatically.";
          break;
        case 1:
          name_2 = "Distraction";
          price_2= 350;
          descr_2= "Some bloons struck by the Ninja's weapons will become distracted and move the wrong way temporarily.";
          break;
        case 2:
          name_2 = "Flash Bomb";
          price_2 = 2750;
          descr_2 = "Sometimes throws a flash bomb that stuns bloons in a large radius.";
          break;
        case 3:
          name_2 = "Sabotage Supply Lines";
          price_2 = 2800;
          descr_2 = "Sabotage Supply Lines Ability: Sabotage the bloons supply lines for 15 seconds. During the sabotage, all bloons are crippled to half speed.";
          break; 
      }
    }
    
    if(type.equals("spike factory")){
      switch(path_1_progression){
        case 0:
          name_1 = "Bigger Stacks";
          price_1 = 700;
          descr_1 = "Generates larger piles of spikes per shot.";
          break;
        case 1:
          name_1 = "White Hot Spikes";
          price_1= 900;
          descr_1= "Cuts through lead like a hot spike through... lead.";
          break;
        case 2:
          name_1 = "Spiked Ball Factory";
          price_1 = 2400;
          descr_1 = "Modified to produce heavy but viciously sharp spiked balls instead of regular spikes. Do extra damage (3x) to ceramic bloons.";
          break;
        case 3:
          name_1 = "Spiked Mines";
          price_1 = 14000;
          descr_1 = "Rigged with heavy explosives, the spiked balls are set to go off when then they lose all their spikes.";
          break; 
      }
      switch(path_2_progression){
        case 0:
          name_2 = "Faster Production";
          price_2 = 800;
          descr_2 = "Attack rate improves.";
          break;
        case 1:
          name_2 = "Even Faster Production";
          price_2= 1250;
          descr_2= "Attack rate improves even more.";
          break;
        case 2:
          name_2 = "MOAB-SHREDR Spikes";
          price_2 = 3000;
          descr_2 = "Each spike does 4x damage to MOAB-class bloons, Attack rate improves.";
          break;
        case 3:
          name_2 = "Spike Storm";
          price_2 = 6500;
          descr_2 = "Lays a thick carpet of spikes over the whole track. Spikes last 5 seconds unless reacted upon, in which the spikes will get an extra 5 seconds to pop a bloon.";
          break; 
      }
    }
    
    
    
    can_purchase_1 = true;
    can_purchase_2 = true;
    
    if(path_2_progression >=3 && path_1_progression==2){
      name_1 = "Path locked";
      descr_1 = "You chose to upgrade the second path.";
      can_purchase_1=false;
      price_1=-1;
    }

    if(path_1_progression == 4){
      name_1 = "Max upgrades";
      descr_1 = "Nothing left to upgrade in this path.";
      can_purchase_1=false;
      price_1=-1;
    }
    if(path_1_progression >=3 && path_2_progression==2){
      name_2 = "Path locked";
      descr_2 = "You chose to upgrade the first path.";
      can_purchase_2=false;
      price_2=-1;
    }

    if(path_2_progression == 4){
      name_2 = "Max upgrades";
      descr_2 = "Nothing left to upgrade in this path.";
      can_purchase_2=false;
      price_2=-1;
    }
    
  }
}
