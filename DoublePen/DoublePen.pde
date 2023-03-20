import controlP5.*;
ControlP5 cp5;
Slider T1_slide;
Slider T2_slide;
Slider theta1_slide;
Slider theta2_slide;
CallbackListener cb;

//float theta=PI/4;
//float theta_dot=0.0;

float l1 = 0.8;
float l2 = 0.6;
float m1 = 1;
float m2 = 1;

//l1 = 0.06;
//l2 = l1;

float tht_1 = 0;
float tht_1n = 0;
float tht_2 = 0;
float tht_2n = 0;
float tht_1d = 0;
float tht_2d = 0;
float tau1 = 0;
float tau2 = 0;

float x = 0;
float x_dot = 0.0;


boolean dragging1=false;
boolean dragging2=false;
boolean theta1_dragging=false;
boolean theta2_dragging=false;

boolean control=false;

void setup() {
  //int heightL=displayHeight;
  //int widthL=displayWidth;
  //println(heightL,widthL);
  size(1280, 700);
  cp5 = new ControlP5(this);
  //translate(1000,1000);

  ////FORCE SLIDER//////
  T1_slide = cp5.addSlider("T1")
    .setPosition(20, height-50)
    .setSize(1200, 20)
    .setRange(-.5, .5)
    .setValue(0)
    .addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      //print(theEvent.getAction());
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE) {
        //abc.setValue(0);
        dragging1 = false;
      }
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        dragging2=true;
      }
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
        control = !control;
        T1_slide.setValue(0);
      }
    }
  }
  );

  T2_slide = cp5.addSlider("T2")
    .setPosition(20, height-100)
    .setSize(1200, 20)
    .setRange(-.5, .5)
    .setValue(0)
    .addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      //print(theEvent.getAction());
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE) {
        //abc.setValue(0);
        dragging1 = false;
      }
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        dragging2=true;
      }
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
        control = !control;
        T2_slide.setValue(0);
      }
    }
  }
  );
  ////FORCE SLIDER//////

  println(tht_1);

  ///////THETA SLIDE//////////
  theta1_slide = cp5.addSlider("theta1")
    .setPosition(20, height-150)
    .setSize(1200, 20)
    .setRange(-PI, PI)
    .setValue(PI/4)
    .addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      //print(theEvent.getAction());
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE) {
        theta1_dragging = false;
        tht_1d=0;
        tht_2d=0;
      }
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        theta1_dragging=true;
        tht_2d=0;
        tht_1d=0;
      }
    }
  }
  );

  theta2_slide = cp5.addSlider("theta2")
    .setPosition(20, height-200)
    .setSize(1200, 20)
    .setRange(-PI, PI)
    .setValue(0)
    .addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      //print(theEvent.getAction());
      if (theEvent.getAction()==ControlP5.ACTION_RELEASE || theEvent.getAction()==ControlP5.ACTION_RELEASE_OUTSIDE) {
        theta2_dragging = false;
        tht_2d=0;
        tht_1d=0;
      }
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        theta2_dragging=true;
        tht_2d=0;
        tht_1d=0;
      }
    }
  }
  );
  ///////THETA SLIDE//////////

  //println(height, width);
}

float T=0.0001;

float F=0.0;
float Fx=0.0;
boolean flag=false;

float M = 0.2;
float Mx = 5;
//int pixelsPerm=3822;

int pixelsPerm = int(1000*(1230-50)/(293.0*50));

long prevTime = millis();
long time=prevTime;
long diff = 0;

