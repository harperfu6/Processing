//米国の地図にマルを描画
//正負を区別して描画しましょう

PImage mapImage;
Table locationTable;
int rowCount;

Table dataTable;
float dataMin = MAX_FLOAT; 
float dataMax = MIN_FLOAT; 

void setup(){
  size(640,400); 
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
  
  background(255);
  image(mapImage, 0, 0);
  
  smooth();
  noStroke();
  
  for(int row=0; row < rowCount; row++){
   String abbrev = dataTable.getRowName(row);
   float x = locationTable.getFloat(row,1);
   float y = locationTable.getFloat(row,2);
   drawData(x, y, abbrev); 
  }
  
}

//マルの描画のための関数
//正負を区別して描画
void drawData(float x, float y, String abbrev){

  float value = dataTable.getFloat(abbrev, 1);
  float diameter = 0;
  
  //値が正の場合 (0も含む)
  if (value >= 0) {
    diameter = map(value, 0, dataMax, 3, 30);
    fill(#333366); //青色を設定
  }
  else{
  //値が負の場合
    diameter = map(value, 0, dataMax, 3, 30);
    fill(#EC5166); //赤色を設定
  }
  
  //正負によって色を変更
  //また、絶対値の大きさによってマルのサイズを調整
  ellipse(x, y, diameter, diameter);  

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
