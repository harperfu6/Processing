import processing.serial.*;

Serial myPort;
PFont display;
String hoverStr = "";
String touchStr = "";
String gestureStr = "";
String lastGestureStr = "";
String modeStr = "";

int mode = 0;

int sensorNum = 4;
int averageNum = 20;

float[] values = new float[sensorNum];//rare 4 sensor data at one frame
float[][] last10Values = new float[sensorNum][averageNum];// rare 4 sensor data of last 10 frames
float[] aveValues = new float[sensorNum];//average 4 data of last 10 frames
float[][] last10AveValues = new float[sensorNum][averageNum*25];//average each 4 sensor data of last 10 frames
float[] baseValues = new float[sensorNum];//4 calib data (not into finger)
float[][] diff_diffValues = new float[sensorNum][2];//different of diff value

int[] hoverArrays = new int[averageNum];
int[] gestureArrays = new int[averageNum*3];

int[] clockArrays = new int[sensorNum];
int startIndex = 0;
int lastIndex = 0;
int indexCount = 0;

boolean startRecognition = false;
boolean finishGesture = false;

boolean touchedInside = false;
boolean touchedOutside = false;

//gesture flag
boolean isStartedRightSwipe = false;
boolean isStartedLeftSwipe = false;
boolean isStartedUpSwipe = false;
boolean isStartedDownSwipe = false;
boolean isStartedClockwise = false;
boolean isStartedAntiClockwise = false;
int isNotHoveredCount = 0;

void setup() {

  size(1500, 250); //width = 500*n

  myPort = new Serial(this, "/dev/cu.usbmodem1421", 9600);
  //myPort = new Serial(this, "/dev/cu.usbmodem1421", 11520);

  display = loadFont("Serif-48.vlw");
  textFont(display, 48);

  //initGraph();
}

void draw() {

  background(10);

  //reload array of last 10 frames and calculate average 4 each sensors of last 10 frames
  aveValues = reloadArrayAndCalcAverage(last10Values, values);

  //reload array of average 4 sensors of last 500 frames
  for (int i = 0; i < last10AveValues.length; i++) {
    reloadArray(last10AveValues[i], aveValues[i]);
  }
  drawGraph(last10AveValues);//draw graph of last 500 average data


  if (startRecognition) {
    drawPosition(aveValues, baseValues);
  } else {
    hoverStr = "push 'c' to calibrate in 3 seconds";
  }

  modeStr = str(mode);

  text(hoverStr, 10, 50);
  text(gestureStr, 10, 100);
  text(touchStr, 10, 150);
  text(modeStr, width - 100, 50);
}

void drawGraph(float value[][]) {

  strokeWeight(2);

  for (int i = 0; i < value.length; i++) {
    switch(i) {
    case 0:
      stroke(0, 60, 255);//blue
      break;
    case 1:
      stroke(255, 165, 0);//orange
      break;
    case 2:
      stroke(255, 0, 0);//red
      break;
    case 3:
      stroke(0, 255, 255);//light blue
      break;
    }
    for (int j = 0; j < value[i].length-1; j++) {
      line(3*j, convToGraphPoint(value[i][j]), 3*(j+1), convToGraphPoint(value[i][j+1]));//x position = j*n
    }
  }
}

float convToGraphPoint(float value) {
  return (height - value*height/1024.0);
}

