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