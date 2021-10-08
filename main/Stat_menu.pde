class Stat_menu{

  Button overview_tab, bloons_tab, towers_tab, abilities_tab;
  ArrayList<Button> tabs = new ArrayList<Button>();
  static final int NB_TABS = 4, TABS_SPACING = 0;
  
  float x1, y1, x2, y2;
  
  boolean active = false;
  
  PImage screen;
  
  Tower_panel intern_tower_panel;
  
  Stat_menu(float x1, float y1, float x2, float y2){
    this.x1=x1;
    this.y1=y1;
    this.x2=x2;
    this.y2=y2;
    
    //screen = get();
        
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
    
    intern_tower_panel = new Tower_panel(x1 + 700, y1+250-84, x1+825, y2, true);
    
    bloons_tab.couleur = color(0, 0, 0, 50);
    
  }
  
  void core(){
    interact();
    show();
  }
  
  
  
  void show(){
    background(screen);
    //image(fond, (x1+x2)/2, (y1+y2)/2);
    //background(255);
    
    noStroke();
    fill(255, 255, 255, 180);
    rect(x1, y1, x2, y1+150, 25, 25, 0, 0);
    fill(0, 0, 0, 220);
    rect(x1, y1+200, x2, y2, 0, 0, 25, 25);

    
    
    textFont(font_32px);
    textAlign(CENTER, TOP);
    outline_text("STATISTIQUES", (x1+x2)/2, y1 + 40, color(255), color(0), 1);
    
    overview_tab.show_as_tab();
    bloons_tab.show_as_tab();
    towers_tab.show_as_tab();
    abilities_tab.show_as_tab();
    
    textFont(font_18px);
    textAlign(LEFT, TOP);
    
    if(overview_tab.selected){
      stat_manager.display("overview", x1 + 10, y1 + 300, 24);
    }
    else if(bloons_tab.selected){
      stat_manager.display("bloons", x1 + 10, y1 + 300, 24);
    }
    else if(towers_tab.selected){
      intern_tower_panel.show();
      stat_manager.display(intern_tower_panel.get_selected_tower_name(), x1+10, y1+300, 24);
      textAlign(CENTER, TOP);
      outline_text(intern_tower_panel.get_selected_tower_name().toUpperCase(), (x1+x2)/2, y1+250, color(0, 128, 0), color(255), 1);
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
    
  }

}
