  // SOUND ANALYZER //
import oscP5.* ;                        // import libraries
import netP5.*;
OscP5 oscP5;
int localhostadress = 9000;
int numBins;
float[] freqBins;
float volume;

  // setup function
void setup() {   
    // window size
  size(200, 200);
  //fullScreen();
  
      // OSC parameters
  oscP5 = new OscP5(this, localhostadress) ;   // connect to OSC channel 
}  
  
  // draw function
void draw() {
  
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