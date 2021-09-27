static final StringList sharp_list = new StringList("dart", "sharp dart", "powerful dart", "razor sharp dart", "blade", "maelstrom blade", "basic boomerang", "multi target boomerang", "glaive boomerang", "glaive ricochet", "tack", "shuriken", "sharp shuriken", "seeking shuriken", "seeking sharp shuriken", "bullet", "spike", "stack spike", "MOAB-SHREDR Spikes", "stack MOAB-SHREDR Spikes");
static final StringList normal_list = new StringList("huge dart ball", "sharp huge dart ball", "razor sharp huge dart ball", "red hot boomerang", "red hot multi target boomerang", "red hot glaive boomerang", "red hot glaive ricochet", "full metal bullet", "point five bullet", "deadly bullet", "cripple MOAB bullet", "bloontonium dart", "bloontonium laser cannon", "ray of doom", "hydra rocket", "purple ball", "huge purple ball", "fireball", "dragon's breath", "flash bomb", "hot spike", "hot MOAB-SHREDR Spikes", "spike ball", "spike mine", "whirlwind", "tornado");
static final StringList shatter_list = new StringList("dart ball", "sharp dart ball", "razor sharp dart ball", "sonic boomerang", "sonic multi target boomerang", "sonic glaive boomerang", "sonic glaive ricochet", "laser cannon", "powerful laser cannon");
static final StringList laser_list = new StringList("laser");  //c'est juste pour mob.pop_layers : un laser ne peut pas pop les enfants du ballon qu'il touche ! Sinon c'est un damage_type normal


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


boolean can_hit(Mob mob, String projectile_type, StringList exceptions){
  // a employer comme ca : 
  //if(can_detect() -> hit()
  //avec hit() qui commence par if(can_hit())
  
  // a changer avec les damage type
  
  if(map.is_hidden(mob.x, mob.y, mob.size/2) )  return false;   //on ne le detecte meme pas
  
  switch(projectile_type){
    case "boomerang" :
      //boomerangs can normally not hit leads and frozen
      if(mob.is_frozen && !exceptions.hasValue("frozen") || mob.type.equals("lead") && !exceptions.hasValue("lead"))  return false;
      break;
    
    case "glaive" :
      //pareil que boomerang
      if(mob.is_frozen && !exceptions.hasValue("frozen") || mob.type.equals("lead") && !exceptions.hasValue("lead"))  return false;
      break;
  
    case "explosion":
      //explosions can't affect black bloons and zebra
      if(mob.type.equals("black") && !exceptions.hasValue("black") || mob.type.equals("zebra") && !exceptions.hasValue("zebra"))  return false;
      break;
  
    case "dart":
      //ne peuvent normalement pas tapper les frozen et les lead
      if(mob.is_frozen && !exceptions.hasValue("frozen") || mob.type.equals("lead") && !exceptions.hasValue("lead"))  return false;
      break;
      
    case "dart ball" :
      //pareil que dart
      if(mob.is_frozen && !exceptions.hasValue("frozen") || mob.type.equals("lead") && !exceptions.hasValue("lead"))  return false;
      break;
    
    case "huge dart ball" :
      //peut péter les lead
      if(mob.is_frozen && !exceptions.hasValue("frozen"))  return false;
      break;
          
    case "tack" :
      //pareil que dart
      if(mob.is_frozen && !exceptions.hasValue("frozen") || mob.type.equals("lead") && !exceptions.hasValue("lead"))  return false;
      break;
    
    case "blade" :
      //pareil que dart
      if(mob.is_frozen && !exceptions.hasValue("frozen") || mob.type.equals("lead") && !exceptions.hasValue("lead"))  return false;
      break;
      
    case "shuriken" :
      //pareil que dart
      if(mob.is_frozen && !exceptions.hasValue("frozen") || mob.type.equals("lead") && !exceptions.hasValue("lead"))  return false;
      break;
      
    case "spike" :
      if(mob.is_frozen && !exceptions.hasValue("frozen") || mob.type.equals("lead") && !exceptions.hasValue("lead"))  return false;
      break;

      
      
        
  }
  
  
    
  //les ballons blancs ne peuvent pas etre gelés mais peuvent etre tapés
  // les zebra eux ne peuvent subir de dmg de glace je pense les blancs aussi enf ait
  //Frozen bloons cannot be popped by sharp objects
  //The B.F.B. is immune to glue 
  
  //Peuvent tapper tous les mobs sans exceptions requises :
  // flamme, laser, hot_spike, spike ball, spike mine
  return true;
}
