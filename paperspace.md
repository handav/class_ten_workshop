### Using Paperspace or NYU's HPC

If you have a bigger dataset, or want to train models faster, you'll need a better computer with a GPU. You have access to NYU's High Powered Computing (HPC) -- we're not going to go over NYU's HPC in class, but Cris Valenzuela has an excellent tutorial at https://github.com/cvalenzuela/hpc.

Paperspace: https://www.paperspace.com/

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
7. Now, you need to get your code and files to the Paperspace machine. You do this with a protocol called SCP (Secure Copy Protocol). You can put all the resources you need in a folder (i.e. a folder called melody_rnn) and send that by typing: 

```
scp -r ./melody_rnn/ paperspace@[YourPublicIP]:./Desktop/
```

8. You'll also need to install Magenta on this machine. Because you have a GPU now, you'll need to install magenta-gpu:

```
pip install magenta-gpu
```