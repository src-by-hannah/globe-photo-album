/*
 * [Final Project] 추억을 담은 지구본
 * 
 * Last Updated : 2021.12.05.
 * @src-by-hannah
 */
 
void setup() {
  size(800, 450);
  background(0);
  
  // ============================================= 시리얼 통신 (arduino) 
  println(Serial.list());
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  
  // ============================================= Image load
  //   - 1 ) 나라 선택 모드 이미지 불러오기
  info = loadImage("./UI/info.PNG"); // 지원하지 않는 나라에 대해
  println("Load Img..." + info);

  for(int i = 0; i < 2; i++) { // 일본 UI 이미지
    japanImg[i] = loadImage("./UI/1_"+(i+1)+".PNG");
    println("Load Japapn UI..." + "./UI/1_"+(i+1)+".PNG");
  }
  
  for(int i = 0; i < 3; i++) { // 미국 UI 이미지
    usaImg[i] = loadImage("./UI/2_"+(i+1)+".PNG");
    println("Load USA UI..." + "./UI/2_"+(i+1)+".PNG");
  }
  
  //   - 2 ) 슬라이드쇼 이미지 불러오기
  for(int i = 0; i < numofTokyo; i++) { // 도쿄 이미지
    tokyoImg[i] = loadImage("./photo/Tokyo/" + (i+1) + ".jpg");
    println("Load Tokyo Img..." + "./photo/Tokyo/" + (i+1) + ".jpg");
  }
  for(int i = 0; i < numofSapporo; i++) { // 삿포로 이미지
    sapporoImg[i] = loadImage("./photo/Sapporo/" + (i+1) + ".jpg");
    println("Load Sapporo Img..." + "./photo/Sapporo/" + (i+1) + ".jpg");
  }
  for(int i = 0; i < numofWashington; i++) { // 워싱턴  이미지
    washingtonImg[i] = loadImage("./photo/Washington/" + (i+1) + ".jpg");
    println("Load Washington Img..." + "./photo/Washington/" + (i+1) + ".jpg");
  }
  for(int i = 0; i < numofNewyork; i++) { // 뉴욕 이미지
    newyorkImg[i] = loadImage("./photo/Newyork/" + (i+1) + ".jpg");
    println("Load Newyork Img..." + "./photo/Newyork/" + (i+1) + ".jpg");
  }
  for(int i = 0; i < numofBoston; i++) { // 보스턴 이미지
    bostonImg[i] = loadImage("./photo/Boston/" + (i+1) + ".jpg");
    println("Load Boston Img..." + "./photo/Boston/" + (i+1) + ".jpg");
  }
}

