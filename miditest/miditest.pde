import themidibus.*; //Import the library
import processing.serial.*;

MidiBus myBus; // The MidiBus
Serial port;

String ports[] =  Serial.list();
int[] val = new int[3];
color RX_flashcolor = 0;
color TX_flashcolor = 0;
float TX_flash = 0;
color flashcolor = color(00, 255, 00);
float RX_flash = 0;

void setup() {
	size(400,400);
	background(0);
	MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
	myBus = new MidiBus(this, 0, 0); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
        port = new Serial(this, Serial.list()[0], 115200);
        port.buffer(3);
        port.clear();
}

void draw() {
	int channel = 0;
	int pitch = 64;
	int velocity = 127;
	
	//myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
	//delay(200);
	//myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff	
	int number = 0;
	int value = 90;
	//myBus.sendControllerChange(channel, number, value); // Send a controllerChange
	//delay(2000);
}

void serialEvent(Serial port)
{
  int i = 0;
  for(i=0; i < 3; i = i +1)
  {
    int inByte = port.read();
    val[i] = inByte;
    if(i==0 && inByte < 128)                                  // Verify 1st Byte is Status byte
    {
      i=3;
    }
  }
  if(val[0] >= 128)
  {
    myBus.sendMessage(val[0], val[1], val[2]);
    RX_flashcolor = flashcolor;
  }
  else
  {
    RX_flashcolor = color(255,0,0);                            // ERROR ! FLash
  }
  RX_flash = millis();
}

void noteOn(int channel, int pitch, int velocity) {
	// Receive a noteOn
	println();
	println("Note On:");
	println("--------");
	println("Channel:"+channel);
	println("Pitch:"+pitch);
	println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
	// Receive a noteOff
	println();
	println("Note Off:");
	println("--------");
	println("Channel:"+channel);
	println("Pitch:"+pitch);
	println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
	// Receive a controllerChange
	println();
	println("Controller Change:");
	println("--------");
	println("Channel:"+channel);
	println("Number:"+number);
	println("Value:"+value);
}
