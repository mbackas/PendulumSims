import controlP5.*;
ControlP5 cp5;
Slider abc;
Slider theta_slide;
CallbackListener cb;
boolean dragging=false;
boolean theta_dragging=false;
boolean control=true;
void setup() {
  //int heightL=displayHeight;
  //int widthL=displayWidth;
  //println(heightL,widthL);
  size(1280, 700);
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
      }
    }
  }
  );
  theta_slide = cp5.addSlider("theta")
    .setPosition(20, height-100)
    .setSize(1200, 20)
    .setRange(-3.5, 3.5)
    .setValue(0)
    .addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      //print(theEvent.getAction());
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE) {
        theta_dragging = false;
        x_dot=0;
      }
      if(theEvent.getAction()==ControlP5.ACTION_PRESS){
        theta_dragging=true;
      }
    }
  }
  );
  println(height, width);
}

float length = 0.05;
float T=0.01;
float x=0.6;
float x_dot=0.0;
float F=0.0;
boolean flag=false;

float M = 0.2;
int pixelsPerm=3822;

void draw() {
  //print(int(dragging));
  if(!dragging && control){
    float val=0;
    if(x>-0.5 && x<0.5){
      val=-4*sin(x)-x_dot;
    }
    //else if (x_dot>0)
    //  val=.5;
    //else
    //  val=-.5;
    //abc.setValue(val);
  }
  if(!theta_dragging){
    //F=0;
    x = generateNextX(F);
    theta_slide.setValue(x);
  }
  
  //print(abc.getTriggerEvent());
  background(0);
  stroke(255);
  fill(255);
  //rotate(-1*HALF_PI);
  //rotate(x);
  line(width/2, height/2, width/2 + pixelsPerm*length*sin(x), height/2 + pixelsPerm*length*-cos(x));
  //line(400, 600, 600, 800);
  //rotate( PI/8.0 * cos( map( millis()%7000, 0, 7000,0,TWO_PI) ) );  line(0,0,150,0);
  ellipse(width/2 + pixelsPerm*length*sin(x), height/2 + pixelsPerm*length*-cos(x), 20, 20);
  //ellipse(1000, 1000, 200, 200);
}

long prevTime = millis();
long time=prevTime;

float generateNextX(float f) {
  float x_new=x;
  time = millis();
  x_dot += (9.8/length*sin(x)+f/(M*length)-x_dot*0)*T;
  prevTime=time;
  x_new += x_dot*T;
  while(x_new>PI){
    x_new-=2*PI;
  }
  while(x_new<-PI){
    x_new+=2*PI;
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
  x=theVal;
  flag = true;
}
