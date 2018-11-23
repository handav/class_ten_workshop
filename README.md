# Workshop for Class 10

### Links and Resources:

1. All Magenta models: https://github.com/tensorflow/magenta/tree/master/magenta/models
2. Lakh Dataset: https://colinraffel.com/projects/lmd/
3. Colab FAQ: https://research.google.com/colaboratory/faq.html

#### Set up Magenta environment:

[https://github.com/tensorflow/magenta/blob/master/README.md](https://github.com/tensorflow/magenta/blob/master/README.md)

#### Generating from pre-trained model: MelodyRNN

###### What MelodyRNN is doing: generating monophonic melodies.

[https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn](https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn)

1. Download a .mag bundle file from the above link. We'll be using lookback_rnn.
2. Make an output folder if there is not one already. We'll be using ./generated/melody_rnn
3. Type this command into terminal: `melody_rnn_generate --config='lookback_rnn' --bundle_file=lookback_rnn.mag --output_dir=./generated/melody_rnn --num_outputs=10 --num_steps=128 --primer_melody="[60]"`

This will take less than a minute to generate 10 pieces.

#### Generating from pre-trained model: ImprovRNN

###### What ImprovRNN is doing: generating melodies that go over a certain chord progression.

#### Generating from pre-trained model: DrumsRNN

###### What DrumsRNN is doing: generating drum beats.

#### Training your own model: MelodyRNN
#### Using Paperspace or NYU's HPC
#### Generating from pre-trained model: MusicVAE (with Colab notebook)

###### What MusicVAE is doing: allows you to generate melodies by interpolating between two MIDIs.


## Assignment

Continue to explore these models (or a different one, if you're feeling ambitious). You can either generate something from a pre-trained model, train your own model and generate from it, or use Onsets and Frames to transcribe some pieces. You'll show these in class next week (quick 3-4 minutes each). 

## Additional Notes

* Don't be afraid to explore the other models we didn't get to in class! Working with them is very similar to what we did today, and each has its own walk-through: [https://github.com/tensorflow/magenta/tree/master/magenta/models](https://github.com/tensorflow/magenta/tree/master/magenta/models)

* Also, you can hook these models up to a MIDI interface! [https://github.com/tensorflow/magenta/tree/master/magenta/interfaces/midi](https://github.com/tensorflow/magenta/tree/master/magenta/interfaces/midi)

