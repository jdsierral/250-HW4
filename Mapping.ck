//
//  ComplexTracker.ck
//
//
//  Created by JuanS.


/* Mapping object to create diatonic scales!
Currently it only has a pentatonic, but its possible to add more */

public class Mapping {

    0 => int linear;
    1 => int pentatonic;
    2 => int minor;

    1 => int mapping;

    0 => int base;

    fun int map(float pos) {
        if (mapping == linear) {
            return linearMapping(pos);
        }

        if (mapping == pentatonic) {
            return pentatonicMapping(pos);
        }

        if (mapping == minor) {
            return minorMapping(pos);
        }

    }

    fun int linearMapping(float pos) {
        (pos / 127.0 * 24.0) $ int => int zone;
        return zone;
    }

    fun int pentatonicMapping(float pos) {
        (pos / 10) $ int => int zone;
        if (zone == 0) return -5;
        if (zone == 1) return 0;
        if (zone == 2) return 3;
        if (zone == 3) return 5;
        if (zone == 4) return 7;
        if (zone == 5) return 10;
        if (zone == 6) return 12;
        if (zone == 7) return 15;
        if (zone == 8) return 17;
        if (zone == 9) return 19;
    }

    fun int minorMapping(float pos) {
        (pos / 10) $ int => int zone;
        if (zone == 0) return -5;
        if (zone == 1) return 0;
        if (zone == 2) return 2;
        if (zone == 3) return 3;
        if (zone == 4) return 5;
        if (zone == 5) return 7;
        if (zone == 6) return 8;
        if (zone == 7) return 10;
        if (zone == 8) return 11;
        if (zone == 9) return 12;
    }

    fun int isNeighbor(float pos, float note) {
        map(pos - 20) => int lowerLimit;
        map(pos + 20) => int higherLimit;
        <<< lowerLimit, note, higherLimit >>>;
        if ((note >= lowerLimit) && (note <= higherLimit)) {
            return 1;
        }
        return 0;
    }
}
