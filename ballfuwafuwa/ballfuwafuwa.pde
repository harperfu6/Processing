Ball ball;

void setup(){
  size(960, 540);
  ball = new Ball(); 
}

void draw(){
  background(20);
  ball.update();
  ball.display(); 
}

class Ball{
  PVector location;     // 座標
  PVector velocity;     // 速度
  PVector acceleration; // 加速度
  PVector mouse;        // マウス
  float topspeed;       // 最高速度
  
  Ball(){
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    mouse = new PVector(mouseX, mouseY);
    topspeed = 5;
  }
  
  // 座標を更新する
  void update(){
    // mouseにマウスの座標をセットする
    mouse.set(mouseX, mouseY);
    // マウスの座標からボールの座標を引いた値を加速度に格納する
    acceleration = PVector.sub(mouse, location);
    // 加速度を正規化する
    acceleration.normalize();
    // 加速度に0.2を掛ける
    acceleration.mult(0.2);
    // 速度に加速度を足す
    velocity.add(acceleration);
    // 速度を、最高速度を超過しないように制限する
    velocity.limit(topspeed);
    // 位置に速度を足す
    location.add(velocity);
  }
  
  // ボールを描画
  void display(){
    stroke(0);
    fill(255);
    ellipse(location.x, location.y, 48, 48);
  }
}
