import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;
import  processing.serial.*;

LeapMotionP5 leap;
Serial  serial;

void setup() {
  size(500, 500, P3D);
  leap = new LeapMotionP5(this);
  serial = new Serial( this, Serial.list()[1], 9600 );
  println(Serial.list()[1]);
}

void draw() {
  background(0);
  //PVector fingerPos = leap.getTip(leap.getFinger(0));
  //ellipse(fingerPos.x, fingerPos.y, 20, 20);
  
  for (Finger f : leap.getFingerList()) {
    PVector screenPos = leap.getTipOnScreen(f);
    ellipse(screenPos.x, screenPos.y, 10, 10);
  }
  
}

void serialEvent(Serial port) {  
  if ( port.available() >= 3) {
    if ( port.read() == 'H' ) {
      int high = port.read();
      int low = port.read();
      int recv_data = high*256 + low;
      println(recv_data); 
    }
  }
}