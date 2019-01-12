import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

Kinect2 kinect2;

void setup() {
  fullScreen(P3D);
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
}

void draw() {
  background(255);
  
  pushMatrix();
  translate(width/2, height/2, -2250);
  
  int skip = 4;
  int[] depth = kinect2.getRawDepth();
  
  stroke(0);
  strokeWeight(2.25);
  beginShape(POINTS);
  for (int x = 0; x < kinect2.depthWidth; x+=skip) {
    for (int y = 0; y < kinect2.depthHeight; y+=skip) {
      int offset = x + y * kinect2.depthWidth;
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
}

PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = (depthValue);
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}
