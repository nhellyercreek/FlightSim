PImage gearD;
PImage gearU;
int planeX = 200;
int planeY = 200;
boolean gearIsDown = true;
boolean stall = false;
float knots = 0;
float max=350;
int stallSpeed=140;
int flapsConf=0;
int alt = 0;
float pitch = 0;
float vs = 0;
boolean ground = true;
boolean up = false;
boolean down = false;
int throttle = 0;
int tos = 160;
int aircraftWeight;
int runwayLength;
int v1, vr, v2;
boolean sim=false;
boolean masterCaution;
String cautionType;
boolean TO;
float pitchRate;
float maxPitch=0.001;
float minPitch=-0.001;
float maxUp=0.30;
float maxDown=-0.15;
boolean fbwMD;
boolean fbwMU;
float maxSpeed;
boolean overSpeed;
boolean controls;
boolean masterCautionDC = false;
boolean decend = false;
float roc;  
float drag;
float dragCOEF;
float defaultDCOEF = 0.5;
float gearDCOEF = 0.2;
float airDensity = 29.95;
PFont font;
PFont regFont;


// used sounds from 
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer a5;
AudioPlayer a10;
AudioPlayer a20;
AudioPlayer retard;
AudioPlayer a30;
AudioPlayer a40;
AudioPlayer a50;
AudioPlayer a60;
AudioPlayer a70;
AudioPlayer a100;
AudioPlayer a200;
AudioPlayer a300;
AudioPlayer a400;
AudioPlayer a500;
AudioPlayer a1000;
AudioPlayer a2500;
AudioPlayer DontSink;
AudioPlayer SinkRate;
AudioPlayer TooLowGear;
AudioPlayer TooLowFlaps;
AudioPlayer TooLowTerrain;
AudioPlayer MasterCaution;

void setup() {
  font= createFont("/Users/noahhellyer/Desktop/Desktop/flightSim/B612-Regular.ttf", 128);
  regFont= createFont("/Users/noahhellyer/Desktop/Desktop/flightSim/SF-Pro.ttf", 120);
  textFont(regFont);
  minim = new Minim(this);
  a5 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/5.wav");
  a10 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/10.wav");
  a20 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/20.wav");
  a30 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/30.wav");
  a40 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/40.wav");
  a50 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/50.wav");
  a60 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/60.wav");
  a70 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/70.wav");
  a100 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/100.wav");
  a200 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/200.wav");
  a300 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/300.wav");
  a400 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/400.wav");
  a500 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/500.wav");
  a1000 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/1000.wav");
  a2500 = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/2500.wav");
  retard = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/retard.wav");
  DontSink = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/DontSink.wav");
  SinkRate = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/SinkRate.wav");
  TooLowGear = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/TooLowGear.wav");
  TooLowFlaps = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/TooLowFlaps.wav");
  TooLowTerrain = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/TooLowTerrain.wav");
  MasterCaution = minim.loadFile("/Users/noahhellyer/Desktop/Desktop/flightSim/Sounds/MasterCaution.mp3");
  retard.play();
  // resize images and load them
  gearD = loadImage("gearD.png");
  gearU = loadImage("gearU.png");
  gearD.resize(600, 350);
  gearU.resize(600, 350);
  size(1080, 720);
  runwayLength=3657;
  aircraftWeight=60000;
  TO = true;
  // premade V speeds. To add actual calculator later
  v1 = 126;
  vr = 126;
  v2 = 146;
}

