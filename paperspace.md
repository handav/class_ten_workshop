# Using Paperspace or NYU's HPC

If you have a bigger dataset, or want to train models faster, you'll need a better computer with a GPU. You have access to NYU's High Powered Computing (HPC) -- we're not going to go over NYU's HPC in class, but Cris Valenzuela has an excellent tutorial at https://github.com/cvalenzuela/hpc.

Paperspace: https://www.paperspace.com/

## Setup

1. Create an account
2. Put in a credit/debit card
3. Choose a machine:
    * East Coast NY2
    * Linux Templates
    * Ubuntu 16.04
    * GPU+  $0.51/hr
    * Scroll to bottom and click 'Create your Paperspace'
4. Click on machine and wait for it to say 'Ready' in blue
5. Check your email for the password to your new machine (from Paperspace)
6. Click the 'Assign a public IP' button (this costs $3/month)
7. Your password for your Paperspace machine will be emailed to you by Paperspace.
8. You'll also need to install Magenta on this machine. First, you'll need to install Conda. Get the installer script:

```
wget https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh
```

Then install it:

```
bash Miniconda2-latest-Linux-x86_64.sh
```

Press enter and type 'yes' when prompted to accept the agreement.

Type this command to make sure those changes are seen by the current terminal window:

```
source ~/.bashrc
```

Make a new Conda environment ('magenta' here is the name of the conda environment):

```
conda create -n magenta python=2.7 jupyter
```

Activate that Conda environment:

```
source activate magenta
```

Finally, install the magenta package. Because you have a GPU now, you'll need to install magenta-gpu:

```
pip install magenta-gpu
```

You may also need to run these three commands if you run into errors:

```
sudo apt-get update
```

and

```
sudo apt-get install gcc
```

and

```
sudo apt-get install build-essential libasound2-dev libjack-dev
```

Finally, make a directory for your project:

```
mkdir train_melodyrnn
``` 

## Transferring your local files, re-downloading .mag file

9. Now, you need to get your code and files to the Paperspace machine.

To train the MelodyRNN, you'll need:
    * your SequenceExamples (sequence_examples folder)
    * the lookback_rnn.mag file (which you can download directly by typing ```wget http://download.magenta.tensorflow.org/models/lookback_rnn.mag```).

You can send files and folders to your Paperspace machine with a protocol called SCP (Secure Copy Protocol). You can send a folder (for example, your sequence_examples folder) by typing: 

```
scp -r ./sequence_examples/ paperspace@[YourPublicIP]:./Desktop/train_melodyrnn/
```

This sends the 'sequence_examples' folder to the paperspace machine's Desktop.


## Training a model

10. From there, the training command is the same as before:

```
melody_rnn_train \
--config=lookback_rnn \
--run_dir=/tmp/melody_rnn/logdir/run1 \
--sequence_example_file=./sequence_examples/training_melodies.tfrecord \
--hparams="batch_size=64,rnn_layer_sizes=[64,64]" \
--num_training_steps=20000
```

If you get an error along the lines of 'ImportError: libcublas.so.9.0', follow the commands in the 'Add NVIDIA package repository' and 'Install CUDA and tools' sections in the 'Install Cuda with apt' section here: https://www.tensorflow.org/install/gpu#install_cuda_with_apt

Where this took about 5.5-6 hours on your local machines, this will take about 3.5 hours on this machine with a GPU. Also, you can leave this running and come back to it later.

