import processing.video.*;
import jp.nyatla.nyar4psg.*;

import javax.vecmath.Vector3f;
import bRigid.*;

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

BPhysics physics;
BBox box;

Capture cam;
MultiMarker nya_r;
MultiMarker nya_l;
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
  
  initBrigid();
  
  colorMode(RGB, 100);
  println(MultiMarker.VERSION);
  
  //キャプチャを作成
  cam=new Capture(this,640,480);
  nya_l=new MultiMarker(this,width,height,"camera_para.dat",new NyAR4PsgConfig(NyAR4PsgConfig.CS_LEFT_HAND,NyAR4PsgConfig.TM_NYARTK));
  nya_l.addARMarker("patt.hiro",80);
  
  nya_r=new MultiMarker(this,width,height,"camera_para.dat",new NyAR4PsgConfig(NyAR4PsgConfig.CS_RIGHT_HAND,NyAR4PsgConfig.TM_NYARTK));
  nya_r.addARMarker("patt.kanji",80);
  cam.start();
}

void initBrigid(){
//extends of physics world
  Vector3f min = new Vector3f(-120, -120, 50);
  Vector3f max = new Vector3f(120, 120, 250);
  //create a rigid physics engine with a bounding box
  physics = new BPhysics(min, max);
  //set gravity
  physics.world.setGravity(new Vector3f(0, 0, -500));

  //create the first rigidBody as Box or Sphere
  //BBox(PApplet p, float mass, float dimX, float dimY, float dimZ)
  box = new BBox(this, 1, 5, 5, 20);
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
  nya_r.detect(cam);
  nya_l.detect(cam);
  background(0);
  nya_r.drawBackground(cam);//frustumを考慮した背景描画
  
  //right
  if((nya_r.isExistMarker(0))){
    nya_l.beginTransform(0);
    drawgrid();
    
    drawBrigid();
    
    nya_l.endTransform();
  }
  
  
  //left
  if((nya_l.isExistMarker(0))){
    nya_l.beginTransform(0);
//    resetMatrix();
//    nya_l.setARPerspective();
    drawgrid();
    
//    PMatrix3D temp = nya_l.getMarkerMatrix(0);
//    float x = temp.m03 + width/2;
//    float y = temp.m13 + height/2;
    //float x = temp.m03 + width/2;
    
//    System.out.println(x); 
//    System.out.println(y); 
//    System.out.println(temp.m23); 
//    System.out.println("");
    
    drawBrigid();
    
    nya_l.endTransform();
  }
  
  getFingerPos();
}

public void drawBrigid() {
  //background(255);
  lights();
  translate(0,-100, 0);
  rotateZ(frameCount*.01f);

  if (frameCount%10==0) {
    //Vector3f pos = new Vector3f(random(30), -150, random(1));
    Vector3f pos = new Vector3f(random(30), -50 * random(1), 150);
    //reuse the rigidBody of the sphere for performance resons
    //BObject(PApplet p, float mass, BObject body, Vector3f center, boolean inertia)
    BObject r = new BObject(this, 100, box, pos, true);
    //add body to the physics engine
    physics.addBody(r);
  }
  //update physics engine every frame
  physics.update();
  // default display of every shape
  physics.display();
}

void getFingerPos(){
  
  for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    ellipse(fingerPos.x, fingerPos.y, 10, 10);
    System.out.println(fingerPos.x);
    System.out.println(fingerPos.y);
    System.out.println(fingerPos.z);
    System.out.println("");
//  }
  
//    for (Hand hand : leap.getHandList()) {
//    PVector handPos = leap.getPosition(hand);
//    ellipse(handPos.x, handPos.y, 20, 20);
//    System.out.println(handPos.x);
//    System.out.println(handPos.y);
//    System.out.println(handPos.z);
//    System.out.println("¥n");
  }
}
