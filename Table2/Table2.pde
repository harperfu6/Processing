//米国の地図にマルを描画

PImage mapImage;
Table locationTable;
int rowCount;

//変更点
//dataTable という変数を追加
Table dataTable;
float dataMin = MAX_FLOAT; //MAX_FLOATというのは浮動小数点の中で一番大きいものを意味する
float dataMax = MIN_FLOAT; //MAX_FLOATというのは浮動小数点の中で一番小さいものを意味する


void setup(){
  size(640,400); 
  mapImage = loadImage("map.png");
  locationTable = new Table("locations.tsv");
  rowCount = locationTable.getRowCount();
  
  //変更点
  //ここで random.tsv というTSV形式のファイルを読み込む 
  //注意点　random.tsv と location.tsv の行数は一致させていなければならない
  dataTable = new Table("random.tsv");
  
  // random.tsv の中身を読みだして、最大値と最小値を確定する
  for(int row = 0; row < rowCount; row++){
    
    // random.tsv の row行目の値を読みだす
    float value = dataTable.getFloat(row, 1);
    
    //現在の最大値よりも大きければ、値を更新
    if(value > dataMax){
      dataMax = value;
    }
    //現在の最小値よりも小さければ、値を更新
    if(value < dataMin){
      dataMin = value;
    }
  }
  
}


//ここからメインループ
void draw(){
  
  background(255);
  image(mapImage, 0, 0);
  
  smooth();
  fill(192,0,0);
  noStroke();
  
  for(int row=0; row < rowCount; row++){
   String abbrev = dataTable.getRowName(row);
   float x = locationTable.getFloat(row,1);
   float y = locationTable.getFloat(row,2);
   drawData(x, y, abbrev); //※変更点　描画のための関数に変わっている
  }
  
}

//マルの描画のための関数
void drawData(float x, float y, String abbrev){

  //random.tsv の abbrev行目のデータを読みだす 
  float value = dataTable.getFloat(abbrev, 1);
  
  //mapという関数については、英語のリファレンスマニュアルに詳細があるので
  //そちらも参考に。
  //mapという関数は、最小値 dataMin を 2 に対応
  //最大値 dataMax を 40 に対応させる。
  // value という値が入ってきた場合、2 から 40 のどれに対応
  // するのかを、dataMax と dataMin を考慮しながら割り当てる関数
  float mapped = map(value, dataMin, dataMax, 2, 40);
  
  //map関数で計算された大きさ mapped がマルの大きさに対応
  //最大値をとる場合、mapped = 40、最小値をとう場合 mapped = 2 となる
  ellipse(x, y, mapped, mapped);  

}


class Table {
  String[][] data;
  int rowCount;
  
  
  Table() {
    data = new String[10][10];
  }

  
  Table(String filename) {
    String[] rows = loadStrings(filename);
    data = new String[rows.length][];
    
    for (int i = 0; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }
      
      // split the row on the tabs
      String[] pieces = split(rows[i], TAB);
      // copy to the table array
      data[rowCount] = pieces;
      rowCount++;
      
      // this could be done in one fell swoop via:
      //data[rowCount++] = split(rows[i], TAB);
    }
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  }


  int getRowCount() {
    return rowCount;
  }
  
  
  // find a row by its name, returns -1 if no row found
  int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (data[i][0].equals(name)) {
        return i;
      }
    }
    println("No row named '" + name + "' was found");
    return -1;
  }
  
  
  String getRowName(int row) {
    return getString(row, 0);
  }


  String getString(int rowIndex, int column) {
    return data[rowIndex][column];
  }

  
  String getString(String rowName, int column) {
    return getString(getRowIndex(rowName), column);
  }

  
  int getInt(String rowName, int column) {
    return parseInt(getString(rowName, column));
  }

  
  int getInt(int rowIndex, int column) {
    return parseInt(getString(rowIndex, column));
  }

  
  float getFloat(String rowName, int column) {
    return parseFloat(getString(rowName, column));
  }

  
  float getFloat(int rowIndex, int column) {
    return parseFloat(getString(rowIndex, column));
  }
  
  
  void setRowName(int row, String what) {
    data[row][0] = what;
  }


  void setString(int rowIndex, int column, String what) {
    data[rowIndex][column] = what;
  }

  
  void setString(String rowName, int column, String what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = what;
  }

  
  void setInt(int rowIndex, int column, int what) {
    data[rowIndex][column] = str(what);
  }

  
  void setInt(String rowName, int column, int what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }

  
  void setFloat(int rowIndex, int column, float what) {
    data[rowIndex][column] = str(what);
  }


  void setFloat(String rowName, int column, float what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }
  
  
  // Write this table as a TSV file
  void write(PrintWriter writer) {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < data[i].length; j++) {
        if (j != 0) {
          writer.print(TAB);
        }
        if (data[i][j] != null) {
          writer.print(data[i][j]);
        }
      }
      writer.println();
    }
    writer.flush();
  }
}
