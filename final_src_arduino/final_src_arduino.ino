/*
 * [Final Project] 추억을 담은 지구본
 * - 이름) 20190149 노한나
 * - 과목) 피지컬컴퓨팅과제어(2021-2) 김윤지 교수님
 * 
 * Last Updated : 2021.12.18.
 * @src-by-hannah
 */
#define GLOBE A0
#define HOME 12
#define LEFT 11
#define CENTER 10
#define RIGHT 9

#define trigPin 7
#define echoPin 6

void setup()
{
  Serial.begin(9600);
  pinMode(LEFT, INPUT_PULLUP);
  pinMode(CENTER, INPUT_PULLUP); // default : HIGH
  pinMode(RIGHT, INPUT_PULLUP); // default : HIGH
  pinMode(HOME, INPUT_PULLUP);
  
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop()
{
  // distance
  long duration, distance;
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);

  distance = duration * 17 / 1000;

  if (0 < distance && distance < 50) Serial.print("T\t");
  else Serial.print("F\t");
  
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
