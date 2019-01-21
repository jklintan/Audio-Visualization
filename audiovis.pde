//Setup minim audio library
import ddf.minim.*;
import ddf.minim.analysis.*;
import peasy.*;
import controlP5.*;
ControlP5 cp5;

PeasyCam cam;

Minim minim;
AudioPlayer song;
BeatDetect beat;

int total = 200;
int depth = 1600;
boolean updated = false;
float koeff = 1;
boolean shrunken = false;
int shrunk = 0;

float angle = PI;

void setup(){
  size(800, 600, P3D);
  //cam = new PeasyCam(this, 500);

  //Pass to minim so we can load files from directory
  minim = new Minim(this);
  
  //Load sound file, create buffer size
  song = minim.loadFile("bensound-energy.mp3");
  
  //Play the sound
  song.play();
  
  //Detect the beats
  beat = new BeatDetect();
  
  //Set the colormode
  colorMode(HSB);
  
  
  cp5 = new ControlP5(this);
  cp5.addSlider("slider1").setPosition(150, -280).setSize(200, 20).setRange(0, 200);
}

void updateCol(){
            float rand1 = random(100, 255);
          float rand2 = random(100, 255);
          float rand3 = random(100, 255);
          stroke(rand1, rand2, rand3);
}




void draw(){
  beat.detect(song.mix);
  background(0);
        lights();
  camera();
  translate(400, 300, 0);
      float r = 200;
      for (int k = 0; k < total+1; k++) {
        float lat = map(k, 0, total, -PI, angle);
  
          for (int j = 0; j < total+1; j++) {
          float lon = map(j, 0, total, -2*PI, 2*angle);
          float x = r * sin(lat) * cos(lon) * koeff;
          float y = r * sin(lat) * sin(lon) * koeff;
          float z = r * cos(lat) * koeff;
          point(x, y, z);
          updated = true;
        }
      }
  
    
    float value = cp5.getController("slider1").getValue();;
      

      for(int i = 0; i < song.bufferSize() - 1; i++){
      float x1 = map( i, 0, song.bufferSize(), 0, 300 );
    float x2 = map( i+1, 0, song.bufferSize(), 0, 300 );
      //line( x1, 300 + song.right.get(i)*50, x2, 300 + song.right.get(i+1)*50 );
      }
      
    if( beat.isOnset() ){
      updateCol();
      if(!shrunken){
        koeff = koeff - koeff/10;
        shrunk++;
        if(shrunk == 1){
          shrunken = true;
          shrunk = 0;
        }
      }else{
        koeff = koeff + koeff/10;
        shrunken = false;
      }
  }
  
  //rotate(radians(frameCount));
  //    line( x1, 150 + song.right.get(i)*50, x2, 150 + song.right.get(i+1)*50 );
  
  angle += PI/2;

}
