//#include <Bounce2.h>

#include <ResponsiveAnalogRead.h>
#include <Bounce.h>

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

const int CHAN = 0;
const int VEL = 100;
const int A_PINS = 6;
const int D_PINS = 2;
const int A_IN[A_PINS] = {A0, A1, A3, A6, A7, A8};
const int D_IN[D_PINS] = {16, 19};
const int CCID[A_PINS] = {21, 22, 23, 25, 26, 27};
const int BOUNCE_TIME  = 5;

byte data[A_PINS];
byte lag[A_PINS];

ResponsiveAnalogRead analog[] {
  {A_IN[0], true},
  {A_IN[1], true},
  {A_IN[2], true},
  {A_IN[3], true},
  {A_IN[4], true},
  {A_IN[5], true},
  {A_IN[6], true}
};

Bounce digital[] = {
  Bounce(D_IN[0], BOUNCE_TIME),
  Bounce(D_IN[1], BOUNCE_TIME),
};

void setup() {
  for (int i = 0; i < D_PINS; i++) {
    pinMode(D_IN[i], INPUT_PULLUP);
  }
}

void loop() {
  getAnalogStateData();
  getDigitalData();
//  getAnalogContinousData();
  while (usbMIDI.read()) {}
}

void getAnalogStateData() {
  for (int i = 0; i < A_PINS; i++) {
    analog[i].update();
    if (analog[i].hasChanged()) {
      data[i] = analog[i].getValue() >> 3;
      if (data[i] != lag[i]) {
        lag[i] = data[i];
        usbMIDI.sendControlChange(CCID[i], data[i], CHAN);
      }
    }
  }
}

void getDigitalData() {
  for (int i = 0; i < D_PINS; i++) {
    digital[i].update();
    if (digital[i].fallingEdge()) {
      usbMIDI.sendNoteOn(60 + 12 * i, VEL, CHAN);
    }
    if (digital[i].risingEdge()) {
      usbMIDI.sendNoteOff(60 + 12 * i, VEL, CHAN);
    }
  }
}
