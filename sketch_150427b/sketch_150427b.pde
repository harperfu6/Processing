void setup(){
  size(400,400);
  colorMode(RGB,512);
  background(0);

}

void draw(){
  float a = -0.745427;
  float b = 0.113009;
  float w = 0.00001;
  
  //float a = -0.744450;
  //float b = 0.135712;
  //float w = 0.000028;
  
  //float a = -0.744550;
  //float b = 0.135712;
  //float w = 0.000008;
  
  //float a = -0.744550;
  //float b = 0.135912;
  //float w = 0.000008;
  
  int h = width / 2;
  int n = 1024;
  int c;
  
  int i,j,l,cc;
  float x, y, zx, zy, u, v, mx;
  
  for(i=-h; i<=h; i++){
      u = (w * i / h) + a;
      for(j=-h; j<=h; j++){
        v = (w * j / h) + b;
        
        x = 0.0;
        y = 0.0;
        
        for(l=1; l<=n; l++){
          zx = x * x - y * y + u;
          zy = 2 * x * y     + v;
          x = zx;
          y = zy;
          mx = x * x + y * y;
          if (mx >= 10.0){
            break;
          }
        }
          c = int (512 * l / n);
          stroke(c * 2, c + 100 , c + 100 );
          point(200+i, 200-j);
        
      }
  }
}
