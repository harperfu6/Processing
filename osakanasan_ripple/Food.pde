class Food{
  
  PVector location;

  Food(PVector _location){
    location = _location;
  }
  
  void draw(){
    ellipse(location.x, location.y, 10, 10);
  }
}
