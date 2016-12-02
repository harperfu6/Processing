import saito.objloader.*;

OBJModel kashiyuka;
OBJModel nocchi;
OBJModel aachan;

void setup(){
  size(640,480,P3D);
  kashiyuka = new OBJModel(this,"model1.obj");
  nocchi = new OBJModel(this,"model2.obj");
  aachan = new OBJModel(this,"model3.obj");
  
  noStroke();
}

void draw() { 
  background(0);
  translate(width/2.0,height+160,0);
  //scale(2.5);
  rotateY(radians(frameCount));

  kashiyuka.draw();
  nocchi.draw();
  aachan.draw();
}
