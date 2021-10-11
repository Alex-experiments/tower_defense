class Cercle{
  float centre_x;
  float centre_y;
  float radius;
  float angle_dep;
  float angle_fin;
  String sens;
  
  Cercle(float centre_x, float centre_y, float radius, float angle_dep, float angle_fin, String sens){
    this.centre_x=centre_x;
    this.centre_y=centre_y;
    this.radius=radius;
    this.angle_dep=angle_dep;
    this.angle_fin=angle_fin;
    while(this.angle_dep>PI){    //seul moyen que j'ai trouvé pour que les angles soient vraiment dans ]-PI, PI] sinon par ex 5%2PI ==5 et -5%2PI==-5...
      this.angle_dep-=2*PI;
    }
    while(this.angle_fin>PI){
      this.angle_fin-=2*PI;
    }
    while(this.angle_dep<=-PI){
      this.angle_dep+=2*PI;
    }
    while(this.angle_fin<=-PI){
      this.angle_fin+=2*PI;
    }
    this.sens=sens;  
  }
  
  float longueur(){
    float angle_total;
    
    if(sens.equals("trigo")){
      angle_total = (angle_fin - angle_dep) % (2*PI);
    }
    else{
      angle_total = (2*PI - (angle_fin - angle_dep)) % (2*PI);
    }
    if(angle_total<0)  angle_total+=2*PI;
    return angle_total * radius;
  }
  
  float[] get_pos(float avancement){
    
    int correc=1;
    if(sens.equals("horaire"))  correc=-1;
    
    return new float[] {centre_x + radius * cos(correc * avancement/radius + angle_dep), centre_y - radius * sin(correc * avancement/radius + angle_dep)};
  }

}
