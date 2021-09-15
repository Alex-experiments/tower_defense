//https://forum.processing.org/beta/num_1276644884.html

Line myLine=new Line(1, 1, 1, 1);

class Line{
  // where does the line start/end? 
  public float x1, x2, y1, y2; 
  
  // some happy math variables
  private float dx, dy, d, ca, sa, mx, dx2, dy2; 
  
  // we use this to store the result, 
  // so if you want to store the result and calculate again 
  // you should do 
  // PVector mine = new PVector(); 
  // mine.set( line.getDistance( mouseX, mouseY ) ); 
  private PVector result; 
  
  public Line(float x1, float y1, float x2, float y2 ){
    this.x1 = x1; 
    this.y1 = y1; 
    this.x2 = x2; 
    this.y2 = y2; 
    result = new PVector(); 
    //update();
  }
  
  /**
   * Call this after changing the coordinates!!! 
   */
  public void update(){
    dx = x2 - x1; 
    dy = y2 - y1; 
    d = sqrt( dx*dx + dy*dy ); 
    ca = dx/d; // cosine
    sa = dy/d; // sine 
  }
  
  /**
   * Returns a point on this line
   * that is closest to the point (x,y)
   * 
   * The result is a PVector. 
   * result.x and result.y are points on the line. 
   * The result.z variable contains the distance from (x,y) to the line, just in case you need it :) 
   */
  PVector getDistance( float x, float y ){
    update();
    mx = (-x1+x)*ca + (-y1+y)*sa;
    
    if( mx <= 0 ){
      result.x = x1; 
      result.y = y1; 
    }
    else if( mx >= d ){
      result.x = x2; 
      result.y = y2; 
    }
    else{
      result.x = x1 + mx*ca; 
      result.y = y1 + mx*sa; 
    }
    
    dx2 = x - result.x; 
    dy2 = y - result.y; 
    result.z = sqrt( dx2*dx2 + dy2*dy2 ); 
    
    return result;   
  }
  

}
