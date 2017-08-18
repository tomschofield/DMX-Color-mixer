import dmxP512.*;
import processing.serial.*;
import java.util.Date.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
DmxP512 dmxOutput;
int universeSize=128;

boolean DMXPRO=true;
String DMXPRO_PORT="COM3";//case matters ! on windows port must be upper cased.
int DMXPRO_BAUDRATE=115000;

Screen [] screens;
int screenIndex = 1;
boolean runDMX = false;
long startTime=0;
long timeoutInterval=4000;
int pScreenIndex=0;

int yellowDefaultValue;
int redDefaultValue;
int greenDefaultValue;

int yellowDMXChannel;
int redDMXChannel;
int greenDMXChannel;

float lowLightRange;
float highLightRange;
int quitHour;
int quitMinute;


void setup() {
  size(1920, 1080);
  smooth();

  ///import settings
  XML xml;
  xml = loadXML("settings.xml");

  yellowDefaultValue =255* xml.getChild("yellowDefaultValue").getIntContent()/100;
  redDefaultValue = 255* xml.getChild("redDefaultValue").getIntContent()/100;
  greenDefaultValue = 255* xml.getChild("greenDefaultValue").getIntContent()/100;
  
  yellowDMXChannel = xml.getChild("yellowDMXChannel").getIntContent();
  redDMXChannel = xml.getChild("redDMXChannel").getIntContent();
  greenDMXChannel = xml.getChild("greenDMXChannel").getIntContent();
  
  timeoutInterval =1000* xml.getChild("timeoutInterval").getIntContent();

  lowLightRange = 255* xml.getChild("lowLightRange").getIntContent()/100;
  highLightRange =255* xml.getChild("highLightRange").getIntContent()/100;
  
  quitHour = xml.getChild("quitHour").getIntContent();
  quitMinute = xml.getChild("quitMinute").getIntContent();
  
  
  dmxOutput=new DmxP512(this, universeSize, false);
  if (runDMX) {
    dmxOutput.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);

    dmxOutput.set(yellowDMXChannel, yellowDefaultValue); 
    dmxOutput.set(redDMXChannel, redDefaultValue); 
    dmxOutput.set(greenDMXChannel, greenDefaultValue);
  }
  //frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */

  screens = new Screen[4];

  ///add screen 1
  Screen screen = new Screen("Slide_1080x1920px_Colour_Vision.jpg");
  GUIElement button1 = new GUIElement(960, 721, 323, 323, 1, 0) ;
  screen.addGuiElement(button1);
  screens[0]= screen;

  ///add screen 2
  Screen screen1 = new Screen("Slide_1080x1920px_Colour_Vision2.jpg");
  //GUIElement fader1 = new GUIElement("/pb/1", 0, 255, 100, 100, 300, 10) ;
  GUIElement fader1 = new GUIElement(redDMXChannel, lowLightRange, highLightRange, 515, 668, 880, 10, color(255, 0, 0)) ;
  GUIElement fader2 = new GUIElement(greenDMXChannel, lowLightRange, highLightRange, 515, 884, 880, 10, color(0, 255, 0)) ;

  screen1.addGuiElement(fader1);
  screen1.addGuiElement(fader2);

  GUIElement button2 = new GUIElement(957, 354, 323, 323, 2, 0) ;

  screen1.addGuiElement(button2);
  screens[1]= screen1;

  ///add screen 3
  Screen screen3 = new Screen("Slide_1080x1920px_Colour_Vision3.jpg");
  GUIElement button3 = new GUIElement(561, 671, 323, 323, 3, 0) ;
  screen3.addGuiElement(button3);
  GUIElement button4 = new GUIElement(960, 671, 323, 323, 3, 1) ;
  screen3.addGuiElement(button4);
  GUIElement button5 = new GUIElement(1359, 671, 323, 323, 3, 2) ;
  screen3.addGuiElement(button5);
  screens[2]= screen3;

  ///add screen 4
  Screen screen4 = new Screen("Slide_1080x1920px_Colour_Vision4.jpg");
  screens[3]= screen4;
}


void draw() {
  background(0);
  quitAt( quitHour,  quitMinute);
  dmxOutput.set(yellowDMXChannel, yellowDefaultValue); 
  if (screenIndex==3&&startTime!=0) {
    if (millis()-startTime>timeoutInterval) {
      screenIndex=0; 
      startTime=0;
    }
  }

  if (screenIndex==2&&pScreenIndex==1) {
    DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    Date date = new Date();
    String newLine = dateFormat.format(date);

    GUIElement element1 = (GUIElement) screens[1].GUIElements.get(0);
    GUIElement element2 = (GUIElement) screens[1].GUIElements.get(1);


    newLine+=",";
    newLine+=str(element1.getCurrentVal());
    newLine+=",";
    newLine+=str(element2.getCurrentVal());


    updateLog(newLine);

    element1.resetSlider();
    element2.resetSlider();
  }
  if (screenIndex==0) {
    dmxOutput.set(yellowDMXChannel, yellowDefaultValue); 
    dmxOutput.set(redDMXChannel, redDefaultValue); 
    dmxOutput.set(greenDMXChannel, greenDefaultValue);
  }



  screens[screenIndex].display();
  pScreenIndex=screenIndex;
}
void quitAt(int quitHour, int quitMinute) {
  println(quitHour,hour(),  quitMinute,minute());
  if (quitHour==hour() && quitMinute==minute()) {
    dmxOutput.set(1, 0); 
    dmxOutput.set(2, 0); 
    dmxOutput.set(3, 0);
    exit();
  }
}
void updateLog(String newLine) {
  String block="";
  try {
    String [] lines = loadStrings("log.csv");
    block= join(lines, "\n");
    block+="\n"+newLine;
  }
  catch(Exception e) {
    println("no log file");
  }
  PrintWriter output;

  output = createWriter("data/log.csv");
  output.print(block);
  output.flush();
  output.close();
}
void mouseDragged() {
  screens[screenIndex].checkInteraction(mouseX, mouseY, true);
}
void mousePressed() {
  screens[screenIndex].checkInteraction(mouseX, mouseY, false);
  /* in the following different ways of creating osc messages are shown by example */
  //OscMessage myMessage = new OscMessage("/test");

  //myMessage.add(123); /* add an int to the osc message */

  ///* send the message */
  //oscP5.send(myMessage, myRemoteLocation);
}