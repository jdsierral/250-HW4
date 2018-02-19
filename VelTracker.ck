//
//  VelocityTracker.ck
//
//
//  Created by JuanS.


public class VelTracker {
    float a;
    float b;
    float s;
    float fs;
    float T;
    float lag;

    fun void setFs( float newFs ) {
        newFs => fs;
    }

    fun void setTau( float valInMs ) {
        Math.exp(-1.0/ (fs * valInMs / 1000.0 )) => a;
        1.0 - a => b;
    }

    fun void setTarget( float newValue ) {
        Std.fabs(newValue - lag) => T;
        newValue => lag;
    }

    fun void setPole( float newPoleValue ){
        newPoleValue => a;
        1.0 - a => b;
    }

    fun float tick( float val ) {
        s + b * (val - s) => s;
        return s;
    }

    fun float tick() {
        return tick(T);
    }
    fun float setState( float newValue ) {
        newValue => s;
    }
}
