//
//  ComplexTracker.ck
//
//
//  Created by JuanS.


/* Mapping object to create diatonic scales!
Currently it only has a major, minor, pentantonic, but its possible to add more */


public class Mapping {
    0 => int chromatic;
    1 => int major;
    2 => int minor;
    3 => int majorPentatonic;
    4 => int minorPentatonic;
    5 => int minorHarmonic;
    6 => int minorMelodic;
    7 => int minorFullScale;
    8 => int dorian;
    9 => int frigian;
    10 => int lydian;
    11 => int mixolydian;
    12 => int locrian;

    [0,1,2,3,4,5,6,7,8,9,10,11,12] @=> int chromaticMap[];
    [0,2,4,5,7,9,11,12] @=> int majorMap[];
    [0,2,3,5,7,8,10,12] @=> int minorMap[];
    [0,3,5,6,7,10,12] @=> int minorPentatonicMap[];
    [0,2,3,4,7,9,12] @=> int majorPentatonicMap[];
    [0,2,3,5,7,8,11,12] @=> int minorHarmonicMap[];
    [0,2,3,5,7,9,11,12] @=> int minorMelodicMap[];
    [0,2,3,5,7,8,10,11,12] @=> int minorFullScaleMap[];

    1 => int numNotes;
    0 => int base;
    0 => int mapping;
    0 => int transpose;
    4 => int octave;
    0 => float cents;

    fun float map(float pos) {
        if (mapping == 0) {
            return chromaticMapping(pos);
        } else if (mapping == 1) {
            return majorMapping(pos);
        } else if (mapping == 2) {
            return minorMapping(pos);
        } else if (mapping == 3) {
            return majorPentatonicMapping(pos);
        } else if (mapping == 4) {
            return minorPentatonicMapping(pos);
        }
    }

    fun float chromaticMapping(float pos) {
        chromaticMap.size() => int maxIndx;
        pos $ int => int alignment;
        (pos * numNotes) $ int => int note;
        return chromaticMap[note % maxIndx] + alignment * numNotes + base + cents/100.0;
    }

    fun float majorMapping(float pos) {
        majorMap.size() => int maxIndx;
        pos * numNotes / (maxIndx $ float) => float posMod;
        (pos * numNotes + base) $ int => int note;
        note / maxIndx $ int => int alignment;
        majorMap[note % maxIndx] + alignment * 12 + base => int final;
        return final + transpose + octave * 12 + cents/100.0;
    }

    fun float minorMapping(float pos) {
        minorMap.size() => int maxIndx;
        pos * numNotes / (maxIndx $ float) => float posMod;
        (pos * numNotes + base) $ int => int note;
        note / maxIndx $ int => int alignment;
        minorMap[note % maxIndx] + alignment * 12 + base => int final;
        return final + transpose + octave * 12 + cents/100.0;
    }

    fun float majorPentatonicMapping(float pos) {
        majorPentatonicMap.size() => int maxIndx;
        pos * numNotes / (maxIndx $ float) => float posMod;
        (pos * numNotes + base) $ int => int note;
        note / maxIndx $ int => int alignment;
        majorPentatonicMap[note % maxIndx] + alignment * 12 + base => int final;
        return final + transpose + octave * 12 + cents/100.0;
    }

    fun float minorPentatonicMapping(float pos) {
        minorPentatonicMap.size() => int maxIndx;
        pos * numNotes / (maxIndx $ float) => float posMod;
        (pos * numNotes + base) $ int => int note;
        note / maxIndx $ int => int alignment;
        minorPentatonicMap[note % maxIndx] + alignment * 12 + base => int final;
        return final + transpose + octave * 12 + cents/100.0;
    }

    fun float minorMapping(float pos) {
        minorHarmonicMap.size() => int maxIndx;
        pos * numNotes / (maxIndx $ float) => float posMod;
        (pos * numNotes + base) $ int => int note;
        note / maxIndx $ int => int alignment;
        minorHarmonicMap[note % maxIndx] + alignment * 12 + base => int final;
        return final + transpose + octave * 12 + cents/100.0;
    }

    fun float minorMapping(float pos) {
        minorMelodicMap.size() => int maxIndx;
        pos * numNotes / (maxIndx $ float) => float posMod;
        (pos * numNotes + base) $ int => int note;
        note / maxIndx $ int => int alignment;
        minorMelodicMap[note % maxIndx] + alignment * 12 + base => int final;
        return final + transpose + octave * 12 + cents/100.0;
    }

    fun float minorMapping(float pos) {
        minorFullScaleMap.size() => int maxIndx;
        pos * numNotes / (maxIndx $ float) => float posMod;
        (pos * numNotes + base) $ int => int note;
        note / maxIndx $ int => int alignment;
        minorFullScaleMap[note % maxIndx] + alignment * 12 + base => int final;
        return final + transpose + octave * 12 + cents/100.0;
    }
}
