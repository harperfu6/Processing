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

OBJModel model1;
OBJModel model2;
OBJModel model3;
Capture cam;
MultiMarker nya;
PFont font=createFont("FFScala", 32);

PImage img = loadImage("ipad_air1.png");

float pre_move_x, pre_move_y, pre_move_z = 0;
float pre_move_x2, pre_move_y2, pre_move_z2 = 0;
float pre_move_x_one, pre_move_y_one, pre_move_z_one = 0;
float move_x, move_y, move_z = 0;
float move_x2, move_y2, move_z2 = 0;
float move_x_one, move_y_one, move_z_one = 0;
float pre_x,  pre_y, pre_z = 0;
float pre_x2,  pre_y2, pre_z2 = 0;
float pre_x_one,  pre_y_one, pre_z_one = 0;

float now_x, now_y, now_z = 0;
float now_x_one, now_y_one, now_z_one = 0;

float[] x = new float[10];
float[] y = new float[10];
float[] z = new float[10];

float[] x2 = new float[10];
float[] y2 = new float[10];
float[] z2 = new float[10];

float[] x_one = new float[10];
float[] y_one = new float[10];
float[] z_one = new float[10];

float[] finger_x = new float[5];
float[] finger_y = new float[5];
float[] finger_z = new float[5];

float a = 0, b = 0;
float sum_xy = 0, sum_x = 0, sum_y = 0, sum_x2 = 0, sumb = 0, pre_sumb = 0;
float pre_hand_pos;

float now_rotate_y = 0;
float move_rotate_y = 0;

int index = 0;
boolean go_left, go_right;
int goodsNum;
int count = 0;
boolean countCheck = true;
int trackNum = 0;

boolean oneCheck = false;
int pre_oneCount = 0;
int oneCount = 0;
boolean one_start = false;


void setup() {
  //size(640,480,P3D);
  //size(960,540,P3D);
  size(1280, 720, P3D);
  textureMode(NORMAL);
  
  leap = new LeapMotionP5(this);
  
  model1 = new OBJModel(this, "Tablet-(3rd-Generation).obj");
  model2 = new OBJModel(this, "Anatolia-E-pad-MONARCH.obj");
  model3 = new OBJModel(this, "Tablet-(3rd-Generation).obj");
  noStroke();
  
//  //座標軸の捉え方が変わるので、この方がわかりやすい
//  model.translateToCenter();
//  //DrawModeの設定
//  model.setDrawMode(POLYGON);  
  
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
    //println(cameras[0]);
  }
  
  //キャプチャを作成
  //cam=new Capture(this,640,480);
  nya=new MultiMarker(this,width,height,"camera_para.dat",new NyAR4PsgConfig(NyAR4PsgConfig.CS_LEFT_HAND,NyAR4PsgConfig.TM_NYARTK));
  nya.addARMarker("patt.hiro",40);
  
