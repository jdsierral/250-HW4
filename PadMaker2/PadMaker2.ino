#include <ResponsiveAnalogRead.h>
#include <Bounce.h>
#include <DSP.h>

//  ===================================  //
//  Description of Analog Inputs
//
//  A0 => Pitch Slider 1
//  A1 => Pitch Slider 2
//  A3 => Joystick 1.x
//  A4 => Joystick 1.y
//  A5 => Joystick 2.x
//  A6 => Joystick 2.y
//  A7 => Envelope Slider
//  ===================================  //
//  ===================================  //
//  Description of Digital Inputs
//
//  16 => Joystick Button 1
//  19 => Joystick Button 2
//  ===================================  //

const int CHAN = 0;
const int VEL = 100;
const int A_PINS = 6;
const int D_PINS = 2;
const int A_IN[A_PINS] = {A0, A1, A8, A3, A6, A7};
const int D_IN[D_PINS] = {16, 19};
const int CCID[A_PINS] = {21, 22, 23, 25, 26, 27};
const int BOUNCE_TIME  = 5;

int Note[D_PINS] = {60, 72};

byte data[A_PINS];
byte lag[A_PINS];

unsigned long prevMicros = 0;
unsigned long interval = 1000;

OnePole* onePole;
OneDiff* oneDiff;
DiffPole* diffPole;

ResponsiveAnalogRead Joysticks[] {
  {A_IN[3], true},
  {A_IN[4], true},
  {A_IN[5], true},
  {A_IN[6], true}
};

ResponsiveAnalogRead Sliders[] {
  {A_IN[0], true},
  {A_IN[1], true},
  {A_IN[2], true}
};

Bounce buttons[] = {
  Bounce(D_IN[0], BOUNCE_TIME),
  Bounce(D_IN[1], BOUNCE_TIME),
};

void setup() {
  for (int i = 0; i < D_PINS; i++) {
    pinMode(D_IN[i], INPUT_PULLUP);
  }
  onePole = new OnePole(1000);
  oneDiff = new OneDiff(1000);
  poleDiff = new poleDiff(1000);
}

void loop() {
  unsigned long startMicros = micros();
  getData();
  long diff = micros() - startMicros;
  if (interval - diff > 0) {
    delayMicroseconds( interval - diff );
  }
}

void getData() {
  getButtonsData();
  getJoystickData();
  getPitchData();
  getEnvelopeData();
  while (usbMIDI.read()) {}  
}


void getButtonsData(){
  for (int i = 0; i < D_PINS; i++) {
    digital[i].update();
    if (digital[i].fallingEdge()) {
      usbMIDI.sendNoteOn(Note[i], VEL, CHAN);
    }
    if (digital[i].risingEdge()) {
      usbMIDI.sendNoteOff(Note[i], VEL, CHAN);
    }
  }
}




//void getAnalogData() {
//  for (int i = 0; i < A_PINS; i++) {
//    analog[i].update();
//    if (analog[i].hasChanged()) {
//      data[i] = analog[i].getValue() >> 3;
//      if (data[i] != lag[i]) {
//        lag[i] = data[i];
//        usbMIDI.sendControlChange(CCID[i], data[i], CHAN);
//      }
//    }
//  }
//}

void getDigitalData() {
  
}

