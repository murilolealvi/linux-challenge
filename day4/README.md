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

### Introduction

I will leverage this topic to learn how to create a package manager with [Slackjeff](https://slackjeff.com.br/) course! 

At the beginning, all packages installed should be compilled and its files distributed on */sbin* and other directories. To remove or update it, the user should keep track for all the files generated and exlude these one by one. The hardcore would create a script to automatically perform this all.

At this age that the **package manager** was created, in 90s era.
We can classify it in low level and high level.

The low level tracks all libraries that will be installed and do all of it operations (create, update and delete) Examples:
* dpkg
* rpm
* pkgtools
  
In other hand, the high level will get the package from a mirror on the web, evaluate dependencies and forward to the low level. Examples:
* apt
* yum/dnf
* pacman


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

Let's focus on the low level.

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

We start with a shell script to create a package by its argument and check if it is empty:
```sh
case "$1" in #pkg argument
        create|-c) #create or -c operator
                shift #remove the inital argument on the queue (go to the next) to get package name
        #the -z is a operator to test if the string is empty
                if [ -z "$1" ]; then
                        printf '%s\n' "Package is null" #%s pass a string, in this case a new line
                        exit 1 #exit digit
                fi
        ;;
```

We can implement the create package function with command ```tar```:
```sh
#function
CREATE() {
        pkg_name="$1" #empty argument verified below
        if tar -cvf ../${pkg_name}. .; then #pack the package as a tarball
                printf '%s\n' "Package created: ${pkg_name}"
                return 0               
        else
                printf '%s\n' "Package failed: ${pkg_name}"
                exit 1
        fi
}
```
Let's try it out by giving it execution permission:

![null](images/null.png)

Afterwards, we can create this shell script as a process to the superuser (```/usr/sbin/```):

```bash
cp createpkg /usr/sbin
```

From previous compiled app ***nano-test***, we can compile it to the source with this new script:

![createpkg](images/createpkg.png)

We can see the package created: 

![package](images/package.png)

OBS: We can use ```sh -x``` to check which contexts the execution passes for a specific argument.

The optimization is done in order to get multiple packages and check it all in a ```for``` loop, also encapsulating the variables as ```local```:

![for](images/for.png)


We can check it working:

![optimization](images/optimization.png)

Now, we validate the package extension:

![extension](images/extension.png)

Validating:

![validating](images/validating.png)

Now we guarantee that it includes version+build (e.g., package-1.0-1, in other words version 1.0 build 1):

![version](images/version.png)

Validating again:

![test-version](images/test-version.png)











