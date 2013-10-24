/* @pjs font="TitilliumText.otf"; */

int screenWidth = 980;
int screenHeight = 640;

PFont myFont;
PFont myFont2;

float maxDTheta = PI/10;
float minDTheta = PI/20;
float maxTheta = PI/2;
float childGenOdds = .01;
 
float minBoltWidth = 3;
float maxBoltWidth = 10;
 
float minJumpLength = 1;
float maxJumpLength = 10;
 
boolean stormMode = true;
boolean fadeStrikes = true;
boolean randomColors = false;
float maxTimeBetweenStrikes = 1000;
 
color boltColor;
color skyColor;
 
 
lightningBolt bolt;
float lastStrike = 0;
float nextStrikeInNms = 0;
 
//distance, in milliseconds, of the storm.
float meanDistance = 0;

void setup() {
  colorMode(HSB,100);
  smooth();
  size(screenWidth, screenHeight);
  
  // set up font for sketch
  myFont = createFont("TitilliumText.otf");
  textFont(myFont,48);

  
  background(0);

  noFill();
  meanDistance = 1000*.5;

  boltColor = color(100,0,100);
  skyColor = color(0,0,0);
  background(skyColor);
  drawKey();
}

void draw(){
  //check if any of the stored times need to make a 'ding'
   
  if(stormMode && millis()-lastStrike>nextStrikeInNms){//time for a new bolt?
    lastStrike = millis();
    nextStrikeInNms = random(0,maxTimeBetweenStrikes);
    noStroke();
    fill(0,0,0);
    rect(0,169,width,height);
    noFill();
    bolt = new lightningBolt(random(0,width),174,random(minBoltWidth,maxBoltWidth),0,minJumpLength,maxJumpLength,false,false,false,false);
    bolt.flash();
    bolt.drawMarker();
  }
}

int randomSign() //returns +1 or -1
{
  float num = random(-1,1);
  if(num==0)
    return -1;
  else
    return (int)(num/abs(num));
}
 
color randomColor(){
  return color(random(0,100),99,99);
}
 
color slightlyRandomColor(color inputCol,float length){
  float h = hue(inputCol);
  h = (h+random(-length,length))%100;
  return color(h,99,99);
}

void drawKey(){
   ellipseMode(CENTER);
   textAlign(CENTER);
   textFont(myFont,48);
   fill(boltColor);
   text("Lightning Strikes on 9/14/2013", width/2, 55);
   textFont(myFont,14);
   strokeWeight(5);
   stroke(100,0,100,60);
   line(0,170,width,170);
   noStroke();
   //key 1
   fill(35,100,70);
   ellipse(155,100,30,30);
   fill(boltColor);
   text("US Strike", 203, 107);
   //key 2
   fill(boltColor);
   ellipse(285,100,30,30);
   fill(boltColor);
   text("Non-US Strike", 350, 107);
   //key 3
   fill(100,65,100);
   ellipse(440,100,30,30);
   fill(boltColor);
   text("US Strike + Human Hit", 528, 107);
   //key 4
   fill(10,80,100);
   ellipse(640,100,30,30);
   fill(boltColor);
   text("Non-US Strike + Human Hit", 742, 107);
}

class lightningBolt{
  float lineWidth0,theta,x0,y0,x1,y1,x2,y2,straightJump,straightJumpMax,straightJumpMin,lineWidth;
  color lightningColor;
  boolean usHit = false;
  boolean nonUsHit = false;
  boolean usStrike = false;
  boolean nonUsStrike = false;

