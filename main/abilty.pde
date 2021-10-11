class Ability{
  ArrayList<Tower> towers_having_this_ability = new ArrayList<Tower>();
  ArrayList<Tower> towers_in_cd = new ArrayList<Tower>();
  Tower tower_actually_in_cd;
  
  float cooldown_duration, duration;    //en secondes
  int show_slot, spacing = 2;
  int uses_available=1, max_uses_available=1;
  Button bouton;
  boolean global_cooldown = false;
  private float smallest_cd = -1.;
  
  String ability_name;
  
  Ability(Tower enabled_by_tower, float cooldown_duration, float duration, String ability_name, String ability_descr, boolean loading_ability){
    this.cooldown_duration = cooldown_duration;
    this.duration = duration;
    this.show_slot = abilities.size();    //l'instance est crée juste avant d'etre ajoutée à la liste abilities
    this.towers_having_this_ability.add(enabled_by_tower);
    this.ability_name = ability_name;
    this.bouton = new Button((40+spacing)*show_slot, 610, 40+(40+spacing)*show_slot, 650, "", '²');
    bouton.pos_aff = pos_coins_sprites.get(ability_name+" ability icon");
    bouton.descr = ability_name.toUpperCase()+"\n"+ability_descr;
    bouton.width_descr = 200;
    if(!loading_ability){
      stat_manager.increment_stat("Bought", ability_name);
      stat_manager.increment_stat("Abilities bought", "overview");
    }
  }
  
  public void core(){
    if(this.bouton.is_cliqued()){
      Tower tour_used = get_tour_to_use();
      this.use(tour_used);  //le bouton sera non cliquable si aucune tour n'est utilisable (uses_available==0)
      tour_used.ability_use_time = FAKE_TIME_ELAPSED;
      stat_manager.increment_stat("Used", ability_name);
      stat_manager.increment_stat("Abilities used", "overview");
      if(!global_cooldown){
        tour_used.ability_cooldown_timer = FAKE_TIME_ELAPSED;
        if(smallest_cd < 0)  smallest_cd = FAKE_TIME_ELAPSED;
      }
      towers_in_cd.add(tour_used);
      this.uses_available--;
      
    }
    update();
    show();
  }
  
  public void initial_cd(Tower tour){
    uses_available--;
    tour.ability_cooldown_timer = FAKE_TIME_ELAPSED;
    towers_in_cd.add(tour);
    set_smallest_cd();
  }
  
  public void initial_cd(Tower tour, float init_cd){
    uses_available--;
    tour.ability_cooldown_timer = FAKE_TIME_ELAPSED - cooldown_duration + init_cd;
    towers_in_cd.add(tour);
    set_smallest_cd();
  }
  
  private Tower get_tour_to_use(){
    //on doit d'abord déterminer de quelle tour l'effet part :
    Tower tour_used=null;
    for(Tower tour : towers_having_this_ability){
      if( !towers_in_cd.contains(tour)){
        tour_used = tour;
        break;
      }
    }
    return tour_used;
  }
  
  public float get_remaining_cd_of_tower(Tower tour){      //ne gère pas le cd global
    if(!towers_in_cd.contains(tour))  return 0.;
    else return cooldown_duration - (FAKE_TIME_ELAPSED - tour.ability_cooldown_timer);
  }
  
  
  
  //function to be over rided
  void use(Tower tour_used){}
  void continue_use(Tower tour){}
  void end_effect(Tower tour){
    tour.ability_use_time = -1;
  }
  
  private void update(){
    if(global_cooldown){
      if(tower_actually_in_cd != null && FAKE_TIME_ELAPSED - tower_actually_in_cd.ability_cooldown_timer > cooldown_duration){
        this.add_one_use(false);
        towers_in_cd.remove(tower_actually_in_cd);
        tower_actually_in_cd = null;
      }
      
      if(towers_in_cd.size()==0)  return;  //il n'y a rien a faire car durée d'un cd est forcément > durée effective de l'ability
      
      if(tower_actually_in_cd == null){
        tower_actually_in_cd = towers_in_cd.get(0);
        tower_actually_in_cd.ability_cooldown_timer = FAKE_TIME_ELAPSED;
      }
    }
    else{
      boolean need_to_set_smallest_cd = false;
      for(int i=towers_in_cd.size()-1; i>=0; i--){
        if(FAKE_TIME_ELAPSED - towers_in_cd.get(i).ability_cooldown_timer > cooldown_duration){
          this.add_one_use(false);
          towers_in_cd.remove(i);
          need_to_set_smallest_cd = true;
        }
      }
      if(need_to_set_smallest_cd)  set_smallest_cd();
    }
    for(Tower tour : towers_in_cd){
        if(tour.ability_use_time >= 0 && FAKE_TIME_ELAPSED - tour.ability_use_time > duration)    this.end_effect(tour);
        else  continue_use(tour);
      }
  }
  
  public void add_one_use(boolean max_use_too){
    this.uses_available++;
    if(max_use_too){
      this.max_uses_available++;
      stat_manager.increment_stat("Bought", ability_name);  
    }
    this.bouton.text="";
    this.bouton.unclickable=false;
  }
  
  private void set_smallest_cd(){
    if(towers_in_cd.size() == 0)  smallest_cd = -1.;
    else{
      float min_cd_time = Float.POSITIVE_INFINITY;
      for(Tower tour : towers_in_cd){
        if(tour.ability_cooldown_timer < min_cd_time){
          min_cd_time = tour.ability_cooldown_timer;
        }
      }
      smallest_cd = min_cd_time;
    }
  }
  
  
  private void show(){
    
    this.bouton.show_ability(1.);
    if(this.uses_available==0){
      String cd;
      bouton.show_cooldown(cooldown_duration - FAKE_TIME_ELAPSED + smallest_cd, cooldown_duration);
      if(global_cooldown)  cd=str(ceil(this.cooldown_duration - FAKE_TIME_ELAPSED + tower_actually_in_cd.ability_cooldown_timer));
      else cd=str(ceil(this.cooldown_duration - FAKE_TIME_ELAPSED + smallest_cd));
  
      textAlign(CENTER, CENTER); // centre le texte horizontalement et verticalement
      outline_text(cd, (bouton.top_left_x+bouton.bottom_right_x)/2, (bouton.top_left_y + bouton.bottom_right_y)/2, color(0), color(255), 1);
      this.bouton.unclickable = true;
    }
    outline_text(str(this.uses_available), 40*(show_slot+.15)+spacing*show_slot, 620, color(255), color(0), 1);
  }
  
  public void delete(Tower tour_to_be_deleted){
    this.end_effect(tour_to_be_deleted);
    towers_having_this_ability.remove(tour_to_be_deleted);
    if(!towers_in_cd.contains(tour_to_be_deleted))   this.uses_available--;
    else  towers_in_cd.remove(tour_to_be_deleted);
    this.max_uses_available--;
    if(max_uses_available<=0){
      abilities.remove(this);
      for(int i=0; i<abilities.size(); i++){
        abilities.get(i).update_show_slot(i);
      }
    }
    if(!global_cooldown)  set_smallest_cd();
    else if(tower_actually_in_cd == tour_to_be_deleted)  tower_actually_in_cd = null;
  }
  
  private void update_show_slot(int place_in_list){
    show_slot = place_in_list;
    bouton.top_left_x = (40+spacing)*show_slot;
    bouton.bottom_right_x = 40+(40+spacing)*show_slot;
  }
  
  
 
}