//  nya=new MultiMarker(this,width,height,"camera_para.dat",new NyAR4PsgConfig(NyAR4PsgConfig.CS_RIGHT_HAND,NyAR4PsgConfig.TM_NYARTK));
  nya.addARMarker("patt.kanji",40);
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
  
  move_x2 = smoothByMeanFilter(x2);
  move_y2 = smoothByMeanFilter(y2);
  move_z2 = smoothByMeanFilter(z2);
  
  move_x_one = smoothByMeanFilter(x_one);
  move_y_one = smoothByMeanFilter(y_one);
  move_z_one = smoothByMeanFilter(z_one);
  
  fill(0, 0, 0);
  text("move_x:"+move_x, 0,20);
  text("move_x2:"+move_x2, 0,40);
  text("move_rotate_y:"+move_rotate_y, 0,60);
  
  //Hiro
  if((nya.isExistMarker(0))){
    nya.beginTransform(0);
    drawgrid();
    pushMatrix();
    translate(0,-400, 20);
    
    if((move_x < -6 || move_x2 < -6) && countCheck){
      go_right = true;
      System.out.println("right!!");
      count = 0;
      countCheck = false;
    }
    if((move_x > 6|| move_x2 > 6) && countCheck){
      go_left = true;
      System.out.println("left!!");
      count = 0;
      countCheck = false;
    }
    
    if(pre_move_x != move_x || pre_move_y != move_y || pre_move_z != move_z){
      if(pre_move_x2 != move_x2 || pre_move_y2 != move_y2 || pre_move_z2 != move_z2){
        
        if(move_x * move_x2 < 0){
            now_x += move_x;
        }
        if(move_y * move_y2 < 0){
            now_y += move_y;
        }
        if(move_z * move_z2 < 0){
            now_z += move_z;
        }
      }
    }
    
    if(pre_move_x_one != move_x_one || pre_move_y_one != move_y_one || pre_move_z_one != move_z_one){
      now_x_one += move_x_one;
      now_y_one += move_y_one;
      now_z_one += move_z_one;
    }
    
    pre_move_x = move_x;
    pre_move_y = move_y;
    pre_move_z = move_z;
    
    pre_move_x2 = move_x2;
    pre_move_y2 = move_y2;
    pre_move_z2 = move_z2;
    
    pre_move_x_one = move_x_one;
    pre_move_y_one = move_y_one;
    pre_move_z_one = move_z_one;
    
    
//    rotateZ(now_z/10);
//    rotateY(now_y/10);
    
    if(go_right == true){
      goodsNum++;
      if(goodsNum >= 3){
        goodsNum = 2;
      }
      go_right = false;
    }
    else if(go_left == true){
      goodsNum--;
      if(goodsNum <= -1){
        goodsNum = 0;
      }
      go_left = false;
    }
    //System.out.println("num:"+goodsNum);
    
    if(trackNum == 1){
//      translate(-now_x_one * 3, -now_z_one * 3, now_y_one * 3);
//      drawgoods();
    }
    
    if(trackNum == 2){
      rotateZ(now_z/15);
      rotateY(now_y/15);
      drawgoods();
    }
    //scale(0.01);
    //model1.draw();
    popMatrix();
    
    pushMatrix();
    checkBothHands();
    popMatrix();
    
    nya.endTransform();
    
    count++;
    if(count > 60){
      countCheck = true;
    }
  }

  
  //finger
//  fill(255);
//  for (Finger finger : leap.getFingerList()) {
//    PVector fingerPos = leap.getTip(finger);
//    ellipse(fingerPos.x, fingerPos.y, 10, 10);
//  }
  
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
  
  float yoko = 500;
  float tate = 700;
  float takasa = 20;
  
  box(yoko, tate, takasa);
  
  beginShape();
  texture(img);
//  vertex(yoko/2, tate/2, takasa/2, 0, 0);
//  vertex(-yoko/2, tate/2, takasa/2, 1, 0);
//  vertex(-yoko/2, -tate/2, takasa/2, 1, 1);
//  vertex(yoko/2, -tate/2, takasa/2, 0, 1);
  
  vertex(-yoko/2, -tate/2, takasa/2, 0, 0);
  vertex(yoko/2, -tate/2, takasa/2, 1, 0);
  vertex(yoko/2, tate/2, takasa/2, 1, 1);
  vertex(-yoko/2, tate/2, takasa/2, 0, 1);
  endShape();
}

//Kindle Paperwhite
void drawgoods2(){
  fill(10,10,10);
  box(400, 550, 30);
}

//kobo glo
void drawgoods3(){
  fill(0,250,200);
  //fill(100, 100, 100);
  box(380, 500, 30);
}

float smoothByMeanFilter(float data[]){
  float sum = 0;
  
  for(int i = 0; i < 10; i++){
    sum += data[i];
  }
  return sum / 10;
}

