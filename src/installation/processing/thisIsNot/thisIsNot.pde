void settings() {
  fullScreen(P3D);
}

void setup() {
  canvas = createGraphics(displayWidth, displayHeight, P3D);
  
  /* INITIALIZE KINECTS */
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  
  kinect2.initDevice();
  
  /* INITIALIZE SYPHON SERVER */
  server = new SyphonServer(this, "Processing Syphon");
  cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}

void draw() {
  canvas.beginDraw(); // YOU MUST HAVE `beginDraw()` and `endDraw()` TO DISPLAY PROPERLY
  canvas.background(255);
  
  canvas.pushMatrix();
  canvas.translate(width/2, height/2, -2250);
  
  int skip = 4;
  int[] depth = kinect2.getRawDepth();
  
  canvas.stroke(0);
  canvas.strokeWeight(2.25);
  canvas.beginShape(POINTS);
  for (int x = 0; x < kinect2.depthWidth; x+=skip) {
    for (int y = 0; y < kinect2.depthHeight; y+=skip) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
      
      PVector point = depthToPointCloudPos(x, y, d);
      canvas.vertex(point.x, point.y, point.z);
      
      // THIS IS WHERE YOU MAP DISTANCE FROM KINECT //
      if (d > 200 && d < 3000) {
        canvas.stroke(0);
      } else {
        canvas.stroke(255);
      }
    }
  }
  canvas.endShape();
  canvas.popMatrix();
  canvas.fill(255);
  
  canvas.endDraw(); // YOU MUST HAVE `beginDraw()` and `endDraw()` TO DISPLAY PROPERLY
  image(canvas, 0, 0);
  server.sendImage(canvas);
}
