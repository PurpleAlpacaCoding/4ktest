// Created by Ian (PurpleAlpacaCoding) December 2021

//Arays to store points for vornoi.
PVector[] points = new PVector[35];
PVector[] myVels = new PVector[points.length + 1];
int[] myDirs = new int[points.length];
// Vels and Dirs are for animation - Moving the points in circles.

// IDK if processing has a 'large number' constant, so I made one
float INF = 99999999;
// This is how we actually store the image created.
PGraphics fram;

void setup()
{
  size(500, 500);
  // 4k res
  fram = createGraphics(3840, 2160);
  // population
  for (int i = 0; i < points.length; i++)
  {
    PVector temp = PVector.fromAngle(random(0, 2 * PI));
    temp.mult(random(1, fram.width/3));
    points[i] = new PVector(temp. x + fram.width/3, temp.y + fram.height/3);
    myDirs[i] = floor(random(4));
    myVels[i] = PVector.fromAngle(random(2 * PI)).mult(random(0.5, 1));
  }
  myVels[myVels.length - 1] = PVector.fromAngle(0);
}

void draw()
{
  fram.beginDraw();
  fram.loadPixels();

  for (int x = 0; x < fram.width; x++)
  {
    for (int y = 0; y < fram.height; y++)
    {
      //for every pixel, find the 2nd and 3rd closest point.
      float D1 = INF;
      float D2 = INF;
      float D3 = INF;
      for (PVector p : points)
      {
        //Calculate the distance. 
        float temp = dist(x, y, p.x, p.y);
        //Compare to closest.
        if (temp < D1)
        {
          //if its the closest, switch the others.
          D3 = D2;
          D2 = D1;
          D1 = temp;
        }
        //Otherwise, check if its the 2nd closest.
        else if (temp < D2)
        {
          D3 = D2;
          D2 = temp;
        }
        //Check for 3rd.
        else if (temp < D3)
        {
          D3 = temp;
        }
      }

      //Color the pixel based off the three closest points.
      fram.pixels[y * fram.width + x] = color(#4C3D40);
      if (D2 - D1 < 1)
      {
        fram.pixels[y * fram.width + x] = color(#BDB5C0);
      }
      if (D3 - D2 < 5)
      {
        fram.pixels[y * fram.width + x] = color(0);
      }
      if (D3 - D1 < 7)
      {
        fram.pixels[y * fram.width + x] = color(#F6EEF0);
      }
    }
  }

  fram.updatePixels();
  fram.endDraw();

  background(50);
  //image(fram, 0, 0);
  text(frameCount, 50, 50);
  //Now we animate every point in a type of circle.

  myVels[myVels.length - 1].rotate(radians(0.5));
  for (int i = 0; i < points.length; i++)
  {
    switch(myDirs[i])
    {
    case 0:
      myVels[i].rotate(radians(3/2));
      break;
    case 1:
      myVels[i].rotate(radians(-3/2));
      break;
    case 2:
      myVels[i].rotate(radians(2));
      break;
    case 3:
      myVels[i].rotate(radians(-2));
      break;
    }

    points[i].add(myVels[i]);
    points[i].add(myVels[myVels.length - 1]);
  }

  // Saving every image in a folder 'images' for export
  if (frameCount <= 720)
  {
    fram.save("images/fram-" + nf(frameCount, 5) + ".tif");
  } else
  {
    // It loops after 720 frames, no need to keep going
    exit();
  }
}
