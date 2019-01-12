import codeanticode.syphon.*;

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;
PImage img;

void setup() {
  fullScreen();
  kinect2 = new Kinect2(this);
  
  kinect2.initDepth();
  kinect2.initDevice(); // Can accept arguments for how many Kinect devices to use //
  
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
}

void captureEvent() {
 
  // Add this in a nested loop with appropriate parameters //
  
  
}

void draw() {
  
  img.loadPixels();
  
  int[] depth = kinect2.getRawDepth();
  for (int x = 0; x < kinect2.depthWidth; x++) {
    for (int y = 0; y < kinect2.depthHeight; y++) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
      
      // THIS SETS RANGE KINECT WILL DETECT //
      if (d > 300 && d < 1500) {
        img.pixels[offset] = color(255, 0, 0);
      } else {
        img.pixels[offset] = color(255);
      }
    }
  }
  
  img.updatePixels();
  image(img, 0, 0);
}
