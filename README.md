# Workshop for Class 10

### Links and Resources:

1. All Magenta models: https://github.com/tensorflow/magenta/tree/master/magenta/models
2. Lakh Dataset: https://colinraffel.com/projects/lmd/
3. Colab FAQ: https://research.google.com/colaboratory/faq.html

### Set up Magenta environment:

[https://github.com/tensorflow/magenta/blob/master/README.md](https://github.com/tensorflow/magenta/blob/master/README.md)

## Generating from pre-trained model: MelodyRNN
#### What MelodyRNN is doing: generating monophonic melodies.

[https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn](https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn)

1. Download a .mag bundle file from the above link. We'll be using lookback_rnn. A .mag file is a format that bundles the model checkpoint, metagraph, and some model metadata into one file.
2. Make an output folder if there is not one already. We'll be using ./generated/melody_rnn
3. Type this command into terminal: 

```
melody_rnn_generate --config='lookback_rnn' --bundle_file=lookback_rnn.mag --output_dir=./generated/melody_rnn --num_outputs=10 --num_steps=128 --primer_melody="[60]"
```

This will take less than a minute to generate 10 pieces.

## Generating from pre-trained model: ImprovRNN
#### What ImprovRNN is doing: generating melodies that go over a certain chord progression.

1. Download the chord_pitches_improv bundle file (.mag file) from [https://github.com/tensorflow/magenta/tree/master/magenta/models/improv_rnn](https://github.com/tensorflow/magenta/tree/master/magenta/models/improv_rnn).

2. In terminal, type:

```
improv_rnn_generate \
--config='chord_pitches_improv' \
--bundle_file=chord_pitches_improv.mag \
--output_dir=./generated/improv_rnn \
--num_outputs=10 \
--primer_melody="[60]" \
--backing_chords="C G Am F C G Am F" \
--render_chords
```

*Note*: the '\' character is to format the command so the parameters are each on their own line. You can also type the command in all at once without those characters, like we did to generate from MelodyRNN. 

The primer melody argument will give a starting note or melody to the model. The backing chords are the chords you want the model to generate a melody for. You can change these two parameters to get interesting melodies.

Let's try priming it with Twinkle Twinkle Little Star over the chords from 'I will Surivive':

```
improv_rnn_generate \
--config='chord_pitches_improv' \
--bundle_file=chord_pitches_improv.mag \
--output_dir=./generated/improv_rnn \
--num_outputs=10 \
--primer_melody="[60, -2, 60, -2, 67, -2, 67, -2]" \
--backing_chords="Am Dm G C F Bdim E E" \
--render_chords
```

From the documentation:

"This will generate a melody starting with a middle C over the chord progression C G Am F, where each chord lasts one bar and the progression is repeated twice. If you'd like, you can supply a longer priming melody using a string representation of a Python list. The values in the list should be ints that follow the melodies_lib.Melody format (-2 = no event, -1 = note-off event, values 0 through 127 = note-on event for that MIDI pitch). For example --primer_melody="[60, -2, 60, -2, 67, -2, 67, -2]" would prime the model with the first four notes of Twinkle Twinkle Little Star. Instead of using --primer_melody, we can use --primer_midi to prime our model with a melody stored in a MIDI file. For example, --primer_midi=<absolute path to magenta/models/melody_rnn/primer.mid> will prime the model with the melody in that MIDI file.

You can modify the backing chords as you like; Magenta understands most basic chord types e.g. "A13", "Cdim", "F#m7b5". The --steps_per_chord option can be used to control the chord duration."


## Generating from pre-trained model: DrumsRNN
#### What DrumsRNN is doing: generating drum beats.



## Training your own model: MelodyRNN

[https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn](https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn)

1. Convert MIDI files into NoteSequences. NoteSequences are protocol buffers, or a way to serialize data. Serializing data helps store and work with large data structures/files more efficiently.

To convert your MIDI files, type this command into terminal (change your input directory as needed):

```
convert_dir_to_note_sequences \
  --input_dir=clean_midi/Nirvana \
  --output_file=notesequences.tfrecord \
  --recursive
```

where input_dir is the directory of your MIDI files (it can have child folders) and output_file is the name of your notesequences file, in .tfrecord format. TFRecord file formats are a Tensorflow-specific file format, allowing you to store data efficiently.

This command will take a long time (>1 hour) on the entire Clean Midi Lakh dataset (--input_dir=clean_midi). You can also input one musician folder (--input_dir=clean_midi/Nirvana). This will take about 1 minute on a folder with about 150 MIDI files. If you have your own dataset, your input_dir will be the name of the folder containing your data.

*NOTE*: corrupt or poorly formatted MIDI files will be skipped at this stage.

2. Convert NoteSequences to SequenceExamples. Each SequenceExample is a Tensorflow-specific format which contains a sequence of inputs and a sequence of labels, and is representing a melody. The following command extracts melodies from the NoteSequences and saves them in SequenceExample format. We'll be using lookback_rnn as our config.

```
melody_rnn_create_dataset \
--config='lookback_rnn' \
--input=notesequences.tfrecord \
--output_dir=./sequence_examples \
--eval_ratio=0.10
```

3. Train the model

```
melody_rnn_train \
--config=lookback_rnn \
--run_dir=/tmp/melody_rnn/logdir/run1 \
--sequence_example_file=./sequence_examples/training_melodies.tfrecord \
--hparams="batch_size=64,rnn_layer_sizes=[64,64]" \
--num_training_steps=20000
```

You can keep your eye on the Loss, which you want to decrease. You can think of Perplexity as how "surprised" the model is by the test data -- you also want this number to decrease over time.

This will probably take about 5-6 hours on your local computer (using 20000 steps, for a small <150 MIDI file dataset). On the Nirvana folder I ended up with a loss of 0.187004.

Checkpoints are saved (default directory is /tmp/melody_rnn/logdir/run1/train/).

4. Generate from the model

This is very similar to generating from the MelodyRNN model earlier, except instead of a .mag file that includes a model checkpoint, we're using our model's checkpoint instead. We can see that the checkpoints are in the run_dir folder by typing in terminal:

```
open /tmp/melody_rnn/logdir/run1
```

To generate several pieces from our model, type:

```
melody_rnn_generate \
--config=lookback_rnn \
--run_dir=/tmp/melody_rnn/logdir/run1 \
--output_dir=./generated/melody_rnn/Nirvana/ \
--num_outputs=10 \
--num_steps=128 \
--hparams="batch_size=64,rnn_layer_sizes=[64,64]" \
--primer_melody="[60]"
```

You can change the primer_melody argument to get different results based on that melody as input. From the documentation:

"We can use --primer_melody to specify a priming melody using a string representation of a Python list. The values in the list should be ints that follow the melodies_lib.Melody format (-2 = no event, -1 = note-off event, values 0 through 127 = note-on event for that MIDI pitch). For example --primer_melody="[60, -2, 60, -2, 67, -2, 67, -2]" would prime the model with the first four notes of Twinkle Twinkle Little Star. Instead of using --primer_melody, we can use --primer_midi to prime our model with a melody stored in a MIDI file. For example, --primer_midi=<absolute path to magenta/models/shared/primer.mid> will prime the model with the melody in that MIDI file. If neither --primer_melody nor --primer_midi are specified, a random note from the model's note range will be chosen as the first note, then the remaining notes will be generated by the model. In the example below we prime the melody with --primer_melody="[60]", a single note-on event for the note C4."

## Colab Notebooks

Make sure you are using the GPU (go to Edit -> Notebook Settings to change this). For the record, Colab has limits on both GPU time and storage, so they are better for quick interaction than long-term training (at the moment).

First, let's check out the basic Colab intro: [https://colab.research.google.com/notebooks/welcome.ipynb](https://colab.research.google.com/notebooks/welcome.ipynb)

## Generating from pre-trained model: MusicVAE (with Colab notebook)
##### What MusicVAE is doing: allows you to generate melodies by interpolating between two MIDIs.

Copy the [MusicVAE Colab notebook](https://colab.research.google.com/notebooks/magenta/music_vae/music_vae.ipynb) to your drive with the 'Copy to Drive' button.


## Assignment

Continue to explore these models (or a different one, if you're feeling ambitious). You can either generate something from a pre-trained model, train your own model and generate from it, or use Onsets and Frames to transcribe some pieces. You'll show these in class next week (quick 3-4 minutes each). 

## Additional Notes and Things to Do

* Don't be afraid to explore the other models we didn't get to in class! Working with them is very similar to what we did today, and each has its own walk-through: [https://github.com/tensorflow/magenta/tree/master/magenta/models](https://github.com/tensorflow/magenta/tree/master/magenta/models)

* You can look at the PolyphonyRNN model, which is very similar to MelodyRNN, but it generates polyphonic music (meaning it generates more than one note at a time).

* For advanced exploration in training the MelodyRNN model, you can try changing the hyperparameters (the --hparams argument): try changing the batch size and rnn layer sizes and see what happens! (Remember to use the same values when generating from the model).

* Also, you can hook these models up to a MIDI interface! [https://github.com/tensorflow/magenta/tree/master/magenta/interfaces/midi](https://github.com/tensorflow/magenta/tree/master/magenta/interfaces/midi)

* Try using the Onsets and Frames (piano transcription model) in Colab here: [https://colab.research.google.com/notebooks/magenta/onsets_frames_transcription/onsets_frames_transcription.ipynb](https://colab.research.google.com/notebooks/magenta/onsets_frames_transcription/onsets_frames_transcription.ipynb) 

* There are other Colab notebooks you can explore in the Seedbank:
[https://research.google.com/seedbank/](https://research.google.com/seedbank/). Note: we'll be checking out NSynth next week.