class Super_monkey_fan_club extends Ability{
  //Abilité qui va transformer les 10 dart monkey les plus proche (range infinie) en super monkey fan pendant 15 sec)
  //The rate of fire also stacks to up to twice as fast as a regular Super Monkey.  
  
  ArrayList<Super_monkey_fan> list_of_super_monkey_fans = new ArrayList<Super_monkey_fan>();
  //maintenir cette liste va permettre de les garder en mémoire et de maintenir à jour les summoner associé à chaque appel de use()
  //ainsi le ability_casted_by_tour associé à un super monkey fan sera toujours à jour
  
  Super_monkey_fan_club(Tower enabled_by_tower, boolean loading_ability){
    super(enabled_by_tower, 50., 15., "super monkey fan club", "Converts up to 10 nearby dart monkeys into Super Monkeys for 15 seconds.", loading_ability);
  }
  
  ArrayList<Tower> get_closest_dart_monkeys(int number, Tower tour_used, boolean get_already_impacted_towers){
    ArrayList<Tower> closest_dart_monkeys = new ArrayList<Tower>();
    
    Tower tower_to_replace=null;
    float dist_tower_to_replace=-1.;
    
    for(Tower tour : towers){    //on va créer une arrayList des 10 dart monkeys towers les plus proches (dont celle qui a lancée l'ability)
            
      if(tour.type.equals("dart monkey")){
        if(get_already_impacted_towers){
          if(tour.active)  continue;    //tour pas déjà impactée par un super monkey fan club
        }
        else if(!tour.active)  continue;    //tour deja impactee par un super monkey fan club
        
        float dist = distance(tour_used.x, tour_used.y, tour.x, tour.y);
        
        if(closest_dart_monkeys.size()<number){    //si on a pas encore récup 10 tours, on ajoute
          closest_dart_monkeys.add(tour);
          if(dist>dist_tower_to_replace){
            dist_tower_to_replace = dist;
            tower_to_replace = tour;
          } 
        }
        else if(dist<dist_tower_to_replace){    //la on vire la plus loin pour la remplacer par celle la
          closest_dart_monkeys.remove(tower_to_replace);
          closest_dart_monkeys.add(tour);
          
          dist_tower_to_replace=-1.;            //il faut maintenant re parcourir notre liste pour savoir laquelle est la nouvelle plus loin
          for(Tower t : closest_dart_monkeys){
            dist = distance(tour_used.x, tour_used.y, t.x, t.y);
            if(dist>dist_tower_to_replace){
              dist_tower_to_replace = dist;
              tower_to_replace = t;
            }
          }
        }
      }
    }
    return closest_dart_monkeys;
  }

