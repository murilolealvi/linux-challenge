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
