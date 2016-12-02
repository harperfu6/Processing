//うつるんです、普通のシミュレーション

int Length = 500;

int Max_Human = 400; //画面に登場させる人間の数
int Sick = 98; //病気にならない確率

int[][] MAP = new int[Length][Length];
Human[] UofT_Human = new Human[Max_Human];

//初期化部
void setup() {
  size(Length,Length);
  background(0);
  frameRate(30);

  //ここで人間を生成
  // 
  for(int i=1; i < Max_Human; i++){
    int k1 = int(random(100));
    //乱数を生成し、Sick以下ならば健常者、それ以外なら病気
    if(k1 < Sick){
      k1 = 1;
    }
    else{
      k1 = 2;
    }
     //動きのための初期設定
     //k2,k3は出現座標
     int k2 = int(random(Length));
     int k3 = int(random(Length));

     //k4,k5は速度ベクトル
     int k4 = 0;
     int k5 = 0;
     if(k1 == 1){
       k4 = 3 - int(random(5));
       if(k4 == 0) k4 = 1;
       k5 = 3 - int(random(5));
       if(k5 == 0) k5 = 1;
     }
     else{
       k4 = 2 - int(random(4));
       if(k4 == 0) k4 = 1;
       k5 = 2 - int(random(4));
       if(k5 == 0) k5 = 1;
     }
     
    UofT_Human[i] = new Human(k1,k2,k3,k4,k5);
  }
  
 
  //空間の状態管理配列
  for(int i=0; i< Length; i++){
    for(int j=0; j< Length; j++){
      MAP[i][j] = 0;
    }
  }
 
}


//メインループ
void draw() {
 background(0);

 //人間を描画
 for(int j=1; j < Max_Human; j++){
     UofT_Human[j].draw();
  }

  //人間を動かす
  for(int j=1; j < Max_Human; j++){
     UofT_Human[j].drive();
  }
 
  //人間同士の衝突判定
  for(int j=1; j < Max_Human; j++){
     UofT_Human[j].coll();
  }
  
}

//人間のクラスを定義
class Human
{

  int xpos; //x座標
  int ypos; //y座標
  int xvel; //x方向の速さ
  int yvel; //y方向の速さ
  int condition; //健康かそれとも病気かのパラメータ
  
  Human(int c, int xp, int yp, int xv, int yv) {
    xpos = xp;
    ypos = yp;
    xvel = xv;
    yvel = yv;
    condition = c;
  }

 //もし健康ならば青、病気ならば赤を描画
  void draw () {
    if(condition ==1){
      fill(0,0,255);
      ellipse(xpos,ypos,4,4);
    }
    else{
      fill(255,0,0);
      ellipse(xpos,ypos,4,4);
    } 
  }

  void drive () {
    MAP[xpos][ypos] = 0;
    xpos = (xpos + xvel + Length) % Length;
    ypos = (ypos + yvel + Length) % Length;
     MAP[xpos][ypos] = condition;  
  }
 
  //衝突判定を行う部分
  void coll () {
    for(int i = -2; i < 3; i++){
      for(int j = -2; j < 3; j++){
        if ((MAP[(xpos+i+Length)%Length][(ypos+j+Length)%Length] > 0) && (i != 0) && (j != 0)){
          xvel = -xvel;
          yvel = -yvel;
          if(MAP[(xpos+i+Length)%Length][(ypos+j+Length)%Length] == 2){
            condition = 2;
          }     
        }
      }
    }
  }
}


void mousePressed() {
 saveFrame("sample_2.png"); 
}

