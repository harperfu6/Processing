import processing.funnel.*;

Arduino arduino;

Pin sensorPin;

final float threshold = 0.08;

void setup(){
  size(400, 400);
  
  PFont font = createFont("CourierNewPSMT", 18);
  textFont(font);
  
  arduino = new Arduino(this, Arduino.FIRMATA);
  sensorPin = arduino.analogPin(0);
}

void draw(){
  background(0);
  
  float value = sensorPin.value;
  
  if(value > threshold){
    int range = round((6787 / (value * 1023 -3)) - 4);
    test("Range: " + range + " cm", 10, 20);
  }
  else{
    test("Range: OFF", 10, 20);
  }
}

