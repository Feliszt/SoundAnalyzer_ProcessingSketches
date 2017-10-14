  // OSC parameters
import oscP5.* ;                        // import libraries
import netP5.*;
OscP5 oscP5;
int localhostadress ;

  // freq parameters
int numBins;
float[] freqBins = new float[numBins+1];

  // rect parameters
float maxSz;
float rotRects;

void setup() {
  // set window
  size(800, 800);
  
  // set drawing parameters
  noStroke();
  rectMode(CENTER);
  maxSz = min(width, height);
  maxSz = maxSz * 0.5;
  
  // OSC parameters
  localhostadress = 8060 ;                     // set OSC adress
  oscP5 = new OscP5(this, localhostadress) ;   // connect to OSC channel 
}

void draw() {
  // set background
  background(0);
  
  // draw rectangles
  pushMatrix();
  translate(width / 2, height /2);
  rotate(rotRects);
  for(int i = 0; i < numBins; i++) {
    // set rect size
    float rectSz = map(i, 0, numBins, maxSz, 10);
    rectSz = map(freqBins[i], 0, 100, rectSz, 2 * rectSz); 
    
    // set rect rot
    float rectRot = - freqBins[i] / 100;
    
    // set color
    //color c = color(map(i, 0, numBins, 20, 100));
    color c = color(map(i, 0, numBins, 20, 100) + map(freqBins[i], 0, 100, 0, 50));
    
    // rotate each rect
    pushMatrix();
    rotate(rectRot);
    scale(rectSz);
    
    // draw rect
    fill(c);    
    rect(0, 0, 1, 1);
    
    popMatrix();
  }
  popMatrix();
  
  // update rotation
  //rotRects -= freqBins[0] / 10000;
}

  // function that receives OSC messages
void oscEvent(OscMessage theOscMessage) {   
  // get number of bins
  if(theOscMessage.checkAddrPattern("/numBins")==true)
  {
    numBins = theOscMessage.get(0).intValue();
  }
  
  // get each bin value
  freqBins = new float[numBins];
  if (theOscMessage.checkAddrPattern("/binsFreq")==true) {
    for (int i = 0; i < numBins; i++) {
      freqBins[i] = theOscMessage.get(i).floatValue(); 
    }
  }
}