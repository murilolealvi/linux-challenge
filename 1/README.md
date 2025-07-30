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

The disk space usage is acomplish with ```df``` and to get the size of a file use ```du```: 

![df](/day1/images/df.png)

The most curious processs to me was ```iftop```, which is capable to capture real time traffic on an interface:

![iftop](/day1/images/iftop.png)

Similar tool is ```iperf```.

## Extension

After the above study, some questions were left for curiosity.

### What is swap and swap space?
We firstly describe the process of **swapping**. It actively copies a page (chunk) of memory to a preconfigured/partitioned space on the hard disk. This special place is called **swap space**.
It aims to free the page copied from the memory and, then, extend the virtual memory beyond the physical RAM.
Volatile memory performs better than the swap space. For particular applications, it is better to kill it instead to allocate on swap space.

To check:
```bash
$ swapon --show
NAME           TYPE      SIZE USED PRIO
/dev/zram0     partition   8G   0B  100
/swap/swapfile file      512M   0B   -2
```

The command ```free``` can show it as well.
To set up a partition and enable it for paging:
```bash
mkswap /dev/blk
swapon /dev/blk
```

To disable:
```
swapoff /dev/blk
```

OBS: blk can be a SSD, HDD or a NVME disk.

All the discussion is for a preallocated space. A option is a **swap file**. It varies accordingly to usage:
![swapfile](/day1/images/swapfile.png)

The creation is done:
```
mkswap -U clear --size 4G --file /swapfile
```

The ```-U clear``` option is used to create a swap space without UUID, so the ```fstab``` does not need to ensure its activation for every boot. It indicates a **disposable** file to the OS on its **size** (free allocation).

Then, we activate it:
```bash
swapon /swapfile
```

For this matter, we still need to indicate to ```fstab``` so the file can be generated:
```bash
nano /etc/fstab
/swapfile none swap defaults 0 0
```
Because it does not have a UUID, it must be specified by its location.
The deactivation follows the inverse path:
```
swapoff /swapfile
rm -f /swapfile
#remove entry from fstab
```

The kernel always tries to optimize the system on memory. It can take a unused temporary memory, unload it and reload it later. In other words, freeing up file pages.
On Linux, the parameter **swapiness** (0-200) indicates how much preference should the SO use for swap instead to free pages. The default is 60.

### How Linux deals with out-of-memory (OOM)?

The kernel normally over-commits memory for the applications for spike usages. When multiple applications are under this model, there is a process named **out-of-memory killer** or **OOM killer**.

We can monitor killed processes  via ```vmstat```, which has options for delay and count. An alternative one is ```sar``` with options **-r** for memory and **-S** for swap.

To get the most recent OOM process, we need to loop into log messages:
```bash
grep -i kill /var/log/messages*
grep -i kill /var/log/syslog*
journalctl -k #kernel messages
dmesg
```
The culprit for OOM is not only a faulty memory size, but how an application handles pages and lock it for usage (**mlock()**). For a distributed environment, one node can emit OOM while the others are up.
