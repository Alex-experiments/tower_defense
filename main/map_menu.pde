class Map_menu{
  float x1, y1, x2, y2;
  
  boolean active = false, existing_save = false;
  
  PImage screen;
  
  Map_panel map_panel;
  Button exit, load_game;

  final color couleur = color(255, 255, 255, 230);
  
  int map_chosen = -1;
  
  Map_menu(float x1, float y1, float x2, float y2){
    this.x1=x1;
    this.y1=y1;
    this.x2=x2;
    this.y2=y2;
  }
  
  void init(){
    active = true;
    map_chosen = -1;
    screen = get();
    
    map_panel = new Map_panel(x1 + 50, y1+50, x2-50, y2-150);
    
    exit = new Button(x2-40, y1 + 10, x2-10, y1+40, "", char(-1));
    exit.use_shortcut_key = false;
    exit.associated_image = loadImage("exit_icon.png");
    
    String[] lines = loadStrings("save.txt");
    if(lines != null){
      existing_save = true;
      load_game = new Button((x1+x2)/2 - 125, y2-75, (x1+x2)/2 + 125, y2-25, "", char(-1));
      load_game.use_shortcut_key = false;
      load_game.associated_image = loadImage("load_icon.png");
    }
    
    textFont(font_32px);
    textAlign(CENTER, TOP);
  }
  
  void core(){
    interact();
    if(existing_save && load_game.is_cliqued()){
      boolean success = game.init(true, "normal", 2);
      if(!success){
        println("GAME COULDN'T LOAD SAVE");
        load_game.unclickable = true;
      }
      else  active = false;
    }
    show();
    if(ended()){
      active = false;
      if(map_chosen>=0)  game.init(false, "normal", map_menu.map_chosen);
      else main_menu.init(); 
    }
  }

  void show(){
    background(screen);    
    noStroke();
    fill(couleur);
    rect(x1, y1, x2, y2, 25, 25, 25, 25);
    
    outline_text("TRACKS", (x1+x2)/2, y1 + 40, color(255), color(0), 1);
    
    exit.show_associated_image();
    if(existing_save){
      load_game.show();
      load_game.show_associated_image();
    }
    map_panel.show();    
  }
  
  void interact(){    
    String map = map_panel.get_map_cliqued();
    if(map!=null){
      map_chosen = int(map.substring(map.indexOf("_")+1, map.indexOf(".")));
    }
  }
  
  boolean ended(){
    return exit.is_cliqued() || map_chosen>-1;
  }

}

class Map_panel{
  
  ArrayList<Button> buttons;
  
  float top_left_x, top_left_y, bottom_right_x, bottom_right_y;
  static final int button_w = 350, button_h = 260;
  
  StringList map_names = new StringList("map_2.png", "map_3.png");
  
  Map_panel(float top_left_x, float top_left_y, float bottom_right_x, float bottom_right_y){
    this.top_left_x=top_left_x;
    this.top_left_y=top_left_y;
    this.bottom_right_x=bottom_right_x;
    this.bottom_right_y=bottom_right_y;
    instantiate_all_buttons();
  }
  
  void instantiate_all_buttons(){
    buttons = new ArrayList<Button>();
    for(int i=0; i<map_names.size(); i++){
      String map_name = map_names.get(i);
      Button new_button;
      if(i%2==0)  new_button = new Button(top_left_x,          top_left_y+94 + (button_h+1) * i/2,     top_left_x+button_w, top_left_y+94 + button_h + (button_h+1) * i/2, "", char(-1));
      else  new_button = new Button(bottom_right_x - button_w, top_left_y+94 + (button_h+1) * (i-1)/2, bottom_right_x,      top_left_y+94 + button_h + (button_h+1) * (i-1)/2, "", char(-1));
      
      new_button.associated_image = loadImage(map_name);
      new_button.use_shortcut_key = false;
       
      buttons.add(new_button);
    }    
  }

  String get_map_cliqued(){
    for(int i = 0; i<buttons.size(); i++){
      if(buttons.get(i).is_cliqued())  return map_names.get(i);
    }
    return null;
  }
  
  void show(){
    for(Button button : buttons)  button.show_associated_image(.4);
  }
  
}
