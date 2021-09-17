class Instant_projectile{
  int damage, pierce;
  
  String damage_type, bullet_type;
  Tower fired_from_tower;

  Instant_projectile(Tower fired_from_tower, Mob target){
    this.fired_from_tower=fired_from_tower;
    hit(target);
  }
  
  void verif_damage_type(){
    if(damage_type.equals(get_damage_type(bullet_type)))  return;
    println("NOT GOOD ! Projectile :", bullet_type, "gives", damage_type, "and", get_damage_type(bullet_type));
  }
  
  void hit(Mob target){
    int nb_layers_popped=target.pop_layers(damage, true, damage_type);
    fired_from_tower.pop_count+=nb_layers_popped;
    joueur.game_pop_count+=nb_layers_popped;
    if(target.layers<=0){
      enemis.remove(target);
    }
  }
}

class Bullet extends Instant_projectile{
  static final int damage = 2, pierce = 1;
  static final String damage_type = "sharp", bullet_type = "bullet";
  
  Bullet(Tower fired_from_tower, Mob target){
    super(fired_from_tower, target);
  }  
}

class Full_metal_bullet extends Instant_projectile{
  static final int damage = 4, pierce = 1;
  static final String damage_type = "normal", bullet_type = "full metal bullet";
  
  Full_metal_bullet(Tower fired_from_tower, Mob target){
    super(fired_from_tower, target);
  }  
}

class Point_five_bullet extends Instant_projectile{
  static final int damage = 7, pierce = 1;
  static final String damage_type = "normal", bullet_type = "point five bullet";
  
  Point_five_bullet(Tower fired_from_tower, Mob target){
    super(fired_from_tower, target);
  }  
}

class Deadly_bullet extends Instant_projectile{
  static final int damage = 18, pierce = 1;
  static final String damage_type = "normal", bullet_type = "deadly bullet";
  
  Deadly_bullet(Tower fired_from_tower, Mob target){
    super(fired_from_tower, target);
  }  
}
