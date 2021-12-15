// Serial communication 관련
import processing.serial.*;
Serial myPort;
String recvMSG; // 아두이노로 부터 받은 메세지 저장 (줄바꿈을 기준으로 String으로 받아옴)

int recvRot = 0; // 아두이노로 부터 받은 현재 포텐슘미터 값 (0 ~ 1023)
String hButton = "F"; // 아두이노로 부터 받은 home button 정보 ("T" or "F")
String lButton = "F"; // 아두이노로 부터 받은 left button 정보 ("T" or "F")
String cButton = "F"; // 아두이노로 부터 받은 center button 정보 ("T" or "F")
String rButton = "F"; // 아두이노로 부터 받은 right button 정보 ("T" or "F")

// 주요 trigger
int curRot = 0; // 포텐슘미터 값 저장 (값이 변하는 경우를 detecting 하기 위함)

int country;    // 0 : 아무것도 아님, 1 : 일본, 2 : 미국
int curCountry = 1; // 지구본이 위치한 나라 저장 (위치가 변경되는 경우를 detecting 하기 위함)
int city;       // 도시
int curCity;

boolean slideMode = false; // true : 슬라이드 쇼 모드, false : 나라 선택 모드
boolean pause; // true : 슬라이드 쇼 일시 정지, false : 슬라이드 쇼 진행 중
boolean available = true; // button pressed 가능 여부 >> true : 버튼 인식 가능, false : 버튼 인식 불가능

// 이미지 관련
PImage info;

PImage[] japanImg = new PImage[2];
PImage[] usaImg = new PImage[3];

int numofTokyo = 8;        // python 결과 file을 기반으로 작성
int numofSapporo = 5;
int numofWashington = 3;
int numofNewyork= 6;
int numofBoston = 6;
PImage[] tokyoImg = new PImage[numofTokyo];
PImage[] sapporoImg = new PImage[numofSapporo];
PImage[] washingtonImg = new PImage[numofWashington];
PImage[] newyorkImg = new PImage[numofNewyork];
PImage[] bostonImg = new PImage[numofBoston];

int imgNum = 0;
int lastTime = 0;
int lastButtonPressedTime = 0;

// UI 관련
int w = 800;
int h = 450;
