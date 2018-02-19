//
//  ComplexTracker.ck
//
//
//  Created by JuanS.
//  Base class for a complex envelope tracker.
//  It has a differnt time for the attack of the transients than for the release
//  allowing to have a slow release while still being responsive


public class ComplexTracker {
    float aA;
    float bA;
    float aR;
    float bR;
    float s;
    float fs;
    float T;

    fun void setFs( float newFs) {
        newFs => fs;
    }

    fun void setTauAttack( float valInMs ) {
        Math.exp(-1.0 / (fs * valInMs / 1000.0)) => aA;
        1.0 - aA => bA;
    }

    fun void setTauRelease( float valInMs ) {
        Math.exp(-1.0 / (fs * valInMs / 1000.0)) => aR;
        1.0 - aR => bR;
    }

    fun float tick( float val ) {
        if (Math.fabs(val) > s) {
            s + bA * (Math.fabs(val) - s) => s;
        } else {
            s + bR * (Math.fabs(val) - s) => s;
        }
        return s;
    }

    fun float setTarget( float newValue ) {
        newValue => T;
    }

    fun float tick() {
        return tick( T );
    }

    fun void setState( float newValue ) {
        newValue => s;
    }
}
