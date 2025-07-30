# Users and Groups


We want to create users and restrict permissions.

## New user

To create it:

```bash
adduser user
```
OBS: Case sensitive

To configure a password to it:
```bash
passwd user
```

A new group and an user already into it:
```bash
groupadd developers
adduser --ingroup developers user
```


To add an user to the group:
```bash
usermod -aG group user
```

To switch it:
```bash
su user
```

The user won't be able to issue ```sudo```, they must be part of the group:
```bash
usermod -aG  sudo user
```
















