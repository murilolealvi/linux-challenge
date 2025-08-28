# Design hard disk layout

In this lesson we will dive deep into disks and filesystems.
As we know, the kernel makes possible to access an entire disk and one of its partition at the same time. This process would look:

![partition](../images/partition.png)

The user uses the filesystem, a structured storage that we are used to, for disk access. Moreover, it uses SCSI as we previously learned to control in hardware layer.

To produce partitions, the common tools are ```parted``` for CLI, ```gparted``` for GUI and ```fdisk```. Both support mBR and GPT partition tables.

To check the actual partition applied:

```bash
parted -l
```

![parted](../images/parted.png)

It is under GPT partition table as a virtual block disk. The ```parted``` command has a tricky size calculation, since it is approximated in a way it finds easiest to read. On other hand, ```fdisk -l``` shows it exactly:
![fdisk](../images/fdisk.png)


It is based in 512-byte sectors, and it even shows the disk identifier.
OBS:
-  ```fdisk``` modifications are notified as system calls to the kernel
-  ```parted``` signals kernel when individual partitions are altered
- we can check modifications with kernel events via ```udevadm monitor --kernel```
- to force a partition table change like ```fdisk``` system call: ```blockdev -rereadpt /dev/sd_```
  

**Exercise:** We will manage a USB drive to perform modifications with ```fdisk```

First, we access the disk:
```bash
fdisk /dev/sda
```

It enters on interactive mode, some commands are shown with help utility:

![fdisk-help](../images/fdisk-help.png)

To print the partition table:

![partition-table](../images/partition-table.png)

OBS: Any modification can be recover with **q**(quit without saving)

To wipe out the partition and create a 200MB one (MBR-style partition table):

![fdisk-delete](../images/fdisk-delete.png)

To write a 200MB first sector:

![fdisk-write](../images/fdisk-write.png)






