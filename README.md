# Docker image is designed to be used for remote pairing.

To build the image:
```
make build
```

To run the container:
```
buddy=someuser workdir=~/work make run
```

In the above example, someuser is the person I'm pairing with, so we assign that to $buddy.

Additionally, we want to specify our repository path to be mounted into the container at runtime, this is stored in the workdir variable.

This command will output a ssh command you can paste into your terminal.

The container will fetch our ssh pubkeys from Github and add them along with tmux session params to the pair users's authorized_keys file.  When you connect to the container, you are automatically dropped into a shared tmux session as the 'pair' user, with the code directory mountd in.

And that's it, you'll want to run your git operations outside of the container when you're done for the day. Also make sure to clean up afteryourself when you're done with your work:

```
make clean
```