void draw() {
  if (sim == true) {
    
      frameRate(60);
    fill(0);
    textSize(15);
    background(255);
    textAlign(CORNER);
    text("Flaps: "+flapsConf, width-width+20, 20);
    text("Speed: "+knots, width-width+20, 35);
    text("Altitude: "+alt/60, width-width+20, 50);
    text("VS: "+vs, width-width+20, 65);
    text("Throttle: "+throttle+"%", width-width+20, 80);
    text("Pitch: "+pitch*100, width-width+20, 95);
    fill(255);
    flaps();
    stall();
    stallSpeed();
    ground();
    plane();
    TOS();
    speed();
    AOA();
    overspeed();
    masterCaution();
    gpws();
    altPhys();
    drag();
    dragCOEF();
    vertSpeed();
  } else if(controls==true){
    background(0);
    fill(255);
    textAlign(CENTER);
    textSize(30);
    text("Press C again to exit",width/2,height-100);
    
  } else{
    background(0);
    fill(255);
    textAlign(CENTER);
    textSize(30);
    text("Welcome to the Airbus A320 Neo flight simulator!", width/2, 50);
    text("Sim configured as:", width/2, 200);
    text("Aircraft Weight: " + aircraftWeight + " kg", width/2, 240);
    text("Runway Length: " + runwayLength + " m", width/2, 280);
    text("Click anywhere to continue", width/2, 400);
    text("Click C to see controls", width/2, 320);
    tos = vr;
  }
}
void overspeed(){
  if(flapsConf==1){
   maxSpeed=215; 
  } else if(flapsConf==2){
   maxSpeed=200; 
  } else if(flapsConf==3){
   maxSpeed=185; 
  } else if(flapsConf==4){
   maxSpeed=177; 
  } else {
    maxSpeed=350;
  }
  if(knots>maxSpeed){
   overSpeed=true; 
  } else {
   overSpeed=false; 
  }
}
void AOA() {
  if (TO == true) {
    if (up == true && knots>tos*0.90 && fbwMU==false) {
      pitch+=maxPitch;
    }
  }
  if (down==true  && knots>tos*0.90 && fbwMD==false &&ground==true&&pitch>0.001){
    pitch-=maxPitch;
  }
  if (down==true  && knots>tos*0.90 && fbwMD==false &&ground==false){
    pitch-=maxPitch;
  }
  
  if (pitch>=maxUp) {
    fbwMU = true;
  } else {
    fbwMU = false;
  }
  if (pitch<=maxDown) {
    fbwMD=true;
  } else {
    fbwMD=false;
  }
  if (abs(pitch) < 0.000001) {
    pitch = 0;
}

}


void speed() {
  knots = knots +throttle*0.0015;
}
void TOS() {
  if (flapsConf == 0) {
    tos = 160;
    if (TO == true && throttle>0 && masterCautionDC == false){
       masterCaution=true;
       cautionType="FLAPS NOT IN T.O. CONFIG";
    }
   
  }
  if (flapsConf == 1) {
    tos=128;
  }
  if (flapsConf==2) {
    tos=148;
  }
  if (flapsConf==3) {
    tos=78;
  }
  if (flapsConf==4) {
    tos=60;
    if (TO == true && throttle>0){
       masterCaution=true;
       cautionType="FLAPS NOT IN T.O. CONFIG";
    }
   
  }
}
void plane() {
  translate(planeX + gearD.width / 2, planeY + gearD.height / 2);
  rotate(pitch);
  if (gearIsDown) {
    image(gearD, -gearD.width / 2, -gearD.height / 2);
  } else {
    image(gearU, -gearU.width / 2, -gearU.height / 2);
  }
  resetMatrix();
}

void ground() {
  if (alt ==0) {
    ground = true;
  } else {
    ground = false;
  }
  if (ground==true) {
    gearIsDown=true;
  }
}
void flaps() {
  if (flapsConf==5) {
    flapsConf=4;
  }
  if (flapsConf==-1) {
    flapsConf=0;
  }
}

void stall() {
  if (knots > stallSpeed || ground == true) {
    stall = false;
  } else {
    stall = true;
  }
  if (stall == true && pitch>-10) {
    pitch -=0.01;
    vs -=0.5;
    knots++;
  } else if(stall==true){
    vs -=0.5;
    knots++; 
  }
}

void stallSpeed() {
  if (flapsConf==0) {
    stallSpeed=130;
  } else if (flapsConf==1) {
    stallSpeed = int(tos*0.85);
  } else if (flapsConf==2) {
    stallSpeed = int(tos*0.85);
  } else if (flapsConf==3) {
    stallSpeed = int(tos*0.85);
  } else if (flapsConf==4) {
    stallSpeed = int(tos*0.85);
  }
}

