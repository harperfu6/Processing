import processing.funnel.*;

Arduino arduino;

Pin ledPin;

void setup(){
  size(400, 400);
  
  Configuration config = Arduino.FIRMATA;
  config.setDigitalPinMode(9, Arduino.OUT);
  arduino = new Arduino(this, config);
  
  ledPin = arduino.digitalPin(9);
}

void draw(){
  background(100);
}

void mousePressed(){
  ledPin.value = 1;
}

void mouseReleased(){
  ledPin.value = 0;
}

