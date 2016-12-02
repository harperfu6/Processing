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

LeapMotionP5 leap;

Capture cam;
MultiMarker nya;
PFont font=createFont("FFScala", 32);

float x_axis = 0, z_axis = 0, y_axis = 0;

int goodsNum = 0;
int index = 0;

int count = 0;

float pre_x,  pre_y, pre_z = 0;
float[] x = new float[10];
float[] y = new float[10];
float[] z = new float[10];

//Hand[] hands = new Hand[2];
Hand hand = new Hand();

void setup() {
  //size(640,360,P3D);
  //size(960,540,P3D);
  size(1280, 720, P3D);
  
  leap = new LeapMotionP5(this);
  leap.enableGesture(Type.TYPE_SWIPE);
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("no camera!!!!!");
    exit();
  }
  else {
    println("DEVICE resolution");
    for (String c : cameras) {
      println(c);
    }
    cam = new Capture(this, cameras[16]);
  }
  
  //キャプチャを作成
  //cam=new Capture(this,640,480);
  nya=new MultiMarker(this,width,height,"camera_para.dat",new NyAR4PsgConfig(NyAR4PsgConfig.CS_LEFT_HAND,NyAR4PsgConfig.TM_NYARTK));
  nya.addARMarker("patt.hiro",60);
  
  cam.start();
}

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

void draw(){
  if (cam.available() !=true) {
      return;
  }
  cam.read();
  nya.detect(cam);
  background(0);
  nya.drawBackground(cam); 

  directionalLight(50, 50, 50, -1, 1, -1);
  ambientLight(50, 50, 50);

  //Hiro
  if((nya.isExistMarker(0))){
    nya.beginTransform(0);
    drawgrid();
    
    translate(0,-200, 20);
    checkBothHands();
      translate(-hand.palmPosition().getX()*2,-hand.palmPosition().getZ()*2, hand.palmPosition().getY()*2);
      rotateY(z_axis);
      rotateX(x_axis/75);
      rotateZ(y_axis);
      drawgoods();
    nya.endTransform();
  }
  count++;
}

void drawgoods(){
  switch(goodsNum){
        case 0:
          drawgoods1();
          break;
        case 1:
          drawgoods2();
          break;
        case 2:
          drawgoods3();
          break;
        default:
         break;
  }
}

//ipad Air
void drawgoods1(){
  fill(100,100,100);
  
//  float yoko = 500;
//  float tate = 700;
//  float takasa = 20;
  
  float yoko = 330;
  float tate = 480;
  float takasa = 15;
  box(yoko, tate, takasa);
}

//Kindle Paperwhite
void drawgoods2(){
  fill(10,10,10);
  box(235, 330, 20);
}

//kobo glo
void drawgoods3(){
  fill(0,250,200);
  //fill(100, 100, 100);
  box(230, 314, 20);
}

void checkBothHands(){
  
  int hand_size = leap.getHandList().size();
  
  if(hand_size == 1){
    //leap.disableGesture(Type.TYPE_SWIPE);
    hand = leap.getHandList().get(0);
    int size = hand.fingers().count();
    float sum_xy = 0, sum_x = 0, sum_y = 0, sum_x2 = 0, sumY = 0;
    float[] finger_x = new float[5];
    float[] finger_y = new float[5];
    //float[] finger_z = new float[5];
    
    if(size >= 2){ //<>//
      sum_xy = 0;
      sum_x = 0;
      sum_y = 0;
      sum_x2 = 0;
      
      for(int i = 0; i < size; i++){
        finger_x[i] = hand.fingers().get(i).tipPosition().getX();
        finger_y[i] = hand.fingers().get(i).tipPosition().getY();
        sumY += finger_y[i];
      }
      
      for(int i = 0; i < size; i++){
        sum_xy += finger_x[i] * finger_y[i];
        sum_x += finger_x[i];
        sum_y += finger_y[i];
        sum_x2 += pow(finger_x[i], 2);
      }
     
     z_axis = (size * sum_xy - sum_x * sum_y) / (size * sum_x2 - pow(sum_x, 2.0));
     x_axis = (sumY / size) - hand.palmPosition().getY();
      
    }
  }
  /*
  if(hand_size == 2){
    y_axis = hand.palmPosition().getX();
  }*/
}

public void swipeGestureRecognized(SwipeGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    if(gesture.direction().getX() < 0 && count > 30){
      goodsNum++;
      if(goodsNum > 2){
        goodsNum = 2;
      }
    }
    else if(gesture.direction().getX() > 0 && count > 30){
      goodsNum--;
      if(goodsNum < 0){
        goodsNum = 0;
      }
    }
    count = 0;
  }
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
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