void draw() {
  // ============================================= RECV MSG (FROM ARDUINO) 
  if(myPort.available() > 0) {
      recvMSG = myPort.readStringUntil('\n');
  }
  
  // 데이터 전처리
  if(recvMSG != null) {
    String trimMSG = recvMSG.trim(); // 줄바꿈 제거
    //println(trimMSG);
    
    String[] temp = trimMSG.split("\t");
    
    recvRot = Integer.parseInt(temp[0]);
    hButton = temp[1];
    lButton = temp[2]; 
    cButton = temp[3];
    rButton = temp[4]; 
  }
  
  // ============================================= 받은 값 처리
  if((recvRot != curRot) && !slideMode) {     // 나라 선택 모드에서 지구본을 "돌렸다면" 
    curRot = recvRot;         // curRot 갱신
    changeMap();
  }
  if (millis()-lastButtonPressedTime >= 3000) {
      available = true; // 버튼 누르고 3초 지나면 버튼 인식 가능함
      lastButtonPressedTime = millis();
  }
  // 계속 누르고 있을 경우, 반복되어 인식되는 것을 방지하기 위함
  if(available && lButton.equals("T")) {    // left 버튼을 눌렀다면
    left();
    available = false;
  }
  if(available && cButton.equals("T")) { // center 버튼을 눌렀다면
    center();  
    available = false;
  }
  if(available && rButton.equals("T")) { // right 버튼을 눌렀다면
    right();   
    available = false;
  }
  if(available && hButton.equals("T")) { // home 버튼을 눌렀다면
    home();    
    available = false;
  }
  
  // ============================================= 이미지 draw 
  //   - 1) 나라 선택 모드 일 때
  if(!slideMode) {
    if (curCountry == 1) { // 일본 (1 - Tokyo, 2 - Sapporo)
      // 순환구조
      if (city > 2) {
        city = 1;
      }
      if (city < 1) {
        city = 2;
      }
      image(japanImg[city - 1], 0, 0, w, h);
    }
    else if (curCountry == 2) { // 미국 (1 - Washington, 2 - Newyork, 3 - Boston)
      // 순환구조
      if (city > 3) {
        city = 1;
      }
      if (city < 1) {
        city = 3;
      }
      image(usaImg[city - 1], 0, 0, w, h);
    }
    else { // 지원하지 않는 나라를 가리키고 있을 때
      image(info, 0, 0, w, h); 
    }
  }
  
  //   - 2) 슬라이드 쇼 모드 일 때
  else {
    rect(0, 0, w, h);
    float magnification; // 사진 축소or확대 비율
    int wSize; // h 기준에 맞춰 가로 사이즈 조절
    
    if (curCountry == 1 && curCity == 1) { // 일본 도쿄
      // 순환구조
      if(imgNum > numofTokyo) { // 끝까지 돌면 처음부터 실행
        imgNum = 1;
      }
      if(imgNum < 1) { // 처음으로 오면 가장 뒷 사진 실행
        imgNum = numofTokyo;
      }
      magnification = tokyoImg[imgNum - 1].height / h;
      wSize = Math.round(tokyoImg[imgNum - 1].width / magnification);
      image(tokyoImg[imgNum - 1], w/2 - wSize/2, 0, wSize, h);
    }
    else if (curCountry == 1 && curCity == 2) { // 일본 삿포로
      // 순환구조
      if(imgNum > numofSapporo) { // 끝까지 돌면 처음부터 실행
        imgNum = 1;
      }
      if(imgNum < 1) { // 처음으로 오면 가장 뒷 사진 실행
        imgNum = numofSapporo;
      }
      magnification = sapporoImg[imgNum - 1].height / h;
      wSize = Math.round(sapporoImg[imgNum - 1].width / magnification);
      image(sapporoImg[imgNum - 1], w/2 - wSize/2, 0, wSize, h);
    }
    else if (curCountry == 2 && curCity == 1) { // 미국 워싱턴
      // 순환구조
      if(imgNum > numofWashington) { // 끝까지 돌면 처음부터 실행
        imgNum = 1;
      }
      if(imgNum < 1) { // 처음으로 오면 가장 뒷 사진 실행
        imgNum = numofWashington;
      }
      magnification = washingtonImg[imgNum - 1].height / h;
      wSize = Math.round(washingtonImg[imgNum - 1].width / magnification);
      image(washingtonImg[imgNum - 1], w/2 - wSize/2, 0, wSize, h);
    }
    else if (curCountry == 2 && curCity == 2) { // 미국 뉴욕
      // 순환구조
      if(imgNum > numofNewyork) { // 끝까지 돌면 처음부터 실행
        imgNum = 1;
      }
      if(imgNum < 1) { // 처음으로 오면 가장 뒷 사진 실행
        imgNum = numofNewyork;
      }
      magnification = newyorkImg[imgNum - 1].height / h;
      wSize = Math.round(newyorkImg[imgNum - 1].width / magnification);
      image(newyorkImg[imgNum - 1], w/2 - wSize/2, 0, wSize, h);
    }
    else if (curCountry == 2 && curCity == 3) { // 미국 보스턴
      // 순환구조
      if(imgNum > numofBoston) { // 끝까지 돌면 처음부터 실행
        imgNum = 1;
      }
      if(imgNum < 1) { // 처음으로 오면 가장 뒷 사진 실행
        imgNum = numofBoston;
      }
      magnification = bostonImg[imgNum - 1].height / h;
      wSize = Math.round(bostonImg[imgNum - 1].width / magnification);
      image(bostonImg[imgNum - 1], w/2 - wSize/2, 0, wSize, h);
    }
    println("imgNum : " + imgNum);
    // 슬라이드 멈춤 상태가 아니고, 일정 시간(3s)이 지나면 이미지 갱신
    if (!pause && (millis()-lastTime >= 3000)) {
      imgNum += 1;
      lastTime = millis();
    }
  }
  
  delay(500);
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>>> changeMap
void changeMap() {
  println("changed map function activate!");
  
  if(10 < curRot && curRot < 55) {         // 일본
    country = 1;
  }
  
  else if(102 < curRot && curRot < 270) {  // 미국
    country = 2;
  }
  
  else country = 0;                       // 아무것도 아님
  
  // 만약 회전했는데 가르키는 나라가 달라지면
  if(curCountry != country) {
    city = 0;     // 도시를 가르키는 마커는 0으로 갱신
    curCountry = country; // 현재 위치하는 나라가 달라짐
  }
  
  println("curRot : " + curRot);
  println("curCountry (1, 2) : " + curCountry);
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>>> LEFT
void left() {
  println("left function activate!");
  
  //   - 1) 나라 선택 모드 일 때
  if(!slideMode) city -= 1; // 이전 나라로
  
  //   - 2) 슬라이드 쇼 모드 인데 일시 정지 상태이면
  else if (slideMode && pause) imgNum -= 1; // 이전 이미지로
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>>> center
void center() {
  println("center function activate!");
  
  //   - 1) 나라 선택 모드 일 때
  if(!slideMode) {
    curCity = city;
    city = 0; // city 마커 초기화
    slideMode = true;
  }
  
  //   - 2.1) 슬라이드 쇼 모드 인데 진행 중이라면
  else if (slideMode && !pause) {
    pause = true; // 일시 정지
  }
  
  //   - 2.2) 슬라이드 쇼 모드 인데 일시 정지 상태이면
  else if (slideMode && pause) {
    pause = false; // 다시 슬라이드 쇼 진행
  }
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>>> right
void right() {
  println("right function activate!");

  //   - 1) 나라 선택 모드 일 때
  if(!slideMode) city += 1; // 다음 나라로
  
  //   - 2) 슬라이드 쇼 모드 인데 일시 정지 상태이면
  else if (slideMode && pause) imgNum += 1; // 다음 이미지로
}

// >>>>>>>>>>>>>>>>>>>>>>>>>>>> home
void home() {
  println("home function activate!");
  
  slideMode = false;
}
