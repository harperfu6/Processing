PImage myPhoto;

int w = 1440;//img width
int h = 900;//img height
int pixels;//Number of pixel

FloatList odata = new FloatList();
FloatList ndata = new FloatList();
FloatList tempV = new FloatList();

float eps = 5;
float z = 0.2;
PVector light = new PVector(1, 1, 0);

void setup(){
  //size(1920, 1080);
  size(w, h);
  pixels = w * h;
  myPhoto = loadImage("");
  
}

void update(){
  background(0, 100, 220);
  
  if(random(1) < 0.3){
    ripple();
  }
  
  sim();
  
  //loadPixels();
  for (int i=0; i<pixels; i++) {//Make each first ripple
        int x = i % w;
        int y = i / w;
        
        PVector n = new PVector(getVal(x - eps, y) - getVal(x + eps, y), getVal(x, y - eps) - getVal(x, y + eps),  eps * 2.0);//Check pixels around
        n.normalize();
        
        float spec = (1 - (light.x + n.x)) + (1 - (light.y + n.y));
        spec /= 2;
        
        if (spec > z)
            spec = (spec - z) / (1 - z);
        else
            spec = 0;
        
        spec *= 255.0;
        
        fill(2);
        
        /*
        ofColor c = image.getColor(x + n.x * 60, y + n.y * 60);//Get "edge" of ripple
        c += spec;//Make "edge" brighter
        updatedImage.setColor(x, y, c);
        */
        
    }

}

void draw(){

}

void sim(){
  //Store current situation then update.
    for (int i=0; i<pixels; i++) {
        tempV.set(i, odata.get(i));
    }
    for (int i=0; i<pixels; i++) {
        odata.set(i,ndata.get(i));
    }
    for (int i=0; i<pixels; i++) {
        ndata.set(i, tempV.get(i));
    }
    
    //Spread
    for (int i=0; i<pixels; i++) {
        int x = i % w;
        int y = i / w;
        if (x > 1 || y > 1 || x <= w - 1 || y <= h - 1){
            float val = (odata.get((x-1)+y*w) + odata.get((x+1)+y*w) + odata.get(x+(y-1)*w) + odata.get(x+(y+1)*w)) / 2;
            val = val - ndata.get(x+y*w);
            val *= 0.96875;
            ndata.set(x+y*w, val);
        }
    }

}

float getVal(int x, int y){
  if (x < 1 || y < 1 || x >= w - 1 || y >= h - 1){
    return 0;
  }
  float a = odata.get(x+y*w);
  return a;
}

void ripple(){
  //Randomly make ripple
    int rx = (int)random(w - 10) + 5;
    int ry = (int)random(h - 10) + 5;
    for (int x = -5; x < 5; x++){
        for (int y = -5; y < 5; y++){
            int targetPix = (rx + x) + (w * (ry + y));
            odata.set(targetPix,100);
        }
    }

}