  void use(Tower tour_used){
    ArrayList<Tower> closest_dart_monkeys = get_closest_dart_monkeys(10, tour_used, false);
    
    if(closest_dart_monkeys.size()<10){
      ArrayList<Tower> closest_impacted_dart_monkeys = get_closest_dart_monkeys(10-closest_dart_monkeys.size(), tour_used, true);
      for(Tower tour : closest_impacted_dart_monkeys){
        closest_dart_monkeys.add(tour);
      }
      
    }
    
    for(Tower tour : closest_dart_monkeys){
      boolean has_already_a_smf_linked = false;
      for(Super_monkey_fan smf : list_of_super_monkey_fans){
        if(smf.summoner == tour){
          has_already_a_smf_linked = true;
          smf.ability_casted_by_tour = tour_used;  //on met ca à jour
          break;
        }
      }
      if(!has_already_a_smf_linked){
        tour.active = false;
        Super_monkey_fan smf = new Super_monkey_fan(tour, tour_used, "super monkey fan", tour.x, tour.y);
        towers.add(smf);
        list_of_super_monkey_fans.add(smf);
      }
    }
    
  }  
  
  void end_effect(Tower tour_used){
    //on veut supprimer toutes les super monkey fans towers crées par cette instance
    //mais on veut garder celles affectées par d'autres
    
    for(int i = list_of_super_monkey_fans.size()-1; i>=0; i--){
      Super_monkey_fan smf = list_of_super_monkey_fans.get(i);
      if(smf.ability_casted_by_tour != tour_used) continue;    //si le cast de l'abilité n'a pas crée cette tour ou si un autre cast a ré-affecté la tour entre temps
      smf.summoner.active = true;
      towers.remove(smf);
      list_of_super_monkey_fans.remove(i);
    }

    tour_used.ability_use_time = -1;    //permet de dire que l'ability n'est plus effective
  }

}

class Blade_maelstrom extends Ability{
  //Blade Maelstrom rapidly shoots two streams of blades, which spiral outwards.
  //Each of the blades have unlimited pierce
  
  Blade_maelstrom(Tower enabled_by_tower, boolean loading_ability){
    super(enabled_by_tower, 20., 6., "blade maelstrom", "Covers the area in an unstoppable storm of blades.", loading_ability);
  }
  
  void use(Tower tour_used){
    tour_used.ability_state = 0;
  }
  
  void continue_use(Tower tour){
    for(int i=0; i<joueur.game_speed; i++){
      if(tour.ability_state>128)  return;
      projectiles.add(new Projectile(tour, tour.x, tour.y, tour.ability_state*PI/32, "maelstrom blade"));
      projectiles.add(new Projectile(tour, tour.x, tour.y, tour.ability_state*PI/32+PI, "maelstrom blade"));
      tour.ability_state++;
    }
  }
  
  
  
}

class Turbo_charge extends Ability{
  //increases the firing speed of the tower by 5x (hypersonic) for 10 seconds.
    
  Turbo_charge(Tower enabled_by_tower, boolean loading_ability){
    super(enabled_by_tower, 45., 10., "turbo charge", "Increases attack speed to hypersonic for 10 seconds.", loading_ability);
  }

