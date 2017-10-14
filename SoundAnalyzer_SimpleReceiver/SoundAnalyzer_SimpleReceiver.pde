  // OSC parameters
import oscP5.* ;                        // import libraries
import netP5.*;
OscP5 oscP5;
int localhostadress ;

  // freq parameters
int numBins;
float[] freqBins;
float volume;

  // rectangle parameters
float szRect;
float interRectMax = 20;
float startRect;
color colBg = #e1d8cd;
color colRect = #623722;

  // setup function
void setup() {   
    // window size
  size(1000, 500);
  rectMode(CORNER);
  noStroke();
  
    // set rect parameters
   startRect = width / 16;
  
      // OSC parameters
  localhostadress = 9001 ;                     // set OSC adress
  oscP5 = new OscP5(this, localhostadress) ;   // connect to OSC channel 
}  
  
  // draw function
void draw() {
  // set background
  background(240);
  
  // compute size of rect
  float interRect = interRectMax / numBins * interRectMax;
  szRect = (width - 2 * startRect - (numBins - 1) * interRect ) / numBins;
  
  
  pushMatrix();
  translate(startRect, height / 2);
  // draw each rectangle
  fill(colRect);
  float offsetX = 0;
  for(int i = 0; i < numBins; i++)
  {
    rect(offsetX, -freqBins[i], szRect, freqBins[i]);    
    offsetX += szRect + interRect;
  }
  popMatrix();
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