  lightningBolt(float x0I, float y0I, float width0, float theta0, float jumpMin, float jumpMax, boolean _usStrike, boolean _nonUsStrike, boolean _usHit, boolean _nonUsHit){
 
    lineWidth0 = width0;
    lineWidth = width0;
    theta = theta0;
    x0 = x0I;
    y0 = y0I;
    x1 = x0I;
    y1 = y0I;
    x2 = x0I;
    y2 = y0I;
    straightJumpMin = jumpMin;
    straightJumpMax = jumpMax;
    straightJump = random(straightJumpMin,straightJumpMax);
    if (_usHit == true  || _nonUsHit == true  || _usStrike == true || _nonUsStrike == true){
      if (_usHit == true){
       //hit in the US
       lightningColor = color(100,65,100);
       usHit = true;
      }
       if (_nonUsHit == true){
       //hit in the US
       lightningColor = color(10,80,100);
       nonUsHit = true;
      }
       if (_usStrike == true){
       //US Strike
       lightningColor = color(35,100,70);
       usStrike = true;
      }
       if (_nonUsStrike == true){
       //non-US Strike
       lightningColor = color(boltColor);
       nonUsStrike = true;
      }     
    }
    else {
      float ranNum = random(100000);
      ranNum = ranNum * 0.001;
      if (ranNum >0 && ranNum <=.012){
       //hit in the US
       lightningColor = color(100,65,100);
       usHit = true;
      }
       if (ranNum >.012 && ranNum <=.025){
       //hit in the US
       lightningColor = color(10,80,100);
       nonUsHit = true;
      }
       if (ranNum >.025 && ranNum <=49.83){
       //US Strike
       lightningColor = color(35,100,70);
       usStrike = true;
      }
       if (ranNum >49.83 && ranNum <=100){
       //non-US Strike
       lightningColor = color(boltColor);
       nonUsStrike = true;
      }      
    }
  }

 
  void flash()
  {
    while(y2<height && (x2>0 && x2<width))
    {
      strokeWeight(1);
       
      theta += randomSign()*random(minDTheta, maxDTheta);
      if(theta>maxTheta)
        theta = maxTheta;
      if(theta<-maxTheta)
        theta = -maxTheta;

      straightJump = random(straightJumpMin,straightJumpMax);
      x2 = x1-straightJump*cos(theta-HALF_PI);
      y2 = y1-straightJump*sin(theta-HALF_PI);

      lineWidth = map(y2, height,y0, 1,lineWidth0);
      if(lineWidth<0)
        lineWidth = 0;
      if(usHit == true){
        stroke(100,65,100);        
      }
       if(nonUsHit == true){
        stroke(10,80,100);        
      }
       if(usStrike == true){
        stroke(35,100,90);        
      }
       if(nonUsStrike == true){
        stroke(boltColor);    
      }
      strokeWeight(lineWidth);
      line(x1,y1,x2,y2);
      x1=x2;
      y1=y2;
      //think about making a fork
      if(random(0,1)<childGenOdds){//if yes, have a baby!
        float newTheta = theta;
        newTheta += randomSign()*random(minDTheta, maxDTheta);
        if(theta>maxTheta)
          theta = maxTheta;
        if(theta<-maxTheta)
          theta = -maxTheta;
         if(usHit == true){
          (new lightningBolt(x2, y2, lineWidth, newTheta, straightJumpMin, straightJumpMax,false,false,true,false)).flash();
        }
         if(nonUsHit == true){
          (new lightningBolt(x2, y2, lineWidth, newTheta, straightJumpMin, straightJumpMax,false,false,false,true)).flash();    
        }
         if(usStrike == true){
          (new lightningBolt(x2, y2, lineWidth, newTheta, straightJumpMin, straightJumpMax,true,false,false,false)).flash();       
        }
         if(nonUsStrike == true){
          (new lightningBolt(x2, y2, lineWidth, newTheta, straightJumpMin, straightJumpMax,false,true,false,false)).flash();       
        }
        
      }
    }
  }
void drawMarker(){
      noStroke();
      if(usHit){
         fill(100,65,100,80);
         ellipse(x0,155,10,10);        
      }
       if(nonUsHit){
         fill(10,80,100,80);
         ellipse(x0,155,10,10);        
      }
       if(usStrike){
         fill(35,100,70,80);
         ellipse(x0,155,10,10);        
      }
       if(nonUsStrike){
         fill(100,0,100,80);
         ellipse(x0,155,10,10);        
      }  
  }
}
