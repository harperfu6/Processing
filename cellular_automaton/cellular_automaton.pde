//最も基本的なセルオートマトンのプログラム
 
CA ca;   // セルオートマトンのクラスの定義

//初期化部
void setup() {
  size(200,200);
  frameRate(12);
  background(0);
  //int[] ruleset = {0,1,0,1,1,0,1,0};    // セルオートマトンの遷移ルールを定義
  int[] ruleset = {1,0,1,1,1,0,0,0};
  ca = new CA(ruleset);                 // セルオートマトンを初期化
}

//メインループ
//画面の一番下にいっても描画し続けるので永久に止まらない
void draw() {
  ca.render();    // セルオートマトンの描画関数を呼び出す
  ca.generate();  // 次の世代のセルオートマトンを計算する関数を呼び出し
}


//セルオートマトンのクラスを定義

class CA {

  int[] cells;     // セルが格納される配列
  int generation;  // 何世代目かを示す指標
  int scl;         // セルの描画サイズの指標　セルは正方形でその一辺に相当
  int[] rules;     // 遷移ルールを格納する配列 


  CA(int[] r) {
    rules = r; //ルール数がセット
    scl = 2; //セルの描画サイズを1辺2画素にセット
    cells = new int[width/scl]; //セルを格納する配列を、描画サイズを考慮しセット
    restart(); //セルオートマトンを初期化
  }
  
  // セルオートマトンの初期化を行う関数
  void restart() {
    for (int i = 0; i < cells.length; i++) {
      cells[i] = int(random(2)); //初期世代のセルをランダムに設定
    }
    generation = 0; //世代をあらわす変数を0にセット
  }

  //次の世代を計算する関数
  void generate() {
   
    //次の世代のセルを格納するための配列を確保
    int[] nextgen = new int[cells.length];
  
    //両端以外の処理
    for (int i = 1; i < cells.length-1; i++) {
      int left = cells[i-1];   // 左の隣接セルをセット
      int me = cells[i];       // 注目セルをセット
      int right = cells[i+1];  // 右の隣接セルをセット
      nextgen[i] = rules(left,me,right); //ルール関数を呼び出し次の世代のセルを計算
    }
    
    //両端の処理 
    int left = cells[cells.length-1];
    int me = cells[0];
    int right = cells[1];
    nextgen[0] = rules(left,me,right);
    
    left = cells[cells.length-2];
    me = cells[cells.length-1];
    right = cells[0];
    nextgen[cells.length-1] = rules(left,me,right);
    
    
    // すべてが計算し終わったら、次の世代を現在の世代にコピーする
    cells = (int[]) nextgen.clone();
    generation++;
  }
  
  //セルの描画部
  void render() {
    //sclの大きさの正方形を、水平方向に左から右へ描画
    //世代が大きくなるほど、画面下に描画されるようになる
    for (int i = 0; i < cells.length; i++) {
      if (cells[i] == 1) fill(255);
      else               fill(0);
      noStroke();
      rect(i*scl,generation*scl, scl, scl); 
    }
  }
  
  //遷移ルールに従い、次の世代のセルを計算する部分
  // ここでaは左隣、bは注目セル、cは右隣のセルに相当
  int rules (int a, int b, int c) {
    if (a == 1 && b == 1 && c == 1) return rules[0];
    if (a == 1 && b == 1 && c == 0) return rules[1];
    if (a == 1 && b == 0 && c == 1) return rules[2];
    if (a == 1 && b == 0 && c == 0) return rules[3];
    if (a == 0 && b == 1 && c == 1) return rules[4];
    if (a == 0 && b == 1 && c == 0) return rules[5];
    if (a == 0 && b == 0 && c == 1) return rules[6];
    if (a == 0 && b == 0 && c == 0) return rules[7];
    return 0;
  }
 
}
