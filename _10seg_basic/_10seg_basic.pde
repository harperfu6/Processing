import processing.funnel.*;

Arduino arduino;

int num = 5;

//Pin[] ledPin;
Pin ledPin;

void setup(){
  size(400, 400);
  //ledPin = new Pin[num];
  
   Configuration config = Arduino.FIRMATA;
   /*
   for(int i = 2; i < (2 + num); i++){
     config.setDigitalPinMode(i, Arduino.OUT);
   }
   arduino = new Arduino(this, config);
   
   for(int i = 2; i < (2 + num); i++){
     ledPin[i-2] = arduino.digitalPin(i);
   }
   */
   config.setDigitalPinMode(3, Arduino.OUT);
   arduino = new Arduino(this, config);
   //ledPin[0] = arduino.digitalPin(3);
   ledPin = arduino.digitalPin(3);
}

void draw(){
  background(100);
  /*
  int i = 0;
  while(i < num){
    ledPin[i].value = 1;
    delay(200);
    i++;
    ledPin[i-1].value = 0;
  }
  */
  ledPin.value = 1;
}




