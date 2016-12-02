//交通シミュレータ「ながれさん」プログラム
// 追い越しができるバージョン

int Length = 800; //道路の長さ 800画素に設定
int Max_Car = 10; //Max_Carに設定した台数が走るようになる
int[][] X = new int[Length][2]; //道路状況を管理する配列
Car[] myCar = new Car[Max_Car]; //車のクラスを定義

void setup() {
  size(Length,100); //Length x 100 の窓を準備
  background(0); 
  
  frameRate(40); //フレームレートは20くらいに設定すると滑らか。私のパソコンでは
  
  //車を初期設定
  //追い越しありの場合、自分の走っているレーンの状態も管理します
  for(int i=0; i < Max_Car; i++){
    //各車ごとに、色をランダムに塗りましょう
    float k1 = random(255); 
    float k2 = random(255);
    float k3 = random(255);
    int k4 = int(random(5)+1); //Max_speed
    int k5 = int(random(3)+1); //現在のスピード
    int k6 = 0; // 0は右レーン、1は左レーン
    color tempcolor = color(k1,k2,k3);
    //車の初期位置をセット。まずは等間隔にならべましょう。
    myCar[i] = new Car(tempcolor,Length/Max_Car*i,65,k4,k5,k6);
    
  }
  
  //道路を管理する配列を初期化
  //2レーン分、管理しないといけません。
  for(int i=0; i< Length; i++){
    X[i][0] = 0;
    X[i][1] = 0;
  }
    
}



//メインループ
void draw() {
 
  background(0); //画面を真っ黒に塗りつぶす
  draw_background(); //道路を描画
    
 //各車を描画、制御する
 for(int j=0; j < Max_Car; j++){

   //レーンチェンジをする場合としない場合で
  //　アクションを変更 
  
   myCar[j].draw(); //車を描画する
   
     if(myCar[j].change==0){
       //レーンチェンジをしない場合
       myCar[j].drive(); //アクセルペダルの制御関数を呼び出し
       myCar[j].breaking(); //ブレーキペダルの制御関数を呼び出し
     }
     else{ 
       //レーンチェンジをする場合
       myCar[j].lane_ch(); //レーンチェンジを開始
     }
 }  
  
  //道路を管理する配列をきれいに
  for(int i=0; i< Length; i++){
    X[i][0] = 0;
    X[i][1] = 0;
  }
  
  //もう一度、自分の位置をしっかり書き込みましょう。
  for(int i=0; i< Max_Car; i++){
      X[((myCar[i].xpos + width) % width)][myCar[i].lane] = 1;
  }

}



//車のクラスを定義
class Car
{
  color c; //車の色
  int xpos; //現在のx座標
  int ypos; //現在のy座標
  int Max_Speed;
  int xvel; //x方向へのスピード（現在は1次元なので車のスピードに相当）
  int lane; //現在のレーンの状態
  int change; //レーンチェンジの状態
  
  Car(color c_, int xp, int yp, int mx, int xv, int l) {
    c = c_;
    xpos = xp;
    ypos = yp;
    Max_Speed = mx;
    xvel = xv;
    lane = l;
  }

  //車を描画する関数
  void draw () {
    stroke(0);
    fill(c); //各車の色をセット
    rect(xpos,ypos,15,10); //車のボディを書く
    stroke(0);
    fill(255); //車の天井部を白に塗る
    rect(xpos+2,ypos+2,5,6);
    
    //タイヤを描画する
    fill(0);
    rect(xpos+2,ypos-2,4,2);
    rect(xpos+8,ypos-2,4,2);
    rect(xpos+2,ypos+10,4,2);
    rect(xpos+8,ypos+10,4,2);
    
  }

  //アクセルペダルの制御関数
  void drive () {
    
      //前方をチェックするルーチン
      int k = 0;
      for(int i = xpos + 1; i < xpos + 15; i++){
        k = k + X[(i + width) % width][lane];
      }
      
      //もし前方に車があれば、kは0よりも大きくなる
      if(k < 1) {
        xvel = xvel + 2; //アクセルを踏むとスピードが2上がる
        //もし最大速度よりも大きくなったら、制限をかける
        if(xvel > Max_Speed){
          xvel = Max_Speed; 
        }
      }
    
      X[xpos][lane] = 0; //道路状態を管理する配列の、現在の車の位置0にする。
                   //この配列が1になっていれば、車両が存在する。
                   //0になっていれば、車両は存在しない
                   
      xpos = (xpos + xvel + width) % width; //車の位置を移動
      
      X[xpos][lane] = 1;   //車の位置を道路管理配列に書き込む
  

      
  }
    
   
  //ブレーキペダルの制御関数
  void breaking (){
    //前方に車がいるかどうかを判定
    for(int i = xpos + 1; i < xpos + 20; i++){
      //車がいれば、ブレーキをふむ
      if(X[(i+width)%width][lane] == 1){
        xvel = xvel - 2; //ブレーキをふむと 2速度が減少
        if(xvel < 0) xvel = 0;
        
        
        change = 1;
        break;
      }
    }
  }
  
  //追い越し（レーンチェンジ）を制御する関数
  void lane_ch(){
    
    
    //レーンが0だったら、1へ移動しながら追い越す
    if(lane == 0){ 
      
         ypos = ypos - 3; //y座標を少しずつ移動
         xpos = (xpos + xvel + width) % width; //x座標も移動
         X[xpos][lane] = 0;
         if(xvel < 0){
           xpos = (xpos + int(random(3)) + width) % width;
         }
         X[xpos][lane] = 1;
         
         if(ypos < 30){ 
           //y座標が30より小さくなった時点でレーンチェンジ完了
           change = 0;
           lane = 1;
         
           X[xpos][0] = 0;
           X[xpos][1] = 1;
         }
    }
    
    //レーンが1だったら、0へ移動しながら追い越す
    if(lane == 1){
       ypos = ypos + 3; //y座標を少しずつ移動
       xpos = (xpos + xvel + width) % width;  //x座標も移動
       X[xpos][lane] = 0;
       if(xvel < 0){
         xpos = (xpos + int(random(3)) + width) % width;
       }
       X[xpos][lane] = 1;
       if(ypos > 65){
          //y座標が65より大きくなった時点でレーンチェンジ完了
         change = 0;
         lane = 0;
         
         X[xpos][1] = 0;
         X[xpos][0] = 1;
       }
    
    }
  }
  
 
}

//背景を描画する
void draw_background(){
  noStroke();
  
  //道路を描画
  fill(150,150,150);
  rect(0,10,Length,80);
  
  //中央線を描画
  for(int j=0; j < 40; j++){
    fill(255,255,255);
    rect(0+j*20,50,15,2);
  }
  
}
 
 
void mousePressed() {
 saveFrame("sample_1.png"); 
}
