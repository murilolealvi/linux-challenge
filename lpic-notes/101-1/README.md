# Determine and Configure Hardware

## Device files intro

For an user with experience, it is a common sense that the startup for a compute follows the BIOS, bootloader and then the OS.

The BIOS stands for the motherboard firmware, and it is there where **device activation** is done. The old BIOS needed and MBR (Master Boot Record) at the first sector of the first partition. Nowadays, the UEFI needs an EFI System Partition (ESP) and uses FAT anywhere on the partition, with each bootloader registered. A curiosity:
* BIOS firmware is in 16-bit Assembly lang
* UEFI firmware is in 64-bit C lang

The **device inspection** is performed after boot inside the operating system.

The hardware is handled by multiple interfaces, one of them is the Peripheral Component Interconnect (PCI), now called PCI Express (PCIe).
Back on time, we had PATA (Parallel ATA) which carries data from the drive and the mobo at the same time. However, in a much slower speed than SATA (Serial ATA), that now carries the data with bits sequentially.

On Linux, we can list all of these components:
```bash
lspci #list PCI devices
lsusb #list USB devices
```

To get deeper info on a specific device, we must get his unique address (the first column):
![pci-address](../images/pci-address.png)

And then:
```bash
lspci -s address -v
```

![lspci](../images/lspci.png)

It shows the kernel driver in use for this device as well. In this case, ```virtio-pci```.
For ```lsusb```, we can do the same using the product ID from the vendor:
```bash
lspusb -d id -v
```

![lsusb](../images/lsusb.png)

All above list devices that not certainly are operational. The kernel stores a bunch of modules/drivers that are loaded on demand. The ```kmod``` package provides tools to handle these, to list it all the active/loaded ones use ```lsmod```:

![lsmod](../images/lsmod.png)

The *Used By* column shows the dependencies, in other words, the modules which are dependent with. The ```modprobe``` command can load/unload a specific module. 

To load:
```bash
modprobe module
```
And to unload:
```bash
modprobe -r module
```

The ```modinfo``` can show more about the module:
![modinfo](../images/modinfo.png)


Through ```/etc/modprobe.d/*.conf``` we can blacklist a module to be loaded, or be preferred.







## 

