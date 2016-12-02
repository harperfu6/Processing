//マルチエージェントシミュレータ 
// レベル2　+ 食べ物・体力を回復の概念を導入
// by Hajime Nobuhara

int Length = 400; //空間管理配列の大きさ
int Max_Human = 100; //シミュレータに登場させる人間の数
int current_Human = 20;
int increase_num;

//空間管理配列を準備
int[][] MAP = new int[Length][Length]; 

//人間の配列を準備
Human_class[] Human = new Human_class[Max_Human];


int season_count = 0; //季節の移り変わりカウンター
int allSeason_count = 1000;
int season = 0; //季節: 春0, 夏1, 秋2, 冬3


//初期化部
void setup() {
  colorMode(HSB);
  size(Length, Length);
  background(0);
  frameRate(30);

  //ここで人間を生成
  for(int i=0; i < current_Human; i++){
     int k1 = 1; //生きている人間の状態を1、死んでいる場合は 0
     int k2 = int(random(width)); //登場する初期 x座標
     int k3 = int(random(height)); //登場する初期 y座標
     int k4 = int(random(5)); //人間の動作方向をランダムにセット
     int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
     int k6 = 1000 + int(random(200)); //1000~1200の範囲で体力をセット
     Human[i] = new Human_class(k1,k2,k3,k4,k5,k6);
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
 makeground(season_count++);

 increase_num = 0;
 //人間を描画
 for(int j=0; j < current_Human; j++){
  
  //生きている人間だけ処理 
   if(Human[j].type == 1){
     Human[j].timer ++;  //人間の体内時計を1つカウントアップ
     //人間を描画
     //アニメーションを使っており、体内時計に合わせて動く
     Human[j].draw(); 
     
     Human[j].hp = Human[j].hp - 1; //1単位時間で体力を1減らす

     if(Human[j].hp < 0){
       Human[j].type = 0;  //もし体力が0になったら、状態を死に変更
       MAP[Human[j].xpos][Human[j].ypos] = 0;  //状態管理の配列から消去
     }
     
     //hpの値によって増殖
     if(current_Human < Max_Human){
       if(Human[j].hp > 1200){
         
         int k1 = 1; //生きている人間の状態を1、死んでいる場合は 0
         int k2 = (Human[j].xpos + 10 + width) % width; //近くに登場
         int k3 = (Human[j].ypos + 10 + height) % height; //近くに登場
         int k4 = int(random(5)); //人間の動作方向をランダムにセット
         int k5 = int(random(5)); //人間の体内時計を0～4の間でセット
         int k6 = 1000 + int(random(200)); //200~400の範囲で体力をセット
         Human[current_Human + increase_num] = new Human_class(k1,k2,k3,k4,k5,k6);//新しく人を生成
         Human[j].hp = 1000 + int(random(200)); //産みの体力
         increase_num++;
         println("make!!");
       }
     } 
   }
 }
 
 println("increase: " + increase_num);
 current_Human += increase_num;

  //人間を動かす
  for(int j=0; j < current_Human; j++){
     if(Human[j].type == 1){
       Human[j].drive();
     }
  }
  
  //お互いの衝突判定
  for(int j=0; j < current_Human; j++){
    if(Human[j].type == 1){
     Human[j].coll();
    }
  }
  
  //食べ物の追跡
  for(int j=0; j < current_Human; j++){
     if(Human[j].type == 1){
       Human[j].eat();
    }
  }
  
  //食べ物を発生
  switch(season){
    case 0:
      if(int(random(1000)) < 80){
        MAP[int(random(Length))][int(random(Length))] = 2;
      }
      break;
    case 1:
      if(int(random(1000)) < 200){
        MAP[int(random(Length))][int(random(Length))] = 2;
      }
      break;
    case 2:
      if(int(random(1000)) < 100){
        MAP[int(random(Length))][int(random(Length))] = 2;
      }
      break;
    case 3:
      if(int(random(1000)) < 20){
        MAP[int(random(Length))][int(random(Length))] = 2;
      }
      break;
  }
  
  //食べ物を描画(ミカンのようなもの)
  for(int i=0; i < Length ; i++){
    for(int j=0; j < Length; j++){
      if(MAP[i][j] == 2){
        fill(30,255,255);
        ellipse(i,j,10,10);
        fill(35,255,255);
        ellipse(i,j,8,8);
        fill(45,255,255);
        ellipse(i,j,5,5);
        
        stroke(145,255,255);
        line(i-1,j-5,i-1,j-8); 
        line(i,j-5,i,j-7); 
        noStroke();    
      } 
    }
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
  int hp; //体力
    
  Human_class(int c, int xp, int yp, int dirt, int t, int h) {
    xpos = xp;
    ypos = yp;
    type = c;
    direction = dirt;
    timer = t;
    hp = h;
  }



 //人間を描画する部分
  void draw () {
 
    smooth();
    noStroke();
    
    //体力によって色を変更しましょう
    
    
    fill(100,255,255); //健康な状態
    
    if(hp < 100){
      fill(40,255,255); //体力が落ち始めた状態
    }
  
    if(hp < 50){
       fill(10,255,255); //危険な状態
    }   
       
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
  
  
  //食べ物の獲得
  
  void eat(){
    
    int action = 0;
    
    for(int r = 0; r < 100; r++){
      for(int s = 0; s < 360; s=s+10){
          
      int i = int(r * cos(radians(s)));
      int j = int(r * sin(radians(s)));
          
      if ((MAP[(xpos+i+width) % width][(ypos+j+height) % height] == 2)){       
        
            MAP[xpos][ypos] = 0;
             
            if((i > 0)&&(action==0)){
              direction = 1;
              xpos = (xpos + 1 + width) % width; //右に動かす
              action = 1;
            }
            
            if((i < 0)&&(action==0)){
               direction = 2;
               xpos = (xpos - 1 + width) % width; //左に動かす
               action = 1;
            }
          
            if((j > 0)&&(action==0)){
              direction = 3;
              ypos = (ypos + 1 + height) % height; //下に動かす
              action = 1;
            }
            if((j < 0)&&(action==0)){
              direction = 4;
              ypos = (ypos - 1 + height) % height; //上に動かす
              action = 1;
            }       
      }
      if(action == 1)
       break;
      }
    }
    
      //もし食料のところへたどり着いたら、
            //エネルギーが回復
            if((MAP[xpos][ypos] == 2)){
              hp = hp + 500;
              
            }
            
            MAP[xpos][ypos] = 1;
  }
  
  
  
}


//背景を描画
void makeground(int _season_count){
  
  pushStyle();
  colorMode(RGB);
  
  _season_count = (_season_count + allSeason_count) % allSeason_count;
  if(_season_count >= 0 && _season_count < allSeason_count / 4){
    fill(255, 228, 225);
    season = 0;
  }
  else if(_season_count >= allSeason_count / 4 && _season_count < allSeason_count / 2){
    fill(175, 238, 238);
    season = 1;
  }
  else if(_season_count >= allSeason_count / 2 && _season_count < allSeason_count * 3 / 4){
    fill(240, 230, 140);
    season = 2;
  }
  else{
    fill(230, 230, 230);
    season = 3;
  }
  
  rect(0,0,width,height);
  popStyle();
  
  //println(_season_count);
}

void mousePressed() {
 saveFrame("human3.png"); 
}
