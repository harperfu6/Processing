ArrayList<WaterFairy> fairies = new ArrayList<WaterFairy>();
ArrayList<BigFish> bigFishes = new ArrayList<BigFish>();
ArrayList<Food> foods = new ArrayList<Food>();
WaterFairy removeFairy;
WaterFairy generateFairy;
BigFish removeBigFish;
BigFish generateBigFish;
boolean gyakusyu;

void setup(){
  //size(1920, 1080);
  //size(1440, 900);
  size(1000, 700);
  // 配列を初めは要素数１で生成
  fairies.add(new WaterFairy());
}

void draw(){
  background(0, 120, 180);
  //background(100);
  
  if(bigFishes.size() > 0){
  if(fairies.size()/bigFishes.size() > 8){
    gyakusyu = true;
  }
  else{
    gyakusyu = false;
  }
  }
  else{
    gyakusyu = false;
  }
  
  for(WaterFairy fairy : fairies){
    fairy.display();
    fairy.collision();
    if(fairy.hp < 100){
      removeFairy = fairy;
    }
    else if(fairy.hp > 2450 && !fairy.generate){
      generateFairy = fairy;
    }
  }
  
  if(removeFairy != null){
    foods.add(new Food(removeFairy.location));
    fairies.remove(removeFairy);
    removeFairy = null;
  }
  if(generateFairy != null){
    fairies.add(new WaterFairy(new PVector(generateFairy.location.x + 10, generateFairy.location.y + 10)));
    //fairies.add(new WaterFairy());
    generateFairy.generate = true;
    generateFairy = null;
  }
  
  for(BigFish bigFish : bigFishes){
    bigFish.display();
    bigFish.collision();
    if(bigFish.hp < 100){
      removeBigFish = bigFish;
    }
    
  }
  
  if(removeBigFish != null){
    
    for(int i = 0; i < 10; i++){
      int angle = 360/10 * i;
      foods.add(new Food(new PVector(removeBigFish.location.x + 30*cos(radians(angle)), removeBigFish.location.y + 30*sin(radians(angle)))));
    }
    
    /*
    for(int i = -2; i < 2; i++){
      foods.add(new Food(new PVector(removeBigFish.location.x + i*20, removeBigFish.location.y)));
    }
    */
    bigFishes.remove(removeBigFish);
    removeBigFish = null;
    gyakusyu = false;
  }
  
  for(Food food : foods){
    food.draw();
  }
}

void keyPressed(){
  if(key == 'm'){
    // マウスが押されると、新しいお魚さんが生まれる
    fairies.add(new WaterFairy());
  }
  if(key == 'b'){
    // マウスが押されると、新しいお魚さんが生まれる
    bigFishes.add(new BigFish());
  }
}

void mousePressed(){
  foods.add(new Food(new PVector(mouseX, mouseY)));
}

class WaterFairy{
  float[] x, y;
  float angle;
  PVector location;
  PVector velocity;
  PVector randomloc; // ランダムに設定される座標（マウスの代わり）
  PVector acceleration;
  float topspeed;
  float maxforce;    // Maximum steering force
  int space = 10;
  int segNum = 8;
  int hp;
  boolean generate;
  Food neighborFood;
  BigFish enemy;
  
  
  WaterFairy(){
    x = new float[segNum];
    y = new float[segNum];
    location = new PVector(random(width - 300) + 100, random(height - 300) + 100);
    velocity = new PVector(0,0);
    // ランダムな座標を決める
    randomloc = new PVector(random(width - 350) + 150, random(height - 350) + 150);
    topspeed = 7;
    maxforce = 0.03;
    hp = 1500;
  }
  
  WaterFairy(PVector _location){
    x = new float[segNum];
    y = new float[segNum];
    location = _location;
    velocity = new PVector(0,0);
    // ランダムな座標を決める
    randomloc = new PVector(random(width - 350) + 150, random(height - 350) + 150);
    topspeed = 7;
    maxforce = 0.03;
    hp = 1500;
  }
  
