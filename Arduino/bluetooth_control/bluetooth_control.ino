#define ENA 5
#define ENB 11
#define IN1 6
#define IN2 7
#define IN3 8
#define IN4 9
#define carSpeed 100

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

// /* Connect bluetooth recieved signal to movement modes */
// void movementMode() {
//   switch(mov_mode) {
//     case FORWARD: moveForward(); break;
//     case BACK: moveBackward(); break;
//     case RIGHT: turnRight(); break;
//     case LEFT: turnLeft(); break;
//     case STOP: stop(); break;
//   }
// }

/* Function to move forward */
void moveForward() {
  analogWrite(ENA,carSpeed);
  analogWrite(ENB,carSpeed);
  digitalWrite(IN1,HIGH);
  digitalWrite(IN2,LOW);  // Right wheel forward
  digitalWrite(IN3,LOW);
  digitalWrite(IN4,HIGH);  // Left wheel forward
  Serial.println("Forward");
}

/* Function to move backward */
void moveBackward() {
  digitalWrite(ENA,carSpeed);
  digitalWrite(ENB,carSpeed);
  digitalWrite(IN1,LOW);
  digitalWrite(IN2,HIGH); // Right wheel backward
  digitalWrite(IN3,HIGH);
  digitalWrite(IN4,LOW); // Left wheel backward
  Serial.println("Backward");
}

/* Function to turn left */
void turnLeft() {
  digitalWrite(ENA,carSpeed);
  digitalWrite(ENB,carSpeed);
  digitalWrite(IN1,HIGH);
  digitalWrite(IN2,LOW); // Right wheel forward
  digitalWrite(IN3,HIGH);
  digitalWrite(IN4,LOW); // Left wheel backward
  Serial.println("Left");
}

/* Function to turn right */
void turnRight() {
  digitalWrite(ENA,carSpeed);
  digitalWrite(ENB,carSpeed);
  digitalWrite(IN1,LOW);
  digitalWrite(IN2,HIGH); // Right wheel backward
  digitalWrite(IN3,LOW);
  digitalWrite(IN4,HIGH); // Left wheel forward
  Serial.println("Right");
}

/* Function to stop */
void stop() {
  digitalWrite(ENA,LOW);
  digitalWrite(ENB,LOW);
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
  getBTData();
  // movementMode();
}
