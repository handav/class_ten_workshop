#!/bin/bash

SOUNDFONT=./GeneralUserGS.sf2

# converts midi to .raw format with fluidsynth
fluidsynth -lr 44100 -g 2 -R 0 -F /tmp/midi_temp.raw $SOUNDFONT $1
# converts .raw to mp3 with lame
lame --preset standard /tmp/midi_temp.raw ${1/.mid/.mp3}