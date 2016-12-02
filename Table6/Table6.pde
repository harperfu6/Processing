//米国の地図にマルを描画
//マウスによるインタラクション機能を追加します

PImage mapImage;
Table locationTable;
int rowCount;
float count = 0;

Table dataTable;
float dataMin = MAX_FLOAT; 
float dataMax = MIN_FLOAT; 

void setup(){
  size(640,400); 
  
  //フォントをセットします
  //loadFont でロードするファイルは、自分がCreateしたフォント
  //にしてください。
  PFont font = loadFont("AlBayan-12.vlw");
  textFont(font);
  
  mapImage = loadImage("map.png");
  locationTable = new Table("locations.tsv");
  rowCount = locationTable.getRowCount();

  dataTable = new Table("random.tsv");
  
  for(int row = 0; row < rowCount; row++){
    
    float value = dataTable.getFloat(row, 1);
    
    if(value > dataMax){
      dataMax = value;
    }
 
    if(value < dataMin){
      dataMin = value;
    }
  }
  
}


//ここからメインループ
void draw(){
  
  count = count + 0.01;
  float size_rate = abs(sin(count));
  
  background(255);
  image(mapImage, 0, 0);
  
  smooth();
  noStroke();
  
  for(int row=0; row < rowCount; row++){
   String abbrev = dataTable.getRowName(row);
   float x = locationTable.getFloat(row,1);
   float y = locationTable.getFloat(row,2);
   drawData(x, y, abbrev, size_rate); 
  }
  
}

//マルの描画のための関数
//正負を区別して描画
void drawData(float x, float y, String abbrev, float r){

  float value = dataTable.getFloat(abbrev, 1);
  float radius = 0;
  
  //正負の判定をし、色分けします
  if(value >=0){
    radius = map(value, 0, dataMax, 1.5, 15);
    fill(#4422CC);
  }
  else{
    radius = map(value, 0, dataMin, 1.5, 15);
    fill(#FF4422);
  }  
  ellipseMode(RADIUS);
  ellipse(x, y, radius*r, radius*r);
  
  //もし、それぞれのマルにマウスのポインタが近づいて
  // radius+2 未満になったら、その値と、州の名前を描画する
  if(dist(x,y,mouseX, mouseY) < radius+2){
    fill(0);
    textAlign(CENTER);
    text(value + " (" + abbrev + ")", x, y - radius-4);
  }

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