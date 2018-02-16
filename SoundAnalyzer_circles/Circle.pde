class Circle {
  float weight;
  float rad;
  color col;
  boolean out;
  
 Circle(float _rad, float _weight) {
   rad = _rad;
   weight = _weight;
   
   col = 220;
 }
 
 void update() {
   // update properties
  rad += map(rad, 0, 1.5 * width, 1, 1); 
  weight += map(rad, 0, 1.5 * width, 0.01, 0.1);
  
  // update state
  out = rad > 1.5 * width;
 }
 
 void show(float offset, color showCol) {
   noFill();
   strokeWeight(weight + offset);
   stroke(showCol);
   
   float accRad = rad + 0;   
   ellipse(width / 2, height / 2, accRad, accRad);
 } 
}