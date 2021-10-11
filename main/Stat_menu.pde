class Stat_menu{

  Button overview_tab, bloons_tab, towers_tab, abilities_tab, exit;
  ArrayList<Button> tabs = new ArrayList<Button>();
  static final int NB_TABS = 4, TABS_SPACING = 0;
  
  float x1, y1, x2, y2;
  
  boolean active = false;
  
  PImage screen;
  
  Tower_panel intern_tower_panel;
  Ability_panel intern_ability_panel;
  
  //color color_1 = color(32, 20, 7, 220);
  //color_1 = color(255, 255, 255, 220)
  final color color_1 = color(255, 255, 255, 230), color_2 = color(0, 0, 0, 220);
  
  Stat_menu(float x1, float y1, float x2, float y2){
    this.x1=x1;
    this.y1=y1;
    this.x2=x2;
    this.y2=y2;
  }
  
  void init(){
    active = true;
    screen = get();
    int tab_width = int(((x2-x1) - (NB_TABS-1) * TABS_SPACING )/NB_TABS);
    
    overview_tab = new Button(x1, y1 + 150, x1 + tab_width, y1 + 200, "Overview", 'O');
    overview_tab.selected = true;
    tabs.add(overview_tab);
    bloons_tab = new Button(x1+tab_width+TABS_SPACING, y1 + 150, x1 + 2*tab_width+TABS_SPACING, y1 + 200, "Bloons", 'B');
    tabs.add(bloons_tab);
    towers_tab = new Button(x1+2*(tab_width+TABS_SPACING), y1 + 150, x1 + 3*tab_width+2*TABS_SPACING, y1 + 200, "Towers", 'T');
    tabs.add(towers_tab);
    abilities_tab = new Button(x1+3*(tab_width+TABS_SPACING), y1 + 150, x1 + 4*tab_width+3*TABS_SPACING, y1 + 200, "Abilities", 'A');
    tabs.add(abilities_tab);
    
    intern_tower_panel = new Tower_panel(x1 + 800, y1+250-84, x1+925, y2, true);
    intern_ability_panel = new Ability_panel(x1 + 800, y1+250-84, x1+925, y2);
    
    exit = new Button(x2-40, y1 + 10, x2-10, y1+40, "", char(-1));
    exit.use_shortcut_key = false;
    exit.associated_image = loadImage("exit_icon.png");
    
  }
  
  void core(){
    interact();
    show();
    if(ended()){
      active=false;
      main_menu.init();
    }
  }
  
  
  
  void show(){
    background(screen);
    //image(fond, (x1+x2)/2, (y1+y2)/2);
    //background(255);
    
    noStroke();
    //fill(255, 255, 255, 180);
    fill(color_1);
    rect(x1, y1, x2, y1+150, 25, 25, 0, 0);
    //fill(0, 0, 0, 220);
    fill(color_2);
    rect(x1, y1+200, x2, y2, 0, 0, 25, 25);

    
    
    textFont(font_32px);
    textAlign(CENTER, TOP);
    outline_text("STATISTIQUES", (x1+x2)/2, y1 + 40, color(255), color(0), 1);
    
    exit.show_associated_image();
    
    overview_tab.show_as_tab(color_1, color_2);
    bloons_tab.show_as_tab(color_1, color_2);
    towers_tab.show_as_tab(color_1, color_2);
    abilities_tab.show_as_tab(color_1, color_2);
    
    textFont(font_18px);
    textAlign(LEFT, TOP);
    
    if(overview_tab.selected){
      stat_manager.display("overview", x1 + 10, y1 + 275, 24);
    }
    else if(bloons_tab.selected){
      stat_manager.display("bloons", x1 + 10, y1 + 275 - 24, 24);
    }
    else if(towers_tab.selected){
      intern_tower_panel.show();
      stat_manager.display(intern_tower_panel.get_selected_tower_name(), x1+10, y1+275, 24);
      textAlign(CENTER, TOP);
      outline_text(intern_tower_panel.get_selected_tower_name().toUpperCase(), (x1+x2)/2, y1+250, color(0, 128, 0), color(255), 1);
    }
    else if(abilities_tab.selected){
      intern_ability_panel.show();
      stat_manager.display(intern_ability_panel.get_selected_ability_name(), x1+10, y1+275, 24);
      textAlign(CENTER, TOP);
      outline_text(intern_ability_panel.get_selected_ability_name().toUpperCase(), (x1+x2)/2, y1+250, color(0, 128, 0), color(255), 1);
    }
    
  }
  
  void interact(){
    for(Button tab : tabs){
      if(tab.is_cliqued()){
        for(Button temp : tabs){
          temp.selected = temp == tab;
        }
      }
    }
    
    if(towers_tab.selected){
      intern_tower_panel.update_selection();
    }
    else if(abilities_tab.selected)  intern_ability_panel.update_selection();
  }
  
  boolean ended(){
    return exit.is_cliqued();
  }

}

class Ability_panel{
  
  ArrayList<Button> buttons;
  
  float top_left_x, top_left_y, bottom_right_x, bottom_right_y;
  
  Ability_panel(float top_left_x, float top_left_y, float bottom_right_x, float bottom_right_y){
    //on doit tj avoir bottom_right_x = top_left_x + 81
    this.top_left_x=top_left_x;
    this.top_left_y=top_left_y;
    this.bottom_right_x=bottom_right_x;
    this.bottom_right_y=bottom_right_y;
    instantiate_all_buttons();
  }
  
  void instantiate_all_buttons(){
    buttons = new ArrayList<Button>();
    for(int i=0; i<ability_names.size(); i++){
      String abi = ability_names.get(i);
      Button new_button;
      if(i%2==0)  new_button = new Button(top_left_x, top_left_y+94 + 63 * i/2, top_left_x+62, top_left_y+156 + 63 * int(i/2), "", char(-1));
      else  new_button = new Button(bottom_right_x - 62, top_left_y+94 + 63 * (i-1)/2, bottom_right_x, top_left_y+156 + 63 * int(i/2), "", char(-1));
      //if(i%2==0)  new_button = new Button(top_left_x, top_left_y+94 + 41 * i/2, top_left_x+40, top_left_y+134 + 41 * int(i/2), "", char(-1));
      //else  new_button = new Button(bottom_right_x - 40, top_left_y+94 + 41 * (i-1)/2, bottom_right_x, top_left_y+134 + 41 * int(i/2), "", char(-1));
      
      new_button.pos_aff = pos_coins_sprites.get(abi+" ability icon");
      new_button.couleur = color(255, 255, 255, 40);
      new_button.use_shortcut_key = false;
      
      if(i==0)  new_button.selected = true;
 
      buttons.add(new_button);
    }    
  }
  
  String get_selected_ability_name(){
    for(int i = 0; i<buttons.size(); i++){
      if(buttons.get(i).selected)  return ability_names.get(i);
    }
    return "NO ABILITY NAME FOUND : PROBLEM NO BUTTON SELECTED";
  }
  
  void update_selection(){
    for(Button button : buttons){
      if(button.is_cliqued()){
        for(Button temp : buttons) temp.selected = temp == button;
      }
    }
  }
  
  void show(){
    for(Button button : buttons)  button.show_ability(1.55);
  }
  
}
