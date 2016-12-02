import processing.video.*;
import jp.nyatla.nyar4psg.*;

import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;

import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.KeyTapGesture;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;

import saito.objloader.*;

LeapMotionP5 leap;

OBJModel model;

Capture cam;
MultiMarker nya_r;
MultiMarker nya_l;
MultiMarker nya;
PFont font=createFont("FFScala", 32);

float move_x, move_y, move_z = 0;
float pre_x,  pre_y, pre_z = 0;
float now_x, now_y, now_z = 0;
float[] x = new float[10];
float[] y = new float[10];
float[] z = new float[10];
int index = 0;


void setup() {
  size(640,480,P3D);
  
  leap = new LeapMotionP5(this);
  
  model = new OBJModel(this);
  model.load("Samsung I9295 Galaxy S4 Active.obj");
  //noStroke();
  
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
println("no camera!!!!!");
exit();
} else {
println("DEVICE resolution");
for (String c : cameras) {
println(c);
}
//cam = new Capture(this, cameras[0]);
//println(cameras[0]);
}
  
  //キャプチャを作成
  cam=new Capture(this,640,480);
  nya=new MultiMarker(this,width,height,"camera_para.dat",new NyAR4PsgConfig(NyAR4PsgConfig.CS_LEFT_HAND,NyAR4PsgConfig.TM_NYARTK));
  nya.addARMarker("patt.hiro",80);
  
//  nya=new MultiMarker(this,width,height,"camera_para.dat",new NyAR4PsgConfig(NyAR4PsgConfig.CS_RIGHT_HAND,NyAR4PsgConfig.TM_NYARTK));
  nya.addARMarker("patt.kanji",80);
  cam.start();
}

int c=0;
void drawgrid()
{
  pushMatrix();
  stroke(0);
  strokeWeight(2);
  line(0,0,0,100,0,0);
  textFont(font,20.0); text("X",100,0,0);
  line(0,0,0,0,100,0);
  textFont(font,20.0); text("Y",0,100,0);
  line(0,0,0,0,0,100);
  textFont(font,20.0); text("Z",0,0,100);
  popMatrix();
}

void draw()
{
  c++;
  if (cam.available() !=true) {
      return;
  }
  cam.read();
//  nya_r.detect(cam);
//  nya_l.detect(cam);
  nya.detect(cam);
  background(0);
  //nya_r.drawBackground(cam);//frustumを考慮した背景描画
  nya.drawBackground(cam); 
  
  //leap.enableGesture(Type.TYPE_SWIPE);

  directionalLight(50, 50, 50, -1, 1, -1);
  ambientLight(50, 50, 50);

  move_x = smoothByMeanFilter(x);
  move_y = smoothByMeanFilter(y);
  move_z = smoothByMeanFilter(z);
  
  //right
  if((nya.isExistMarker(1))){
    nya.beginTransform(1);
    fill(50,50,50);
    drawgrid();
    pushMatrix();
    translate(0,-200,20);
    //rotate((float)c/100);
    now_x += move_x;
    now_y += move_y;
    now_z += move_z;
    rotateZ(-now_x/150);
    rotateZ(-move_x/150);
    rotateY(-now_y/150);
    rotateY(-move_y/150);
//    rotateY(now_z/50);
//    rotateY(move_z/50);
    box(300, 180, 20);
    model.draw();
    popMatrix();
    nya.endTransform();
  }
  //left
  if((nya.isExistMarker(0))){
    nya.beginTransform(0);
    fill(100,100,100);
    drawgrid();
    pushMatrix();
    translate(0,-200,20);
    //rotate((float)c/100);
    now_x += move_x;
    now_y += move_y;
    now_z += move_z;
    rotateZ(-now_x/150);
    rotateZ(-move_x/150);
    rotateY(-now_y/150);
    rotateY(-move_y/150);
//    rotateY(now_z/50);
//    rotateY(move_z/50);
    box(400, 200, 20);
    model.draw();
    popMatrix();
    nya.endTransform();
  }

  
  //leapmotion
//  fill(255);
//  for (Finger finger : leap.getFingerList()) {
//    PVector fingerPos = leap.getTip(finger);
//    ellipse(fingerPos.x, fingerPos.y, 10, 10);
//  }

  for (Hand hand : leap.getHandList()) {
    PVector handPos = leap.getPosition(hand);
    ellipse(handPos.x, handPos.y, 20, 20);
    x[index] = handPos.x - pre_x;
    y[index] = handPos.y - pre_y;
    z[index] = handPos.z - pre_z;
    
    index = (index + 1) % 10;
    pre_x = handPos.x;
    pre_y = handPos.y;
    pre_z = handPos.z;
    System.out.println(handPos.x);
    System.out.println(handPos.y);
    System.out.println(handPos.z);
    System.out.println("¥n");
  }
}

float smoothByMeanFilter(float data[]){
  float sum = 0;
  
  for(int i = 0; i < 10; i++){
    sum += data[i];
  }
  return sum / 10;
}

public void stop() {
  leap.stop();
}
