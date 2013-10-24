class lightningBolt{
  float lineWidth0,theta,x0,y0,x1,y1,x2,y2,straightJump,straightJumpMax,straightJumpMin,lineWidth,alpha;
  color lightningColor;
  boolean usStrike = false;
  boolean nonUsStrike = false;
  boolean usHit = false;
  boolean nonUsHit = false;
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
       lightningColor = color(100,65,70);
       usHit = true;
      }
      else if (_nonUsHit == true){
       //hit in the US
       lightningColor = color(10,80,70);
       nonUsHit = true;
      }
      if (_usStrike == true){
       //US Strike
       lightningColor = color(60,40,70);
       usStrike = true;
      }
      else if (_nonUsStrike == true){
       //non-US Strike
       lightningColor = color(boltColor);
       nonUsStrike = true;
      }     
    }
    else {
      float ranNum = random(100000);
      ranNum = 100 * 0.001;
      println(ranNum);
      if (ranNum >0 && ranNum <=.012){
       //hit in the US
       lightningColor = color(100,65,70);
       usHit = true;
      }
      else if (ranNum >.012 && ranNum <=.025){
       //hit in the US
       lightningColor = color(10,80,70);
       nonUsHit = true;
      }
      if (ranNum >.025 && ranNum <=49.83){
       //US Strike
       lightningColor = color(60,40,70);
       usStrike = true;
      }
      else if (ranNum >49.83 && ranNum <=100){
       //non-US Strike
       lightningColor = color(boltColor);
       nonUsStrike = true;
      }      
    }
  }

 
  void draw()
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
       
      if(randomColors)
        lightningColor = slightlyRandomColor(lightningColor,straightJump);
       
      lineWidth = map(y2, height,y0, 1,lineWidth0);
      if(lineWidth<0)
        lineWidth = 0;
      if(usHit){
        lightningColor = slightlyRandomColor(color(100,65,70),straightJump);
        stroke(100,65,70);        
      }
      else if(nonUsHit){
        lightningColor = slightlyRandomColor(color(10,80,70),straightJump);
        stroke(10,80,70);        
      }
      else if(usStrike){
        lightningColor = slightlyRandomColor(color(60,40,70),straightJump);
        stroke(60,40,70);        
      }
      else if(nonUsStrike){
        lightningColor = slightlyRandomColor(boltColor,straightJump);
        stroke(boltColor);        
      }
      strokeWeight(lineWidth);
      line(x1,y1,x2,y2);
      x1=x2;
      y1=y2;
      alpha = alpha-5; 
      //think about making a fork
      if(random(0,1)<childGenOdds){//if yes, have a baby!
        float newTheta = theta;
        newTheta += randomSign()*random(minDTheta, maxDTheta);
        if(theta>maxTheta)
          theta = maxTheta;
        if(theta<-maxTheta)
          theta = -maxTheta;
        if(usHit){
          (new lightningBolt(x2, y2, lineWidth, newTheta, straightJumpMin, straightJumpMax,false,false,true,false)).draw();        
        }
        else if(nonUsHit){
          (new lightningBolt(x2, y2, lineWidth, newTheta, straightJumpMin, straightJumpMax,false,false,false,true)).draw();    
        }
        else if(usStrike){
          (new lightningBolt(x2, y2, lineWidth, newTheta, straightJumpMin, straightJumpMax,true,false,false,false)).draw();       
        }
        else if(nonUsStrike){
          (new lightningBolt(x2, y2, lineWidth, newTheta, straightJumpMin, straightJumpMax,false,true,false,false)).draw();       
        }
        
      }
    }
  }
void drawMarker(){
      noStroke();
      if(usHit){
         fill(100,65,70,80);
         ellipse(x0,155,10,10);        
      }
      else if(nonUsHit){
         fill(10,80,70,80);
         ellipse(x0,155,10,10);        
      }
      else if(usStrike){
         fill(60,40,70,80);
         ellipse(x0,155,10,10);        
      }
      else if(nonUsStrike){
         fill(100,0,100,80);
         ellipse(x0,155,10,10);        
      }  
  }
}
