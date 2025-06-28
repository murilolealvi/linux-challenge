# Get to know your server


## First steps
For this lab, I created a droplet in DigitalOcean in order to simulate a production environment:

![digitalocean](/day1/images/digitalocean.png)

I shared my public SSH key and logged on it via terminal. The exchange between the keys is done as below (IP address as an example):
```bash
ssh -i ~/.ssh/id root@1.1.1.1
```


The first task was to get some info about the server.
The ```lsb_release``` command display distribution info:

![lsb_release](/day1/images/lsb_release.png)

As we can see, an Ubuntu distro on the latest version. Other command share kernel specifics:

![uname](/day1/images/uname.png)

Now we have the kernel version, the timezone and the architecture running. From user space:

![whoami](/day1/images/whoami.png)


## Hardware information

As a beginner on Linux, we know that ```ls``` command is used to search on files in directories. However, it shows a way to **list** a bunch of other information. For example, with ```lshw``` (from ls+hardware) we can see a summary of network, disks, usbs and hardware information. Since the output is big, I have avoid to print it.
However, we can select the ones that we want. With ```lscpu``` we have CPU architecture:

![lscpu](/day1/images/lscpu.png)

Or with ```lsblk``` we have block devices information (disks):

![lsblk](/day1/images/lsblk.png)

On the same manner, PCI devices with ```lspci```:

![lspci](/day1/images/lspci.png)

On the memory realm, we have the well known ```free``` to check the amount of memory used by the system. Don't forget the -h to see it on megabytes!

![free](/day1/images/free.png)

The ```vmstat``` command can show the virtual memory details.

The disk space is acomplish

