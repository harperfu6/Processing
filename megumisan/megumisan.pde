//森林火災シミュレータ「めぐみさん」
//Hajime Nobuhara  
//サイト過程を利用

int sx, sy; //2次元セルを管理する縦と横の長さ
float density = 50; //木の存在確率 
float moe = 100; //
int[][][] world; //各セルを管理する配列

//初期化部
void setup() 
{ 
  size(300, 300); //描画窓は300x300
  frameRate(60); //フレームレートは10
  sx = width; //2次元セルの管理配列の横の長さ
  sy = height; //2次元セルの管理配列の縦の長さ

   //sx * sy の大きさの配列を2つ準備
   //ここで、1つめは現在の世代、2つめは次の世代を保管するために使う
  world = new int[sx][sy][2];

   
  for(int i = 0; i < sx; i++){
     for(int j = 0; j < sy; j++){
       //木の存在確率よりも小さければ木を植える
       //大きければ木は存在しない
      if(random(10000) < density * 100){
        world[i][j][1] = 1; 
      }
     else{
       world[i][j][1] = 0;  
     }
     }
  }
  
  //任意の3点から火事を起こす
  for(int i = 0; i < 3; i++){
    world[(int)random(sx)][(int)random(sy)][1] = 2; 
  }
} 
 
 
 //メインループ
void draw() 
{ 
  background(0); //背景を黒にセット
  
  //描画ループ
  //world[x][y][1]の状態を初期化しながら
  //world[x][y][0]にworld[x][y][1]の状態をコピー
  //但し、world[x][y][1]は特に更新されない場合もあるので
  //その場合を区別するために、1,0,-1の3つの状態使う
  
  for (int x = 0; x < sx; x=x+1) { 
    for (int y = 0; y < sy; y=y+1) { 
   
      if ((world[x][y][1] == 1) || (world[x][y][1] == 0 && world[x][y][0] == 1)) 
      { 
        world[x][y][0] = 1; //もし木が生存していたら、そのまま
        stroke(0,255,0);
        point(x, y); 
      } 
      if (world[x][y][1] == -1) 
      { 
        //木が燃え尽きていれば灰色をプロット
        stroke(200,200,200);
        point(x, y); 
      
      }
      
      if (world[x][y][1] == 2) 
      { 
        world[x][y][0] = 2; // 燃えていたら燃やす
        stroke(255,0,0);
        point(x,y);
        
      } 
      world[x][y][1] = 0; 
    } 
  } 
  
  // 各木の生死判定　
  for (int x = 0; x < sx; x=x+1) { 
    for (int y = 0; y < sy; y=y+1) { 
      
      //周囲の木の状態を判定
      //縦横4方向を調べる
      int count = neighbors(x, y); 
      
      //もし自分自身が生きていて、周囲のセルのうち燃えている木があれば
      //燃えるか否かの判定を行う
      if ((count > 0) && world[x][y][0] == 1) { 
        float r = random(100);
        if(moe > r){
          world[x][y][1] = 2;
        }
        else{
          world[x][y][1] = 1;
        }
      }
     
     //もし自分自身が燃えていたら、死ぬ
      if (world[x][y][0] == 2){ 
        world[x][y][1] = -1; 
      } 
    
    } 
  } 
} 


//周囲の木の燃え具合を判定する関数
//周囲4方向で燃えている木が1本でもあれば
//1以上の値を返す

int neighbors(int x, int y) 
{ 
  int i = 0;
  
  if(world[(x + 1) % sx][y][0] == 2){
    i++;
  }
  if(world[x][(y + 1) % sy][0] == 2){
    i++;
  }
  if(world[(x + sx - 1) % sx][y][0] == 2){
    i++;
  }
 if(world[x][(y + sy - 1) % sy][0] == 2){
   i++;
 }
 
 return i;
 
} 

 

