class Screen {
  PImage slide;
  ArrayList GUIElements;
  
  Screen(String slideFname) {
    slide = loadImage(slideFname);
    GUIElements = new ArrayList();
  }
  void display() {
    image(slide, 0, 0);
    for (int i=0; i<GUIElements.size(); i++) {
      GUIElement element = (GUIElement) GUIElements.get(i);
      element.display();
    }
  }
  void addGuiElement(GUIElement element) {
    GUIElements.add(element);
  }
  void checkInteraction(int mX, int mY, boolean isDragged) {
   
    for (int i=0; i<GUIElements.size(); i++) {
      GUIElement element = (GUIElement) GUIElements.get(i);
      element.interact(mX, mY, isDragged);
    }
  }
}