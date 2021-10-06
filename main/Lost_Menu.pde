PVector gravity=new PVector(0, .1);


class Lost_menu extends Menu_pancarte{
  
  int menu_offset_x = 40, menu_offset_y = 110, menu_w = 91, menu_h = 88, replay_offset_x=175, replay_offset_y=110, replay_w = 91, replay_h = 88;
  
  Button menu, replay;
  float x, y, w, h;
  PImage bg, panneau = loadImage("wooden sign avec attaches metal.png");
  
  boolean freeze = false, active = true, choice_made=false, go_to_menu = false, go_replay = false, transition = false;
  
  Point top_left;
  
  Lost_menu(int round_number){
    super(1, 348, -350, 200, 304, 150);
    h=150;
    w = 305;
    top_left = links.get(ropes_extremity_links.get(1)).ptA;
    x = top_left.pos.x; y = top_left.pos.y;
    menu   = new Button(x + menu_offset_x,   y + menu_offset_y,   x + menu_offset_x + menu_w,     y + menu_offset_y + menu_h,     "", 'M');
    menu.associated_image = loadImage("menu button.png");
    replay = new Button(x + replay_offset_x, y + replay_offset_y, x + replay_offset_x + replay_w, y + replay_offset_y + replay_h, "", 'R');
    replay.associated_image = loadImage("replay button.png");
  }
  
  void core(){
    background(bg);
    if(!choice_made){
      if(!freeze){
        for(int i = 0; i<5; i++)  update();
        freeze = PVector.sub(top_left.pos, top_left.prev_pos).mag()<.004;
      }
      //else println("freeze");
    }
    else for(int i = 0; i<3; i++) update();
    top_left = links.get(ropes_extremity_links.get(1)).ptA;
    x = top_left.pos.x; y = top_left.pos.y;
    update_pos_boutons();
    if(!choice_made) interact();
    image(panneau, x+5+w/2, y+32+h/2);
    show();
    show_chain();
  }
  
  void interact(){
    if(menu.is_cliqued()){
      choice_made = true;
      go_to_menu = true;
      gravity = new PVector(random(-.1, .1), -.1);
      return;
    }
    if(replay.is_cliqued()){
      choice_made = true;
      go_replay = true;
      gravity = new PVector(random(-.1, .1), -.1);
      return;
    }
  }
  
  boolean transition_ended(){
    return y+h<0;
  }
  boolean ended(){
    return choice_made && transition_ended();
  }
  
  void update_pos_boutons(){
    menu.update_pos(x + menu_offset_x,   y + menu_offset_y, menu_w, menu_h);
    replay.update_pos(x + replay_offset_x, y + replay_offset_y, replay_w, replay_h);
  }
  
  void show(){
    /*strokeWeight(1);
    stroke(255);
    for(Link zelda : links){
      zelda.show();
    }*/
    menu.show();
    replay.show();
  }
}

class Menu_pancarte{
  ArrayList<Point> points = new ArrayList<Point>();
  ArrayList<Link> links = new ArrayList<Link>();
  
  IntList ropes_extremity_links = new IntList();
  
  int max_iter=50;
  IntList order;
  
  ArrayList<Point> buttons_top_left_corner = new ArrayList<Point>();
  
  PImage maillon_face = loadImage("chainon metal face.png"), maillon_side = loadImage("chainon metal side.png");
  
  Menu_pancarte(int nb_box, float x, float y, float distance_inter_box, int width_box, int height_box){
    create_pancarte(nb_box, x, y, distance_inter_box, width_box, height_box);
  }
  
  void update(){
    for(Point pt : points){
      if(!pt.locked)  pt.update();
    }
  
    order = IntList.fromRange(links.size());
    for(int iter=0; iter<max_iter; iter++){ 
      order.shuffle();
      for(int i : order)   links.get(i).update();
    }
  }

  void create_pancarte(int nb_box, float x, float y, float distance_inter_box, int width_box, int height_box){ 
    
    float angle_offset = random(QUARTER_PI, HALF_PI);
    if(random(0., 1.)<.5)  angle_offset*=-1;
        
    for(int i=0; i<nb_box; i++){
      float x2 = x + distance_inter_box*cos(angle_offset + HALF_PI);
      float y2 = y + distance_inter_box*sin(angle_offset + HALF_PI);
      
      create_rope(600, x, y, x2, y2, i==0);
      create_rope(600, x+width_box, y, x2+width_box, y2, i==0);
      
      x = x2;
      y = y2 + height_box;
      if(random(0., 1.)<.5)  angle_offset*=-1;
    }
    for(int i = 0; i<nb_box-1; i++)    add_new_box(ropes_extremity_links.get(1 + 4*i), ropes_extremity_links.get(3 + 4*i), ropes_extremity_links.get(4*(i+1)), ropes_extremity_links.get(2 + 4*(i+1)));
    add_new_box(ropes_extremity_links.get(1 + 4*(nb_box-1)), ropes_extremity_links.get(3 + 4*(nb_box-1)), -width_box, -height_box);
  } 
  
