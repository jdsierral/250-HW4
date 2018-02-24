# 250-HW4

THis is the 4th homework for 250. The idea was to create an instrument by designing it from scratch using digital design techniques. The enclosure was laser cutted in acrylic and designed in inkScape.

My proposal was to use softpots to track the frequencies as seems natural in most string instruments; however, in this case the envelope of the instrument is calculated from the velocity of the movement over a third softpot. This is particularly interesting as it allows a huge dynamic range even from a small 5cm softpot.



# Video Example:

The following video is an example of the possibilities of this instrument
https://www.youtube.com/watch?v=RREjYEOBxy0&feature=youtu.be


# Chuck Side
In Chuck, Im using multple oscillators with slight detunnuning between them to fatten the sound. Also A very neat class is used to map the sliders to certain scales (different types of scales are already hardcoded). Additionally, a low pass resonant filter is controlled by one of the joysticks and the vibrato level is controlled by the other.

# The Controller
The controller was built from scratch and assembled in a very nice transparent acrylic box which allows to dig into the details of the construction. Maybe I could add some encoders to the side as chaning parameters could be really helpful instead of goint through the code to do it!
