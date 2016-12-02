CA ca;   // セルオートマトンのクラスの定義
int counter = 0; //状態遷移ルールを管理するカウンター 0から出発

//初期化部
void setup() {
  size(200,200);
  frameRate(30); //フレームレートは速めに設定
  background(0); 
  int[] ruleset = {0,0,0,0,0,0,0,0};    // 状態遷移ルールはルール0からスタート
  ca = new CA(ruleset);                 // セルオートマトンの初期化
}


//メインループ
void draw() {
  ca.render();    //セルオートマトンの描画関数を呼び出し
  ca.generate();  //次の世代のセルを計算する関数を呼び出し
  
  //もし画面一番下まで描画し終えたら if文の中を実行
  if (ca.finished()) {   //ca.finishedは、画面一番下まで描画したか否かの判定
    save("./data/rule" + counter + ".png");
    background(0); //画面を黒で塗りなおし
    counter = counter + 1; //状態遷移ルールを1つインクリメント
    ca.rule_update(); //状態遷移ルールをセット
    ca.restart(); //セルの初期化
    println("class : " + counter);
  }
  
  if(counter == 255){
    exit();
  }
}

//もしマウスのボタンがクリックされたら
//同じ遷移ルールで、セルの初期状態だけ変更し、計算をやりなおす
void mousePressed() {
  background(0);
  ca.restart();
}

//セルオートマトンのクラスの定義本体

class CA {
  int[] cells;     //セルの配列を確保
  int generation;  //セルオートマトンの世代を管理する変数
  int scl;         //セルの描画サイズ
  int[] rules;     //状態遷移ルールを保存する配列

  CA(int[] r) {
    rules = r;
    scl = 2;
    cells = new int[width/scl]; 
    restart();
  }
  
  // 状態遷移ルールをセットする関数
  void setRules(int[] r) {
    rules = r;
  }
  
  // 状態遷移ルールを更新する関数
  void rule_update() {
    int k = counter; //変数k に状態遷移ルールのカウンターをセット
    for (int i = 0; i < 8; i++) {
     rules[7-i] = int (k % 2); //ビットシフト操作で、ルールをセットしてゆく
     k = int(k / 2); 
    }
  }
  
  // セル状態を初期化
  void restart() {
    for (int i = 0; i < cells.length; i++) {
      cells[i] = int(random(2));
    }
    generation = 0;
  }

  // 次の世代のセルを計算する関数
  void generate() {
    int[] nextgen = new int[cells.length]; //次の世代のセルを保管する配列
    
    for (int i = 1; i < cells.length-1; i++) {
      int left = cells[i-1];   
      int me = cells[i];       
      int right = cells[i+1];  
      nextgen[i] = rules(left,me,right);
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
    
    //次の世代の配列を、現在の世代にコピー
    cells = (int[]) nextgen.clone();
    generation++;
  }
  
  // セルを描画する関数
  void render() {
    for (int i = 0; i < cells.length; i++) {
      if (cells[i] == 1) fill(255);
      else               fill(0);
      noStroke();
      rect(i*scl,generation*scl, scl,scl);
    }
  }
  
  //次のセルを計算
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
  
  //もし画面の一番下まで描画が終わったら、trueを返す
  boolean finished() {
    if (generation > height/scl) {
       return true;
    } else {
       return false;
    }
  }
}
