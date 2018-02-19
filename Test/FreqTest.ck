Gain out;

out => dac.chan(8);
out => dac.chan(9);

/* out => dac; */


TriOsc osc;

Gain gate;

float rawEnv;

Mapping map;
Tracker freqTracker;
VelTracker velTracker;
ComplexTracker gateTracker;

osc => gate => out;

1::second / 1::samp => float fs;


out.gain(0.1);
freqTracker.setPole(0.9995);
velTracker.setPole(0.9999);
gateTracker.setFs(fs);
gateTracker.setTauAttack(20);
gateTracker.setTauRelease(100);
2 => map.mapping;

velTracker.setTarget(1.0);

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
            <<< msg.data1, msg.data2, msg.data3 >>>;
            if (msg.data2 == 25) {
                /* updateFreq(msg.data3); */
            } else if (msg.data2 == 26) {
                if (msg.data3 < 4) {
                    /* velTracker.setTarget( 0.0 ); */
                } else {
                    /* velTracker.setTarget( 1.0 ); */
                    updateFreq(msg.data3);
                }
            } else if (msg.data2 == 27) {
                updateEnvelope(msg.data3);
            }
        }
    }
}


fun void updateFreq(float newVal) {
    (newVal/127.0 * 100) $ int => int pos;
    map.map(pos) => int note;
    if (Std.fabs(note - freqTracker.s) > 3) {
        freqTracker.setState( note );
    } else {
        freqTracker.setTarget( note );
    }
}

fun void updateEnvelope(float newValue) {
    newValue / 127.0 * 100.0 => rawEnv;
}

fun void sampleEnvelopeData() {
    while(true) {
        velTracker.setTarget( rawEnv );
        20::ms => now;
    }
}

while(true){
    freqTracker.tick() => float pos;
    Std.mtof(pos + 60) => float freq;
    osc.freq(freq);
    velTracker.tick() => float envVal;
    gateTracker.tick(envVal) => gate.gain;
    1::samp => now;
}
