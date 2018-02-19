Gain out;

out => dac.chan(8);
out => dac.chan(9);

out => dac;

Moog osc11;
Moog osc12;
Moog osc21;
Moog osc22;

LPF lpf;

Gain gen;
Gain env;

1::second / 1::samp => float fs;
0 => float envVal;
0 => int state1;
0 => int state2;

Mapping map;
Diff diff;
ComplexTracker envTracker;
Tracker freq1Tracker;
Tracker freq2Tracker;

envTracker.setFs(fs);
freq1Tracker.setFs(fs);
freq2Tracker.setFs(fs);
envTracker.setTauAttack( 10.0 );
envTracker.setTauRelease( 250.0 );
freq1Tracker.setTau(1.0);
freq2Tracker.setTau(1.0);

freq1Tracker.setState(440);
freq2Tracker.setState(440);


2 => map.mapping;
0 => float envLag;

osc11 => gen;
osc12 => gen;
osc21 => gen;
osc22 => gen;

gen => lpf => env => out;

env.gain(0.5);
gen.gain(0.5);
lpf.freq(20000.0);
out.gain(0.5);


spork ~ activateMIDI();
spork ~ envelopeTracking();
spork ~ freq1Tracking();
spork ~ freq2Tracking();

fun void activateMIDI() {
    MidiIn midiIn;
    MidiMsg msg;

    midiIn.open(2);

    <<< midiIn.name() >>>;

    while ( true ) {
        midiIn => now;
        while(midiIn.recv(msg)) {
            <<< msg.data1, msg.data2, msg.data3 >>>;
            if (msg.data2 == 25) {
                updateFreq1(msg.data3);
            } else if (msg.data2 == 26) {
                updateFreq2(msg.data3);
            } else if (msg.data2 == 27) {
                updateEnvelope(msg.data3);
            } else if (msg.data1 == 143 && msg.data2 == 60) {
                if (state1 == 1) {
                    0 => state1;
                    osc11.noteOff(1.0);
                    osc12.noteOff(1.0);
                } else {
                    1 => state1;
                    osc11.noteOn(1.0);
                    osc12.noteOn(1.0);
                }
            } else if (msg.data1 == 143 && msg.data2 == 72) {
                if (state2 == 1) {
                    0 => state2;
                    osc21.noteOff(1.0);
                    osc22.noteOff(1.0);
                } else {
                    1 => state2;
                    osc21.noteOn(1.0);
                    osc22.noteOn(1.0);
                }
            }
        }
    }
}


fun void updateFreq1(int newVal){
    newVal/127.0 * 100 => float val;
    map.map(val) + 57 => int note;
    Std.mtof(note) => float freq;
    freq1Tracker.setTarget( freq );
}

fun void updateFreq2(int newVal) {
    newVal/127.0 * 100 => float val;
    map.map(val) + 57 => int note;
    Std.mtof(note) => float freq;
    freq2Tracker.setTarget( freq );
}

fun void updateEnvelope(float newVal) {
    0 => float delta;
    if (newVal != 0) {
        newVal - envLag => delta;
        newVal => envLag;
    }
    envTracker.setTarget( delta );
}

fun void envelopeTracking() {
    while(true) {
        envTracker.tick() => envVal;
        env.gain(envVal);
        1::samp => now;
    }
}

fun void freq1Tracking() {
    while(true) {
        freq1Tracker.tick() => float freq;
        osc11.freq(freq);
        osc12.freq(freq * 2.0);
        1::samp => now;
    }
}

fun void freq2Tracking() {
    while(true) {
        freq2Tracker.tick() => float freq;
        osc21.freq(freq);
        osc22.freq(freq * 2.0);
        1::samp => now;
    }
}

while(true) {
    1::samp => now;
}
