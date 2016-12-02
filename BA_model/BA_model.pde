// 複雑ネットワーク BAモデル サンプルプログラム

int Length = 500;
int Max_Node = 100;
int Node_number = 4;
int total_degree = (Node_number - 1) * Node_number;

float[] prob = new float[Max_Node];
int prob_num = 1;
int[] nd_num = new int[Max_Node];

Node[] Test_Node = new Node[Max_Node];

//初期化部
void setup() {
  size(Length*2,Length);
  background(0);
  smooth();
  frameRate(1); //フレームレートはゆっくりに設定

  //フォントを作成します
   PFont font = loadFont("SansSerif-12.vlw");
   textFont(font);

  //Node_numberの数だけノードを配置します
  for(int i=0;i<Node_number;i++) {
    //新規に発生したノードの位置はランダムに設定
    //但し，画面の幅に少し余裕をもたせて表示するため 
    int k1 = int(random(Length -40)) + 20;
    int k2 = int(random(Length -40)) + 20;
    Test_Node[i] = new Node(k1,k2);
    //Test_Node[i].link_number = Node_number;
    Test_Node[i].link_number = 3;

      for(int j=0;j<Node_number;j++) {
        Test_Node[i].link[j] = j;
      }
  }  

}


//メイン部分
void draw() {

  Node_number = Node_number + 1; //ノードを1個ずつ増やしてゆきます
  total_degree = total_degree + 4; //まず次数の総和が2増えます

  //新規に発生したノードの位置はランダムに設定
  //但し，画面の幅に少し余裕をもたせて表示するため 
  int k1 = int(random(Length -40)) + 20;
  int k2 = int(random(Length -40)) + 20;
  Test_Node[Node_number-1] = new Node(k1,k2);

  //新規に発生させたノードの次数を2に設定します
  Test_Node[Node_number-1].link_number = 2;

  for(int i=0; i< Test_Node[Node_number -1].link_number; i++) {
    //上記で設定した次数に基づき、リンク相手をランダムに選びます
    Test_Node[Node_number-1].link[i] = get_link(random(0,1));
    
    //接続先の次数を更新
    Test_Node[Test_Node[Node_number-1].link[i]].link_number++;   
  }

  drawblack();

  //ノードを描画します
  for(int j=0; j < Node_number; j++) {
    Test_Node[j].draw();
  }

  //リンク（エッジ）を描画します
  for(int j=0; j < Node_number; j++) {
    for(int i=0; i< Test_Node[j].link_number; i++) {
      stroke(255);
      line(Test_Node[j].xpos,Test_Node[j].ypos, Test_Node[Test_Node[j].link[i]].xpos, Test_Node[Test_Node[j].link[i]].ypos);
    }
  }
  
  //ヒストグラムの描画部分
  
  stroke(255);
  line(Length+30, Length - 30, Length*2-30, Length - 30);
  text("probability", Length*2-45, Length - 15);
  line(Length+30, 75, Length+30, Length-30);
  text("number of nodes", Length+30, 60);
  
  //現在の総次数の表示
   fill(0,255,0);
   text(total_degree, Length+30 , 30);
   
   
  // このあたりにヒストグラムの計算をするとよいでしょう
  //0に初期化
  for(int i = 0; i < prob_num; i++){
    prob[i] = 0;
    nd_num[i] = 0;
  }
  
  prob[0] = Test_Node[0].prob;
  nd_num[0] = 1;
  prob_num = 1;
  
  for(int i = 1; i < Node_number; i++){
    for(int j = 0; j <= prob_num; j++){
      if(Test_Node[i].prob == prob[j]){
        nd_num[j]++;
        break;
      }
      if(j == prob_num - 1){
        prob[prob_num] = Test_Node[i].prob;
        prob_num++;
      }
    }
  }
  
  pushStyle();
  strokeWeight(3);
  
  for(int i = 0; i < prob_num; i ++){
    line(Length+30 + Length*prob[i]*2, Length-32, Length+30 + Length*prob[i]*2, Length-32 - nd_num[i]*15);
    println("prob: " + prob[i] + ",  num: " + nd_num[i]);
  }
  
  popStyle();
  
}


//ノードのクラス
class Node
{
  int xpos; //x座標
  int ypos; //y座標
  int link_number; //当該ノードの次数
  int [] link = new int[Max_Node]; //リンクの相手先情報を格納
  float prob;

  Node(int xp, int yp) {
    xpos = xp;
    ypos = yp;
  }

  void draw () {
    prob = (float)((float)link_number / (float)total_degree);
    noStroke();
    fill(0,0,200);
    ellipse(xpos,ypos,15+link_number*3,15+link_number*3);
    //ノードの接続確率を描画しましょう
    fill(255);
    text(prob, xpos - 10, ypos - 10);
    //ノードの次数を描画しましょう
    fill(255,0,0);
    text(link_number, xpos + 25, ypos - 10);
  }
}


int get_link (float rand) {
  int res = 0;
  float sum = 0;
  float tmp;
  for(int i=0; i<Node_number; i++) {
    tmp = Test_Node[i].link_number;
    sum += (tmp / total_degree);
    if (rand < sum) {
      res = i;
      break;
    }
  }
  return(res);
}


void drawblack() {
  rectMode(CORNER);
  fill(0);
  rect(0,0,width,height);
}
