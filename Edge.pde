class Edge{
  float startx,starty;//The x and y position of the one end of the edge
  float endx, endy;//The x and y position of the other end of the edge
  color col;//the colour of the edge
  
  Edge(float sx, float sy, float ex, float ey, color c){
    this.startx = sx;
    this.starty = sy;
    this.endx = ex;
    this.endy = ey;
    this.col = c;
  
  }
  //draw the edge on screen
  void drawedge(){
    stroke(this.col);
    strokeWeight(3);
    line(this.startx, this.starty, this.endx, this.endy);
    
  }
  //calculate the length of the edge
  float distance(){
    float d = sqrt(pow((endx-startx),2)+pow((endy-starty),2));
    return d;
  
  }

}
