class Ability{
  ArrayList<Tower> towers_having_this_ability = new ArrayList<Tower>();
  ArrayList<Tower> towers_in_cd = new ArrayList<Tower>();
  Tower tower_actually_in_cd;
  
  float cooldown_duration, duration;    //en secondes
  int show_slot;
  int uses_available=1, max_uses_available=1;
  Button bouton;
  boolean global_cooldown = false;
  private float smallest_cd = -1.;
  
  Ability(Tower enabled_by_tower, float cooldown_duration, float duration){
    this.cooldown_duration = cooldown_duration;
    this.duration = duration;
    this.show_slot = abilities.size();    //l'instance est crée juste avant d'etre ajoutée à la liste abilities
    this.towers_having_this_ability.add(enabled_by_tower);
  }
  
  public void core(){
    if(this.bouton.is_cliqued()){
      Tower tour_used = get_tour_to_use();
      this.use(tour_used);  //le bouton sera non cliquable si aucune tour n'est utilisable (uses_available==0)
      tour_used.ability_use_time = FAKE_TIME_ELAPSED;
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
  
  
  
  //function to be over rided
  void use(Tower tour_used){}
  void continue_use(Tower tour){}
  void end_effect(Tower tour){}
  
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
    if(max_use_too)  this.max_uses_available++;
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
    if(this.uses_available==0){
      if(global_cooldown)  this.bouton.text=str(ceil(this.cooldown_duration - FAKE_TIME_ELAPSED + tower_actually_in_cd.ability_cooldown_timer));
      else this.bouton.text=str(ceil(this.cooldown_duration - FAKE_TIME_ELAPSED + smallest_cd));
      this.bouton.unclickable = true;
    }
    this.bouton.show();
    text(str(this.uses_available), 48*show_slot, 600, 48*(show_slot+.4), 616);
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
    bouton.top_left_x = 48*show_slot;
    bouton.bottom_right_x = 48*(show_slot+1);
  }
  
  
 
}

class Super_monkey_fan_club extends Ability{
  //Abilité qui va transformer les 10 dart monkey les plus proche (range infinie) en super monkey pendant 15 sec)
  //The rate of fire also stacks to up to twice as fast as a regular Super Monkey.  
  
  ArrayList<Tower> closest_dart_monkeys = new ArrayList<Tower>();  
  
  Super_monkey_fan_club(Tower enabled_by_tower, float cooldown_duration, float duration){
    super(enabled_by_tower, cooldown_duration, duration);
    this.bouton = new Button(48*show_slot, 600, 48*(show_slot+1), 648, "");
  }

  void use(Tower tour_used){
    
    float dist_min=Float.POSITIVE_INFINITY;
    
    closest_dart_monkeys = new ArrayList<Tower>();
    
    Tower tower_to_replace=null;
    float dist_tower_to_replace=-1.;
    
    for(Tower tour : towers){    //on va créer une arrayList des 10 dart monkeys towers les plus proches (dont celle qui a lancée l'ability)
            
      if(tour.type.equals("dart monkey")){
        
        float dist = distance(new float[] {tour_used.x, tour_used.y}, new float[] {tour.x, tour.y});
        
        if(closest_dart_monkeys.size()<10){    //si on a pas encore récup 10 tours, on ajoute
          closest_dart_monkeys.add(tour);
          if(dist>dist_tower_to_replace){
            dist_tower_to_replace = dist;
            tower_to_replace = tour;
          } 
        }
        else if(dist<dist_min){    //la on vire la plus loin pour la remplacer par celle la
          closest_dart_monkeys.remove(tower_to_replace);
          closest_dart_monkeys.add(tour);
          
          dist_tower_to_replace=-1.;            //il faut maintenant re parcourir notre liste pour savoir laquelle est la nouvelle plus loin
          for(Tower t : closest_dart_monkeys){
            dist = distance(new float[] {tour_used.x, tour_used.y}, new float[] {t.x, t.y});
            if(dist>dist_tower_to_replace){
              dist_tower_to_replace = dist;
              tower_to_replace = t;
            }
          }
        }
      }
    }
     
    tour_used.towers_affected_by_ability = new ArrayList<Tower>();
    for(Tower tour : this.closest_dart_monkeys){
      for(int i=0; i<tour.attack_speed_list.size(); i++){
        tour.attack_speed_list.set(i, tour.attack_speed_list.get(i) * 10);    //en attendant le super monkey
      }
      tour_used.towers_affected_by_ability.add(tour);
    }    
  }  
  
