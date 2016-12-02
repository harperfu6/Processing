//ちょっと色っぽい森林火災シミュレータ「めぐみさん」
//Hajime Nobuhara  
//隣接画素の判定は4方向

int sx, sy; //2次元セルを管理する縦と横の長さ
float density = 65; //木の存在確率 
float moe = 100; //木の燃えやすさ
int[][][] world; //各セルを管理する配列
color [][] world_c; 
int b_size = 5;

int direction = 2; //"NW: 1" "NE: 2", "SW: 3", "SE: 4" //風の向き
float wind = 100; //風の強さ



//初期化部
void setup() 
{ 
  size(500, 500); //描画窓は500x500
  frameRate(5); //フレームレートは5
  color(HSB);
  sx = width / b_size; //2次元セルの管理配列の横の長さ
  sy = height / b_size; //2次元セルの管理配列の縦の長さ

   //sx * sy の大きさの配列を2つ準備
   //ここで、1つめは現在の世代、2つめは次の世代を保管するために使う
  world = new int[sx][sy][2];
  world_c = new color[sx][sy]; //各木の色を管理する変数

   
  for(int i = 0; i < sx; i++){
     for(int j = 0; j < sy; j++){
       
      if(random(10000) < density * 100){
        //木の色をランダムにする
        //ただし、森らしくみえる範囲で
        world[i][j][1] = 1; 
        world_c[i][j] = color(random(200),random(30)+200,random(50));
      }
     else{
       world[i][j][1] = 0;  
     }
     }
  }
  
  for(int i = 0; i < 25; i++){
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
        //ここで生きている木を描画します
        stroke(world_c[x][y]);
        point(x*b_size+2, y*b_size); 
        line(x*b_size+1, y*b_size+1, x*b_size+3, y*b_size+1);
        line(x*b_size+1, y*b_size+2, x*b_size+3, y*b_size+2);
        line(x*b_size, y*b_size+3, x*b_size+4, y*b_size+3);
        point(x*b_size+2, y*b_size+4); 
      } 
      if (world[x][y][1] == -1) 
      { 
         //ここで死んでいる木を描画します
        stroke(200,200,200);
        point(x*b_size+2, y*b_size); 
        line(x*b_size+1, y*b_size+1, x*b_size+3, y*b_size+1);
        line(x*b_size+1, y*b_size+2, x*b_size+3, y*b_size+2);
        line(x*b_size, y*b_size+3, x*b_size+4, y*b_size+3);
        point(x*b_size+2, y*b_size+4); 
        //world[x][y][0] = 0; 木が死んでしまったら、0にする
      }
      
      if (world[x][y][1] == 2) 
      { 
        world[x][y][0] = 2; 
         //ここで燃える木を描画します
        stroke(255,0,0);
        point(x*b_size+2, y*b_size); 
        line(x*b_size+1, y*b_size+1, x*b_size+3, y*b_size+1);
        line(x*b_size+1, y*b_size+2, x*b_size+3, y*b_size+2);
        line(x*b_size, y*b_size+3, x*b_size+4, y*b_size+3);
        point(x*b_size+2, y*b_size+4); 
        
      } 
      world[x][y][1] = 0; 
    } 
  } 
  
  // 各木の生死判定　
  for (int x = 0; x < sx; x=x+1) { 
    for (int y = 0; y < sy; y=y+1) { 
      
      //周囲の木の状態を判定
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
      if (world[x][y][0] == 2)
      { 
        world[x][y][1] = -1; 
      } 
     
      
    } 
  } 
} 
 
//周囲の木の燃え具合を判定する関数
int neighbors(int x, int y) 
{ 
  int i = 0;
  
  float r = random(100); //風の強さの影響
  
  switch(direction){
    case 1:
      if(world[(x + sx - 1) % sx][y][0] == 2){
        i++;
      }
      if(world[x][(y + sy - 1) % sy][0] == 2){
        i++;
      }
      if(world[(x + 1) % sx][y][0] == 2){
        if(wind < r)
        i++;
      }
      if(world[x][(y + 1) % sy][0] == 2){
        if(wind < r)
        i++;
      }
      break;
     case 2:
      if(world[(x + sx - 1) % sx][y][0] == 2){
        if(wind < r)
        i++;
      }
      if(world[x][(y + sy - 1) % sy][0] == 2){
        i++;
      }      
       if(world[(x + 1) % sx][y][0] == 2){
        i++;
      }
      if(world[x][(y + 1) % sy][0] == 2){
        if(wind < r)
        i++;
      }
      break;
     case 3:
      if(world[(x + sx - 1) % sx][y][0] == 2){
        i++;
      }
      if(world[x][(y + sy - 1) % sy][0] == 2){
        if(wind < r)
        i++;
      }      
       if(world[(x + 1) % sx][y][0] == 2){
        if(wind < r)
        i++;
      }
      if(world[x][(y + 1) % sy][0] == 2){
        i++;
      }
      break;
     case 4:
      if(world[(x + sx - 1) % sx][y][0] == 2){
        if(wind < r)
        i++;
      }
      if(world[x][(y + sy - 1) % sy][0] == 2){
        if(wind < r)
        i++;
      }      
       if(world[(x + 1) % sx][y][0] == 2){
        i++;
      }
      if(world[x][(y + 1) % sy][0] == 2){
        i++;
      }
      break;
  }
 
 return i; 
           
} 

 
void mousePressed() {
 saveFrame("sample_4.png"); 
}