void drawPosition(float values[], float bases[]) {

  boolean isGotHover = false;
  float maxValue = 0;
  int maxIndex = -1;
  float[] diffValues = new float[values.length];
  int[] x = new int[values.length];
  int[] y = new int[values.length];

  hoverStr = "";

  pushMatrix();
  pushStyle();
  stroke(255);//white
  noFill();
  ellipse(width-240, 70, 120, 120);
 
  for (int i = 0; i < values.length; i++) {
    diffValues[i] = values[i] - bases[i];//diff value of average and base(no finger)

    hoverStr += "sensor";
    hoverStr += str(i+1);
    hoverStr += ": ";

    //wheter there is a finger in circle sensor
    if (diffValues[i] > 30) {
      isGotHover = true;

      hoverStr += str((int)diffValues[i]);
      hoverStr += "  ";

      //consider as liner (1/4 when draw)
      x[i] = (int)diffValues[i]/4;
      y[i] = (int)diffValues[i]/4;

      if (x[i] > 55/1.41) {
        x[i] = (int)(55/1.41);
      }
      if (y[i] > 55/1.41) {
        y[i] = (int)(55/1.41);
      }

      if (i == 0 || i == 1) {
        x[i] *= -1;
      }
      if (i == 1 || i == 2) {
        y[i] *= -1;
      }
    } else {
      hoverStr += str(0);
      hoverStr += "  ";
    }

    stroke(255, 0, 0);
    fill(255, 0, 0);
    
    if (!touchedOutside && !touchedInside) {
      translate(x[i], y[i]);
    }
  }
  
    for (int i = 0; i < diff_diffValues.length; i++) {
      reloadArray(diff_diffValues[i], diffValues[i]);
    }
  
  if (!touchedOutside && !touchedInside) {
    for (int i = 0; i < diff_diffValues.length; i++) {
      if (diff_diffValues[i][1] - diff_diffValues[i][0] > 100) {
        touchedInside = true;
      } else if (diff_diffValues[i][1] - diff_diffValues[i][0] > 30) {
        touchedOutside = true;
      }
    }
  }


  //About outside touch
  if (touchedOutside) {
    float maxValue1 = 0;
    int maxIndex1 = -1;
    for (int j = 0; j < values.length; j++) {
      if (diffValues[j] > 500) {
        if (diffValues[j] > maxValue1) {
          maxValue1 = diffValues[j];
          maxIndex1 = j;
        }
      }
    }
    if (maxIndex1 >= 0) {
      touchStr = "Outside touch";
      touchStr += str(maxIndex1+1);


      pushMatrix();
      translate(width-240, 70);

      int threshold = 600;
      
      if (maxIndex1 == 0) {
        rotate(PI* 3/4);
        if(diffValues[1] > threshold){
          rotate((float)(diffValues[1] / diffValues[0])/4 * PI);
        }
      }
      else if (maxIndex1 == 1) {
        rotate(PI* 5/4);
        if(diffValues[0] > threshold){
         rotate((float)(diffValues[0] / diffValues[1])/4 * -PI);
        }
        else if(diffValues[2] > threshold){
          rotate((float)(diffValues[2] / diffValues[1])/4 * PI);
        }
      }
      else if (maxIndex1 == 2) {
        rotate(PI* 7/4);
        if(diffValues[1] > threshold){
          rotate((float)(diffValues[1] / diffValues[2])/4 * -PI);
        }
        else if(diffValues[3] > threshold){
          rotate((float)(diffValues[3] / diffValues[2])/4 * PI);
        }
      }
      else if (maxIndex1 == 3) {
        rotate(PI* 1/4);
        if(diffValues[2] > threshold){
          rotate((float)(diffValues[2] / diffValues[3])/4 * -PI);
        }
      }
      stroke(0, 255, 0);
      fill(0, 255, 0);
      translate(65, 0);
      ellipse(0, 0, 10, 10);
      popMatrix();
      
    } else {
      touchedOutside = false;
      touchStr = "";
    }
  }

  //About inside touch
  if (touchedInside) {
    float maxValue1 = 0;
    int maxIndex1 = -1;
    for (int j = 0; j < values.length; j++) {
      if (diffValues[j] > 1000) {
        if (diffValues[j] > maxValue1) {
          maxValue1 = diffValues[j];
          maxIndex1 = j;
        }
      }
    }
    if (maxIndex1 >= 0) {
      touchStr = "Inside touch";
      touchStr += str(maxIndex1+1);
      
      pushMatrix();
      translate(width-240, 70);

      int threshold = 200;
      int scale = 1;
      
      if (maxIndex1 == 0) {
        rotate(PI* 3/4);
        if(diffValues[3] > threshold){
          rotate((float)(diffValues[3] / diffValues[0])/4 * -PI * scale);
        }
        else if(diffValues[1] > threshold){
          rotate((float)(diffValues[1] / diffValues[0])/4 * PI * scale);
        }
      }
      else if (maxIndex1 == 1) {
        rotate(PI* 5/4);
        if(diffValues[0] > threshold){
         rotate((float)(diffValues[0] / diffValues[1])/4 * -PI * scale);
        }
        else if(diffValues[2] > threshold){
          rotate((float)(diffValues[2] / diffValues[1])/4 * PI * scale);
        }
      }
      else if (maxIndex1 == 2) {
        rotate(PI* 7/4);
        if(diffValues[1] > threshold){
          rotate((float)(diffValues[1] / diffValues[2])/4 * -PI * scale);
        }
        else if(diffValues[3] > threshold){
          rotate((float)(diffValues[3] / diffValues[2])/4 * PI * scale);
        }
      }
      else if (maxIndex1 == 3) {
        rotate(PI* 1/4);
        if(diffValues[2] > threshold){
          rotate((float)(diffValues[2] / diffValues[3])/4 * -PI * scale);
        }
        else if(diffValues[0] > threshold){
          rotate((float)(diffValues[0] / diffValues[3])/4 * PI * scale);
        }
      }
      stroke(0, 0, 255);
      fill(0, 0, 255);
      translate(55, 0);
      ellipse(0, 0, 10, 10);
      popMatrix();
    } else {
      touchedInside = false;
      touchStr = "";
    }
  }


  //if any finger is hover
  if (isGotHover && !touchedOutside && !touchedInside) {
    if (mode == 0) {
      gestureStr = getGesture(diffValues);
    } else {
      gestureStr = getCircle(diffValues);
    }
    ellipse(width-240, 70, 10, 10);
  } else if (!isGotHover || finishGesture) {
    isNotHoveredCount++;
    if (isNotHoveredCount > 50) {
      isNotHoveredCount = 0;
      initGestureFlag();
      initCircleGestureFlag();
      lastGestureStr = "";
      gestureStr = "";
    }
  }

  popStyle();
  popMatrix();
}

