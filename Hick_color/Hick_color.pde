PrintWriter output;

StringList colorList;
int count = 0;
int pushNum = 0;
String colorName;
boolean changeColor = true;
int rightNum;
int rightIndex;
int[] displayNum = new int[4];

float[] record = new float[20];
int recordIndex = 0;
boolean write;

int pushCount = 1;
PFont font2;

void setup(){
  size(400,500);
  PFont font = createFont("MS Gothic",48,true);
  font2 = createFont("MS Gothic",20,true);
  textFont(font);
  colorList = new StringList();
  colorList.append("無");
  colorList.append("青");
  colorList.append("赤");
  colorList.append("緑");
  colorList.append("黄");
  colorList.append("紫");
  colorList.append("白");
  colorList.append("黒");
  colorList.append("灰色");
  colorList.append("橙");
  colorList.append("茶");
  
  for(int i = 0; i < 4; i++){
    displayNum[i] = 0;
  }
  
  output = createWriter("name_and_color" + ".csv"); 
}

void draw(){
  background(200,200,200);
  
  if(recordIndex == 20){
    text("finish!!", 50, 50);
    for(float f : record){
      println(f);
      output.println(f);
    }
    output.flush(); 
    output.close(); 
    exit();  
  }
  
  else{
  count++;
  
  if(changeColor){
    rightNum = (int)random(10) + 1;
    colorName = colorList.get(rightNum);
    //displayNum[0] = rightNum;
  }
  fill(0);
  textSize(50);
  text(colorName, 50, 50);
  
  text(pushCount, 300, 50);

  if(changeColor){
    for(int i = 0; i < 4; i++){
      displayNum[i] = 0;
    }
    rightIndex = (int)random(4);
    displayNum[rightIndex] = rightNum;
  }
  
  for(int i = 0; i < 4; i++){
    pushStyle();
    if(i == rightIndex){
      //drawColor(rightNum);
    }
    else if(changeColor){
      boolean find = false;
      int num = 0;
      while(true){
        num = (int)random(10) + 1;
        for(int n : displayNum){
          if(num == n){
            find = true;
            break;
          }
          else{
            find = false;
          }
        }
        if(find != true){
          break;
        }
      }
      //drawColor(num);
      
      
      if(displayNum[i] == 0){
        displayNum[i] = num;
      }
      else{
        displayNum[i+1] = num;
      }
      
      if(i == 3){
        changeColor = false;
      }
    }
    drawColor(displayNum[i]);
    
    rect(10, i*40+100, 200, 30);
    
    pushMatrix();
    translate(100, i*40+120);
    pushStyle();
    if(displayNum[i] == 6){
      fill(0);
      //fill(255);
    }
    else{
      fill(255);
    }
    textFont(font2);
    drawCharacter(displayNum[i]);
    popStyle();
    popMatrix();
    
    popStyle();
  }
  
  text("time: " + (float)count / 60, 50, 300);

}

}

void keyPressed(){
  if(key == '1'){
    if(rightIndex + 1 == 1){
      record[recordIndex++] = (float)count / 60;
      changeColor = true;
      count = 0;
      pushCount++;
    }
  }
  else if(key == '2'){
    if(rightIndex + 1 == 2){
      record[recordIndex++] = (float)count / 60;
      changeColor = true;
      count = 0;
      pushCount++;
    }
  }
  else if(key == '3'){
    if(rightIndex + 1 == 3){
      record[recordIndex++] = (float)count / 60;
      changeColor = true;
      count = 0;
      pushCount++;
    }
  }
  else if(key == '4'){
    if(rightIndex + 1 == 4){
      record[recordIndex++] = (float)count / 60;
      changeColor = true;
      count = 0;
      pushCount++;
    }
  }
}

void mousePressed( ){
  if(mouseX > 10 && mouseX < 210){
    if(mouseY > 100 && mouseY < 130){
    }
    else if(mouseY > 140 && mouseY < 170){
    }
    else if(mouseY > 180 && mouseY < 210){
    }
    else if(mouseY > 220 && mouseY < 250){
    }
  }
}

void drawColor(int num){
  switch(num){
    case 1:
      fill(0,0,255);
      break;
    case 2:
      fill(255,0,0);
      break;
    case 3:
      fill(0,255,0);
      break;
    case 4:
      fill(255,255,0);
      break;
    case 5:
      fill(255,0,255);
      break;
    case 6:
      fill(255,255,255);
      break;
    case 7:
      fill(0,0,0);
      break;
    case 8:
      fill(125,125,125);
      break;
    case 9:
      fill(255,165,0);
      break;
    case 10:
      fill(139,69,19);
      break;
  }
}

void drawCharacter(int num){
  switch(num){
    case 1:
      text("Blue",0,0);
      break;
    case 2:
      text("Red",0,0);
      break;
    case 3:
      text("Green",0,0);
      break;
    case 4:
      text("Yellow",0,0);
      break;
    case 5:
      text("Purple",0,0);
      break;
    case 6:
      text("White",0,0);
      break;
    case 7:
      text("Black",0,0);
      break;
    case 8:
      text("Gray",0,0);
      break;
    case 9:
      text("Orange",0,0);
      break;
    case 10:
      text("Brown",0,0);
      break;
  }
}
