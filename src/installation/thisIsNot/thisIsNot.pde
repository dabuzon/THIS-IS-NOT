import codeanticode.syphon.*;

import netP5.*;
import oscP5.*;

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2a;
Kinect2 kinect2b;

PImage canvas;

SyphonServer server;
OscP5 oscP5;
NetAddress myBroadcastLocation;

void setup() {
  fullScreen(P3D);
  // Does this work? //
  canvas = createGraphics(displayWidth, displayHeight, P3D);
  
  kinect2a = new Kinect2(this);
  kinect2a.initDepth();
  
  kinect2b = new Kinect2(this);
  kinect2b.initDepth();
  
  kinect2a.initDevice(0);
  kinect2b.initDevice(1);
  /* 
     Putting `background(255)` only in setup() will keep the points drawn instead of constantly being drawn.
     However, not sure why we need to put background twice if we could just have it in draw() only.
     Refer to MultiKinect.pde code at https://github.com/shiffman/OpenKinect-for-Processing/blob/master/OpenKinect-Processing/examples/Kinect_v2/MultiKinect2/MultiKinect2.pde
  */
  // background(255);
  
  server = new SyphonServer(this, "Processing Cube");
  oscP5 = new OscP5(this, 5001);
  myBroadcastLocation = new NetAddress("127.0.0.1", 5000);
}

void draw() {
  background(255);
  
  pushMatrix();
  translate(width/2, height/2, -2250);
  
  int skip = 4;
  int[] depth = kinect2a.getRawDepth();
  
  stroke(0);
  strokeWeight(2.25);
  beginShape(POINTS);
  for (int x = 0; x < kinect2a.depthWidth; x+=skip) {
    for (int y = 0; y < kinect2a.depthHeight; y+=skip) {
      int offset = x + y * kinect2a.depthWidth;
      int d = depth[offset];
      
      PVector point = depthToPointCloudPos(x, y, d);
      vertex(point.x, point.y, point.z);
      
      // THIS IS WHERE YOU MAP DISTANCE FROM KINECT //
      if (d > 300 && d < 1500) {
        stroke(0);
      } else {
        stroke(255);
      }
    }
  }
  endShape();
  popMatrix();
  fill(255);
  
  // FIGURE OUT HOW TO CONVERT CURRENT DRAWING INTO A PImage //
  image(canvas, 0, 0);
  server.sendImage(canvas);
}

PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}
