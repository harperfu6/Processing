// WS sample program by Hajime Nobuhara 
//

int W_size = 400; // screen size 
int N = 100; // Node number 
int Loop = 20; // Loop number 
Node[] WS_Node = new Node[N];
int R;

void setup() {
  size(W_size, W_size);
  background(0);
  smooth();
  frameRate(1); //フレームレートはゆっくり

  //フォントを生成しましょう
  PFont font = loadFont("SansSerif-18.vlw");
  textFont(font);

  //nodes
  for(int i=0; i<N; i++) {
    int k1 = int(W_size/2 + W_size/2.5*cos(2*PI*i/N));
    int k2 = int(W_size/2 - W_size/2.5*sin(2*PI*i/N));
    WS_Node[i] = new Node(k1,k2);
    WS_Node[i].link_number = 2;
    for(int j=0; j<2; j++) {
      WS_Node[i].link[j] = (i+j+1)%N;
    }
  }
}


//main
void draw() {

  //reset
  fill(0);
  rect(0, 0, W_size, W_size);

  //draw links
  for(int j=0; j < N; j++) {
    for(int i=0; i< WS_Node[j].link_number; i++) {
      stroke(255);
      line(WS_Node[j].xpos, WS_Node[j].ypos, WS_Node[WS_Node[j].link[i]].xpos, WS_Node[WS_Node[j].link[i]].ypos);
    }
  }

  //draw nodes
  fill(255);
  textAlign(CENTER,CENTER);
  for(int j=0; j < N; j++) {
    WS_Node[j].draw();
    fill(255);
    text(j,int(W_size/2 + W_size/2.3*cos(2*PI*j/N)),int(W_size/2 - W_size/2.3*sin(2*PI*j/N)));
  }



  //connect a link to another node
  R = int(random(N));
  WS_Node[R].link[int(random(2))] = (R + int(random(N/6,N/2)))%N;

 
  if(frameCount%Loop==0) {
    for(int i=0; i<N; i++) {
      for(int j=0; j<2; j++) {
        WS_Node[i].link[j] = (j+1+i)%N;
      }
    }
  }

}


class Node {

  int xpos;
  int ypos;
  int link_number;
  int [] link = new int[N];

  Node(int xp, int yp) {
    xpos = xp;
    ypos = yp;
  }
  
  void draw() {
    noStroke();
    fill(0,0,255);
    ellipse(xpos,ypos,15,15);
  }
  
}

