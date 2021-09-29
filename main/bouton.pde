class Button{

  static final byte CASE_MASK = 1 << 5; // 0b00100000
  
  float top_left_x;
  float top_left_y;
  float bottom_right_x;
  float bottom_right_y;
  String text;
  String descr;
  
  boolean selected=false;
  
  boolean enfonce=false;
  
  boolean unclickable=false;
  color unclickable_color = color(144);
  
  boolean show_descr_above=true;
  char shortcut_key;
  
  Button(float top_left_x, float top_left_y, float bottom_right_x, float bottom_right_y, String text, char shortcut_key){
    this.top_left_x=top_left_x;
    this.top_left_y=top_left_y;
    this.bottom_right_x=bottom_right_x;
    this.bottom_right_y=bottom_right_y;
    this.text=text;
    this.shortcut_key = uppercase(shortcut_key);
  } 
  
  void show(){
       
    
    
    if(unclickable){
      fill(unclickable_color);
    }
    else{
      noFill();
    }
    stroke(0);
    strokeWeight(1);
    rect(top_left_x, top_left_y, bottom_right_x, bottom_right_y);
    
    if(enfonce){
      rect(top_left_x+1, top_left_y+1, bottom_right_x-1, bottom_right_y-1);
    }
    
    if(selected){
      stroke(255, 0, 0);
      rect(top_left_x-1, top_left_y-1, bottom_right_x+1, bottom_right_y+1);      
    }
    
    
    fill(0);
    if(text!=""){
      textAlign(CENTER, CENTER); // centre le texte horizontalement et verticalement
      text(text, top_left_x, top_left_y, bottom_right_x, bottom_right_y);
    }
    
    if(mouse_on_button() && descr != null){
      if(show_descr_above){     //cela sera le cas pour les boutons de l'info panel (upgrades)
        fill(255);
        rect(top_left_x, top_left_y-100, bottom_right_x, top_left_y);
        fill(0);
        textAlign(CENTER, CENTER); // centre le texte horizontalement et verticalement
        text(descr, top_left_x, top_left_y-100, bottom_right_x, top_left_y);
      }
      else{     //cela sera le cas pour les boutons de l'achat panel
        fill(255);
        rect(top_left_x-100, top_left_y, top_left_x, bottom_right_y);
        fill(0);
        textAlign(CENTER, CENTER); // centre le texte horizontalement et verticalement
        text(descr, top_left_x-100, top_left_y, top_left_x, bottom_right_y);
      
      }
    }
  }
  
  
  boolean is_cliqued(){
    //return true uniquement si on vient de le cliquer a cette frame (pas enfoncé)
    if(enfonce){
      if( !(mouse_on_button() && mousePressed && mouseButton==LEFT) && !(keyPressed && uppercase(key) == shortcut_key))    enfonce=false;
      return false;
    }
    if(unclickable)  return false;
    if(mousePressed && mouseButton==LEFT && mouse_on_button() || keyPressed && uppercase(key) == shortcut_key ){
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
  
