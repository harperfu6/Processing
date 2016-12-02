import processing.funnel.*;

Arduino arduino;

Pin sensorPin;
Pin ledPin;

void setup(){
  size(400, 400);
  
  Configuration config = Arduino.FIRMATA;
  config.setDigitalPinMode(9, Arduino.PWM);
  arduino = new Arduino(this, config);
  
  sensorPin = arduino.analogPin(0);
  ledPin = arduino.digitalPin(9);
  
  Scaler scaler = new Scaler(0, 1, 1, 0);
  sensorPin.addFilter(scaler);
}

void draw(){
  background(100);
}

void change(PinEvent e){
  if(e.target == sensorPin){
    ledPin.value = sensorPin.value;
    println(sensorPin.value);
  }
}


