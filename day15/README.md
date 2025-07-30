# Deeper into repositories

Repositories is where the packages that we install easily with our package manager, be it ```apt```, ```yum```, ```dnf```, ```pacman``` or ```zypper```.

For RPM based distros, we have RPM non free, Terra, Remi...
For DPKG based distros, we have PPA (Personal Package Archive) for cutting edge software. We can add it:

```bash
sudo add-apt-repository ppa:ubuntusway-dev/dev
```

On Fedora (Terra example):
```bash
dnf config-manager --add-repo  https://github.com/terrapkg/subatomic-repos/raw/main/terra.repo
```
