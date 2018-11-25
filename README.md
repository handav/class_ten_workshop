# Workshop for Class 10

### Links and Resources:

1. All Magenta models: https://github.com/tensorflow/magenta/tree/master/magenta/models
2. Lakh Dataset: https://colinraffel.com/projects/lmd/
3. Colab FAQ: https://research.google.com/colaboratory/faq.html

### Set up Magenta environment:

[https://github.com/tensorflow/magenta/blob/master/README.md](https://github.com/tensorflow/magenta/blob/master/README.md)

### Generating from pre-trained model: MelodyRNN
##### What MelodyRNN is doing: generating monophonic melodies.

[https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn](https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn)

1. Download a .mag bundle file from the above link. We'll be using lookback_rnn. A .mag file is a format that bundles the model checkpoint, metagraph, and some model metadata into one file.
2. Make an output folder if there is not one already. We'll be using ./generated/melody_rnn
3. Type this command into terminal: `melody_rnn_generate --config='lookback_rnn' --bundle_file=lookback_rnn.mag --output_dir=./generated/melody_rnn --num_outputs=10 --num_steps=128 --primer_melody="[60]"`

This will take less than a minute to generate 10 pieces.

### Generating from pre-trained model: ImprovRNN
##### What ImprovRNN is doing: generating melodies that go over a certain chord progression.

### Generating from pre-trained model: DrumsRNN
##### What DrumsRNN is doing: generating drum beats.

### Training your own model: MelodyRNN

[https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn](https://github.com/tensorflow/magenta/tree/master/magenta/models/melody_rnn)

1. Convert MIDI files into NoteSequences. NoteSequences are protocol buffers, or a way to serialize data. Serializing data helps store and work with large data structures/files more efficiently.

[https://github.com/tensorflow/magenta/blob/master/magenta/scripts/README.md](https://github.com/tensorflow/magenta/blob/master/magenta/scripts/README.md)

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
--output_dir=/tmp/melody_rnn/sequence_examples \
--eval_ratio=0.10
```

3. Train the model

```
melody_rnn_train \
--config=lookback_rnn \
--run_dir=/tmp/melody_rnn/logdir/run1 \
--sequence_example_file=/tmp/melody_rnn/sequence_examples/training_melodies.tfrecord \
--hparams="batch_size=64,rnn_layer_sizes=[64,64]" \
--num_training_steps=20000
```

You can keep your eye on the Loss, which you want to decrease. You can think of Perplexity as how "surprised" the model is by the test data -- you also want this number to decrease over time.


### Using Paperspace or NYU's HPC

* NYU High Powered Computing (HPC): We're not going to go over NYU's HPC in class, but Cris Valenzuela has an excellent tutorial at https://github.com/cvalenzuela/hpc.

* Paperspace: https://www.paperspace.com/

1. Create an account


### (Maybe: Onsets and Frames)

### Generating from pre-trained model: MusicVAE (with Colab notebook)
##### What MusicVAE is doing: allows you to generate melodies by interpolating between two MIDIs.


## Assignment

Continue to explore these models (or a different one, if you're feeling ambitious). You can either generate something from a pre-trained model, train your own model and generate from it, or use Onsets and Frames to transcribe some pieces. You'll show these in class next week (quick 3-4 minutes each). 

## Additional Notes

* Don't be afraid to explore the other models we didn't get to in class! Working with them is very similar to what we did today, and each has its own walk-through: [https://github.com/tensorflow/magenta/tree/master/magenta/models](https://github.com/tensorflow/magenta/tree/master/magenta/models)

* For advanced exploration, you can try changing the hyperparameters (the --hparams argument): try changing the batch size and rnn layer sizes and see what happens! (Remember to use the same values when generating from the model).

* Also, you can hook these models up to a MIDI interface! [https://github.com/tensorflow/magenta/tree/master/magenta/interfaces/midi](https://github.com/tensorflow/magenta/tree/master/magenta/interfaces/midi)

