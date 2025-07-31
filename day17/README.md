# Build from the source


Our package managers get the files as binaries pre-compiled. Under the hood, the binaries are built, dependencies installed and finally package delivered.

We will compile and install ```nmap``` to evaluate how it is done.

## Getting the source

```bash
wget https://nmap.org/dist/nmap-7.97.tar.bz2
```

As we see, it is bzip2 compressed. We could issue ```bzip2 -cd file``` and then extract the tarball, or do it on demand:

```bash
tar -jxvf nmap-7.97.tar.bz2
```

OBS: The option ```-j``` stands for uncompress bzip2 file first

On [Nmap page](https://nmap.org/download) we get already a summary of the source compilation:

![page](images/page.png)

The steps follows:

* ./configure: check the system and adapts the package to it (x84, x64, ARM)
* make: compiles
* make install: installs the compiled files into the root directory, environment data and variable data


When compiling nmap, an error arise:

![dbus](images/dbus.png)

The solution was to pass manually ```dbus``` package:
```bash
make distclean
pkg-config --libs dbus-1 #get system package config
LIBS="-ldbus-1" ./configure
make
```

A second error appears:

![build](images/build.png)

We install build package:
```bash
apt install python3-build
```

And it works now.

## Makefile

In order to deepen or concepts around compiling, we will use the Makefile script to learn it more.
The construction is made by directives and rules, that sequentially perform commands:

```makefile
all:
    echo "Hello World"
```

We can execute it via ```make```:

![make](images/make.png)

To execute it in quiet mode, we add:
```makefile
all:
    @echo "Hello World"
```

To return the commands on Makefile script without executing it:
```bash
make -n
```

The structure follows:
#target #dependency
    #recipe (commands)

For example:

![message](images/message.png)

![dependency](images/dependency.png)



We can specify the target with parameters on make command:
```bash
make message
```


