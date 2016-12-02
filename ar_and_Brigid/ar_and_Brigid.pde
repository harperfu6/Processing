import processing.video.*;
import jp.nyatla.nyar4psg.*;

import javax.vecmath.Vector3f;
import bRigid.*;

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
    drawgrid();
    
    drawBrigid();
    
    nya_l.endTransform();
  }
  
}

public void drawBrigid() {
  //background(255);
  lights();
  translate(0,-100, 0);
  rotateZ(frameCount*.01f);

  if (frameCount%4==0) {
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
