import controlP5.*;
ControlP5 cp5;
Slider abc;
Slider theta_slide;
CallbackListener cb;

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
  theta_slide = cp5.addSlider("theta")
    .setPosition(20, height-100)
    .setSize(1200, 20)
    .setRange(-3.5, 3.5)
    .setValue(1.69)
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
  println(height, width);
}

float T=0.01;
float theta=1.69;
float theta_dot=0.0;
float F=0.0;
boolean flag=false;

float M = 0.2;
int pixelsPerm=3822;

void draw() {
  //print(int(dragging));
  if(!dragging && control){
    float val=0;
    val = 100*theta_dot/(abs(theta_dot)+0.0001)*((1.005*M*length*g)-(0.5*M*length*length*theta_dot*theta_dot)-(M*g*length*cos(theta)));
    if(theta>-0.5 && theta<0.5){
      val=-4*sin(theta)-.2*theta_dot;
    }
    //else if (theta_dot>0)
    //  val=.05;
    //else
    //  val=-.05;
    abc.setValue(val);
  }
  if(!theta_dragging){
    //F=0;
    theta = generateNextTheta(F);
    theta_slide.setValue(theta);
  }
  
  //print(abc.getTriggerEvent());
  background(0);
  stroke(255);
  fill(255);
  //rotate(-1*HALF_PI);
  //rotate(theta);
  line(width/2, height/2, width/2 + pixelsPerm*length*sin(theta), height/2 + pixelsPerm*length*-cos(theta));
  //line(400, 600, 600, 800);
  //rotate( PI/8.0 * cos( map( millis()%7000, 0, 7000,0,TWO_PI) ) );  line(0,0,150,0);
  ellipse(width/2 + pixelsPerm*length*sin(theta), height/2 + pixelsPerm*length*-cos(theta), 20, 20);
  //ellipse(1000, 1000, 200, 200);
}

long prevTime = millis();
long time=prevTime;
float g=9.8;

float generateNextTheta(float f) {
  float theta_new=theta;
  time = millis();
  theta_dot += (g/length*sin(theta)+f/(M*length)-0.01*theta_dot)*T;
  prevTime=time;
  theta_new += theta_dot*T;
  while(theta_new>PI){
    theta_new-=2*PI;
  }
  while(theta_new<-PI){
    theta_new+=2*PI;
  }
  return theta_new;
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