//void drawSlider(){

//}

//void moveSlider(float values[]){

//}

void initGestureFlag() {

  isStartedRightSwipe = false;
  isStartedLeftSwipe = false;
  isStartedUpSwipe = false;
  isStartedDownSwipe = false;
}

void initCircleGestureFlag() {

  isStartedClockwise = false;
  isStartedAntiClockwise = false;

  for (int i = 0; i < clockArrays.length; i++) {
    clockArrays[i] = 0;
  }

  indexCount = 0;
  startIndex = 0;
  lastIndex = 0;
}

String getGesture(float values[]) {

  int maxThreshold = 40;
  int minThreshold = 40;

  if (isStartedRightSwipe) {      
    if (values[2] > maxThreshold && values[3] > maxThreshold && values[2]+values[3] > values[0]+values[1]) {// && values[0] < minThreshold && values[3] < minThreshold){

      println("right");
      initGestureFlag();
      lastGestureStr = "Right Swipe";
      finishGesture = true;
      return "Right Swipe";
    }
  }
  if (isStartedLeftSwipe) {
    if (values[0] > maxThreshold && values[1] > maxThreshold && values[0]+values[1] > values[2]+values[3]) {// && values[1] < minThreshold && values[2] < minThreshold){

      println("left");
      initGestureFlag();
      lastGestureStr = "Left Swipe";
      finishGesture = true;
      return "Left Swipe";
    }
  }
  if (isStartedUpSwipe) {
    if (values[1] > maxThreshold && values[2] > maxThreshold && values[1]+values[2] > values[0]+values[3]) {// && values[0] < minThreshold && values[1] < minThreshold){

      println("up");
      initGestureFlag();
      lastGestureStr = "Up Swipe";
      finishGesture = true;
      return "Up Swipe";
    }
  }
  if (isStartedDownSwipe) {
    if (values[0] > maxThreshold && values[3] > maxThreshold && values[0]+values[3] > values[1]+values[2]) {// && values[2] < minThreshold && values[3] < minThreshold){

      println("down");
      initGestureFlag();
      lastGestureStr = "Down Swipe";
      finishGesture = true;
      return "Down Swipe";
    }
  } else {
    if (values[0] > maxThreshold && values[1] > maxThreshold && values[0]+values[1] > values[2]+values[3]) {// && values[1] < minThreshold && values[2] < minThreshold){
      isStartedRightSwipe = true;
    }
    if (values[2] > maxThreshold && values[3] > maxThreshold && values[2]+values[3] > values[0]+values[1]) {// && values[0] < minThreshold && values[3] < minThreshold){
      isStartedLeftSwipe = true;
    }
    if (values[0] > maxThreshold && values[3] > maxThreshold && values[0]+values[3] > values[1]+values[2]) {// && values[2] < minThreshold && values[3] < minThreshold){
      isStartedUpSwipe = true;
    }
    if (values[1] > maxThreshold && values[2] > maxThreshold && values[1]+values[2] > values[0]+values[3]) {// && values[0] < minThreshold && values[1] < minThreshold){
      isStartedDownSwipe = true;
    }
  }
  return lastGestureStr;
}

