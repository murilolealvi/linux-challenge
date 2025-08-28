# Design hard disk layout

In this lesson we will dive deep into disks and filesystems.

## partition

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

## filesystem

What the user interactes to is the filesystem. It is a form of database, structured to transform simple block device into a hierarchy of files and subdirectories.

To be used, it needs to be mounted. In other words, attach the filesystem to a specific point in system's directory tree (mount point). For example, new users are mounted under ```/home``` directory.

OBS: Mount point must exist before the filesystem to be mounted

Back in the day, filesystems were implemented in the kernel. However, a [new protocol](https://9fans.github.io/plan9port/man/man9/intro.html) manages the File System in User Space(FUSE).

**Quick look**: how user-space and kernel communicates with FUSE
- application tries to access a file under a standard syscall (```open()``` or ```read()```)
- kernel (virtual filesystem or LFS) receives it and check the mount point as FUSE and passes it to the kernel module
- now in user-space, the driver process acts as a 9P client to translate into the protocol (```Twalk``` to navigate into the directory tree, ```Topen``` to open the file and ```Tread``` to read)
- it is sent over the network or a local socket to the 9P server
- the server responds(```Rread``` to get file's data) and send it back to the FUSE driver
- it passes to the kernel module and it extracts to the application


Types:

- ext4 (simplicity and maturity): successor of ext2 after cache was added to ext3 to enhance data integrity and hasten booting (speed up startup process), it supportts larger files and greater number of subdictories.
- btrfs (snapshots and data correction): instead of overwriting data in place, it writes a modified copy to a new location (copy-on-write), it has built-in support for snapshots, subvolumes, RAID and uses checksums for data and metadata correlation for correction
- fat (microsoft): vfat (up to 4GB) or exfat (4GB and up) partitions by default used solely for windows (that now supports ntfs)
- xfs (performance with large files and dynamic allocation): the filesystem capable to handle the largest files (up to 8 exbibytes!), it is optimized for large sequential I/O operations (streaming, large databases...) and allocate dynamically space and inodes
- zfs (data integrity and own RAID implementation): it has a primary focus on preventing data corruption with 256-bit checksum and copy-on-write nature


To create a filesystem in a disk:

```bash
mkfs -t/--type ext4 /dev/sda
#or
mkfs.ext4 /dev/sda
```

It determines the number of blocks a reasonable defaults.
To mount it, we must provide:
* filesystem device
* filesystem type
* mount point

Manually:
```bash
mount -t/--type ext4 /dev/sda mountpoint
```


Normally the type is automatically detected, so no need to provide it. To unmount(detach):
```bash
umount mountpoint
```

The options could be general or filesystems-specifid:
* -r: read-only mode
* -n: do not update system runtime mount database(```/etc/mtab```)
* -o: specify long options, like ro,uid,noexec,remount, etc...

As we know, a disk is managed by its UUID (```udev``` and ```devtmpfs```) and represented to it via symlinks. When it is mounted, it does no different: it creates a UUID and initialize the filesystem data structure. To get all UUIDs per disk (can be called serial numbers):
```bash
blkid
```

![blkid](../images/blkid.png)

It is visible a VFAT and EXT4 partitions. We could mount based upon the UUID:
```bash
mount UUID=2025-07-02-20-57-26-00 /home/extra
```

### /etc/fstab











