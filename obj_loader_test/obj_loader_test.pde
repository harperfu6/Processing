import saito.objloader.*;

OBJModel kashiyuka;
OBJModel nocchi;
OBJModel aachan;

void setup(){
  size(640,480,P3D);
  kashiyuka = new OBJModel(this,"Anatolia-E-pad-x2.obj");
  
  noStroke();
}

void draw() { 
  background(0);
  //translate(width/2.0,height+160,0);
  //scale(2.5);
  //rotateY(radians(frameCount));

  scale(10);
  //translate(10,50, 0);
  kashiyuka.draw();
//  nocchi.draw();
//  aachan.draw();
}
