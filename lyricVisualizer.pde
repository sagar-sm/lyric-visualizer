//Sagar Mohite
//Happy by Pharrell Williams

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import java.util.*;

PShader blur;
PFont oseb;
int DELAY = 5000;

Minim minim;
AudioPlayer song;
AudioInput in;
BeatDetect beat, beat2;
BeatListener bl;

int saved = 1, saved2 = 1;
String text[];
String[] lyrics = new String[75];
Integer[] start = new Integer[75];
int[] end = new int[75];
String[] words = new String[3];
int c = 0;

float eRadius, r;
float kickSize, snareSize, hatSize;
PVector kick, snare, hat;
PVector farKick, farSnare, farHat;
ArrayList<PVector> ellipses, farEllipses; 


float R=125; 
float centerR=125; 
float a=PI/2; 
float a1=PI; 
float a2=3*PI/2; 
float pathR=125; 
float pathG=125; 
float G=125; 
float centerG=125; 
float pathB=125; 
float B=125; 
float centerB=125; 


void setup(){
  //blur = loadShader("blur.glsl");
  text = loadStrings("happy.txt");
  oseb = loadFont("oseb.vlw");
  minim = new Minim(this);
  song = minim.loadFile("happy.mp3",1024);
  
  for(int i = 0; i < text.length; i++){
    if(text[i].equals(Integer.toString(c+1))){  
      String times[] = split(text[i+1], " --> ");
      
      start[c] = int(toMillis(times[0])) - 5000 + DELAY;
      end[c] = int(toMillis(times[1])) - 5000 + DELAY;
      lyrics[c] = "";

      c++;
    }
    else if(!text[i].isEmpty()){ 
      if(Character.isLetter(text[i].charAt(0)))
        lyrics[c-1] += " " + text[i];
    }
  }  
  
  beat = new BeatDetect();
  beat2 = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat2.setSensitivity(300);  
  bl = new BeatListener(beat2, song);
  
  size(displayWidth,displayHeight,P3D);
  //song.play();
  eRadius = 20;
  r = 1;
  kickSize = snareSize = hatSize = 16;
}

void draw(){
  //filter(blur);
  if(millis() > DELAY)
    song.play();
  if(millis() > 126000+DELAY){
    background(pathR, pathG, pathB);
    pathR=centerR+R*sin(a); 
    a=a+.009;
    
    pathG=centerG+G*sin(a1); 
    a1=a1+.009;
    
    pathB=centerB+B*sin(a2); 
    a2=a2+.009;
  }
  else {
    background(245);
  }
  noStroke();
  
  beat.detect(song.mix);
  float a = map(eRadius, 20, 400, 60, 255);
  if(millis() > 126000 + DELAY) fill(251,251,251,a);
  else fill(0, 0, 0, a);
  if ( beat.isOnset() ) eRadius = 400;
  ellipse(0, height, eRadius, eRadius);
  ellipse(width, height, eRadius, eRadius);
  eRadius *= 0.95;
  if ( eRadius < 20 ) eRadius = 20;
  
  List<Integer> l = Arrays.asList(start);
  int c = closest(millis(), l);
  String[] wordsInLine;
  if (Arrays.asList(start).contains(c)){
    String line = lyrics[Arrays.asList(start).indexOf(c)];
    wordsInLine = split(line, ' ');
    if(saved != c){
      int index = new Random().nextInt(wordsInLine.length);
      
      for(int i = 0; i < 3; i++){
        while(wordsInLine[index] == "" || wordsInLine[index] == " ")
          index = new Random().nextInt(wordsInLine.length);
        words[i] = wordsInLine[index];
        index = new Random().nextInt(wordsInLine.length);
        
        kick = new PVector(random(70, 2*width/5),random(70, height/3));
        snare = new PVector(random(2*width/5, 3*width/5),random(height/3, 2*height/3));
        hat = new PVector(random(3*width/5, width-210),random(2*height/3, height-70));
        
        farKick = new PVector(random(width, 2*width),random(height, 2*height));
        farSnare = new PVector(random(0, -1*width),random(0, -1*height));
        farHat = new PVector(random(width, 2*width),random(0, -1*height));
        
//        for(int j = 0; j < 10; j++){
//          PVector fe = new PVector(random(width, 2*width),random(0, -1*height));
//          farEllipses.add(fe);
//          PVector e = new PVector(random(width/5, 4*width/5),random(height/4, 3*height/4));
//          ellipses.add(e);
//        }     
      }
      saved = c;
    }    
  }
  else {
    wordsInLine = split(lyrics[0],' ');
  }
  
  if ( beat2.isKick() ) kickSize = 100;
  if ( beat2.isSnare() ) { 
    snareSize = 100;
  } 
  if ( beat2.isHat() ) hatSize = 100;
  
  farKick.x = lerp(farKick.x, kick.x, 0.07);
  farKick.y = lerp(farKick.y, kick.y, 0.09);
  farSnare.x = lerp(farSnare.x, snare.x, 0.07);
  farSnare.y = lerp(farSnare.y, snare.y, 0.1);
  farHat.x = lerp(farHat.x, hat.x, 0.06);
  farHat.y = lerp(farHat.y, hat.y, 0.09);
  
  textFont(oseb, kickSize);
  text(words[0], farKick.x,farKick.y);
  textFont(oseb, snareSize);
  text(words[1], farSnare.x, farSnare.y);
  textFont(oseb, hatSize);
  text(words[2], farHat.x, farHat.y);
  
  if(millis() > 126000 + DELAY) stroke(251);
  else stroke(25);
  
  strokeWeight(1);
  line(0,height, farKick.x, farKick.y);
  line(width,0, farKick.x, farKick.y);
  line(width,height, farSnare.x, farSnare.y);
  line(0,height, farSnare.x, farSnare.y);
  line(0,0, farHat.x, farHat.y);
  line(width,height, farHat.x, farHat.y);


  kickSize = constrain(kickSize * 0.97, 89, 100);
  snareSize = constrain(snareSize * 0.97, 89, 100);
  hatSize = constrain(hatSize * 0.97, 89, 100);
    if ( beat2.isSnare() ) { 
      r = 1;
    
  } 
  float alpha = map(r, 0, 2*width, 125, 0);
  fill(33, 129, 255, alpha);
  noStroke();
  ellipse(0,height, r, r);
  ellipse(width, height, r, r);
  r*=1.2;
  
//  if(millis()>171){
//    for(int i = 0; i < 10; i++){
//      fill(255);
//      farEllipses.get(i).x = lerp(farEllipses.get(i).x, ellipses.get(i).x, 0.1);
//      farEllipses.get(i).y = lerp(farEllipses.get(i).y, ellipses.get(i).y, 0.11);
//      ellipse(farEllipses.get(i).x, farEllipses.get(i).y, 10, 10);
//    }
// }
  
}


void stop()
{
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();  
  super.stop();
}

Float toMillis(String t){
  String times[] = split(t, ":");
  String SSS[] = split(times[2], ",");
 
  return (Float.parseFloat(times[0])*60*60*1000) + (Float.parseFloat(times[1])*60*1000) + (Float.parseFloat(SSS[0])*1000) + Float.parseFloat(SSS[1]); 
}

int closest(int of, List<Integer> in) {
    int min = Integer.MAX_VALUE;
    int closest = of;
    int b = 0;
    for (int v : in) {
        final int diff = Math.abs(v - of);
        b++;
        if (diff < min) {
            min = diff;
            closest = v;
        }
        if(b>71)return closest;
    }
    return closest;
}

boolean sketchFullScreen(){
  return true;
}

