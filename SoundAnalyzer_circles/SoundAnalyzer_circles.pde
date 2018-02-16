  // OSC parameters
import oscP5.* ;                        // import libraries
import netP5.*;
OscP5 oscP5;
int localhostadress = 9000;

  // freq parameters
int numBins;
float[] freqBins;
float volume;

//
int numBinsPrev = 0;
ArrayList<Circle> circles = new ArrayList<Circle>();

  // setup function
void setup() {   
    // window size
  size(1000, 800);
  //fullScreen();
  
      // OSC parameters
  oscP5 = new OscP5(this, localhostadress) ;   // connect to OSC channel 
}  
  
  // draw function
void draw() {
  // background
  int colBg = 10;
  background(colBg);
  
  // compute color
  color col = color((int) map(volume, 0, 0.5, 10, 500));
  
  if(numBins != numBinsPrev) {
   if(numBins > numBinsPrev) {
    for(int i = 0; i < numBins - numBinsPrev; i++) {
     Circle newCirc = new Circle(0, 2);
     circles.add(newCirc);
    }
   }
   if(numBins < numBinsPrev) {
    for(int i = 0; i < numBinsPrev - numBins; i++) {
     circles.remove(circles.size() - 1); 
    }
   }
  }
  
  //
  for(int i = 0; i < numBins; i++) {
   circles.get(i).update();
   circles.get(i).show(freqBins[i] * 1, col);
   
   if(circles.get(i).out) {
      circles.remove(i);
      Circle newCircle = new Circle(0, 2);
      circles.add(newCircle);
   }
  }
  
  // update numBins
  numBinsPrev = numBins;
}

  // function that receives OSC messages
void oscEvent(OscMessage theOscMessage) {
  // debug
  //println(theOscMessage);
  
  if(theOscMessage.checkAddrPattern("/volume")==true)
  {
    volume = theOscMessage.get(0).floatValue();
  }
  
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