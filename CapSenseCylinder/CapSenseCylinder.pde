
import processing.serial.*;

Serial myPort;
PFont display;
int NUM = 1;
int x;
int cnt = 0;//counter

int[][] sensors = new int[NUM][500];
color[] col = new color[NUM];

int[] feature = new int[10];
int[] lowpass = new int[2];

float lowpassW = 0;
int downIndex = 0;
boolean isDowned = false;
int downValue;
String result = "NONE";
String resultStr = "";
int[] group = new int[70];
int getTime = 0;
//ArrayList<Integer> group_data = new ArrayList<Integer>(); 

void setup(){

  size(1500, 250); //width = 500*n

  myPort = new Serial(this, "/dev/cu.usbmodem1421", 9600);

  sensors[0][0] = 0;
  group[0] = 0;
  lowpass[0] = 0;
  lowpass[1] = 0;
  display = loadFont("Serif-48.vlw");

  //initGraph();
}

void draw(){

  background(10);
  strokeWeight(2);
  stroke(255, 127, 31);

  for(int i = 0; i < NUM; i++){
    for(int j = 0; j < sensors[i].length-1; j++){
      line(3*j, convToGraphPoint(sensors[i][j]), 3*(j+1), convToGraphPoint(sensors[i][j+1]));//x position = j*n
    }
  }

  //result = recognize(feature);

  //textFont(display, 48);
  //text(result, 10, 50);
  
  
  
  //resultStr = checkGroup(group);

  //if(resultStr.length() == 6){
    //textFont(display, 48);
    //text(resultStr, 300, 50);
  //}


  //if(cnt > width){
  //  initGraph();
  //}
  //cnt++;
}

void initGraph(){

  colorMode(RGB, 255);
  background(0);
  noStroke();
  cnt = 0;

  col[0] = color(255, 127, 31);

}

void serialEvent(Serial myPort){

  if(myPort.available() >= 3){//header+highByte+lowByte
    if(myPort.read() == 'H'){
            //println("get H!!");
      int high = myPort.read();
      int low = myPort.read();
      x = high*256+low;
      //x *= 10;
      x = (int)map(x, 0, 1500*10, 0, 1024);
      
      //update lowpass array (latest data is in last index)
      for(int i = 0; i < sensors[0].length-1; i++){
        sensors[0][i] = sensors[0][i+1];
      }
      
      //for(int i = 0; i < group.length-1; i++){
      //  group[i] = group[i+1];
      //}

      //for(int i = 0; i < feature.length-1; i++){
      //  feature[i] = feature[i+1];
      //}

      lowpass[1] = (int)(lowpassW * lowpass[0] + (1-lowpassW) * x);

      //latest data is in last index
      sensors[0][sensors[0].length-1] = lowpass[1];
      //feature[feature.length-1] = lowpass[1];
      //group[group.length-1] = lowpass[1];
      //println(lowpass[1]);
      
      //last lowpass is index 0
      lowpass[0] = lowpass[1];

    }
  }
}

float convToGraphPoint(int value){
  return (height - value*height/1024.0);
}

//String checkGroup(int array[]){
  
//  int maxValue = 0;
//  int preValue = 0;
//  boolean isGetValue = false;
//  int peak_count = 0;
//  boolean isDrop = false;
//  int[] peakArray = new int[50];
//  //String result = "";
  
//  if(millis() - getTime > 3000){
//    if(array[5] > 50){
//      println("gesture!!");
//      getTime = millis();
//      resultStr = "";
      
//      for(int i = 0; i < array.length; i++){
//        println(array[i]);
//        if(array[i] > maxValue){
//          maxValue = array[i];
//        }
//        if(array[i] > 50 || preValue > 50){
//          //if(isDrop && array[i] < preValue)
//          if(array[i] > preValue){
//            //preValue = array[i];
//            isDrop = false;
//          }
//          else if(!isDrop && array[i] <= preValue){
//            //preValue = array[i];
//            println("up!!");
//            isDrop = true;
            
//            peakArray[peak_count++] = preValue;
            
//            //if(preValue >= 200){
//            //  resultStr += "1";
//            //}
//            //else if(preValue < 200){
//            //  resultStr += "0";
//            //}
//          }
//        }
//        preValue = array[i];
//      }
//      println(peak_count);
//      if(maxValue > 150){
//      for(int i = 0; i < peakArray.length; i++){
        
//        if(peakArray[i] > maxValue - 20 || peakArray[i] > 160){
//      //    isGetValue = false;
//            resultStr += "1";
//        }
//        else if(peakArray[i] > maxValue - 100 || peakArray[i] > 70){
//      //    isGetValue = true;
//          resultStr += "0";
//        }
//      }
//      }
//      else{
//        resultStr = "000000";
//      }
//        //else{
//        //  result
//        //}
//      //  else if(!isGetValue && array[i] > 50 && array[i] > maxValue - 80){
//      //    isGetValue = true;
//      //    resultStr += "0";
//      //  }
//      return resultStr;
//    }
//    else{
//      return resultStr;
//    }
//  }
//  else{
//    return resultStr;
//  }
//}

////calculate peak time
//String recognize(int array[]){

//  int maxValue = 0;
//  int minValue = 10000;
//  int peak_count0 = 0;
//  int peak_count1 = 0;

//  //if(array[0] == downValue){

//    for(int i = 0; i < array.length; i++){
//      if(array[i] >= 135){
//        peak_count1++;
//      }
//      else if(array[i] >= 80){
//        peak_count0++;
//      }

//      if(peak_count1 > 0 || peak_count0 > 0){
//        if(array[i] < 80){
//          isDowned = true;
//          downValue = array[i];
//        }
//      }
//    }

//    //println("peak_count0" + peak_count0);

//    if(peak_count1 >= 2){
//      return "1";
//    }
//    else if(peak_count0 >= 2){
//      return "0";
//    }
//    else{
//      return "NONE";
//    }
//  //}
//  //return "";
//}