void draw() {
  //print(int(dragging));
  //if (!dragging1 && !dragging2 && control) {
  //  float val=0;
  //  //val = 100*theta_dot/(abs(theta_dot)+0.0001)*((1.005*M*length*g)-(0.5*M*length*length*theta_dot*theta_dot)-(M*g*length*cos(theta)));
  //  if (tht_1> -0.5 && tht_1 < 0.5) {
  //    //val=-4*sin(theta)-.2*theta_dot;
  //  }
  //  //else if (theta_dot>0)
  //  //  val=.05;
  //  //else
  //  //  val=-.05;
  //  T1_slide.setValue(val);
  //}
  if (!theta1_dragging && !theta2_dragging) {
    //F=0;
    //float tht_1_old = tht_1;
    //float tht_1d_old = tht_1d;
    int i=0;
   for(; i<diff/(1000.0*T); i++) {
      tht_1n = generateNextTheta1(tau1, tau2, tht_1, tht_1d, tht_2, tht_2d, T);
      tht_2n = generateNextTheta2(tau1, tau2, tht_1, tht_1d, tht_2, tht_2d, T);
      tht_1=tht_1n;
      tht_2=tht_2n;
    }
    print(i);
    theta1_slide.setValue(tht_1);
    theta2_slide.setValue(tht_2);
    //print("t1d =",tht_1d);
    //print(" t2d =",tht_2d);
    println();
  }
  //print(abc.getTriggerEvent());
  background(0);
  stroke(255);
  fill(255);
  //rotate(-1*HALF_PI);
  //rotate(theta);
  //while(millis()-prevTime < T*1000){
  //println(tht_1);
  //}
  //line(10,10,10+pixelsPerm*0.25,10);
  line(width/2, height/2, width/2 + pixelsPerm*l1*sin(tht_1), height/2 + pixelsPerm*l1*cos(tht_1));
  line(width/2 + pixelsPerm*l1*sin(tht_1), height/2 + pixelsPerm*l1*cos(tht_1), width/2 + pixelsPerm*l1*sin(tht_1) + pixelsPerm*l2*sin(tht_2), height/2 + pixelsPerm*l1*cos(tht_1) + pixelsPerm*l2*cos(tht_2));
  //line(400, 600, 600, 800);
  //rotate( PI/8.0 * cos( map( millis()%7000, 0, 7000,0,TWO_PI) ) );  line(0,0,150,0);
  ellipse(width/2 + pixelsPerm*l1*sin(tht_1), height/2 + pixelsPerm*l1*cos(tht_1), 20/0.3*m1, 20/0.3*m1);
  ellipse(width/2 + pixelsPerm*l1*sin(tht_1) + pixelsPerm*l2*sin(tht_2), height/2 + pixelsPerm*l1*cos(tht_1) + pixelsPerm*l2*cos(tht_2), 20/0.3*m2, 20/0.3*m2);
  //ellipse(1000, 1000, 200, 200);
  time = millis();
  diff = time-prevTime;
  prevTime = time;
}
float g=9.8;

//float theta1dd = (-2*g*l1*l2*m1*sin(tht_1) - g*l1*l2*m2*sin(tht_1) - g*l1*l2*m2*sin(tht_1 - 2*tht_2) - pow(l1, 2)*l2*m2*pow(tht_1d, 2)*sin(2*tht_1 - 2*tht_2) - 2*l1*pow(l2, 2)*m2*pow(tht_2d, 2)*sin(tht_1 - tht_2) - 2*l1*T2*cos(tht_1 - tht_2) + 2*l2*T1)/(2*pow(l1, 2)*l2*m1 - 2*pow(l1, 2)*l2*m2*pow(cos(tht_1 - tht_2), 2) + 2*pow(l1, 2)*l2*m2);
//float theta2dd = (-g*l1*l2*m1*m2*sin(tht_2) + g*l1*l2*m1*m2*sin(2*tht_1 - tht_2) - g*l1*l2*pow(m2, 2)*sin(tht_2) + g*l1*l2*pow(m2, 2)*sin(2*tht_1 - tht_2) + 2*pow(l1, 2)*l2*m1*m2*pow(tht_1d, 2)*sin(tht_1 - tht_2) + 2*pow(l1, 2)*l2*pow(m2, 2)*pow(tht_1d, 2)*sin(tht_1 - tht_2) + l1*pow(l2, 2)*pow(m2, 2)*pow(tht_2d, 2)*sin(2*tht_1 - 2*tht_2) + 2*l1*m1*T2 + 2*l1*m2*T2 - 2*l2*m2*T1*cos(tht_1 - tht_2))/(2*l1*pow(l2, 2)*m1*m2 - 2*l1*pow(l2, 2)*pow(m2, 2)*pow(cos(tht_1 - tht_2), 2) + 2*l1*pow(l2, 2)*pow(m2, 2));



