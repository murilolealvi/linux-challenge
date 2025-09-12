# Modify process execution priorities
Priority under multitasking and multithreading system


## multitask

Processes operates into CPU core time slots. Each process is selected via *system calls* (OS process to CPU/kernel control) and the interval between the response from CPU is allocated for another program. 

To monitor the system calls made:
```bash
strace command
```

Previously, the learned that one process can start another with *fork()* syscall to spawn a copy and *exec()* to start a new program. The ```strace``` monitors after the *fork()* call:

![strace](../images/strace.png)

From the image, we see that it starts with *exec()* family syscall (*execve()*) and then memory initialization(*brk()*).

To only monitor library calls, we can use ```ltrace```. It does not track anything at kernel level.

However, programs that do not use system calls would use the CPU indefinitely. The workaround is **preemption**, which has a timer that calculates the CPU slice for the process to forcibly interrupt it and proceed with the queue.

The master for this management is the **scheduler**. It can be defined into policies and priorities:
* real-time policy: critial tasks with 0-99 priority number
* normal policy: system and user programs with 100-139 priority number which have same priority value and influenced by their "nice value" (-20 to +19) based on aggressive CPU utilization need.


To check priorities, we look into PRI field from ```ps -el```:

![ps-el](../images/ps-el.png)

For historical values, the ```ps``` uses -40 to 99 priority numbers. In other words, all the processes listed are under normal policy with 120 as its priority. The ```top``` command also has the same field (which also has a different priority number, it reduces by 100): 

![top](../images/top.png)

The field NI indicates the process niceness (if under normal policy). As we can see, some programs require an aggressive amount of CPU slice. We could start a process with this value modified:
```bash
nice -n 15 tar czf home.tar.gz /home
```

If already in activity, we can ```renice``` it:
```bash
renice -10 -p pid #reduces 10 from niceness
#we can specify a group(-g) or an user(-u)
```

## multithread

A thread is similar to a process with an identifier (thread ID or TID) and the kernel scheduler runs threads just like it. However, all threads inside a single process share their system resources and some memory.

The primary advantage is the intercommunication with their shared memory instead of network connection or pipe. To overcome multiple I/O resources, which usually *fork()* itself to handle a new input or output stream, the thread offer a similar mechanism without overhead to start a new process.