  void display(){
    
    hp--;
    
    PVector sep = separate(fairies);
    sep.mult(7);
    
    
    PVector esc = new PVector(0,0);
    if(!gyakusyu){
    if(enemy != null){
      esc = escape(enemy.location);
      esc.mult(5);
    }}
    
    // 毎フレーム１％の確率でランダムな座標を決める
    if(gyakusyu){
      float neighbor = sqrt(width * width + height * height);
      for(BigFish bigFish : bigFishes){
        float sub = PVector.sub(bigFish.location, location).mag();
        if(sub < neighbor){
          neighbor = sub;
          randomloc.set(bigFish.location);
          enemy = bigFish;
        }
      }
    }
    
    else if(foods.size() > 0 && hp < 1500){
      float neighbor = sqrt(width * width + height * height);
      for(Food food : foods){
        float sub = PVector.sub(food.location, location).mag();
        if(sub < neighbor){
          neighbor = sub;
          randomloc.set(food.location);
          neighborFood = food;
        }
      }
    }
    else if(foods.size() > 0 && random(1) < 0.01){
      randomloc.set( random(width - 350) + 150, random(height - 350) + 150);
      neighborFood = null;
    }
    else if(random(1) < 0.01){
      randomloc.set( random(width - 350) + 150, random(height - 350) + 150);
      neighborFood = null;
    }
    else{
      neighborFood = null;
    }
    // ランダムに決められた座標に向かうlocationを計算
    acceleration = PVector.sub(randomloc, location);
    acceleration.normalize();
    acceleration.mult(0.2);
    if(neighborFood != null){
      acceleration.mult(4.0);
    }
    acceleration.add(sep);
    if(enemy != null){
      acceleration.add(esc);   
    }
    
    velocity.add(acceleration);
    velocity.limit(topspeed);

    if(location.x + velocity.x < 100 || location.x + velocity.x > width - 100){
      if(random(1) < 0.5){
        //velocity.rotate(90);
        //acceleration.x *= -1;
        velocity.x *= -1;
      }
      else{
        //velocity.rotate(-90);
        //acceleration.x *= -1;
        velocity.x *= -1;
      }
    }
    if(location.y + velocity.y < 100 || location.y + velocity.y > height - 100){
      if(random(1) < 0.5){
        //velocity.rotate(90);
        velocity.y *= -1;
      }
      else{
        //velocity.rotate(-90);
        velocity.y *= -1;
      }
    }


    location.add(velocity);
    
    /*    
    if(location.x < 50 || location.x > width - 50){
      acceleration.x *= -1;
      velocity.x *= -1;
    }
    if(location.y < 50 || location.y > height - 50){
      acceleration.y *= -1;
      velocity.y *= -1;
    }
    */
    
    drawBody(0, location.x, location.y);
    for(int i = 0; i < x.length-1; i++){
      drawBody(i+1, x[i], y[i]);
    }
  }
  
  void drawBody(int i, float mx, float my){
    calculateAngle(i, mx, my);
    pushMatrix();
    pushStyle();
    stroke(255, min(hp/10, 255));
    fill(255, min(hp/10, 255));
    translate(x[i], y[i]);
    rotate(angle);
    switch(i){
      case 0 :
        noFill();
        //stroke(255, 180);
        strokeWeight(2);
        //arc(0, 0, 60, 60, HALF_PI, PI+HALF_PI);
        //ellipse(-35, 0, 5, 5);
        break;
      case 1 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 15, 15);
        ellipse(0, 0, 7, 7);
        //fill(255);
        ellipse(0, 0, 3, 3);
        ellipse(-space/2, 0, 5, 5);
        
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(-space/4, space/3, 6, 6);
        ellipse(-space/4, -space/3, 6, 6);
        //fill(255);
        ellipse(-space/4, space/3, 3, 3);
        ellipse(-space/4, -space/3, 3, 3);
        
        stroke(255, 180);
        strokeWeight(1);
        //line(-space/4, space/3, -100, 70);
        //line(-space/4, -space/3, -100, -70);
        //fill(255);
        //ellipse(-100, 70, 5, 5);
        //ellipse(-100, -70, 5, 5);
        break;
      case 2 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 15, 15);
        ellipse(0, 0, 7, 7);
        //fill(255);
        ellipse(0, 0, 3, 3);
        ellipse(-space/2, 0, 5, 5);
        
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(-space/4, space/3, 6, 6);
        ellipse(-space/4, -space/3, 6, 6);
        //fill(255);
        ellipse(-space/4, space/3, 3, 3);
        ellipse(-space/4, -space/3, 3, 3);
        