float generateNextTheta1(float T1, float T2, float Theta1, float Theta1_dot, float Theta2, float Theta2_dot, float per) {
  float tht_1_new=Theta1;
  // tht_1d += (f*(Mx+M)/(M*length) - fx*cos(Theta)/length + pow(Theta_dot,2)*sin(Theta)*cos(Theta)*M + g*(Mx+M)*sin(Theta))/(Mx+M*pow(sin(Theta),2))*per;
  //print("before");
  tht_1d += per*(-2*g*l1*l2*m1*sin(Theta1) - g*l1*l2*m2*sin(Theta1) - g*l1*l2*m2*sin(Theta1 - 2*Theta2) - pow(l1, 2)*l2*m2*pow(Theta1_dot, 2)*sin(2*Theta1 - 2*Theta2) - 2*l1*pow(l2, 2)*m2*pow(Theta2_dot, 2)*sin(Theta1 - Theta2) - 2*l1*T2*cos(Theta1 - Theta2) + 2*l2*T1)/(2*pow(l1, 2)*l2*m1 - 2*pow(l1, 2)*l2*m2*pow(cos(Theta1 - Theta2), 2) + 2*pow(l1, 2)*l2*m2);
  //print("t1d=", (-2*g*l1*l2*m1*sin(Theta1) - g*l1*l2*m2*sin(Theta1) - g*l1*l2*m2*sin(Theta1 - 2*Theta2) - pow(l1, 2)*l2*m2*pow(Theta1_dot, 2)*sin(2*Theta1 - 2*Theta2) - 2*l1*pow(l2, 2)*m2*pow(Theta2_dot, 2)*sin(Theta1 - Theta2) - 2*l1*T2*cos(Theta1 - Theta2) + 2*l2*T1)/(2*pow(l1, 2)*l2*m1 - 2*pow(l1, 2)*l2*m2*pow(cos(Theta1 - Theta2), 2) + 2*pow(l1, 2)*l2*m2),"\t");
  //print(" tht_1d_num =", (-2*g*l1*l2*m1*sin(Theta1) - g*l1*l2*m2*sin(Theta1) - g*l1*l2*m2*sin(Theta1 - 2*Theta2) - pow(l1, 2)*l2*m2*pow(Theta1_dot, 2)*sin(2*Theta1 - 2*Theta2) - 2*l1*pow(l2, 2)*m2*pow(Theta2_dot, 2)*sin(Theta1 - Theta2) - 2*l1*T2*cos(Theta1 - Theta2) + 2*l2*T1), "\t");
  //print(" tht_1d_denom =", 2*pow(l1, 2)*l2*m1 - 2*pow(l1, 2)*l2*m2*pow(cos(Theta1 - Theta2), 2) + 2*pow(l1, 2)*l2*m2, "\t");
  tht_1_new += tht_1d*per;
  while (tht_1_new>PI) {
    tht_1_new -=2*PI;
  }
  while (tht_1_new<-PI) {
    tht_1_new+=2*PI;
  }
  return tht_1_new;
}

