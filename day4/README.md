# Installing software, exploring the file structure

We will grasp how to manage the package installer, for now the **apt**.

We can search a package with:
```bash
apt search "package"
```

And we can install it:
```bash
apt install mc
```

## Creating our own package manager

I will leverage this topic to learn how to create a package manager with [Slackjeff](https://slackjeff.com.br/) course! 

At the beginning, all packages installed should be compilled and its files distributed on */sbin* and other directories. To remove or update it, the user should keep track for all the files generated and exlude these one by one. The hardcore would create a script to automatically perform this all.

At this age that the **package manager** was created, in 90s era.
We can classify it in low level and high level.

### Simulation

To proceed with atomic install, we need to do a **fakeroot** of the package. As an example, we will compile *nano* and proceed to create a package:

![nano](images/nano.png)

We can extract it via ```tar```:

```bash
tar xvf nano-8.5.tar.xz
```

Upon compilation, we can modify parameters so it is not dispose on root directories:

![configure](images/configure.png)

For testing purpose, we only add ```prefix==/usr/``` in order to create a directory above the binaries and share environment. Finally, a make install on the destination directory so it can be ***fakerooted***:
```bash
make .
make install DESTDIR=/tmp/nano-test/
```

We are able to execute it as the system would do:

![tmp](images/tmp.png)

We create a tarball from the ```/usr/```folder:

```bash
tar cvf nano-8.5.newpkg .
```

In the end, the package manager would extract that tarball and point it to the respective directories, as following:
```bash
tar xvf nano-8.5.newpkg -C /
```

It will work just as it is ```nano```:

![nano-test](images/nano-test.png)

### Operations

In order to encapsulate each function, we implement for each (create, update, install and delete).

#### Createpkg

On this operation, it has to attend some validation on:
* name
* extensions
* version
* build

And the package some prerequisites:
* unique name
* no spaces on it
* unique extension
* count hifens

We start with a shell script 












