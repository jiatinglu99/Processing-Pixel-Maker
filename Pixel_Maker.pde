//***************************************************************************//
//Pixel Maker  Belongs to SpaceShooter Project  By Terry Lu
//Acknowledgement: used ColorPicker designed by julapy
//Link: https://forum.processing.org/one/topic/processing-color-picker.html
/*
Info:
 -- Version 2.4
 -- Published Date: April, 22, 2016
Manual(MUST SEE):
 — Hold 'H' to get help(including the instructions followed)
 — Press ’G’ to Turn on/off grid
 — Press ’I’ to Mirroring Copy(the Left side flip to the right side, which mean you just need to fill the left part of the graph and press ‘i’ to get a perfectly mirrored image)
 — Press 'O' to Mirroring Copy(the Upper size flip to the lower side)
 — Press ’S’ to Save Design(in ".png", the file will be saved under the same folder)
 — Press any number to store color on quick slot
 — Press the number to restore pen's color according to the quick slots
 — Press '-' to clear current quick slot
How to import graph that you have made?
 — Name the png that you want to import as “import.png”, and “Add File” before running the program, choose “Replace” if the prompt comes up.
*/
//***************************************************************************//
PrintWriter output;
Frame frame;
ColorPicker cp;
String filename;
boolean saving = false, grid_on = true, importing = false;
int saveposition = 420;
boolean[] colorsaved = new boolean[10];
color[] colors = new color[10];
int number = 0, timecount = 2000;
PImage pencil, colorboard, importImage, help;

void setup()
{
  size(920, 500);
  frameRate(60);
  frame = new Frame();
  cp = new ColorPicker( 10, 10, 400, 400, 255 );
  for (int i = 0; i < 10; i++)
  {
    colorsaved[i] = false;
  }
  //black pen
  colorsaved[0] = true;
  colors[0] = color(0, 0, 0);
  //eraser
  colorsaved[9] = true;
  colors[9] = color(255, 255, 255);
  pencil = loadImage("pencil.png");
  colorboard = loadImage("file.jpg");
  help = loadImage("help.png");
}

void draw()
{
  background(255);
  if (saving) background(255);
  pushMatrix();
  translate(saveposition, 0);
  frame.draw_p();
  if (!saving && grid_on) frame.grid();
  popMatrix();
  
  if (!saving) cp.render();
  if (saving) 
  {
    filename = str(year())+str(month())+str(day())+str(hour())+str(minute())+str(second());
    save(filename+"/"+filename+".png");
    output = createWriter(filename+"/"+"data.txt");
    for (int i = 0; i < 50; i++)
      for (int j = 0; j < 50; j++)
      output.print(frame.grids[i][j]+",");//("frame.grids["+i+"]["+j+"] = "+frame.grids[i][j]);
    output.flush();
    output.close();
    timecount = 0;
  }
  
  //pencil
  if (mouseX > 420)
  {
    noCursor();
    image(pencil, mouseX - 27, mouseY - 26);
  }
  else cursor(CROSS);
  if (!saving)
  {
    if (timecount < 1000) 
    {
      timecount++;
      stroke(10);
      text("Saved!", 100, 100);
    }
  }
  
  saving = false;
  saveposition = 420;
  
  if (keyPressed)
  {
    if (key == 'h')
  {
    fill(255);
    imageMode(CENTER);
    image(help, 500, 200);
  }
  }
}

class Frame
{
  color[][] grids = new color[50][50];
  boolean gridshow = true;
  
  Frame()
  {
    //String[] stuff = loadStrings("data.txt");
    for (int i = 0; i < 50; i++)
    {
      for (int j = 0; j < 50; j++)
      {
        grids[i][j] = color(255, 255, 255);
      }
    }
  }
  
  void draw_p()
  {
 
    noStroke();
    if (mousePressed && mouseX < 920 && mouseX > 420 && mouseY < 500 && mouseY > 0) grids[(mouseX-420)/10][mouseY/10] = cp.c;//selected;
    for (int i = 0; i < 50; i++)
    {
      for (int j = 0; j < 50; j++)
      {
        fill(grids[i][j]);
        rect(i*10, j*10, 10, 10);
      }
    }
  }
  
  void grid()
  {
      for (int i = 0; i < 50; i++)
      {
        fill(0);
        stroke(0);
        strokeWeight(1);
        line(10*i, 0, 10*i, 500);
        line(0, 10*i, 500, 10*i);
      }
      stroke(0);
      strokeWeight(2);
      line(250, 0, 250, 500);
      line(0, 250, 500, 250);
  }
}

void keyPressed()
{
  if (key == 'g') grid_on = !grid_on;
  if (key == 'i') 
  {
    for (int i = 0; i < 25; i++)
    {
      for (int j = 0; j < 50; j++)
        frame.grids[49-i][j] = frame.grids[i][j];
    }
  }
  if (key == 'o')
  {
    for (int i = 0; i < 25; i++)
    {
      for (int j = 0; j < 50; j++)
        frame.grids[j][49-i] = frame.grids[j][i];
    }
  }
  else if (key == 's')
  {
    saving = true;
    saveposition = 210;
  }
  else if (key == '1') number = 0;
  else if (key == '2') number = 1;
  else if (key == '3') number = 2;
  else if (key == '4') number = 3;
  else if (key == '5') number = 4;
  else if (key == '6') number = 5;
  else if (key == '7') number = 6;
  else if (key == '8') number = 7;
  else if (key == '9') number = 8;
  else if (key == '0') number = 9;
  
  if (key == '0'||key == '1'||key == '2'||key == '3'||key == '4'||key == '5'||key == '6'||key == '7'||key == '8'||key == '9')
  {
    if (!colorsaved[number])
    {
      colorsaved[number] = true;
      colors[number] = cp.c;
    }
    if (colorsaved[number]) cp.c = colors[number];
  }
  
  if (key == '-') colorsaved[number] = false;
  
  if (key == 'p') 
  {
    importing = true;
    importImage = loadImage("import.png");
    background(255);
    imageMode(CENTER);
    image(importImage, 670, 250);
    for (int i = 0; i < 50; i++)
      for (int j = 0; j < 50; j++)
      {
        frame.grids[i][j] = get(420 + 5 + 10*i, 5 + 10*j);
      }
  }
}

public class ColorPicker 
{
  int x, y, w, h, c;
  PImage cpImage;
  
  public ColorPicker ( int x, int y, int w, int h, int c )
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    cpImage = new PImage( w, h );
    //init();
  }
  
  public void render ()
  {
    fill(50);
    rect(0, 0, 420, 500);
    //image( cpImage, x, y );
    imageMode(CORNER);
    image(colorboard, 0, 0);
    if( mousePressed && mouseX >= x && mouseX < x + w && mouseY >= y && mouseY < y + h )
    {
      c = get( mouseX, mouseY );
    }
    fill( c );
    stroke(0);
    rect( x, y+h+10, 400, 50 );
    for (int i = 0; i < 10; i++)
    {
      if (colorsaved[i]) 
      {
        fill(colors[i]);
        rect(10+i*40, 460, 40, 40);
        textAlign(CENTER);
        fill(0);
        if (red(colors[i]) < 100 || green(colors[i]) < 100 || blue(colors[i]) < 100) fill(255);
        if (i < 9) text(i+1, 30+i*40, 480); else text('0', 30+i*40, 480);
      }
    }
  }
}