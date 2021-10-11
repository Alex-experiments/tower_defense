class Button{

  static final byte CASE_MASK = 1 << 5; // 0b00100000
  
  float top_left_x, top_left_y, bottom_right_x, bottom_right_y;
  String text, descr;
  
  boolean selected=false, enfonce=false, unclickable=false;
  color couleur = color(255, 255, 255, 180), unclickable_color = color(250, 144, 144, 200), selected_color = color(0);//color(255, 0, 0);
  
  boolean show_descr_above=true;
  float width_descr;
  char shortcut_key;
  boolean use_shortcut_key = true;
  
  PImage associated_image;
  int[] pos_aff;    //sert seulement pour les ability
  
  Tower associated_tower;
  
  Button(float top_left_x, float top_left_y, float bottom_right_x, float bottom_right_y, String text, char shortcut_key){
    this.top_left_x=top_left_x;
    this.top_left_y=top_left_y;
    this.bottom_right_x=bottom_right_x;
    this.bottom_right_y=bottom_right_y;
    this.text=text;
    this.shortcut_key = uppercase(shortcut_key);
    
    width_descr = bottom_right_x - top_left_x;
  } 
  
  void update_pos(float top_left_x, float top_left_y, float w, float h){
    this.top_left_x=top_left_x;
    this.top_left_y=top_left_y;
    this.bottom_right_x=top_left_x+w;
    this.bottom_right_y=top_left_y+h;
  }
  
  void show(){    
    if(unclickable)  fill(unclickable_color);
    else  fill(couleur);

    stroke(0);
    if(mouse_on_button())  strokeWeight(2);
    else strokeWeight(1);
    rect(top_left_x, top_left_y, bottom_right_x, bottom_right_y);
    strokeWeight(1);
    
    
    if(enfonce)  rect(top_left_x+1, top_left_y+1, bottom_right_x-1, bottom_right_y-1);
    
    if(selected){
      stroke(selected_color);
      rect(top_left_x-1, top_left_y-1, bottom_right_x+1, bottom_right_y+1);        //en plus avec le fill() un peu transparent ca va le faire ressortir
    }   
    
    fill(0);
    if(!text.equals("")){
      textAlign(CENTER, CENTER); // centre le texte horizontalement et verticalement
      text(text, top_left_x, top_left_y, bottom_right_x, bottom_right_y);
    }
    
    if(mouse_on_button() && descr != null){
      textAlign(CENTER, CENTER); // centre le texte horizontalement et verticalement
      if(show_descr_above){     //cela sera le cas pour les boutons de l'info panel (upgrades)
        float x1 = max(0, (top_left_x+bottom_right_x-width_descr)/2);      //on veut que ca sorte pas d'au dessus de l'info panel
        if(x1 + width_descr > tower_panel.top_left_x)   x1 = tower_panel.top_left_x-width_descr-5;  //laisser comme ca pour avoir une marge de 5px
        float y1 = min(top_left_y-110, 545);
        fill(0, 0, 0, 200);
        rect(x1, y1, x1+width_descr, y1+100, 5, 5, 5, 5);
        fill(255);
        text(descr, x1, y1, x1+width_descr, y1+100);
      }
      else{     //cela sera le cas pour les boutons du tower panel
        fill(255);
        rect(top_left_x-100, top_left_y, top_left_x, bottom_right_y, 5, 5, 5, 5);
        fill(0);
        text(descr, top_left_x-100, top_left_y, top_left_x, bottom_right_y);
      }
    }
    if(associated_tower != null){
      associated_tower.show();
    }
    
  }
  
  void show_as_tab(color color_1, color color_2){
    
    if(!selected){
      fill(color_1);
      rect(top_left_x, top_left_y, bottom_right_x, bottom_right_y);
      fill(0);
      if(!text.equals("")){
        textAlign(CENTER, CENTER); // centre le texte horizontalement et verticalement
        text(text, top_left_x, top_left_y, bottom_right_x, bottom_right_y);
      }
    }
    else{
      fill(color_2);
      rect(top_left_x, top_left_y, bottom_right_x, bottom_right_y);
      fill(255);
      if(!text.equals("")){
        textAlign(CENTER, CENTER); // centre le texte horizontalement et verticalement
        text(text, top_left_x, top_left_y, bottom_right_x, bottom_right_y);
      }
    }
    
  }
  
  void show_associated_image(){
    image(associated_image, (top_left_x + bottom_right_x)/2, (top_left_y + bottom_right_y)/2);
    //unclickable
    return;
  }
  void show_associated_image(float scale){
    image(associated_image, (top_left_x + bottom_right_x)/2, (top_left_y + bottom_right_y)/2, associated_image.width*scale, associated_image.height*scale);
    //unclickable
    return;
  }
  void show_image_from_pos_aff(float scale){
    image(all_sprites, (top_left_x + bottom_right_x)/2, (top_left_y + bottom_right_y)/2, pos_aff[2]*scale, pos_aff[3]*scale, pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
  }
  
  void show_ability(float scale){
    show();
    image(ability_sprites, (top_left_x + bottom_right_x)/2, (top_left_y + bottom_right_y)/2, pos_aff[2]*scale, pos_aff[3]*scale, pos_aff[0], pos_aff[1], pos_aff[0]+pos_aff[2], pos_aff[1]+pos_aff[3]);
  }
  
  void show_cooldown(float time_left, float total_cd){
    float ratio = time_left/total_cd;
    stroke(0);
    fill(unclickable_color);
    beginShape();
    vertex((top_left_x+bottom_right_x)/2, top_left_y);
    vertex((top_left_x+bottom_right_x)/2, (top_left_y+bottom_right_y)/2);
    if(ratio>0.875){
      vertex((top_left_x+bottom_right_x)/2 + (bottom_right_x-top_left_x)/2 * (total_cd - time_left)/(total_cd/8), top_left_y);
      vertex(bottom_right_x, top_left_y);
      vertex(bottom_right_x, bottom_right_y);
      vertex(top_left_x, bottom_right_y);
      vertex(top_left_x, top_left_y);
    }
    else if(ratio > .625){
      vertex(bottom_right_x, top_left_y + (.875*total_cd - time_left)/(total_cd/4) * (bottom_right_y - top_left_y));
      vertex(bottom_right_x, bottom_right_y);
      vertex(top_left_x, bottom_right_y);
      vertex(top_left_x, top_left_y);
    }
    else if(ratio > .375){
      vertex(bottom_right_x + (.625*total_cd - time_left)/(total_cd/4) * (top_left_x - bottom_right_x),  bottom_right_y);
      vertex(top_left_x, bottom_right_y);
      vertex(top_left_x, top_left_y);
    }
    else if(ratio > .125){
      vertex(top_left_x, bottom_right_y + (.375*total_cd - time_left)/(total_cd/4) * (top_left_y - bottom_right_y));
      vertex(top_left_x, top_left_y);
    }
    else  vertex(top_left_x + (.125*total_cd - time_left)/(total_cd/8) * (bottom_right_x -top_left_x)/2, top_left_y);
    endShape(CLOSE);
    
  }
  
  
  boolean is_cliqued(){
    //return true uniquement si on vient de le cliquer a cette frame (pas enfoncé)
    if(enfonce){
      if( !(mouse_on_button() && mousePressed && mouseButton==LEFT) && !(use_shortcut_key  && keyPressed && uppercase(key) == shortcut_key))    enfonce=false;
      return false;
    }
    if(unclickable)  return false;
    if(mousePressed && mouseButton==LEFT && mouse_on_button() || use_shortcut_key && keyPressed && uppercase(key) == shortcut_key ){
      enfonce=true;
      return true;
    }
    return false;
  }
  
  boolean mouse_on_button(){
    return mouseX>=top_left_x && mouseX<=bottom_right_x && mouseY>=top_left_y && mouseY<=bottom_right_y;
  }
  
  char uppercase(char c){
    if(c>'z' || c < 'a')  return c;
    return char(c & ~ CASE_MASK);
  }
}
  