float generateNextTheta2(float T1, float T2, float Theta1, float Theta1_dot, float Theta2, float Theta2_dot, float per) {
  float tht_2_new=Theta2;
  // tht_1d += (f*(Mx+M)/(M*length) - fx*cos(Theta)/length + pow(Theta_dot,2)*sin(Theta)*cos(Theta)*M + g*(Mx+M)*sin(Theta))/(Mx+M*pow(sin(Theta),2))*per;
  //print("before");
  
  tht_2d += per*(-g*l1*l2*m1*m2*sin(Theta2) + g*l1*l2*m1*m2*sin(2*Theta1 - Theta2) - g*l1*l2*pow(m2, 2)*sin(Theta2) + g*l1*l2*pow(m2, 2)*sin(2*Theta1 - Theta2) + 2*pow(l1, 2)*l2*m1*m2*pow(Theta1_dot, 2)*sin(Theta1 - Theta2) + 2*pow(l1, 2)*l2*pow(m2, 2)*pow(Theta1_dot, 2)*sin(Theta1 - Theta2) + l1*pow(l2, 2)*pow(m2, 2)*pow(Theta2_dot, 2)*sin(2*Theta1 - 2*Theta2) + 2*l1*m1*T2 + 2*l1*m2*T2 - 2*l2*m2*T1*cos(Theta1 - Theta2))/(2*l1*pow(l2, 2)*m1*m2 - 2*l1*pow(l2, 2)*pow(m2, 2)*pow(cos(Theta1 - Theta2), 2) + 2*l1*pow(l2, 2)*pow(m2, 2));
  //print("t2d=", (-g*l1*l2*m1*m2*sin(Theta2) + g*l1*l2*m1*m2*sin(2*Theta1 - Theta2) - g*l1*l2*pow(m2, 2)*sin(Theta2) + g*l1*l2*pow(m2, 2)*sin(2*Theta1 - Theta2) + 2*pow(l1, 2)*l2*m1*m2*pow(Theta1_dot, 2)*sin(Theta1 - Theta2) + 2*pow(l1, 2)*l2*pow(m2, 2)*pow(Theta1_dot, 2)*sin(Theta1 - Theta2) + l1*pow(l2, 2)*pow(m2, 2)*pow(Theta2_dot, 2)*sin(2*Theta1 - 2*Theta2) + 2*l1*m1*T2 + 2*l1*m2*T2 - 2*l2*m2*T1*cos(Theta1 - Theta2))/(2*l1*pow(l2, 2)*m1*m2 - 2*l1*pow(l2, 2)*pow(m2, 2)*pow(cos(Theta1 - Theta2), 2) + 2*l1*pow(l2, 2)*pow(m2, 2)),"\t");
  //print(" t2d_num=", (-g*l1*l2*m1*m2*sin(Theta2) + g*l1*l2*m1*m2*sin(2*Theta1 - Theta2) - g*l1*l2*pow(m2, 2)*sin(Theta2) + g*l1*l2*pow(m2, 2)*sin(2*Theta1 - Theta2) + 2*pow(l1, 2)*l2*m1*m2*pow(Theta1_dot, 2)*sin(Theta1 - Theta2) + 2*pow(l1, 2)*l2*pow(m2, 2)*pow(Theta1_dot, 2)*sin(Theta1 - Theta2) + l1*pow(l2, 2)*pow(m2, 2)*pow(Theta2_dot, 2)*sin(2*Theta1 - 2*Theta2) + 2*l1*m1*T2 + 2*l1*m2*T2 - 2*l2*m2*T1*cos(Theta1 - Theta2)),"\t");
  //print(" t2d_denom=", 2*l1*pow(l2, 2)*m1*m2 - 2*l1*pow(l2, 2)*pow(m2, 2)*pow(cos(Theta1 - Theta2), 2) + 2*l1*pow(l2, 2)*pow(m2, 2),"\t");
  tht_2_new += tht_2d*per;
  while (tht_2_new>PI) {
    tht_2_new-=2*PI;
  }
  while (tht_2_new<-PI) {
    tht_2_new+=2*PI;
  }
  return tht_2_new;
}



//float generateNextX(float f, float fx, float Theta, float Theta_dot, float per) {
//  float x_new = x;
//  x_dot += (fx - f*cos(Theta)/length - M*g*sin(Theta)*cos(Theta) - pow(Theta_dot, 2)*sin(Theta)*M*length)/(Mx + M*pow(sin(Theta), 2))*per;
//  x_new += x_dot*per;
//  //while(x_new*pixelsPerm < -width/2){
//  //  x_new += 1.0*width/pixelsPerm;
//  //}
//  //while(x_new*pixelsPerm > width/2){
//  //  x_new -= 1.0*width/pixelsPerm;
//  //  print(x_new);
//  //}
//  if (x_new*pixelsPerm < -width/2 && x_dot<0) {
//    x_dot*=-1;
//  }
//  if (x_new*pixelsPerm > width/2 && x_dot>0) {
//    x_dot*=-1;
//    print(x_new);
//  }
//  return x_new;
//}
void T1(float theVal) {
  //println("force = "+theVal);
  tau1=theVal;
  flag = true;
}

void T2(float theVal) {
  //println("force = "+theVal);
  tau2=theVal;
  flag = true;
}

void theta1(float theVal) {
  //println("force = "+theVal);
  tht_1=theVal;
  //tht_1d = 0;
  flag = true;
}

void theta2(float theVal) {
  //println("force = "+theVal);
  tht_2=theVal;
  //tht_2d = 0;
  flag = true;
}