        stroke(255, 180);
        strokeWeight(1);
        //line(-space/4, space/3, -100, 50);
        //line(-space/4, -space/3, -100, -50);
        //fill(255);
        //ellipse(-100, 50, 5, 5);
        //ellipse(-100, -50, 5, 5);
        break;
      case 3 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 12, 12);
        ellipse(0, 0, 5, 5);
        //fill(255);
        ellipse(0, 0, 2, 2);
        ellipse(-space/2, 0, 5, 5);
        break;
      case 4 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 12, 12);
        ellipse(0, 0, 5, 5);
        //fill(255);
        ellipse(0, 0, 2, 2);
        ellipse(-space/2, 0, 5, 5);
        break;
      case 5 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 10, 10);
        ellipse(0, 0, 3, 3);
        //fill(255);
        ellipse(-space/2, 0, 5, 5);
        break;
      case 6 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 10, 10);
        ellipse(0, 0, 3, 3);
        //fill(255);
        ellipse(-space/2, 0, 5, 5);
        break;
      case 7 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 4, 4);
        break;
    }
    popStyle();
    popMatrix();
  }
  
  void calculateAngle(int i, float tx, float ty){
    float dx = tx - x[i];
    float dy = ty - y[i];
    angle = atan2(dy, dx);
    x[i] = tx - (cos(angle) * space);
    y[i] = ty - (sin(angle) * space);
  }
  
  void collision(){
    if(gyakusyu){
      if(PVector.sub(enemy.location, location).mag() < 20){
        enemy.hp -= hp * 1.5;
      }
    }
    
    else if(neighborFood != null){
      if(PVector.sub(neighborFood.location, location).mag() < 20){
        foods.remove(neighborFood);
        hp += 1000;
      }
    }
  }
  
  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector escape(PVector target) {
    PVector desired = PVector.sub(location, target);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(topspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  
  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<WaterFairy> fairies) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (WaterFairy other : fairies) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(topspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
}


class BigFish{
  float[] x, y;
  float angle;
  PVector location;
  PVector velocity;
  PVector randomloc; // ランダムに設定される座標（マウスの代わり）
  PVector acceleration;
  float topspeed;
  float maxforce;    // Maximum steering force
  int space = 15;
  int segNum = 8;
  int hp;
  WaterFairy neighborFairy;
  
  BigFish(){
    x = new float[segNum];
    y = new float[segNum];
    location = new PVector(random(width - 300) + 100, random(height - 300) + 100);
    velocity = new PVector(0,0);
    // ランダムな座標を決める
    randomloc = new PVector(random(width - 350) + 150, random(height - 350) + 150);
    topspeed = 7;
    maxforce = 0.03;
    hp = 1500;
  }
  
  BigFish(PVector _location){
    x = new float[segNum];
    y = new float[segNum];
    location = _location;
    velocity = new PVector(0,0);
    // ランダムな座標を決める
    randomloc = new PVector(random(width - 350) + 150, random(height - 350) + 150);
    topspeed = 7;
    maxforce = 0.03;
    hp = 1500;
  }
  
  void display(){
   
    hp--;
    
    PVector sep = separate(bigFishes);
    sep.mult(15);
    
    // 毎フレーム１％の確率でランダムな座標を決める
    if(fairies.size() > 0 && hp < 1500){
      float neighbor = sqrt(width * width + height * height);
      for(WaterFairy fairy : fairies){
        float sub = PVector.sub(fairy.location, location).mag();
        if(sub < neighbor){
          neighbor = sub;
          randomloc.set(fairy.location);
          neighborFairy = fairy;
          fairy.enemy = this;
        }
      }
    }
    else if(foods.size() > 0 && random(1) < 0.01){
      randomloc.set(random(width - 350) + 150, random(height - 350) + 150);
      neighborFairy = null;
    }
    else if(random(1) < 0.01){
      randomloc.set(random(width - 350) + 150, random(height - 350) + 150);
      neighborFairy = null;
    }
    else{
      neighborFairy = null;
    }
    // ランダムに決められた座標に向かうlocationを計算
    acceleration = PVector.sub(randomloc, location);
    acceleration.normalize();
    acceleration.mult(0.2);
    if(neighborFairy != null){
      acceleration.mult(4.0);
    }
    acceleration.add(sep);
    
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    
    if(location.x + velocity.x < 100 || location.x + velocity.x > width - 100){
      if(random(1) < 0.5){
        //velocity.rotate(90);
        //acceleration.x *= -1;
        velocity.x *= -1;
      }
      else{
        //velocity.rotate(-90);
        //acceleration.x *= -1;
        velocity.x *= -1;
      }
    }
    if(location.y + velocity.y < 100 || location.y + velocity.y > height - 100){
      if(random(1) < 0.5){
        //velocity.rotate(90);
        velocity.y *= -1;
      }
      else{
        //velocity.rotate(-90);
        velocity.y *= -1;
      }
    }
    
    drawBody(0, location.x, location.y);
    for(int i = 0; i < x.length-1; i++){
      drawBody(i+1, x[i], y[i]);
    }
  }
  
  void drawBody(int i, float mx, float my){
    calculateAngle(i, mx, my);
    pushMatrix();
    pushStyle();
    stroke(255, 50, 0, min(hp/10, 255));
    fill(255, 50, 0, min(hp/10, 255));
    translate(x[i], y[i]);
    rotate(angle);
    switch(i){
      case 0 :
        noFill();
        //stroke(255, 180);
        strokeWeight(2);
        arc(0, 0, 60, 60, HALF_PI, PI+HALF_PI);
        ellipse(-35, 0, 10, 10);
        break;
      case 1 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 30, 30);
        ellipse(0, 0, 15, 15);
        //fill(255);
        ellipse(0, 0, 6, 6);
        ellipse(-space/2, 0, 10, 10);
        
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(-space/4, space/3, 12, 12);
        ellipse(-space/4, -space/3, 12, 12);
        //fill(255);
        ellipse(-space/4, space/3, 5, 5);
        ellipse(-space/4, -space/3, 5, 5);
        
        /*
        stroke(255, 180);
        strokeWeight(1);
        line(-space/4, space/3, -100, 70);
        line(-space/4, -space/3, -100, -70);
        fill(255);
        ellipse(-100, 70, 5, 5);
        ellipse(-100, -70, 5, 5);
        */
        break;
      case 2 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 30, 30);
        ellipse(0, 0, 15, 15);
        //fill(255);
        ellipse(0, 0, 6, 6);
        ellipse(-space/2, 0, 10, 10);
        
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(-space/4, space/3, 12, 12);
        ellipse(-space/4, -space/3, 12, 12);
        //fill(255);
        ellipse(-space/4, space/3, 5, 5);
        ellipse(-space/4, -space/3, 5, 5);
        
        /*
        stroke(255, 180);
        strokeWeight(1);
        line(-space/4, space/3, -100, 50);
        line(-space/4, -space/3, -100, -50);
        fill(255);
        ellipse(-100, 50, 5, 5);
        ellipse(-100, -50, 5, 5);
        */
        break;
      case 3 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 25, 25);
        ellipse(0, 0, 10, 10);
        //fill(255);
        ellipse(0, 0, 3, 3);
        ellipse(-space/2, 0, 10, 10);
        break;
      case 4 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 25, 25);
        ellipse(0, 0, 10, 10);
        fill(255);
        ellipse(0, 0, 3, 3);
        ellipse(-space/2, 0, 10, 10);
        break;
      case 5 :
        ///noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 20, 20);
        ellipse(0, 0, 5, 5);
        fill(255);
        ellipse(-space/2, 0, 10, 10);
        break;
      case 6 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 20, 20);
        ellipse(0, 0, 5, 5);
        fill(255);
        ellipse(-space/2, 0, 10, 10);
        break;
      case 7 :
        //noFill();
        //stroke(255, 180);
        strokeWeight(2);
        ellipse(0, 0, 8, 8);
        break;
    }
    popStyle();
    popMatrix();
  }
  
  void calculateAngle(int i, float tx, float ty){
    float dx = tx - x[i];
    float dy = ty - y[i];
    angle = atan2(dy, dx);
    x[i] = tx - (cos(angle) * space);
    y[i] = ty - (sin(angle) * space);
  }
  
  void collision(){
    if(neighborFairy != null){
      if(PVector.sub(neighborFairy.location, location).mag() < 20){
        hp += neighborFairy.hp;
        fairies.remove(neighborFairy);
        //hp += 1000;
      }
    }
  }
  
  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<BigFish> bigFishes) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (BigFish other : bigFishes) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(topspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
}
