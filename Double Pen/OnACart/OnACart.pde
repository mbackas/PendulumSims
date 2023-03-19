import controlP5.*;
ControlP5 cp5;
Slider abc;
Slider theta_slide;
CallbackListener cb;

float theta=PI/4;
float theta_dot=0.0;

float x=0;
float x_dot=0.0;

boolean dragging=false;
boolean theta_dragging=false;
boolean control=true;

float length = 0.06;

void setup() {
  //int heightL=displayHeight;
  //int widthL=displayWidth;
  //println(heightL,widthL);
  size(1280,700);
  cp5 = new ControlP5(this);
  //translate(1000,1000);
  
  ////FORCE SLIDER//////
  abc = cp5.addSlider("force")
    .setPosition(20, height-50)
    .setSize(1200, 20)
    .setRange(-.5, .5)
    .setValue(0)
    .addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      //print(theEvent.getAction());
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE) {
        //abc.setValue(0);
        dragging = false;
      }
      if(theEvent.getAction()==ControlP5.ACTION_PRESS){
        dragging=true;
      }
      if(theEvent.getAction()==ControlP5.ACTION_CLICK){
        control = !control;
        abc.setValue(0);
      }
    }
  }
  );
    ////FORCE SLIDER//////
  
  println(theta);
  
  ///////THETA SLIDE//////////
  theta_slide = cp5.addSlider("theta")
    .setPosition(20, height-100)
    .setSize(1200, 20)
    .setRange(-3.5, 3.5)
    .setValue(3*PI/4)
    .addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      //print(theEvent.getAction());
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE) {
        theta_dragging = false;
        theta_dot=0;
      }
      if(theEvent.getAction()==ControlP5.ACTION_PRESS){
        theta_dragging=true;
      }
    }
  }
  );
  ///////THETA SLIDE//////////
  
  //println(height, width);
}

float T=0.001;

float F=0.0;
float Fx=0.0;
boolean flag=false;

float M = 0.2;
float Mx = 5;
int pixelsPerm=3822;

long prevTime = millis();
long time=prevTime;
long diff = 0;

void draw() {
  //print(int(dragging));
  if(!dragging && control){
    float val=0;
    //val = 100*theta_dot/(abs(theta_dot)+0.0001)*((1.005*M*length*g)-(0.5*M*length*length*theta_dot*theta_dot)-(M*g*length*cos(theta)));
    if(theta> -0.5 && theta < 0.5){
      //val=-4*sin(theta)-.2*theta_dot;
    }
    //else if (theta_dot>0)
    //  val=.05;
    //else
    //  val=-.05;
    abc.setValue(val);
  }
  if(!theta_dragging){
    //F=0;
    float theta_old = theta;
    float theta_dot_old = theta_dot;
    prevTime=time;
    time=millis();
    diff = time-prevTime;
    theta = generateNextTheta(F,Fx,theta_old,theta_dot_old,1.0*diff/1000.0);
    x = generateNextX(F,Fx,theta_old,theta_dot_old,1.0*diff/1000.0);
    theta_slide.setValue(theta);
  }
  
  //print(abc.getTriggerEvent());
  background(0);
  stroke(255);
  fill(255);
  //rotate(-1*HALF_PI);
  //rotate(theta);
  //while(millis()-prevTime < T*1000){
  //println(theta);
//}
  line(width/2 + x*pixelsPerm, height/2, width/2 + x*pixelsPerm + pixelsPerm*length*sin(theta), height/2 - pixelsPerm*length*cos(theta));
  //line(400, 600, 600, 800);
  //rotate( PI/8.0 * cos( map( millis()%7000, 0, 7000,0,TWO_PI) ) );  line(0,0,150,0);
  ellipse(width/2 + x*pixelsPerm + pixelsPerm*length*sin(theta), height/2 - pixelsPerm*length*cos(theta), 20, 20);
  ellipse(width/2 + x*pixelsPerm, height/2, 20, 20);
  //ellipse(1000, 1000, 200, 200);
}
float g=9.8;



float generateNextTheta(float f, float fx, float Theta, float Theta_dot, float per) {
  float theta_new=theta;
  theta_dot += (f*(Mx+M)/(M*length) - fx*cos(Theta)/length + pow(Theta_dot,2)*sin(Theta)*cos(Theta)*M + g*(Mx+M)*sin(Theta))/(Mx+M*pow(sin(Theta),2))*per;
  theta_new += theta_dot*per;
  while(theta_new>PI){
    theta_new-=2*PI;
  }
  while(theta_new<-PI){
    theta_new+=2*PI;
  }
  return theta_new;
}





float generateNextX(float f, float fx, float Theta, float Theta_dot, float per) {
  float x_new = x;
  x_dot += (fx - f*cos(Theta)/length - M*g*sin(Theta)*cos(Theta) - pow(Theta_dot,2)*sin(Theta)*M*length)/(Mx + M*pow(sin(Theta),2))*per;
  x_new += x_dot*per;
  //while(x_new*pixelsPerm < -width/2){
  //  x_new += 1.0*width/pixelsPerm;
  //}
  //while(x_new*pixelsPerm > width/2){
  //  x_new -= 1.0*width/pixelsPerm;
  //  print(x_new);
  //}
  if(x_new*pixelsPerm < -width/2 && x_dot<0){
    x_dot*=-1;
  }
  if(x_new*pixelsPerm > width/2 && x_dot>0){
    x_dot*=-1;
    print(x_new);
  }
  return x_new;
}
void force(float theVal) {
  //println("force = "+theVal);
  F=theVal;
  flag = true;
}

void theta(float theVal) {
  //println("force = "+theVal);
  theta=theVal;
  flag = true;
}
