class Spatial_grid{
  int cell_dim, n_cell_x, n_cell_y;
  
  int spawning_cell_id;
  
  ArrayList<Cell> cells = new ArrayList<Cell>();

  Spatial_grid(int cell_dim){
    this.cell_dim = cell_dim;
    n_cell_x = ceil(875./cell_dim); n_cell_y = ceil(650./cell_dim);
    
    for(int j=0; j<n_cell_y; j++){
      for(int i=0; i<n_cell_x; i++){
        cells.add(new Cell(i+j*n_cell_x));    //leur cell_id sera aussi leur place dans la liste
      }
    }
    
  }
  
  int get_cell_id(float x, float y){
    return min(n_cell_x, max(0, int(x/cell_dim))) + n_cell_x * min(n_cell_y, max(0, int(y/cell_dim)));    //pasque quand un mob spawn avec un avancement négatif il est peut etre hors écran
  }
  
  void change_cell(Mob mob, int old_cell_id, int new_cell_id){
    cells.get(old_cell_id).mobs_in_cell.remove(mob);
    cells.get(new_cell_id).mobs_in_cell.add(mob);
  }
  
  void add_new_mob(Mob mob, int cell_id){
    cells.get(cell_id).mobs_in_cell.add(mob);
  }
  
  void remove_mob(Mob mob, int cell_id){
    cells.get(cell_id).mobs_in_cell.remove(mob);
  }
  
  ArrayList<Mob> get_enemis_to_look_at(float x, float y, float range){
    //En mettant cell_dim au max des mob.size/2, on peut se permettre de ne regarder à chaque fois que dans les cases et celles directement adjacentes 
    
    int min_cell_x = max(0, int((x-range)/cell_dim)-1), max_cell_x = min(n_cell_x, int((x+range)/cell_dim)+1);    //  +/- 1 pour les cases adjacentes aussi
    int min_cell_y = max(0, int((y-range)/cell_dim)-1), max_cell_y = min(n_cell_y, int((y+range)/cell_dim)+1);
    
    ArrayList<Mob> enemis_to_look_at = new ArrayList<Mob>();
    
    for(int j=min_cell_y; j<max_cell_y; j++){
      for(int i=min_cell_x; i<max_cell_x; i++){
        enemis_to_look_at.addAll(cells.get(i+n_cell_x*j).mobs_in_cell);
      }
    }
    return enemis_to_look_at;
  }
  
  int get_nb_enemis_stored(){
    int n = 0;
    for(Cell cell : cells){
      n+=cell.mobs_in_cell.size();
    }
    return n;
  }
  
  void reset_pop_counter(){
    for(Cell cell : cells)  cell.pop_counter=0;
  }


}

class Cell{
  int cell_id, pop_counter;
  ArrayList<Mob> mobs_in_cell = new ArrayList<Mob>();
  
  Cell(int cell_id){
    this.cell_id = cell_id;
  }
  
}