  void end_effect(Tower tour){
    //ATTENTION : cela ne marche pas car en attendant on peut toujours upgrade la tour, ce qui peut rajouter des attaques et donc apres on va lui diviser son attaque par deux...
    //je préconise de créer un type spécial de tour : la fan_club_monkey qui imite un super monkey, sans aucune upgrade available, un prix qu'on va lui attribuer à chaque fois
    //les tours de la liste ne seront juste pas updatées et remplacées par ces nouvelles tours le temps de l'ability
    for(Tower t : tour.towers_affected_by_ability){
      for(int i=0; i<t.attack_speed_list.size(); i++){
        t.attack_speed_list.set(i, t.attack_speed_list.get(i) / 10);    //en attendant le super monkey
      }
    }
    tour.towers_affected_by_ability = new ArrayList<Tower>();  //comme ca si on supprime la tour on ne re débuff pas les tours impactées.
    tour.ability_use_time = -1;    //permet de dire que l'ability n'est plus effective
  }

}

class Blade_maelstrom extends Ability{
  //Blade Maelstrom rapidly shoots two streams of blades, which spiral outwards.
  //Each of the blades have unlimited pierce
  
  Blade_maelstrom(Tower enabled_by_tower, float cooldown_duration, float duration){
    super(enabled_by_tower, cooldown_duration, duration);
    this.bouton = new Button(48*show_slot, 600, 48*(show_slot+1), 648, "");
  }
  
  void use(Tower tour_used){
    for(int i=0; i<64; i++){
     projectiles.add(new Projectile(tour_used, tour_used.x, tour_used.y, i*PI/32, "maelstrom blade"));
    }
  }
  
  
  
}

class Turbo_charge extends Ability{
  //increases the firing speed of the tower by 5x (hypersonic) for 10 seconds.
    
  Turbo_charge(Tower enabled_by_tower, float cooldown_duration, float duration){
    super(enabled_by_tower, cooldown_duration, duration);
    this.bouton = new Button(48*show_slot, 600, 48*(show_slot+1), 648, "");
  }

  void use(Tower tour_used){

    for(int i=0; i<tour_used.attack_speed_list.size(); i++){
      tour_used.attack_speed_list.set(i, tour_used.attack_speed_list.get(i) * 5);
    }
  
  }  
  
  void end_effect(Tower tour){
    for(int i=0; i<tour.attack_speed_list.size(); i++){
      tour.attack_speed_list.set(i, tour.attack_speed_list.get(i) / 5);
    }
    
    tour.ability_use_time = -1;    //permet de dire que l'ability n'est plus effective
  }

}


class Supply_drop extends Ability{

  Supply_drop(Tower enabled_by_tower, float cooldown_duration, float duration){
    super(enabled_by_tower, cooldown_duration, duration);
    this.bouton = new Button(48*show_slot, 600, 48*(show_slot+1), 648, "");
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

  Rocket_storm(Tower enabled_by_tower, float cooldown_duration, float duration){
    super(enabled_by_tower, cooldown_duration, duration);
    this.bouton = new Button(48*show_slot, 600, 48*(show_slot+1), 648, "");
  }
  
  void use(Tower tour_used){
    tour_used.ability_state = 1;
  }
  
  void continue_use(Tower tour){
    Mob target;
    float direction;
    while((tour.ability_state-1) * time_beetween_shoots + tour.ability_use_time <= FAKE_TIME_ELAPSED){
      for(int i=0; i<min(100, enemis.size()); i++){
        target = enemis.get(i);
        direction=atan2(target.y-tour.y, target.x-tour.x);
        projectiles.add(new Projectile(tour, tour.x, tour.y, direction, tour.shoots_list.get(0)));
      }
      tour.ability_state++;
    }
  }
  
}