void keyPressed() {
  if (key=='g' || key=='G' && ground==false) {
    gearIsDown = !gearIsDown;
  }
  if (key=='r' || key=='R') {
    if (flapsConf>=0 && flapsConf<=4) {
      flapsConf--;
    }
  }
  if (key=='f' || key=='F') {
    if (flapsConf>=0 && flapsConf<=4) {
      flapsConf++;
    }
  }
if (key == 'c' || key == 'C') {
    if (sim == false) {
      controls = !controls;
    }
  }
  if (key=='s' || key=='S') {
    up = true;
  }
  if (key=='w' || key=='W') {
    down = true;
  }
  if (key=='a' || key=='A') {
    if (throttle>98) {
      throttle=98;
    }
    throttle+=2;
  }
  if (key=='d' || key == 'D') {
    throttle-=2;
    if (throttle<0) {
      throttle=0;
    }
  }
  if (key=='m' || key=='M' && masterCaution==true) {
    masterCautionDC=true;
    masterCaution=false;
    cautionType="";
  }
}
void keyReleased() {
  if (key=='s' || key=='S') {
    up = false;
  }
  if (key=='w' || key=='W') {
    down = false;
  }
}
void masterCaution() {
  if (masterCaution==true){
    MasterCaution.play();
  } else {
    MasterCaution.pause();
    MasterCaution.rewind();
  }
}
void mousePressed() {
  if (sim==false&&controls==false) {
    sim = true;
  }
}
void gpws(){
  if(decend==true&&alt==2500){
    a2500.play();
  }
  if(decend==true&&alt==1000){
    a1000.play();
  }
  if(decend==true&&alt==500){
    a500.play();
  }
  if(decend==true&&alt==400){
    a400.play();
  }
  if(decend==true&&alt==300){
    a300.play();
  }
  if(decend==true&&alt==200){
    a200.play();
  }
  if(decend==true&&alt==100){
   a100.play(); 
  }
  if(decend==true&&alt==70){
    a70.play();
  }
  if(decend==true&&alt==60){
    a60.play();
  }
  if(decend==true&&alt==50){
    a50.play();
  }
  if(decend==true&&alt==40){
    a40.play();
  }
  if(decend==true&&alt==30){
    a30.play();
  }
  if(decend==true&&alt==20){
    a20.play();
  }
  if(decend==true&&alt==20){
    retard.play();
  }
  if(decend==true&&alt==10){
    a10.play();
  }
}

void altPhys(){
  alt+=(vs/60);
  if (vs<0){
    decend=true;
  } else{
    decend= false;
    a10.rewind();
    a20.rewind();
    retard.rewind();
    a40.rewind();
    a30.rewind();
    a50.rewind();
    a60.rewind();
    a70.rewind();
    a100.rewind();
    a200.rewind();
    a300.rewind();
    a400.rewind();
    a500.rewind();
    a1000.rewind();
    a2500.rewind();
  }
    
}

void dragCOEF(){
  if (gearIsDown==true){
    if(flapsConf==0){
     dragCOEF=defaultDCOEF+gearDCOEF+0.2;
    } 
    if(flapsConf==1){
     dragCOEF=defaultDCOEF+gearDCOEF+0.4;
    } 
    if(flapsConf==2){
     dragCOEF=defaultDCOEF+gearDCOEF+0.6;
    } 
    if(flapsConf==3){
     dragCOEF=defaultDCOEF+gearDCOEF+0.9;
    } 
    if(flapsConf==4){
     dragCOEF=defaultDCOEF+gearDCOEF+1.1;
    } 
  } else if (gearIsDown==false){
      if(flapsConf==0){
     dragCOEF=defaultDCOEF+0.2;
    } 
    if(flapsConf==1){
     dragCOEF=defaultDCOEF+0.4;
    } 
    if(flapsConf==2){
     dragCOEF=defaultDCOEF+0.6;
    } 
    if(flapsConf==3){
     dragCOEF=defaultDCOEF+0.9;
    } 
    if(flapsConf==4){
     dragCOEF=defaultDCOEF+1.1;
    } 
  } 
}

void drag(){
  drag=dragCOEF*0.5*airDensity*122.6;
  roc = ((27000*100)-drag)*knots/60000;
}

void vertSpeed(){
  vs = roc*sin(pitch);
}
