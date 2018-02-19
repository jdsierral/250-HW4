
// Space for configuration of some useful parameters

[0.5, 2.0] @=> float ratio1[];
[1.0, 1.0] @=> float ratio2[];
[1.0, 1.0, 0.5] @=> float mixer[];

[2, 1] @=> int mappingType[];
[5, 5] @=> int octaves[];
[-3, 0]@=> int transpositions[];
[0,0] @=> int baseNotes[];

Gain out;

/* out => dac.chan(8);
out => dac.chan(9); */

out => dac;

Moog osc1[2];
Moog osc2[2];
TriOsc osc3[2]; 


LPF lpf;
LPF lpfF;
SinOsc lfo => blackhole;
Noise nz => blackhole;
Gain gen;
Gain env;
float rawEnv;

1::second / 1::samp => float fs;

[1, 1] @=> int state[];


ComplexTracker envTracker;
VelTracker velTracker;
Tracker freqTracker[2];
Mapping map[2];

lfo.freq(7.0);
nz.gain(8.0);
envTracker.setFs(fs);
envTracker.setTauAttack( 20.0 );
envTracker.setTauRelease( 1.0 );
velTracker.setFs(fs);
velTracker.setTau( 600 );


for (0 => int i; i < 2; i++) {
    freqTracker[i].setFs(fs);
    freqTracker[i].setTau( 30.0 );
    freqTracker[i].setState(60);
    osc1[i].freq(440);
    osc2[i].freq(880);
    osc3[i].freq(220);
    osc1[i].noteOn(1.0);
    osc2[i].noteOn(1.0);
    osc1[i] => gen;
    osc2[i] => gen;
    osc3[i] => gen;
    osc1[i].gain(mixer[0]);
    osc2[i].gain(mixer[1]);
    osc3[i].gain(mixer[2]);
    mappingType[i] => map[i].mapping;
    baseNotes[i] => map[i].base;
    16 => map[i].numNotes;
    octaves[i] => map[i].octave;
    transpositions[i] => map[i].transpose;
}


gen => lpf => lpfF => env => out;

env.gain(0.5);
gen.gain(0.5);
lpf.freq(20000.0);
lpfF.freq(2000);
lpfF.Q(2.0);

out.gain(0.05);

spork ~ activateMIDI();
spork ~ sampleEnvelopeData();


fun void activateMIDI() {
    MidiIn midiIn;
    MidiMsg msg;

    midiIn.open("Teensy MIDI");

    <<< midiIn.name() >>>;

    while ( true ) {
        midiIn => now;
        while(midiIn.recv(msg)) {
            /* <<< msg.data1, msg.data2, msg.data3 >>>; */
            if (msg.data2 == 21) {
                updateFilterFreq(msg.data3);
            } else if (msg.data2 == 22) {
                updateFilterRes(msg.data3);
            } else if (msg.data2 == 23) {
                updateVibrato(msg.data3);
            } else if (msg.data2 == 24) {
            } else if (msg.data2 == 25) {
                if (msg.data3 > 2) updateFreq(0, msg.data3);
            } else if (msg.data2 == 26) {
                if (msg.data3 > 2) updateFreq(1, msg.data3);
            } else if (msg.data2 == 27) {
                updateEnvelope(msg.data3);
            } else if (msg.data1 == 143 && msg.data2 == 60) {
                switchState(0);
            } else if (msg.data1 == 143 && msg.data2 == 72) {
                switchState(1);
            }
        }
    }
}

fun void switchState(int stateNum){
    if (state[stateNum] == 1) {
        0 => state[stateNum];
        osc1[stateNum].noteOff(1.0);
        osc2[stateNum].noteOff(1.0);
        osc3[stateNum].gain(0.0);
    } else {
        1 => state[stateNum];
        osc1[stateNum].noteOn(1.0);
        osc2[stateNum].noteOn(1.0);
        osc3[stateNum].gain(1.0);
    }
}

fun void updateFreq(int freqNum, int newVal){
    (newVal/127.0) => float pos;
    map[freqNum].map(pos) => float note;
    if (Std.fabs(note - freqTracker[freqNum].s) > 7) {
        freqTracker[freqNum].setState( note );
    } else {
        freqTracker[freqNum].setTarget( note );
    }
}

fun void updateEnvelope(float newVal) {
    newVal / 127.0 * 100.0 => rawEnv;
}

fun void sampleEnvelopeData() {
    while(true) {
        velTracker.setTarget( rawEnv );
        20::ms => now;
    }
}

fun void updateFilterFreq(float newVal) {
    newVal / 127.0 * 48.0 => float note;
    Std.mtof(note + 68) => float freq;
    lpf.freq(freq);
}

fun void updateFilterRes(float newVal) {
    newVal / 127.0 * 3 - 1 => float pow;
    Math.pow(10, pow) => float Q;
    lpf.Q(Q);
}

fun void updateVibrato(float newVal) {
    Std.fabs( 64 - newVal)  / 64.0 => float normVal;
    normVal * normVal * normVal * normVal * 0.01 => float mag;
    lfo.gain(mag);
}

while(true) {

    for (0 => int i; i < 2; i++) {
        freqTracker[i].tick() => float note;
        Std.mtof(note) => float freq;
        lfo.last() + 1.0 => float var;
        nz.last() => float rand;
        osc1[i].freq(freq * var + rand);
        osc2[i].freq(freq * ratio1[i] * var + rand);
        osc3[i].freq(freq * ratio2[i] * var );
    }

    velTracker.tick() => float envVal;
    envTracker.tick(envVal) => env.gain;
    1::samp => now;
}