  void create_rope(int nb_points, float x1, float y1, float x2, float y2, boolean lock_first){
    PVector pos = new PVector(x1, y1), delta = new PVector((x2-x1)/nb_points, (y2-y1)/nb_points);
    int n = points.size();
    int temp = links.size();
    
    for(int i = 0; i<nb_points; i++){
      points.add(new Point(pos.copy()));
      pos.add(delta);
      if(i>0)  links.add(new Link(points.get(n - 1 +i), points.get(n + i)));
      else if(lock_first)  points.get(n).locked = true;
    }
    ropes_extremity_links.append(temp);
    ropes_extremity_links.append(links.size()-1);
  }
  
  void add_new_box(int index_top_left, int index_top_right, int index_bot_left, int index_bot_right){
    
    Point top_left = links.get(index_top_left).ptB, top_right = links.get(index_top_right).ptB, bot_left, bot_right;
    
    if(index_bot_left<0 || index_bot_right<0){  //if that's the last box, pass -width_box and -height_box instead
      float x = top_left.pos.x, y = top_left.pos.y;
      bot_left = new Point(new PVector(x, y-index_bot_right));
      points.add(bot_left);
      bot_right = new Point(new PVector(x-index_bot_left, y-index_bot_right));
      points.add(bot_right);
    } 
    else{
      bot_left = links.get(index_bot_left).ptA;
      bot_right = links.get(index_bot_right).ptA;
    }
    
    links.add(new Link(top_left, top_right));
    links.add(new Link(top_left, bot_left));
    links.add(new Link(top_left, bot_right));
    links.add(new Link(top_right, bot_left));
    links.add(new Link(top_right, bot_right));
    links.add(new Link(bot_left, bot_right));
  }
  
  void show_chain(){
    ArrayList<PVector> side_middles = new ArrayList<PVector>();    //comme les side maillons sont à afficher par dessus les autres il faut les afficher en dernier
    FloatList side_orientations = new FloatList();  
    for(int i = 0; i < ropes_extremity_links.size(); i+=2){
      PVector pos1 = links.get(ropes_extremity_links.get(i+1)).ptB.pos;
      boolean show_side = true;
      for(int index = ropes_extremity_links.get(i+1); index >= ropes_extremity_links.get(i); index--){    //on les affiche en partant du bas
        PVector pos2 = links.get(index).ptA.pos.copy();
        if(PVector.sub(pos2, pos1).mag()<20)  continue;
        pos2 = PVector.add(pos1, PVector.sub(pos2, pos1).setMag(20));    //ca permet d'éviter des oscillations
        PVector middle = PVector.add(pos2, pos1).div(2);
        float orientation = PVector.sub(pos2, pos1).heading();
        if(show_side){
          side_middles.add(middle);
          side_orientations.append(orientation);
          show_side = false;
          pos1 = pos2;
          continue;
        }
        pushMatrix();
        translate(middle.x, middle.y);
        rotate(orientation+HALF_PI);
        image(maillon_face, 0, 0);
        show_side = true;
        popMatrix();
        pos1 = pos2.copy();
      }
    }
    
    for(int i = 0; i<side_middles.size(); i++){
      PVector middle = side_middles.get(i);
      float orientation = side_orientations.get(i);
      pushMatrix();
        translate(middle.x, middle.y);
        rotate(orientation+HALF_PI);
        image(maillon_side, 0, 0);
        popMatrix();
    }
    
  }
  
}


class Link{
  Point ptA, ptB;
  float len;
  
  boolean teared = false;
  
  Link(Point ptA, Point ptB){
    this.ptA = ptA;
    this.ptB = ptB;
    this.len = PVector.sub(ptA.pos, ptB.pos).mag();
  }


  void update(){
    PVector middle = PVector.add(this.ptA.pos, this.ptB.pos).div(2);
    PVector dir = PVector.sub(this.ptA.pos, this.ptB.pos);
    
    dir.setMag(this.len/2);
    
    if(!this.ptA.locked)  PVector.add(middle, dir, this.ptA.pos);   //ptA =  middle + len/2 * dir
    if(!this.ptB.locked)  PVector.sub(middle, dir, this.ptB.pos);
        
  }
  
  void show(){
    line(this.ptA.pos.x, this.ptA.pos.y, this.ptB.pos.x, this.ptB.pos.y);
  }
}


class Point{
  PVector pos, prev_pos;
  boolean locked=false;
  
  Point(PVector pos){
    this.pos=pos;
    this.prev_pos = pos.copy();
  }
  
  void update(){
    PVector speed = PVector.sub(this.pos, this.prev_pos).mult(.995);      //facteur de friction
    this.prev_pos = this.pos.copy();
    this.pos.add(speed).add(gravity);
  }
}
