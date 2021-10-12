static final StringList sharp_list = new StringList("dart", "sharp dart", "powerful dart", "razor sharp dart", "blade", "maelstrom blade", "basic boomerang", "multi target boomerang", "glaive boomerang", "glaive ricochet", "tack", "shuriken", "sharp shuriken", "seeking shuriken", "seeking sharp shuriken", "bullet", "spike", "stack spike", "MOAB-SHREDR Spikes", "stack MOAB-SHREDR Spikes");
static final StringList normal_list = new StringList("huge dart ball", "sharp huge dart ball", "razor sharp huge dart ball", "ring of fire", "red hot boomerang", "red hot multi target boomerang", "red hot glaive boomerang", "red hot glaive ricochet", "full metal bullet", "point five bullet", "deadly bullet", "cripple MOAB bullet", "bloontonium dart", "bloontonium laser cannon", "ray of doom", "hydra rocket", "purple ball", "huge purple ball", "fireball", "dragon's breath", "flash bomb", "hot spike", "hot MOAB-SHREDR Spikes", "spike ball", "spike mine", "whirlwind", "tornado");
static final StringList shatter_list = new StringList("dart ball", "sharp dart ball", "razor sharp dart ball", "sonic boomerang", "sonic multi target boomerang", "sonic glaive boomerang", "sonic glaive ricochet", "laser cannon", "powerful laser cannon");
static final StringList laser_list = new StringList("laser");  //c'est juste pour mob.pop_layers : un laser ne peut pas pop les enfants du ballon qu'il touche ! Sinon c'est un damage_type normal

//these list are just there to verify that the damage type I specified in their initialisation is the same as there: been very useful when I made changes


static String get_damage_type(String projectile_type){
  if(sharp_list.hasValue(projectile_type))  return "sharp";
  if(normal_list.hasValue(projectile_type))  return "normal";
  if(shatter_list.hasValue(projectile_type))  return "shatter";
  if(laser_list.hasValue(projectile_type))  return "laser";
  
  println("ERROR : damage type not detected with projectile type :", projectile_type);
  return "ERROR";
}


// Il faut foutre can_hit dans mob.hit() genre si on peut pas tapper bah foutre un return
// mais aussi mettre un can_detect qui serait la fonction à appeller pour tirer sur un mob ou non
boolean can_detect(Mob mob, boolean detects_camo){
  return (detects_camo || !mob.camo) && !map.is_hidden(mob.x, mob.y, mob.size/2);
}

boolean can_damage(Mob mob, String damage_type){
  //https://bloons.fandom.com/wiki/Damage_Types
  
  if(map.is_hidden(mob.x, mob.y, mob.size/2) )  return false;   //on ne le detecte meme pas
  
  switch(damage_type){
    case "normal":
      return true;
     
    case "laser":
      return true;
      
    case "acid":
      return true;
    
    case "explosion":
      return !(mob.type.equals("black") || mob.type.equals("zebra"));      //ne tappe pas les ballons noir ni les zebra
      
    case "shatter":
      return !mob.type.equals("lead");
      
    case "metal glacier freeze":
      return !mob.type.equals("white");
    
    case "sharp":
      return !(mob.type.equals("lead") || mob.is_frozen);
  }
  
  println("ERROR : WASNT ABLE TO DECIDE IF CAN DAMAGE WITH DAMAGE TYPE :  ", damage_type);
  
  return true;  
}
