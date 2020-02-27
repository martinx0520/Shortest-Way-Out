class Node{
  float x,y;//the coordinates of the node
  int index;//index of the node
  ArrayList<Node> Neighbours;//All the neighbours of the node
  
  Node(float x, float y, int index){
    this.x = x;
    this.y = y;
    this.index = index;
    Neighbours = new ArrayList <Node>();
  }
  //plot the node on the screen
  void plot(){
    fill(255);
    circle(this.x, this.y, 50);
    fill(255,0,0);
    text(this.index, this.x,this.y);
    
  }
  //add each others to its own neighbour arraylist
  void addNeighbours(Node n){
    this.Neighbours.add(n);
    n.Neighbours.add(this);
  
  }
 
  

}