String getCircle(float value[]) {

  int maxThreshold = 40;
  int minThreshold = 40;

  float maxValue = 0;
  int maxIndex = -1;
  for (int i = 0; i < values.length; i++) {
    if (value[i] > 60) {
      if (value[i] > maxValue) {
        maxValue = value[i];
        maxIndex = i;
      }
    }
  }
  if (maxIndex >= 0) {
    if (maxIndex != lastIndex) {
      lastIndex = maxIndex;
      reloadArray(clockArrays, lastIndex);
      print(maxIndex);
      println(" hover");

      boolean isClockwise = false;
      boolean isAntiClockwise = false;

      int startIndex1 = clockArrays[0];
      for (int i = 1; i < clockArrays.length; i++) {
        startIndex1++;
        if (clockArrays[i] == (startIndex1 % 4)) {
          if (i == 3) {
            isClockwise = true;
          }
        } else {
          break;
        }
      }
      if (isClockwise) {
        initCircleGestureFlag();
        finishGesture = true;
        println("clockwise");
        lastGestureStr = "Clockwise";
        return "Clockwise";
      } else {
        int startIndex2 = clockArrays[0] + 4;
        for (int i = 1; i < clockArrays.length; i++) {
          startIndex2--;
          if (clockArrays[i] == (startIndex2 % 4)) {
            if (i == 3) {
              isAntiClockwise = true;
            }
          } else {
            break;
          }
        }
      }
      if (isAntiClockwise) {
        initCircleGestureFlag();
        finishGesture = true;
        println("anticlockwise");
        lastGestureStr = "AntiClockwise";
        return "AntiClockwise";
      }
    }
  }

  return lastGestureStr;
}

//float
void reloadArray(float array[], float newValue) {

  for (int i = 0; i < array.length -1; i++) {
    array[i] = array[i+1];
  }
  array[array.length - 1] = newValue;
}

//int
void reloadArray(int array[], int newValue) {

  for (int i = 0; i < array.length -1; i++) {
    array[i] = array[i+1];
  }
  array[array.length - 1] = newValue;
}

//reload and calc sum at the same time
float[] reloadArrayAndCalcAverage(float values[][], float newValues[]) {

  float ave[] = new float[values.length];

  for (int i = 0; i < values.length; i++) {
    for (int j = 0; j < values[i].length - 1; j++) {
      values[i][j] = values[i][j+1];
      ave[i] += values[i][j+1];
    }
    values[i][values[i].length - 1] = newValues[i];
    ave[i] += newValues[i];
    ave[i] /= values[i].length;
  }

  return ave;
}

int reloadGestureArrayAndGetHover(int arrays[], int newHoverIndex) {

  int[] hovers = new int[sensorNum];

  for (int i = 0; i < arrays.length - 1; i++) {
    arrays[i] = arrays[i+1];
    hovers[arrays[i]]++;
  }
  arrays[arrays.length - 1] = newHoverIndex;
  hovers[arrays[arrays.length - 1]]++;

  int maxValue = 0;
  int maxIndex = -1;
  for (int i = 0; i < hovers.length; i++) {
    if (hovers[i] > maxValue) {
      maxValue = hovers[i];
      maxIndex = i;
    }
  }
  if (maxValue > 4) {
    return maxIndex;
  } else {
    return -1;
  }
}

void keyPressed() {
  if (key == 'c') {
    for (int i = 0; i < values.length; i++) {
      baseValues[i] = aveValues[i];
      startRecognition = true;
    }
  }
  if (key == '[' || key == ']') {
    mode++;
    mode %= 2; 
    modeStr = str(mode);
  }
  //switch(key){
  //  case '1':
  //  hoverValues[0] = aveValues[0];
  //  calibCount++;
  //  break;
  //  case '2':
  //  hoverValues[1] = aveValues[1];
  //  calibCount++;
  //  break;
  //  case '3':
  //  hoverValues[2] = aveValues[2];
  //  calibCount++;
  //  break;
  //  case '4':
  //  hoverValues[3] = aveValues[3];
  //  calibCount++;
  //  break;
  //}
  //if(calibCount >= 4){
  //  startRecognition = true;
  //}
}

void serialEvent(Serial myPort) {
  if (myPort.available() >= 7) {
    String cur = myPort.readStringUntil('\n');
    if (cur != null) {
      String[] parts = split(cur, " ");
      if (parts.length == 4) {
        for (int i = 0; i < 4; i++) {
          values[i] = float(parts[i]);
        }
      }
    }
  }
}