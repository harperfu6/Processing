//マルチエージェントシミュレータ
//基本プログラム
// by Hajime Nobuhara

int Length = 400; //空間管理配列の大きさ
int Max_Human = 200; //シミュレータに登場させる人間の数

//空間管理配列を準備
int[][] MAP = new int[Length][Length]; 

//人間の配列を準備
Human_class[] Human = new Human_class[Max_Human];


//初期化部
void setup() {
  colorMode(HSB);
  size(Length, Length);
  background(0);
  frameRate(30);

  //ここで人間を生成
  for(int i=0; i < Max_Human; i++){
     int k1 = 1; //生きている人間の状態を1、死んでいる場合は 0
     int k2 = int(random(width)); //登場する初期 x座標
     int k3 = int(random(height)); //登場する初期 y座標
     int k4 = int(random(5)); //人間の動作方向をランダムにセット
     int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
     Human[i] = new Human_class(k1,k2,k3,k4,k5);
  }
  
  //空間の状態管理配列を初期化
  for(int i=0; i< Length; i++){
    for(int j=0; j< Length; j++){
      MAP[i][j] = 0;
    }
  }
}



//
// メインループ
//

void draw() {
 
 //背景を描画
 makeground();

 //人間を描画
 for(int j=0; j < Max_Human; j++){
     Human[j].timer ++;  //人間の体内時計を1つカウントアップ
     //人間を描画
     //アニメーションを使っており、体内時計に合わせて動く
     Human[j].draw(); 
  }

  //人間を動かす
  for(int j=0; j < Max_Human; j++){
     Human[j].drive();
  }
  
  //お互いの衝突判定
  for(int j=0; j < Max_Human; j++){
     Human[j].coll();
  }
  
}



//
// 人間のクラスを定義
//

class Human_class
{

  int xpos; //x座標
  int ypos; //y座標
  int type; //人間の状態
  int direction; //人間の動作方向
  int timer; //体内時計
    
  Human_class(int c, int xp, int yp, int dirt, int t) {
    xpos = xp;
    ypos = yp;
    type = c;
    direction = dirt;
    timer = t;
  }



 //人間を描画する部分
  void draw () {
    //頭部を描画しちゃいましょう
    smooth();
    noStroke();
    
    //色はグリーン
    fill(100,255,255);
       
    //アニメーションは全部で5種類準備
    //体内時間を5で割って、その余りに応じて
    //表示するアニメを決定
    
    int time = timer % 5;
    switch(time){
      
      case 0:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5); //胴体
        rect(xpos-3,ypos+8,3,5); //左足
        rect(xpos-4,ypos+3,2,5); //左腕
        rect(xpos+2,ypos+3,2,5); //右腕
    
        break;
      case 1:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,4);
        rect(xpos,ypos+8,3,1);        
        break;
       case 2:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,3);
        rect(xpos,ypos+8,3,3);
        break;
        case 3:
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos-3,ypos+8,3,1);
        rect(xpos,ypos+8,3,4);
        break;
        case 4:
        
        //5枚目
        ellipse(xpos,ypos,6,6);
        rect(xpos-3,ypos+3,6,5);
        rect(xpos,ypos+8,3,5);
        rect(xpos-4,ypos+3,2,5); 
        rect(xpos+2,ypos+3,2,5); 
        break;
        
    }
  }


//人間を動かす部分
  void drive () {
    
    //確率5%で動く方向を変更
    if(random(100) < 5){
      //5種類の動きをランダムにセット
      direction = int(random(5));
    }
    
    //動く方向4方向 + 何も動かない
    //合計5種類を準備
    
    switch(direction){
      case 0:
        break; //何も動かず
    
      case 1:
          MAP[xpos][ypos] = 0;
          xpos = (xpos + 1 + width) % width; //右に動かす
          break;
          
      case 2:
          MAP[xpos][ypos] = 0;
          xpos = (xpos - 1 + width) % width; //左に動かす
          break;
          
      case 3:
          MAP[xpos][ypos] = 0;
          ypos = (ypos + 1 + height) % height; //下に動かす
          break;
      
     case 4:
          MAP[xpos][ypos] = 0;
          ypos = (ypos - 1 + height) % height; //上に動かす
          break;
    }
     
   
   //自分の移動先に存在を代入
     MAP[xpos][ypos] = type;  
    
  }
  
  
  //衝突の判定
  void coll() {
    
    //自分の周囲 10x10 の範囲を探索して、他人がいたら避けるようにする
    for(int i = -10; i < 10; i++){
      for(int j = -10; j < 10; j++){
        if (MAP[(xpos+i+width) % width][(ypos+j+height) % height] == 1){
          
          MAP[xpos][ypos] = 0;
          
          //相手から2画素分逃げるようにする
          if(i < 0){
            xpos = (xpos + 2 + width) % width; 
          }
          if(i > 0){
            xpos = (xpos - 2 + width) % width;
          }
          
          //相手から2画素分逃げるようにする
          if(j < 0){
            ypos = (ypos + 2 + height) % height;
          }
          if(j > 0){
            ypos = (ypos - 2 + height) % height;
          }
          
          MAP[xpos][ypos] = type; 
          
       
        }
      }
    }
  }
  
}


//背景を描画
void makeground(){
  fill(128,100,100); //ちょっと薄めのグリーン
  rect(0,0,width,height);  
}
