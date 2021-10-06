class Boomerang extends Projectile{
 
  float angle_dep;
  int avancement=0;
  float centre_x, centre_y, rayon_cercle;
    
  
  Boomerang(Tower fired_from_tower, float centre_x, float centre_y, float rayon_cercle, String boomerang_type){
    super(fired_from_tower, 0, 0, 0, boomerang_type);    //init x, y et direction ne sert à r
    this.centre_x=centre_x;
    this.centre_y=centre_y;
    this.rayon_cercle=rayon_cercle;
    angle_dep = atan2(fired_from_tower.y - centre_y, fired_from_tower.x - centre_x); 
    
    x=fired_from_tower.x;  //sinon ca chie avec collision() car sachant que prev_x n'a pas de valeur par défault ca sera 0...
    y=fired_from_tower.y;
    rotate = true;
  }
  
  void core(int i, int nb_proj){
    deplacement();
    kill();
    if(!orbiting && (ended_circle() || pierce<=0)){
      projectiles.remove(i);
      return;
    }
    show();    //on show tj les boomerangs
    for(Animator anim : sprites)  anim.update(true);
  }
  
  boolean ended_circle(){
    if(orbiting){
      avancement %= 2*PI*rayon_cercle;    //un boomerang orbitant depuis des années pourrait dépasser la limite des floats
      return false;
    }
    return avancement/rayon_cercle>=2*PI;
  }
  
  void deplacement(){
    avancement += speed * joueur.game_speed;
    prev_x=x;
    prev_y=y;
    x = centre_x + rayon_cercle * cos(-avancement/rayon_cercle + angle_dep);
    y = centre_y + rayon_cercle * sin(-avancement/rayon_cercle + angle_dep);
  }
  

  void set_stats(){
    switch(projectile_type){
      case "basic boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 3;
        damage_type = "sharp";
        break;
      case "sonic boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 3;
        damage_type = "shatter";
        break;
      case "red hot boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 3;
        damage_type = "normal";
        break;
      case "multi target boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 7;
        damage_type = "sharp";
        break;
      case "sonic multi target boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 7;
        damage_type = "shatter";
        break;
      case "red hot multi target boomerang":
        speed = 15.; size=10.;
        damage = 1; pierce = 7;
        damage_type = "normal";
        break;
      case "glaive boomerang":
        speed = 15.; size=38.;
        damage = 1; pierce = 12;
        damage_type = "sharp";
        break;
      case "sonic glaive boomerang":
        speed = 15.; size=38.;
        damage = 1; pierce = 12;
        damage_type = "shatter";
        break; 
      case "red hot glaive boomerang":
        speed = 15.; size=38.;
        damage = 1; pierce = 12;
        damage_type = "normal";
        break;
      default:
        println("ERROR : Boomerang type ", projectile_type, " not suitable for shooting boomerang");
        break;
    }
  }

}
