# Change runlevels/boot targets and shutdown or reboot system

With kernel in hands, how does the user space handles the system?
It follows an order:
- init process
- low-level services (udevd and syslogd)
- network
- other services (cron)
- GUIs


Let`s discuss step by step.

## init

As a process as any other program, it is located in ```/sbin```. From Linux history, it had a bunch of init candidates:

### SysVinit

Created by Red Hat, this service manager operates in states (called **runlevels**):
- runlevel 0: shutdown
- runlevel 1: single user mode, without network and non-essential capabilities
- runlevel 2,3 or 4: multi user mode, can login by console or network
- runlevel 5: multi user mode, plus GUI
- runlevel 6: restart

It is choosen by a kernel parameter or in ```/etc/inittab``` file, each runlevel has a script associated with it.
