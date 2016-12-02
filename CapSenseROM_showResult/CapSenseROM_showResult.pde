import processing.serial.*;

Serial myPort;
PFont display;
float value = 0; //Real Time value (1 frame)
float[] last10Values = new float[10]; //To calclate average value of last 10 frames
ArrayList<Float> aveValuesArray = new ArrayList<Float>();
String ROM = "";
boolean isStartedRead = false;

int zero_threshold = 450;
int one_threshold = 700;

float tmpAveValue = 0;
int tmpCount = 0;

void setup() {

  size(1500, 250); //width = 500*n

  myPort = new Serial(this, "/dev/cu.usbmodem1421", 9600);

  display = loadFont("Serif-48.vlw");
  textFont(display, 48);

}

void draw() {

  background(10);

  float aveValue = getAverageValue(last10Values, value);


  if(!isStartedRead){
    if(value > 400){
      isStartedRead = true;
    }
  }
  else{
    
    //use rare data  
    tmpCount++;
    tmpAveValue += value;
    
    
    if(aveValue > 400){
      aveValuesArray.add(aveValue);
      //print(aveValue);
      //print(" ");
    }
    if(value < 400){
      isStartedRead = false;
      
      tmpAveValue /= tmpCount;
      println(tmpAveValue);
      
      if(tmpAveValue > one_threshold){
        ROM += "1";
      }
      else if(tmpAveValue > zero_threshold){
        ROM += "0";
      }
      else{
        
      }
      
      tmpAveValue = 0;
      tmpCount = 0;
      
      //use average data
      //ROM += getBin(aveValuesArray);
      println();
      
      
      aveValuesArray.clear();
    }
  }
  
  text(str(aveValue), 10, 50);
  text(ROM, 10, 150);
  
}

float getAverageValue(float[] values, float newValue){
  
  float ave = 0;
  
  for(int i = 0; i < values.length - 1; i++){
    values[i] = values[i+1];
    ave += values[i+1];
  }
  
  values[values.length-1] = newValue;
  ave += newValue;
  ave /= values.length;
  
  return ave;
}

String getBin(ArrayList<Float> data){
  
  float aveData = 0;
  for(int i = 0; i < data.size(); i++){
    aveData += data.get(i);
  }
  aveData /= data.size();
  
  println(aveData);
  if(aveData > one_threshold){
    return "1";
  }
  else if(aveData > zero_threshold){
    return "0";
  }
  else{
    return "-";
  }
}

void keyPressed() {
  if (key == 'c') {
    ROM = "";
    println("------------------------");
  }
}


void serialEvent(Serial myPort) {
  if (myPort.available() > 0) {
    String cur = myPort.readStringUntil('\n');
    if (cur != null) {
      value = float(cur);
    }
  }
}