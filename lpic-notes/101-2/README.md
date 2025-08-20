# Boot the system

From previous topic, we have already discussed about BIOS and UEFI functionality. Both are firmwares that handles device inspection and activation:
- POST to identify simple hardware failures
- activates basic components for the system
- load the bootloader (MBR in the first 440 bytes of the first device, or ESP partition defined in NVRAM)
- load kernel image into memory(```initramfs```) and starts it 
- kernel mounts the root filesystem
- initializes init process(system daemons and script initialization, normally ```system```) to start user space and its modules
- init sets the rest of the system

To read boot messages already in the system:
```bash
journalctl -b
dmesg #if the system is not systemd-based
```

OBS: ```dmesg``` consults the **kernel ring buffer** for the logs, which differs from a log file because it is stored in RAM and the messages overwrites as they are generated. That is why it can store syslog messages from its daemon

The most famous is GRUB(Grand Unified Bootloader) for Linux systems. A bunch of parameters is installed:
- ascpi
- init: system initiar (eg. /bin/bash)
- systemd.unit: target activation
- mem: available RAM
- quiet: hide boot messages
- vga: video mode
- root: root partiion
- rootflags: mount options
- ro: read-only permission
- rw: read and write permission

The configuration is handled on ```/etc/default/grub```. For kernel parameters we use the field ```GRUB_CMDLINE_LINUX``` and we can check it on ```/proc/cmdline```. To create a new configuration:
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

## Kernel initialization and Boot options

