import processing.video.*;

import codeanticode.syphon.*;

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;
PImage prev;
float threshold = 50;

void setup() {
  fullScreen();
  
  kinect2 = new Kinect2(this);
  kinect2.initVideo();
  kinect2.initDevice();

}

void draw() {
  PImage img = kinect2.getVideoImage();
  image(img, 0, 0);
}
