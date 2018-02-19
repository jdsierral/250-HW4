//
//  ComplexTracker.ck
//
//
//  Created by JuanS.

/* Differntiator to find first difference, track risingEdge and fallingEdge */

public class Diff {
    float s;
    fun float tick(float val) {
        val - s => float out;
        val => s;
        return out;
    }

    fun float risingEdge(float val) {
        val - s => float out;
        val => s;
        return Math.max(0.0, out);
    }

    fun float fallingEdge(float val) {
        s - val => float out;
        val => s;
        return Math.max(0.0, out);
    }
}
