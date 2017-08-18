class GUIElement {
  float lowRange;
  float highRange;
  float range;
  String address;
  int x, y, w, h;
  boolean isSlider = false;
  float sliderPos;
  int sliderDotRad = 60;
  int linksToScreenIndex;
  color col;
  int channel1 = 1;
  int channel2 = 2;
  int buttonIndex;
  GUIElement(int _channel1, float _lowRange, float _highRange, int _x, int _y, int _w, int _h, color _col) {
    lowRange=_lowRange;
    highRange = _highRange;
    range = highRange-lowRange;
    x=_x;
    y= _y;
    w=_w;
    h=_h;
    sliderPos = x+(0.5*w);
    isSlider = true;
    channel1 = _channel1;
    channel2 = _channel2;
    col = _col;
  }
  GUIElement( int _x, int _y, int _w, int _h, int _linksToScreenIndex, int _buttonIndex) {
    x=_x;
    y= _y;
    w=_w;
    h=_h;
    linksToScreenIndex = _linksToScreenIndex;
    buttonIndex = _buttonIndex;
  }
  void display() {
    pushStyle();
    //println("display", isSlider, x, y, w, h);
    if (isSlider) {
      //fill(100);
      //rect(x, y, w, h);
      fill(col);
      noStroke();
      ellipse(sliderPos, y+(0.5*h), sliderDotRad, sliderDotRad);
    } else {
      //ellipse(x, y, w, h);
    }
    popStyle();
  }
  int getCurrentVal() {

    return (int)map(sliderPos, x, x+w, lowRange, highRange);
  }
  void resetSlider() {
    sliderPos=x+(0.5*w);
  }

  void interact(int mX, int mY, boolean isDragged) {

    if (!isSlider && !isDragged) {
      //println("interact:", mX, mY, x, y, w, h, x+w, y+h);

      //surely this is wrong! shouldn't it be w*0.5
      if (dist(mX, mY, x, y)<w) {
        //if (mX>=x && mX <=x+w && mY >= y && mY<=y+h) {
        // sendOsc(1);
        // println("click:");
        if (screenIndex==2) {

          //set start to time out 
          screenIndex=linksToScreenIndex;
          startTime=millis();
        } else if (screenIndex==1) {

          screenIndex=linksToScreenIndex;
        } else {
          screenIndex=linksToScreenIndex;
        }
      }
    } else {
      if (  mX>x && mX <= x+w && mY > (y-h) && mY <y+h+h ) {

        //      if (dist(mX, mY, sliderPos, y+(0.5*h))<sliderDotRad *2  &&  mX>x && mX <= x+w && mY > y && mY <y+h ) {
        float val = map(mX, x, x+w, lowRange, highRange);
        println(val);
        sliderPos = mX;
        sendDMX((int)val);
      }
    }
  }

  //void sendOsc(float currentVal) {
  //  OscMessage myMessage = new OscMessage(address);
  //  myMessage.add(currentVal);
  //  oscP5.send(myMessage, myRemoteLocation);
  //}
  void sendDMX(int currentVal) {
    if (runDMX) {
      dmxOutput.set(yellowDMXChannel, yellowDefaultValue); 
      dmxOutput.set(channel1, currentVal);
      //dmxOutput.set(channel2, currentVal);
    }
  }
}