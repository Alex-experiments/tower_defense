class Map{  
  float longueur_map;
  int map_size_x, map_size_y;
  float epaisseur=20;
  
  String[] directions;
  int[] longueurs;
  ArrayList<Cercle> liste_cercles = new ArrayList<Cercle>();
  float x_depart;
  float y_depart;
  
  ArrayList<float[]> pos_extremales;
  ArrayList<float[]> hidden_rect = new ArrayList<float[]>();
  ArrayList<float[]> spike_storm_pos = new ArrayList<float[]>(); 
  
  int map_number;
  

  Map(int map_number){
    
    this.map_number=map_number;

    load_map();
    FloatList coords_x=new FloatList();    //on stocke la hauteur/largeur max du parcours a chaque nouvelle direction
    FloatList coords_y=new FloatList();
    coords_x.append(x_depart);
    coords_y.append(y_depart);
    
    longueur_map=0;
    
    int compteur_nb_cercle=0;
    
    for(int i=0; i<directions.length; i++){
      if(directions[i]=="droite")  coords_x.append(coords_x.get(coords_x.size()-1)+longueurs[i]);      //on est obligé d'utiliser size() car on ajoute un element a coords_x que lorsqu'on va a droite ou a gauche
      if(directions[i]=="gauche")  coords_x.append(coords_x.get(coords_x.size()-1)-longueurs[i]);
      if(directions[i]=="bas")     coords_y.append(coords_y.get(coords_y.size()-1)+longueurs[i]);
      if(directions[i]=="haut")    coords_y.append(coords_y.get(coords_y.size()-1)-longueurs[i]);
      
      
      if(directions[i]=="cercle"){
        longueur_map+=liste_cercles.get(compteur_nb_cercle).longueur();
        compteur_nb_cercle++;
      }
      else{
        longueur_map+=longueurs[i];
      }
    }
    
    map_size_x=int(coords_x.max());      
    map_size_y=int(coords_y.max());
    
    init_pos_extremales();
    set_spike_storm_pos();
  }
  
  void set_spike_storm_pos(){
    //prends pas encore en compte les hiddens portions
    for(int i=0; i<200; i++){
      spike_storm_pos.add(get_pos(i * longueur_map/200.));
    }
  }
  
  void load_map(){
    //Pour un cercle, mettre direction à "cercle" et le créer dans la liste_cercles
    
    switch (map_number){
      case 0 : 
        directions=new String[] {"bas", "droite", "haut", "gauche", "bas", "droite"};    //plus compact
        longueurs=new int[] {100, 50, 75, 25, 50, 50};
        for(int i=0; i<longueurs.length; i++)  longueurs[i]*=6;
        x_depart=30;
        y_depart=0;
        break;
        
      case 1:
        directions = new String[] {"droite", "haut", "droite", "bas", "droite", "haut", "gauche", "haut", "droite", "bas", "droite", "bas", "gauche", "bas", "gauche", "bas"};
        longueurs = new int[] {    215,       100,     140,     330,   210,     420,     350,       100,    455,     100,     130,     110,     130,   190,   460,       160};
        x_depart=0;
        y_depart=380;
        break;
      
      case 2:
        directions = new String[] {"bas",  "cercle",  "cercle", "cercle", "cercle", "cercle", "cercle", "cercle", "droite"};
        longueurs = new int[] {    90,         0,           0,         0,     0,       0,        0,        0,        332};
        x_depart=725;
        y_depart=0;
        
        
        liste_cercles.add(new Cercle(655, 90, 70, 0, 3.9371738, "horaire"));
        liste_cercles.add(new Cercle(412, 338, 277.20743, 0.79558116, -0.7760527, "trigo"));
        liste_cercles.add(new Cercle(574, 497, 50.216232, -0.7760527, 2.36554, "trigo"));
        liste_cercles.add(new Cercle(412, 338, 176.77496, -0.7760527, 1.5270287, "horaire"));
        liste_cercles.add(new Cercle(418, 201, 39.643646, 1.5270287, 4.6686215, "horaire"));
        liste_cercles.add(new Cercle(412, 338, 97.48767, 1.5270287, 5.931965, "trigo"));
        liste_cercles.add(new Cercle(543, 386, 42.029358, 2.790372, PI/2, "horaire"));
        
        //hidden_rect.add(new float[]{700, 10, 750, 80});
        
        break;
      
      case 3:
        directions = new String[]{"droite", "haut", "droite", "bas", "gauche", "haut", "gauche", "bas", "droite", "haut", "droite", "bas", "gauche", "haut", "gauche"};
        longueurs = new int[] {    120,       215,     640,    165,     20,      145,    600,     410,     600,     145,    20,      165,    640,     215,     120};
        x_depart=0;
        y_depart=320;
        break;
        
      
      default :
        println("NO MAP NUMBER SPECIFIED");
        break;
    }
  }
  
  float [] get_pos(float t){      //t est l'avancement de la map
    float longueur_cumulee=0;
    float x=x_depart;
    float y=y_depart;
    
    int compteur_nb_cercle=0;
    
    for(int i=0; i<directions.length; i++){
      String dir=directions[i];
      float len=longueurs[i];
      if(dir=="cercle"){
        len=liste_cercles.get(compteur_nb_cercle).longueur();
        
      }
      
      
      if(t<=longueur_cumulee+len){
        if(dir=="bas")     return new float[] {x, y+t-longueur_cumulee};
        if(dir=="haut")    return new float[] {x, y-t+longueur_cumulee};
        if(dir=="droite")  return new float[] {x+t-longueur_cumulee, y};
        if(dir=="gauche")  return new float[] {x-t+longueur_cumulee, y};
        if(dir=="cercle")  return liste_cercles.get(compteur_nb_cercle).get_pos(t-longueur_cumulee);
      }
      if(dir=="bas")     y+=len;
      if(dir=="haut")    y-=len;
      if(dir=="droite")  x+=len;
      if(dir=="gauche")  x-=len;
      if(dir=="cercle"){
        Cercle temp = liste_cercles.get(compteur_nb_cercle);
        float[] pos_finale = temp.get_pos(len);
        x=pos_finale[0];
        y=pos_finale[1];
        compteur_nb_cercle++;
      }
      
      longueur_cumulee+=len;
    }
    return new float[] {0, 0};    //cela n'arrivera jamais c'est juste pour ne pas avoir d'erreur (fonction float[])
  }
  
  void show(){
    stroke(155, 155, 155);
    strokeWeight(epaisseur);
    noFill();
    if(map_number==3)  strokeCap(PROJECT);
    
    int compteur_nb_cercle = 0;
    
    for(int i=0; i<pos_extremales.size()-1; i++){
      if(directions[i]=="cercle"){
        Cercle temp=liste_cercles.get(compteur_nb_cercle);
        
        float angle_dep = temp.angle_dep;    //arc trace dans le sens horaire avec des angles qui sont les opposés des miens
        float angle_fin = temp.angle_fin;    //et il ne veut pas tracer un arc de PI à PI/2 -> il faut faire de PI à 3*PI/2
        if(temp.sens=="trigo"){
          angle_dep = temp.angle_fin;
          angle_fin = temp.angle_dep;
        }
        if(-angle_dep>-angle_fin)  angle_fin-=2*PI;
        arc(temp.centre_x, temp.centre_y, 2*temp.radius, 2*temp.radius, -angle_dep, -angle_fin);
        compteur_nb_cercle++;
      }
      else{
        float[] pos1=pos_extremales.get(i);
        float[] pos2=pos_extremales.get(i+1);
        line(pos1[0], pos1[1], pos2[0], pos2[1]);
      }
    }
  }
  
  void hide(){
    fill(255);
    noStroke();
    for(float[] rect : hidden_rect){
      rect(rect[0], rect[1], rect[2], rect[3]);
    }
  }
  
  boolean is_hidden(float x, float y, float rayon_collision){
    for(float[] rect : hidden_rect){
      if(x-rayon_collision>=rect[0] && x+rayon_collision<=rect[2] && y-rayon_collision>=rect[1] && y+rayon_collision<=rect[3])  return true;
    }
    return false;
  }
  
  void init_pos_extremales(){
    pos_extremales = new ArrayList<float[]>();    //a def avant
    
    float x=x_depart;
    float y=y_depart;
    
    pos_extremales.add(new float[] {x, y});
    
    int compteur_nb_cercle = 0;
    
    for(int i=0; i<directions.length; i++){
      String dir=directions[i];
      float len=longueurs[i];
      if(dir=="bas")     y+=len;
      if(dir=="haut")    y-=len;
      if(dir=="droite")  x+=len;
      if(dir=="gauche")  x-=len;
      
      if(dir=="cercle"){
        Cercle temp = liste_cercles.get(compteur_nb_cercle);
        float[] pos_finale = temp.get_pos(temp.longueur());
        x=pos_finale[0];
        y=pos_finale[1];
        compteur_nb_cercle++;
      }
      
      pos_extremales.add(new float[] {x, y});
      
    }
  }

  boolean is_on_track(float x, float y, float size){
    
    if(is_hidden(x, y, size/2))  return false;    //elle est sur une partie cachée
  
    int compteur_nb_cercle = 0;
     
    for(int i=0; i<pos_extremales.size()-1; i++){        //on regarde si on est pas sur le chemin
    
      if(directions[i] != "cercle"){            //le chemin à cet endroit la est une droite
        myLine.x1=pos_extremales.get(i)[0];
        myLine.y1=pos_extremales.get(i)[1];
        myLine.x2=pos_extremales.get(i+1)[0];
        myLine.y2=pos_extremales.get(i+1)[1];
        
        if( myLine.getDistance(x, y).z < (epaisseur+size)/2 ){
          return true;
        }
            
      }
      else{    //le chemin à cet endroit la est un arc de cercle
        //Pour calculer la distance à un arc de cercle : on regarde la distance au cercle si on est dans le bon angle
        //sinon on calcule la distance aux deux points extremaux
        Cercle temp = liste_cercles.get(compteur_nb_cercle);
        if( abs( distance(new float[] {x, y}, new float[] {temp.centre_x, temp.centre_y}) - temp.radius ) < (epaisseur+size)/2 ){ //on est dans le cas ou on est trop proche du cercle complet : il va falloir étudier l'angle
          float angle = -atan2(y-temp.centre_y, x-temp.centre_x);  //compris entre -PI et PI
          
          float angle_debut = temp.angle_dep;
          float angle_fin = temp.angle_fin;          
          
          //ici on vérifie si on est strictement dans l'arc de cercle
          if(angle_debut>angle_fin){
            if(temp.sens=="horaire" && angle_fin<=angle && angle<=angle_debut)    return true;
            if(temp.sens=="trigo" && (angle>=angle_debut || angle<=angle_fin))    return true;
          }
          else{
            if(temp.sens=="trigo" && angle_debut<=angle && angle<=angle_fin)      return true;
            if(temp.sens=="horaire" && (angle>=angle_fin || angle<=angle_debut))  return true;
          }
          
          //mais il reste encore à vérifier si l'on est pas juste a coté de l'arc de cercle et cela se vérifie va la distance aux points extremaux
          if(distance(new float[] {x, y}, pos_extremales.get(i)) < (epaisseur+size)/2)  return true;
          if(distance(new float[] {x, y}, pos_extremales.get(i+1)) < (epaisseur+size)/2)  return true;
        }
          
        
        compteur_nb_cercle++; 
      }
    }
   return false;    //aucune collision avec le chemin n'a été détecté
 }
 
 
}
