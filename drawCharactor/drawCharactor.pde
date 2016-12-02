import org.rosuda.REngine.Rserve.*;
import org.rosuda.REngine.*;

PrintWriter output;
int[][] data = new int[50][50];
int count = 0;
boolean study = false;
String[] number = new String[100];
boolean drawResult;

void setup(){

  background(255);
  size(150, 150);
  
  output = createWriter("/Users/harper/Documents/R/charactor/tmp.txt");
  reWrite();
}

void draw(){
  noFill();
  rect(50,50,50,50);
  
  
  if(number[0] != null && drawResult){
    //println("aaa");
    pushStyle();
    fill(0);
    textSize(24);
    text(number[count - 1], 10, 30);
    popStyle();
  }
}

void stop(){
  output.close();
}

void reWrite(){
  for(int i = 0; i < 50; i++){
    for(int j = 0; j < 50; j++){
      data[i][j] = 0;
    }
  }
}

void saveData(){
  for(int i = 0; i < 50; i++){
    for(int j = 0; j < 50; j++){
      output.print(data[i][j]);
      output.print(" ");
    }
    //output.println("");
    //output.flush();
  }
  //output.println("one");
  output.println("");
  output.flush();
}


void mouseDragged(){
  
  fill(0);
  ellipse(mouseX, mouseY, 3, 3);
  
  //if(study){
    for(int i = -3; i < 3; i++){
      for(int j = -3; j < 3; j++){
      /*
      if(mouseX + i < 0 && mouseY + j < 0){
        data[0][0] = 1;
      }
      else if(mouseX + i < 25 && mouseY + j > 75){
        data[0][49] = 1;
      }
      else if(mouseX + i > 75 && mouseY + j < 25){
        data[49][0] = 1;
      }
      else if(mouseX + i > 75 && mouseY + j > 25){
        data[49][49] = 1;
      }
      else if(mouseX + i < 25){
        data[0][mouseY + j] = 1;
      }
      else if(mouseX + i > 75){
        data[49][mouseY + j] = 1;
      }
      else if(mouseY + j < 25){
        data[mouseX + i][0] = 1;
      }
      else if(mouseY + j > 75){
        data[mouseX + i][49] = 1;
      }
      else{
        data[mouseX + i][mouseY + j] = 1;
      }
      */
        //println(""+mouseX+ ", " + mouseY);
        data[mouseX + i - 50][mouseY + j - 50] = 1;
      }
    }
  //}
}

void keyPressed(){
  if(key == 's'){
    study = true;
    background(255, 228, 255);
    drawResult = false;
  }
  if(key == 'w'){
    study = false;
    background(255);
    drawResult = false;
  }
  
  if(key == 'c'){
    if(study){
      saveData();
      reWrite();
      //println(++count);
      //background(255, 228, 255);
    }
    else{
      saveData();
      try {
        RConnection c = new RConnection();  
        // generate 100 normal distributed random numbers and then sort them 
        c.eval("setwd('/Users/harper/Documents/R/charactor')");
        c.eval("source('charactorSVM.R')");
        number = c.eval("result").asStrings();
        
        println("GETNUMBER: " + number[count++]);
        //tmp = c.eval("sort(rnorm(100))").asDoubles();

      } catch ( REXPMismatchException rme ) {
        rme.printStackTrace();

      } catch ( REngineException ree ) {
        ree.printStackTrace();
      }
      reWrite();
      //println(++count);
      //background(255);
      drawResult = true;
    }
  }
}
