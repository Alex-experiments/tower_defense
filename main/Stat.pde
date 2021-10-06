static final StringList ability_names = new StringList("super monkey fan club", "blade maelstrom", "turbo charge", "supply drop", "spike storm", "summon phoenix", "sabotage supply lines");
static final StringList tower_names = new StringList("dart monkey", "super monkey fan", "tack shooter", "sniper", "boomerang thrower", "ninja monkey", "wizard monkey", "phoenix", "dartling gun", "spike factory");


class Stat_manager{
  ArrayList<Stat> stats = new ArrayList<Stat>();
  IntDict indexes = new IntDict();
  
  ArrayList<StringList> stats_types = new ArrayList<StringList>();

  Stat_manager(){
    stats_types.add(new StringList("overview")); stats_types.add(new StringList("bloons")); stats_types.add(ability_names); stats_types.add(tower_names);
    
    int index = 0;
    for(StringList stats_type : stats_types){
      for(int i=0; i<stats_type.size(); i++){
        String name = stats_type.get(i);
        stats.add(new Stat(name));
        indexes.set(name, index);
        index++;
      }
    }
    init_all();
    load_all();
  }
  
  void increment_stat(String stat_name, String name){
    stats.get(indexes.get(name)).increment_stat(stat_name);
  }
  void increment_stat(int number, String stat_name, String name){
    stats.get(indexes.get(name)).increment_stat(number, stat_name);
  }
  
  void init_all(){
    for(Stat s : stats){
      s.init();
    }
  }
  
  void load_all(){
    String[] lines = loadStrings("stats.txt");
    if(lines == null){
      init_all();
      save_all();
      return;
    }
    
    for(String line : lines){
      boolean found = false;
      for(StringList stats_type : stats_types){
        for(String type : stats_type){
          if(line.indexOf(type)>-1){
            stats.get(indexes.get(type)).load(line);
            found = true;
            break;
          }
        }
        if(found)  break;
      }
    }
    
  }
  
  void save_all(){
    String[] save = new String[]{};
    for(Stat s : stats){
      save = append(save, s.get_save_string());
    }
    saveStrings("/data/stats.txt", save);
  }
  
  void display(String name){
    textAlign(LEFT, CENTER);
    stats.get(indexes.get(name)).display();
  }
  
}


class Stat{
  StringList stats_names;
  IntDict stats_numbers;
  boolean[]  needs_suffix;
  String name;

  
  Stat(String name){
    this.name = name;
    if(ability_names.hasValue(name)){
      stats_names = new StringList("Used", "Bought", "Bloons popped");    //reste a faire bloons popped
      needs_suffix = new boolean[] {true,   true,     false};
      
      if(name.equals("supply drop"))  stats_names.set(2, "Money collected");
      
    }
    else if(tower_names.hasValue(name)){
      stats_names = new StringList("Placed", "Bloons layers popped", "Sold", "Upgraded", "Upgrade 1/x bought", "Upgrade 2/x bought", "Upgrade 3/x bought", "Upgrade 4/x bought", "Upgrade x/1 bought", "Upgrade x/2 bought", "Upgrade x/3 bought", "Upgrade x/4 bought");
      needs_suffix = new boolean[] {true,     false,                 true,     true,     true,                 true,                 true,                 true,                 true,                 true,                 true,                 true};
      
                                    //ALL OK      
    }
    else if(name.equals("bloons")){
      stats_names = new StringList("red", "blue", "green", "yellow", "pink", "black", "white", "lead",  "zebra", "rainbow", "ceramic", "MOAB", "BFB", "ZOMG");
      int temp_len = stats_names.size()-3;
      for(int i = 0; i<3; i++){
        for(int index = 0; index<temp_len; index++){
          stats_names.append(stats_names.get(index) + (i!=1 ? " camo":"") + (i>0 ? " regrowth":""));
        }
      }
      needs_suffix = new boolean[stats_names.size()];
      
      // ALL OK
    }
    else if(name.equals("overview")){
      stats_names = new StringList("Rounds cleared", "Money earned", "Money spent", "Lives lost", "Games started", "Games lost", "Bloons popped", "Bloons layers popped", "Towers bought", "Towers sold", "Upgrades bought", "Abilities used", "Abilities bought");
      needs_suffix = new boolean[stats_names.size()];
      
                                //ALL OK
    }
  }
  
  void init(){
    stats_numbers = new IntDict();
    for(String stat_name : stats_names){
      stats_numbers.set(stat_name, 0);
    }
  }
  
  void increment_stat(String stat_name){
    stats_numbers.increment(stat_name);
  }
  void increment_stat(int number, String stat_name){
    stats_numbers.set(stat_name, stats_numbers.get(stat_name) + number);
  }
  
  void display(){
    for(int i=0; i<stats_names.size(); i++){
      text(stats_names.get(i) + " : " + str(stats_numbers.get(stats_names.get(i))) + ( needs_suffix[i] ? " times":""), width/2, (i+1)*10);
    }
  }
  
  void load(String line){
    line = line.substring(line.indexOf(";")+1, line.length());
    int sep, number;
    for(String stat_name : stats_names){
      sep = line.indexOf(";");
      if(sep==-1){
        println("NOT GOOD : stats have been changed");
        return;
      }
      number = int(line.substring(0, sep));
      line = line.substring(sep+1, line.length());
      stats_numbers.set(stat_name, number);
    }
  }
  
  String get_save_string(){
    String line = name+";";
    for(String stat_name : stats_names){
      line+=str(stats_numbers.get(stat_name))+";";
    }
    return line;
  }

}