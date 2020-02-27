import g4p_controls.*;
//Global Variables
//Buttons
boolean clicked = false;
boolean nodeclicked = false;
boolean edgeclicked = false;
boolean inputclicked = false;
boolean randomizedclicked = false;
boolean dijkstraclicked = false;
boolean clearclicked = false;
//
ArrayList<Node> Nodes = new ArrayList<Node>();//stores all the plotted nodes
ArrayList<Edge> Edges = new ArrayList<Edge>();//stores all the edges
ArrayList<Integer> path;//stores the indexes of the nodes in the shortest path
float ex1,ey1,ex2,ey2;// the x and y coordinates of both ends of the edge
boolean[] vis;//stores the visited nodes when executing the dijkstra algorithm
double[] dis;//stores the distance between the visited nodes when executing the dijkstra algorithm
int[] pre;//stores the index of the node that the program has to visit in order to get to the root node from the destination node(backtracking)
int pc;//Stores the selection of the colour from the gui dropdownlist
int index = 0;//give the current value to the node as its index
int start,end;//inputted values that represent the indexes of the nodes that are connected together by an edge
int rt,de;// inputted values that represent the starting and ending node of the shortest path
int prob = 35;//the probability for randomizing edges, user can adjust this number
color pcolor;//represents the colour of the shortest path on the screen

//Create the window and GUI controller
void setup(){
  createGUI();
  size(1500,900);
  frameRate(60);
  fill(255);
  background(0);
  PFont myFont = createFont("Calibri", 20);
  textFont(myFont);

}
//Detect mouse activities
void mouseClicked(){
  clicked = true;
}

void draw(){
  if(nodeclicked){
    //plot the point if the mouse button is clicked
    if(clicked){
      Node p = new Node(mouseX, mouseY,index);
      Nodes.add(p);
      p.plot();
      clicked = !clicked;
      index++;
    }
  }
  else if(edgeclicked){
    //draw edges on the screen
    ex1 = Nodes.get(start).x;
    ey1 = Nodes.get(start).y;
    ex2 = Nodes.get(end).x;
    ey2 = Nodes.get(end).y;
    Edge e = new Edge(ex1,ey1,ex2,ey2,color(255));
    e.drawedge();
    Edges.add(e);
    Nodes.get(start).addNeighbours(Nodes.get(end));
    edgeclicked = false;
  }
  else if(inputclicked){
    //Read the input from the text file and draw edges
    String[] lines = loadStrings("Edges.txt");
    for(int i=0; i< lines.length; i++) {
      String currLine = lines[i];
      String[] parts = currLine.split(",");
      
      int from = int(parts[0]);
      int to = int(parts[1]);
      
      ex1 = Nodes.get(from).x;
      ey1 = Nodes.get(from).y;
      ex2 = Nodes.get(to).x;
      ey2 = Nodes.get(to).y;
      Edge e = new Edge(ex1,ey1,ex2,ey2,color(255));
      e.drawedge();
      Edges.add(e);
      Nodes.get(from).addNeighbours(Nodes.get(to));
    }
    inputclicked = false;

  }
  else if(randomizedclicked){
    int[] arr = new int[Nodes.size()];//stores indices of the node
    //Initialize the values
    for (int i=0; i<arr.length; i++) {
      arr[i] = i;
    }
    //randomized the edge and display it on the screen
    for (int i=0; i<arr.length; i++) {
        for (int j=i+1; j<arr.length; j++) {
          if (random(0, 100) < prob) {
            ex1 = Nodes.get(i).x;
            ey1 = Nodes.get(i).y;
            ex2 = Nodes.get(j).x;
            ey2 = Nodes.get(j).y;
            Edge e = new Edge(ex1,ey1,ex2,ey2,color(255));
            e.drawedge();
            Edges.add(e);
            Nodes.get(i).addNeighbours(Nodes.get(j));
          }
        }
    }
    randomizedclicked = false;
  }
  else if(dijkstraclicked){
    //find the shortest path and display it on the screen
    int[] p = dijkstra(rt);
    getpath(p,rt,de);
    showpath();
    dijkstraclicked = false;
  }
  else if(clearclicked){
    //clear all the shortest paths on the screen
    for(int i = 0; i < Edges.size(); i++){
      Edges.get(i).drawedge();
    
    }
    clearclicked = false;
  }
}
//Dijkstra's Algorithm by looping
int[] dijkstra(int st){
  vis = new boolean[Nodes.size()];
  dis = new double[Nodes.size()];
  pre = new int[Nodes.size()];
  //set the values for the arrays
  for(int i = 0; i < Nodes.size(); i++){
    dis[i] = Double.POSITIVE_INFINITY;
    vis[i] = false;
  
  }
  dis[st] = 0; pre[st] = -1;
  for(int i = 0; i < dis.length; i++){
    int nxt = minindex(dis, vis);
    try{
      vis[nxt] = true;
      //calculate the distance between the current node and all its neighbours and replace the values in the array with new values
      for(Node n: Nodes.get(nxt).Neighbours){
        int v = n.index;
        Edge e = new Edge(Nodes.get(nxt).x,Nodes.get(nxt).y,n.x,n.y,color(255));
        double d = dis[nxt] + e.distance();
        if(dis[v] > d){
          dis[v] = d;
          pre[v] = nxt;
        
        }
      
      }
    }
    catch(ArrayIndexOutOfBoundsException e){
      continue;
    }
  
  }
  return pre;


}
//find the closest node to the starting node
int minindex(double[] d, boolean[] v){
  double x = Double.POSITIVE_INFINITY;
  int y = -1;
  for(int i = 0; i < dis.length; i++){
    if(!v[i] && d[i] < x){
      y = i;
      x = dis[i];
    }
  
  }
  return y;

}
//Backtrack the array to find the shortest path and store it into an arraylist
void getpath(int[] pre,int st, int ed){
  path = new ArrayList<Integer>();
  path.add(ed);
  int x = ed;
  while(x != st){
    path.add(pre[x]);
    x = pre[x];
  }
}
//Set the colour of the path and display it on screen
void showpath(){
  if(pc == 0){pcolor = color(0,255,0);}
  else if(pc == 1){pcolor = color(255,0,0);}
  else if(pc == 2){pcolor = color(0,0,255);}
  else if(pc == 3){pcolor = color(255,255,0);}
  else if(pc == 4){pcolor = color(128,0,128);}
  else if(pc == 5){pcolor = color(255,165,0);}
  else if(pc == 6){pcolor = color(0,255,255);}
  
  for(int i = path.size()-1; i > 0; i--){
    int a = path.get(i), b = path.get(i-1);
    Edge e = new Edge(Nodes.get(a).x,Nodes.get(a).y,Nodes.get(b).x, Nodes.get(b).y,pcolor);
    e.drawedge();
  }



}
