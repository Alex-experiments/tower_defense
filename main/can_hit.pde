
// Il faut foutre can_hit dans mob.hit() genre si on peut pas tapper bah foutre un return
// mais aussi mettre un can_detect qui serait la fonction à appeller pour tirer sur un mob ou non
boolean can_detect(Mob mob, boolean detects_camo){
  return (detects_camo || !mob.camo) && !map.is_hidden(mob.x, mob.y, mob.size/2);
}

boolean can_hit(Mob mob, String projectile_type, StringList exceptions){
  // a employer comme ca : 
  //if(can_detect() -> hit()
  //avec hit() qui commence par if(can_hit())
  
  if(!map.is_hidden(mob.x, mob.y, mob.size/2)==false )  return false;   //on ne le detecte meme pas
  
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
      
    case "spike ball" :
      //pareil que dart
      if(mob.is_frozen && !exceptions.hasValue("frozen") || mob.type.equals("lead") && !exceptions.hasValue("lead"))  return false;
      break;
    
    case "huge spike ball" :
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
