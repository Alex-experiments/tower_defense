class Animator{
  ArrayList<int[]> sprites_pos;
  int frames_per_sprite, frame_count = 0, nb_sprites;
  boolean on_attack_trigger = false, only_when_resting = false, just_ended = false, is_longest_shooting_anim=false;
  
  //boolean enfonce = false;    //TO CHECK ANIMS
  
  Animator(String sprite_name, int frames_per_sprite){
    this.frames_per_sprite = frames_per_sprite;
    
    StringList all_names = new StringList(sprite_name);
    int i=2;
    while(pos_coins_sprites.containsKey(sprite_name+"_"+str(i))){
      all_names.append(sprite_name+"_"+str(i));
      i++;
    }
    if(pos_coins_sprites.containsKey(sprite_name+" shooting")){
      on_attack_trigger = true;
      all_names.append(sprite_name+" shooting");
      i=2;
      while(pos_coins_sprites.containsKey(sprite_name+" shooting_"+str(i))){
        all_names.append(sprite_name+" shooting_"+str(i));
        i++;
      }
    }
    else if(sprite_name.indexOf("resting")>-1)  only_when_resting = true;
    
    sprites_pos = get_sprites_pos(all_names);
    nb_sprites = sprites_pos.size();
    //println(sprite_name, nb_sprites);
  }
  
  int[] get_pos(){
    return sprites_pos.get(int(frame_count/frames_per_sprite));
  }
  
  int get_largest_dx(){
    int temp = 0;
    for(int[] pos : sprites_pos){
      if(pos[2]>temp)  temp = pos[2];
    }
    return temp;
  }
  
  void update(boolean attack_trigger){
    /*if(nb_sprites>1)  println(int(frame_count/frames_per_sprite));    //TO CHECK ANIMS  
    if(keyPressed && key == CODED){
      if(enfonce)  return;
      enfonce = true;
      if(keyCode == LEFT){
        frame_count-= frames_per_sprite;
        if(frame_count < 0)  frame_count = frames_per_sprite*(nb_sprites-1);
      }
      if(keyCode == RIGHT){
        frame_count+=frames_per_sprite;
        if(frame_count >= frames_per_sprite*nb_sprites)  frame_count = 0;
      }
      
    }
    else enfonce = false;
    if(true)  return;*/
    
    just_ended = false;
    if(nb_sprites == 1 || frame_count == 0 && !attack_trigger && on_attack_trigger)  return;
    if(on_attack_trigger && attack_trigger)  frame_count = 0;    //on reset l'anim
    frame_count += joueur.game_speed;
    if(frame_count >= nb_sprites * frames_per_sprite){
      frame_count = 0;
      just_ended = true;
    }
  }
 
}
