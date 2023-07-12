/* Function to receive bluetooth signals transmitted from the app */
void getBTData() {
  if (Serial.available()) {
    switch(Serial.read()) {
      case 'f': func_mode = Bluetooth; mov_mode = FORWARD; break;
      case 'b': func_mode = Bluetooth; mov_mode = BACK; break;
      case 'r': func_mode = Bluetooth; mov_mode = RIGHT; break;
      case 'l': func_mode = Bluetooth; mov_mode = LEFT; break;
      case 's': func_mode = Bluetooth; mov_mode = STOP; break;
      default: break;
    }
  }
}

void setup() {
  // put your setup code here, to run once:

}

void loop() {
  // put your main code here, to run repeatedly:

}
