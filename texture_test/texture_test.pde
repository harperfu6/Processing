size(1000, 1000, P3D);
//noStroke();
PImage img = loadImage("ipad_air1.png");
textureMode(NORMAL);

translate(500, 500, 100);
rotateX(20);
//box(50, 50, 50);
//beginShape();
//texture(img);
//vertex(-25, -25, 25, 0, 0);
//vertex(25, -25, 25, 1, 0);
//vertex(25, 25, 25, 1, 1);
//vertex(-25, 25, 25, 0, 1);
//endShape();

fill(100,100,100);
  
  float yoko = 340;
  float tate = 480;
  float takasa = 16;
  
  box(yoko, tate, takasa);
  
  beginShape();
  texture(img);
  vertex(-yoko/2, -tate/2, takasa/2, 0, 0);
  vertex(yoko/2, -tate/2, takasa/2, 1, 0);
  vertex(yoko/2, tate/2, takasa/2, 1, 1);
  vertex(-yoko/2, tate/2, takasa/2, 0, 1);
  endShape();
