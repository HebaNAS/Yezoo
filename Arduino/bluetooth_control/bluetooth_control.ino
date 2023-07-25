#include <Servo.h>
Servo carServo;

#define ENA 5
#define ENB 11
#define IN1 6
#define IN2 7
#define IN3 8
#define IN4 9
#define carSpeed 100

/* This section is to initialize variables for the ultrasound sensor */
#define ECHO A4  
#define TRIG A5

int aheadDistance = 0;
int pos = 0;

/* Function to receive bluetooth signals transmitted from the app */
void getBTData() {
  if (Serial.available()) {
    switch(Serial.read()) {
      case 'f': moveForward(); break;
      case 'b': moveBackward(); break;
      case 'r': turnRight(); break;
      case 'l': turnLeft(); break;
      case 's': stop(); break;
      default: break;
    }
  }
}

/* Function to move forward */
void moveForward() {
  analogWrite(ENA,carSpeed);
  analogWrite(ENB,carSpeed);
  digitalWrite(IN1,HIGH);
  digitalWrite(IN2,LOW);  // Right wheel forward
  digitalWrite(IN3,LOW);
  digitalWrite(IN4,HIGH);  // Left wheel forward
  Serial.println("Forward");
  carServo.write(90);
}

/* Function to move backward */
void moveBackward() {
  // Ignore ultrasound object detection if moving backwards
  aheadDistance = distanceTest();
  if (aheadDistance >= 0)
  {
    analogWrite(ENA,carSpeed);
    analogWrite(ENB,carSpeed);
    digitalWrite(IN1,LOW);
    digitalWrite(IN2,HIGH); // Right wheel backward
    digitalWrite(IN3,HIGH);
    digitalWrite(IN4,LOW); // Left wheel backward
    Serial.println("Backward");
  }
}

/* Function to turn left */
void turnLeft() {
  analogWrite(ENA,carSpeed*2);
  analogWrite(ENB,carSpeed*2);
  digitalWrite(IN1,HIGH);
  digitalWrite(IN2,LOW); // Right wheel forward
  digitalWrite(IN3,HIGH);
  digitalWrite(IN4,LOW); // Left wheel backward
  Serial.println("Left");
  carServo.write(150);
}

/* Function to turn right */
void turnRight() {
  analogWrite(ENA,carSpeed*2);
  analogWrite(ENB,carSpeed*2);
  digitalWrite(IN1,LOW);
  digitalWrite(IN2,HIGH); // Right wheel backward
  digitalWrite(IN3,LOW);
  digitalWrite(IN4,HIGH); // Left wheel forward
  Serial.println("Right");
  carServo.write(30);
}

/* Function to stop */
void stop() {
  digitalWrite(ENA,LOW);
  digitalWrite(ENB,LOW);
  Serial.println("Stop");
}

/* Function for Ultrasonic distance measurement */
int distanceTest()   
{
  digitalWrite(TRIG, LOW);   
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);  
  delayMicroseconds(20);
  digitalWrite(TRIG, LOW);   
  float fDistance = pulseIn(ECHO, HIGH);  
  fDistance= fDistance/58;       
  return (int)fDistance;
}

void setup() {
  // put your setup code here, to run once:
  carServo.attach(3);   // attach servo on pin 3 to the board
  carServo.write(90);  //set servo position according to scaled value
  Serial.begin(9600);   // Open the serial port and set the baud rate to 9600
  pinMode(IN1,OUTPUT);
  pinMode(IN2,OUTPUT);
  pinMode(IN3,OUTPUT);
  pinMode(IN4,OUTPUT);
  pinMode(ENA,OUTPUT);
  pinMode(ENB,OUTPUT);
  pinMode(ECHO, INPUT);    
  pinMode(TRIG, OUTPUT);  
}

void loop() {
  // put your main code here, to run repeatedly:
  getBTData();
  aheadDistance = distanceTest();
  if(aheadDistance <= 25)
  {
    stop();
    //Serial.println("Object Detected..Stopping!");
  }
}
