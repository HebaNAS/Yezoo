/* In1 connected to the 9 pin,
In2 connected to the 8 pin, ENA pin 10 */

int ENA = 5;
int IN1 = 6;
int IN2 = 7;

int ENB = 11;
int IN3 = 8;
int IN4 = 9;

/* Function to move forward */
void moveForward() {
  digitalWrite(ENA,HIGH);
  digitalWrite(ENB,HIGH);
  digitalWrite(IN1,HIGH);
  digitalWrite(IN2,LOW);  // Right wheel forward
  digitalWrite(IN3,LOW);
  digitalWrite(IN4,HIGH);  // Left wheel forward
  Serial.println("Forward");
}

/* Function to move backward */
void moveBackward() {
  digitalWrite(ENA,HIGH);
  digitalWrite(ENB,HIGH);
  digitalWrite(IN1,LOW);
  digitalWrite(IN2,HIGH); // Right wheel backward
  digitalWrite(IN3,HIGH);
  digitalWrite(IN4,LOW); // Left wheel backward
  Serial.println("Backward");
}

/* Function to turn left */
void turnLeft() {
  digitalWrite(ENA,HIGH);
  digitalWrite(ENB,HIGH);
  digitalWrite(IN1,HIGH);
  digitalWrite(IN2,LOW); // Right wheel forward
  digitalWrite(IN3,HIGH);
  digitalWrite(IN4,LOW); // Left wheel backward
  Serial.println("Left");
}

/* Function to turn right */
void turnRight() {
  digitalWrite(ENA,HIGH);
  digitalWrite(ENB,HIGH);
  digitalWrite(IN1,LOW);
  digitalWrite(IN2,HIGH); // Right wheel backward
  digitalWrite(IN3,LOW);
  digitalWrite(IN4,HIGH); // Left wheel forward
  Serial.println("Right");
}

/* Function to stop */
void stop() {
  digitalWrite(ENA,HIGH);
  digitalWrite(ENB,HIGH);
  digitalWrite(IN1,LOW);
  digitalWrite(IN2,LOW); // Right wheel stop
  digitalWrite(IN3,LOW);
  digitalWrite(IN4,LOW); // Left wheel stop
  Serial.println("Stop");
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);  // Open the serial port and set the baud rate to 9600
  pinMode(IN1,OUTPUT);
  pinMode(IN2,OUTPUT);
  pinMode(IN3,OUTPUT);
  pinMode(IN4,OUTPUT);
  pinMode(ENA,OUTPUT);
  pinMode(ENB,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  moveForward();
  delay(500);
  turnRight();
  delay(500);
  turnRight();
  delay(500);
  turnRight();
  delay(500);
  moveBackward();
  delay(500);
  turnLeft();
  delay(500);
  turnLeft();
  delay(500);
}
