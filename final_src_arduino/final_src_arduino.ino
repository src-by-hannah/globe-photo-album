/*
 * [Final Project] 추억을 담은 지구본
 * 
 * Last Updated : 2021.12.05.
 * @src-by-hannah
 */
 
#define GLOBE A0
#define HOME 12
#define LEFT 11
#define CENTER 10
#define RIGHT 9

void setup()
{
  Serial.begin(9600);
  pinMode(LEFT, INPUT_PULLUP);
  pinMode(CENTER, INPUT_PULLUP); // default : HIGH
  pinMode(RIGHT, INPUT_PULLUP); // default : HIGH
  pinMode(HOME, INPUT_PULLUP);
}

void loop()
{
  // globe
  int sendROT = analogRead(GLOBE);  
  Serial.print(sendROT); // SEND TO PROCESSING
  
  // button
  if(!digitalRead(HOME)) Serial.print("\tT\t");
  else Serial.print("\tF\t");
  
  if(!digitalRead(LEFT)) Serial.print("T\t");
  else Serial.print("F\t");
  
  if(!digitalRead(CENTER)) Serial.print("T\t");
  else Serial.print("F\t");
  
  if(!digitalRead(RIGHT)) Serial.println("T\t");
  else Serial.println("F\t");
  
  delay(1000);
}
