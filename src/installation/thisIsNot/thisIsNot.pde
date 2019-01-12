import codeanticode.syphon.*;

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;

void setup() {
  fullScreen();
  kinect2 = new Kinect2(this);
  
  kinect2.initDepth();
  kinect2.initDevice(); // Can accept arguments for how many Kinect devices to use //
}

void draw() {
  PImage img = kinect2.getDepthImage();
  image(img, 0, 0);
}
