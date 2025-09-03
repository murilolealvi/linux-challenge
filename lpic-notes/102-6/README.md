# Linux as a virtualization guest

The virtualization purpose is to create isolated environments to run multiple systems/processes. It is done on software and the management layer is upon the **hypervisor**, just how the operating system handles processes. They are classified:
- hypervisor type 2 (hosted): above an operating systems with its resources abstracted
- hypervisor type 1 (baremetal): directly on hardware

The memory, CPU and even I/O peripherals are built upon virtualization. To bypass the virtual hardware between host and guest is known as *paravirtualization*. 

Back in the time, virtual machines only could run in user-mode. It presented problems since the kernel needs to perform kernel-mode operations. For it, the hypervisor is aware of the restricted instructions and emulate it to the host machine (performance tradeoff is minimal). Technologies emerged in order to avoid this (Intel VT-x and AMD AMD-V):
- VT-x: create a new mode for the host and the guest to perform these operations
- AMD-V: uses CPU extensions to not rely on software

## containers

Beyond the server isolation, the modern applications need to have process isolation in order to keep services from interfering each other.

One method of service isolation (**chroot jail**) is through ```chroot()```, a system call to change the root directory so the program is unable to communicate with nothing outside it.

Other method is the resource limit(**rlimit**), which restricts how much CPU time a process can consume and its storage.

OBS: Containers reside on the same kernel, however can use different user-spaces environment. It manages **namespaces** to handle only a set of process IDs (start at PID 1) from itself and its children.

As previously noted, Docker uses **overlay** filesystem to manage the storage in layers (lower and upper):

![overlay](../images/overlay.png)

The Docker and host directories are merged into a single spot. In rootless mode(Podman based), the FUSE version is used (maintains the container in user-mode).

### implementation

Let's try to implement our own engine to run a container. It is just to illustrate these concepts and will have limitations.


First, we must have an overlay filesystem and would have the following hierarchy:
- lowerdir: read-only container base image
- upperdir: writeble changes on host
- workdir: internal directory for overlayfs
- merged: unified view as root filesystem to the container

For our "container image", we will use ```busybox```. It contains common Unix utilities on a single small executable. We install it:
```bash
apt install busybox
```

Once installed, we create our base filesystem that which will compose the lower layer directory for the overlayfs:
```bash
mkdir -p container/bin
```

And copy the ```busybox``` exectuable into that directory and create a symlink for two commands(```sh``` and ```ls``` in busybox): 
```bash
cp $(which busybox) ./container/bin
ln -s busybox ./container/bin/sh
ln -s busybox ./container/bin/ls
```

OBS1: The symlink is created to a relative path for busybox, so it searches on the same directory.
OBS2: The busybox feature is a multi-call binary, it cleverly decides which command to run by checking the name it was called with(```sh``` and ```ls``` in this case).

Afterwards, we can mount it as an overlayfs:
```bash
mkdir upper work merged
mount -t overlay overlay -o lowerdir=./container/,upperdir=./upper/,workdir=./work/ ./merged
```

We call options and initializes the directories as layers.

![merged](../images/merged.png)

Try to create a file inside it:

![upper](../images/upper.png)

The write was only at the upperdir(/upper) and the merged directory(/merged/). 

The script needs to automate this process inside the container image.