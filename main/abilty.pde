class Ability{
  ArrayList<Tower> towers_having_this_ability = new ArrayList<Tower>();
  ArrayList<Tower> towers_in_cd = new ArrayList<Tower>();
  Tower tower_actually_in_cd;
  
  float cooldown_duration, duration;    //en secondes
  int show_slot;
  int uses_available=1, max_uses_available=1;
  Button bouton;
  
  Ability(float cooldown_duration, float duration){
    this.cooldown_duration = cooldown_duration;
    this.duration = duration;
    this.show_slot = abilities.size();    //l'instance est crée juste avant d'etre ajoutée à la liste abilities
  }
  
  void core(){
    if(this.bouton.is_cliqued())   this.use();
    update();
    show();
  }
  
  //function to be over rided
  void use(){}
  void end_effect(Tower tour){}
  
  void update(){    
    
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
      
    for(Tower tour : towers_in_cd){
      if(tour.ability_use_time >= 0 && FAKE_TIME_ELAPSED - tour.ability_use_time > duration){
        this.end_effect(tour);
      }
    }
  }
  
  void add_one_use(boolean max_use_too){
    this.uses_available++;
    if(max_use_too)  this.max_uses_available++;
    this.bouton.text="";
    this.bouton.unclickable=false;
  }
  
  
  void show(){
    if(this.uses_available==0){
      this.bouton.text=str(ceil(this.cooldown_duration - FAKE_TIME_ELAPSED + tower_actually_in_cd.ability_cooldown_timer));
      this.bouton.unclickable = true;
    }
    this.bouton.show();
    text(str(this.uses_available), 48*show_slot, 600, 48*(show_slot+.4), 616);
  }
  
  void delete(Tower tour_to_be_deleted){
    this.end_effect(tour_to_be_deleted);
    towers_having_this_ability.remove(tour_to_be_deleted);
    if(!towers_in_cd.contains(tour_to_be_deleted))   this.uses_available--;
    else  towers_in_cd.remove(tour_to_be_deleted);
    this.max_uses_available--;
    if(max_uses_available<=0)  abilities.remove(this);
    if(tower_actually_in_cd == tour_to_be_deleted)  tower_actually_in_cd = null;
  }
 
}

class Super_monkey_fan_club extends Ability{
  //Abilité qui va transformer les 10 dart monkey les plus proche (range infinie) en super monkey pendant 15 sec)
  //The rate of fire also stacks to up to twice as fast as a regular Super Monkey.  
  
  ArrayList<Tower> closest_dart_monkeys = new ArrayList<Tower>();  
  
  Super_monkey_fan_club(Tower enabled_by_tower, float cooldown_duration, float duration){
    super(cooldown_duration, duration);
    this.towers_having_this_ability.add(enabled_by_tower);
    this.bouton = new Button(48*show_slot, 600, 48*(show_slot+1), 648, "");
  }

  void use(){
    
    //on doit d'abord déterminer de quelle tour l'effet part :
    Tower tour_used=null;
    float x=0,y=0;
    for(Tower tour : towers_having_this_ability){
      if( !towers_in_cd.contains(tour)){
        x=tour.x;
        y=tour.y;
        tour_used = tour;
        break;
      }
    }
    
    float dist_min=Float.POSITIVE_INFINITY;
    
    closest_dart_monkeys = new ArrayList<Tower>();
    
    Tower tower_to_replace=null;
    float dist_tower_to_replace=-1.;
    
    for(Tower tour : towers){    //on va créer une arrayList des 10 dart monkeys towers les plus proches (dont celle qui a lancée l'ability)
            
      if(tour.type.equals("dart monkey")){
        
        float dist = distance(new float[] {x, y}, new float[] {tour.x, tour.y});
        
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
            dist = distance(new float[] {x, y}, new float[] {t.x, t.y});
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
    
    
    tour_used.ability_use_time = FAKE_TIME_ELAPSED;
    towers_in_cd.add(tour_used);
    this.uses_available--;
    
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
