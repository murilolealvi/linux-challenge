# RPM and YUM package management

RedHat created a bunch of package managers: ```rpm```, ```yum``` and ```dnf```
Also, SUSE uses ```zypper```

## rpm

To install a package:
```bash
rpm -i package
```

To update to a newer version:
```bash
rpm -U package
```

To remove a package:
```bash
rpm -e package
```

If it has instrinsic dependencies, RPM will deny its removal.
To list installed packages:
```bash
rpm -qa #query for all
```

To query only a package:
```bash
rpm -qi package
rpm -ql package #list files attached
rpm -qip package #for package not installed yet
rpm -qlp package #files that it would generate
rpm -qf file #check which package owns the file
```

## yum

To search for packages that are not necessarily installed:
```bash
yum search package
```

To install:
```bash
yum install package
```

To update:
```bash
yum update package
yum update #update all
yum check-update package #check if it has an update available
```

To remove:
```bash
yum remove package
```

To get its files:
```bash
yum whatprovides package/file
```

To get information about a package:
```bash
yum info package
```

Repositories are maintained under ```/etc/yum.repos.d/``` and has a .repo extension (just like .lists in Debian). We could add a custom .repo file, at the end of ```/etc/yum.conf``` or even in a command:
```bash
yum-config-manager --add-repo https://rpms.remirepo.net/enterprise/remi.repo
```

To query all available repos:
```bash
yum repolist all
```

It stores cache often under ```/etc/cache/yum``` and could be cleaned with ```yum clean```.

## dnf

To search for a package:
```bash
dnf search package
```

To get some info:
```bash
dnf info package
```

To install:
```bash
dnf install package
```

To remove:
```bash
dnf remove package
```

To update:
```bash
dnf upgrade package
```

To check which package owns the file:
```bash
dnf provides file
```

To get all installed packages:
```bash
dnf list --installed
```

To get all repos:
```bash
dnf repolist
```

We can also use ```config-manager``` to add one:
```bash
dnf config-manager --add-repo URL
```

It is stored at ```/etc/yum.repos.d``` also.

## zypper

To refresh metadata/package index:
```bash
zypper refresh
```

To search for packages:
```bash
zypper search package
```

To get all installed packages:
```bash
zypper search -i #could specify a package
```

To install:
```bash
zypper install package
```

To remove:
```bash
zypper rm package #also removes dependencies
```

To find which package owns the file:
```bash
zypper search --provides file
```

To get package information:
```bash
zypper info package
```

To list and modify repos:
```bash
zypper repos
zypper modifyrepo -d repo #disable
zypper modifyrepo -e repo #enable
```

To add/remove a repo:
```bash
zypper addrepo URL
zypper removerepo repository-name
```





