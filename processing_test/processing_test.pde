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
}

void draw(){
  background(100);
}

void change(PinEvent event){
  if(event.target == sensorPin){
    ledPin.value = sensorPin.value;
  }
}