  void use(Tower tour_used){

    for(int i=0; i<tour_used.attack_speed_list.size(); i++){
      tour_used.attack_speed_list.set(i, tour_used.attack_speed_list.get(i) * 5);
    }
  
  }  
  
  void end_effect(Tower tour_used){
    for(int i=0; i<tour_used.attack_speed_list.size(); i++){
      tour_used.attack_speed_list.set(i, tour_used.attack_speed_list.get(i) / 5);
    }
    
    tour_used.ability_use_time = -1;    //permet de dire que l'ability n'est plus effective
  }

}


class Supply_drop extends Ability{

  Supply_drop(Tower enabled_by_tower, boolean loading_ability){
    super(enabled_by_tower, 60., 0., "supply drop", "Drops a crate giving between $500 and $1500.", loading_ability);
    initial_cd(enabled_by_tower);
  }
  
  void use(Tower tour_used){
    float x = random(20, 855), y = random(20, 630);    //on se garde une marge de 20px sur les cotes pour pas que ca soit trop chiant
    bananas.add(new Banana(x, y, x, y, int(random(500, 1501)), "supply drop"));
  }
  
}

class Rocket_storm extends Ability{
  //normalement on tire sur les 100 ballons les plus proches, mais moins gourmant de demander les 100 premiers ballons de la liste
  static final float time_beetween_shoots = 2.;

  Rocket_storm(Tower enabled_by_tower, boolean loading_ability){
    super(enabled_by_tower, 30., 10, "rocket storm", "Rocket Storm shoots out a missile towards the first 100 bloons on screen.", loading_ability);
  }
  
  void use(Tower tour_used){
    tour_used.ability_state = 0;
  }
  
  void continue_use(Tower tour){
    Mob target;
    float direction;
    while(tour.ability_state<5 && tour.ability_state * time_beetween_shoots + tour.ability_use_time <= FAKE_TIME_ELAPSED){
      for(int i=0; i<min(100, enemis.size()); i++){
        target = enemis.get(i);
        direction=atan2(target.y-tour.y, target.x-tour.x);
        projectiles.add(new Projectile(tour, tour.x, tour.y, direction, tour.shoots_list.get(0)));
      }
      tour.ability_state++;
    }
  }
}

class Spike_storm extends Ability{
  //Lays a thick carpet of spikes over the whole track. Spikes last 5 seconds unless reacted upon, in which the spikes will get an extra 5 seconds to pop a bloon.
  //on va dire 200 spikes sur le terrain
  
  Spike_storm(Tower enabled_by_tower, boolean loading_ability){
    super(enabled_by_tower, 60., 0., "spike storm", "Lays a thick carpet of spikes over the whole track. Spikes last 5 seconds (10 if reacted upon).", loading_ability);
  }
  
  void use(Tower tour_used){
    for(float[] pos : map.spike_storm_pos){
      spikes.add(new Spikes(tour_used, pos[0], pos[1], tour_used.shoots_list.get(0)+" spike storm"));
    }
    
  }
}

class Summon_phoenix extends Ability{

  Summon_phoenix(Tower enabled_by_tower, boolean loading_ability){
    super(enabled_by_tower, 60., 20., "summon phoenix", "Creates a super powerful flying phoenix that flies around wreaking bloon havoc for 20 seconds.", loading_ability);
  }
  
  void use(Tower tour_used){
    towers.add(new Phoenix(tour_used));
  }
  
  void end_effect(Tower tour_used){
    for(int i = towers.size()-1; i>=0; i--){
      Tower tour = towers.get(i);
      if(tour instanceof Phoenix && tour.summoner == tour_used){
        towers.remove(i);
      }
    }
    tour_used.ability_use_time = -1;
  }

}

class Sabotage_supply_lines extends Ability{
  
  Sabotage_supply_lines(Tower enabled_by_tower, boolean loading_ability){
    super(enabled_by_tower, 60., 15., "sabotage supply lines", "Sabotage the bloons supply lines for 15 seconds. During the sabotage, all bloons are crippled to half speed.", loading_ability);
  }
  
  void use(Tower tour_used){
    round.spawn_at_half_speed = true;
    round.nb_of_sabotage_in_use++;
  }
  
  void end_effect(Tower tour_used){
    round.nb_of_sabotage_in_use--;
    if(round.nb_of_sabotage_in_use==0)  round.spawn_at_half_speed = false;
    tour_used.ability_use_time = -1;
  } 
}