void checkBothHands(){
  
  int hand_size = leap.getHandList().size();
  
  if(hand_size == 2){
    Hand first_hand = leap.getHandList().get(0);
    Hand second_hand = leap.getHandList().get(1);
    x[index] = first_hand.palmPosition().getX() - pre_x;
    y[index] = first_hand.palmPosition().getY() - pre_y;
    z[index] = first_hand.palmPosition().getZ() - pre_z; 
    x2[index] = second_hand.palmPosition().getX() - pre_x2;
    y2[index] = second_hand.palmPosition().getY() - pre_y2;
    z2[index] = second_hand.palmPosition().getZ() - pre_z2; 
    pushMatrix();
    translate(-first_hand.palmPosition().getX()*1.5, first_hand.palmPosition().getZ()*1.5 - 400,-first_hand.palmPosition().getY()*1.5);
    sphere(5);
    popMatrix();
    pushMatrix();
    translate(-second_hand.palmPosition().getX()*1.5,second_hand.palmPosition().getZ()*1.5 - 400,-second_hand.palmPosition().getY()*1.5);
    sphere(5);
    popMatrix();
    index = (index + 1) % 10;
    
    pre_x = first_hand.palmPosition().getX();
    pre_y = first_hand.palmPosition().getY();
    pre_z = first_hand.palmPosition().getZ();
    
    pre_x2 = second_hand.palmPosition().getX();
    pre_y2 = second_hand.palmPosition().getY();
    pre_z2 = second_hand.palmPosition().getZ();
    
    text("x:"+pre_x, 0, 80, 0);
    text("y:"+pre_y, 0, 100, 0);
    text("z:"+pre_z, 0, 120, 0);
    
    trackNum = 2;
    oneCheck = false;
  }
  
  else if((hand_size == 1) && !oneCheck){
    if(!one_start){
      oneCount = 0;
      one_start = true;
    }
    oneCount++;
    if(oneCount == 60){
      oneCheck = true;
      one_start = false;
    }
  }
  
  else if((hand_size == 1) && oneCheck){
    Hand hand = leap.getHandList().get(0);
//    x_one[index] = hand.palmPosition().getX() - pre_x_one;
//    y_one[index] = hand.palmPosition().getY() - pre_y_one;
//    z_one[index] = hand.palmPosition().getZ() - pre_z_one; 
//    index = (index + 1) % 10;
//    pre_x_one = hand.palmPosition().getX();
//    pre_y_one = hand.palmPosition().getY();
//    pre_z_one = hand.palmPosition().getZ();

    
//    pushMatrix();
//    translate(-hand.palmPosition().getX()*2,-hand.palmPosition().getZ()*2 - 200,hand.palmPosition().getY()*2 - 150);
//    rotateY(move_rotate_y);
//    drawgoods();
//    popMatrix();
    
    //finger
//    fill(255);
//    for (Finger finger : leap.getFingerList()) {
//      //PVector fingerPos = leap.getTip(finger);
//      //ellipse(fingerPos.x, fingerPos.y, 10, 10);
//      
//    }

    sumb = 0;
    int size = hand.fingers().count();
    System.out.println("count:"+size);
    if(size >= 2){
        for(int i = 0; i < size; i++){
          a = 0;
          //b = 0;
          sum_xy = 0;
          sum_x = 0;
          sum_y = 0;
          sum_x2 = 0;
          
          finger_x[i] = hand.fingers().get(i).tipPosition().getX();
          finger_y[i] = hand.fingers().get(i).tipPosition().getY();
          sumb += finger_y[i];
        }
          //finger_z[i] = hand.fingers().get(i).tipPosition().getZ();
          
        for(int i = 0; i < size; i++) {
           sum_xy += finger_x[i] * finger_y[i];
           sum_x += finger_x[i];
           sum_y += finger_y[i];
           sum_x2 += pow(finger_x[i], 2);
         }
  
          a = (size * sum_xy - sum_x * sum_y) / (size * sum_x2 - pow(sum_x, 2.0));
          //b = (sum_x2 * sum_y - sum_xy * sum_x) / (size * sum_x2 - pow(sum_x, 2));
          b = (sumb / size) - hand.palmPosition().getY();
    }
     
    pushMatrix();
    translate(-hand.palmPosition().getX()*2,-hand.palmPosition().getZ()*2 - 200,hand.palmPosition().getY()*2 - 300);
    rotateY(a);
    rotateX(b/75);
    drawgoods();
    popMatrix();
    
    
    trackNum = 1;
  }
  
  else{
  }
}

public void stop() {
  leap.stop();
}
