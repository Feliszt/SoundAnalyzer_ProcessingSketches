  // OSC parameters
import oscP5.* ;                        // import libraries
import netP5.*;
OscP5 oscP5;
int localhostadress ;

  // freq parameters
int numBins;
float[] freqBins;
float volume;

// parameters
int maxHistSize = 25;
ArrayList<float[]> freqBinsHist = new ArrayList<float[]>();
float rot = 0;
color bgColor = #3A405A;
color shapeColor = #F9DEC9;
boolean mirror = false;
enum DrawMode { FILLED, OUTLINE };
DrawMode mode = DrawMode.FILLED;

  // setup function
void setup() {   
    // window size
  size(800, 800);
  //fullScreen();
  
      // OSC parameters
  localhostadress = 9001 ;                     // set OSC adress
  oscP5 = new OscP5(this, localhostadress) ;   // connect to OSC channel 
}  
  
  // draw function
void draw() {
  // background
  background(bgColor);
  
  pushMatrix();
  translate(width / 2, height / 2);
  rotate(rot);  
  
  // check draw mode
  if(mode == DrawMode.FILLED) {
    noStroke();
  }
  if(mode == DrawMode.OUTLINE) {
    noFill();
    stroke(shapeColor);
  }
  
  for(int j = 0; j < freqBinsHist.size(); j++) {
    float[] freqList = freqBinsHist.get(j);
    float rad = map(j, 0, maxHistSize, width / 4, width / 50);
    float force = map(j, 0, maxHistSize, 1, 0.5);    
      // check draw mode
    if(mode == DrawMode.FILLED) {
      fill(lerpColor(bgColor, shapeColor, (float) j / maxHistSize));
    }
    if(mode == DrawMode.OUTLINE) {
      strokeWeight(map(j, 0, maxHistSize, 3, 0.5));
    } 
    
    beginShape();
    for(int i = 0; i < freqList.length; i++) {
      float rho =  rad + freqList[i] * force; 
      float theta = map(i, 0, numBins, 0, mirror ? PI : 2 * PI);
      vertex(rho * cos(theta), rho * sin(theta));
    }
    if(mirror) {
      for(int i = freqList.length - 1 ; i >= 0; i--) {
        float rho =  rad + freqList[i] * force; 
        float theta = map(i, numBins, 0, PI, 2 * PI);
        vertex(rho * cos(theta), rho * sin(theta));
      }
    }
    endShape(CLOSE);
  }
  popMatrix(); 
  
  
  rot += volume / 30;
}

void keyPressed() {
  if (key == '+') {
    maxHistSize++;
  }
  if (key == '1') {
    mode = DrawMode.FILLED;
  }
  if (key == '2') {
    mode = DrawMode.OUTLINE;
  }
}

void mouseClicked() {
 mirror = !mirror; 
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
    
    freqBinsHist.add(freqBins);
    if(freqBinsHist.size() > maxHistSize) {
      freqBinsHist.remove(0);
    }
  }  
}