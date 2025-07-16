# Power drip

Since we are using DigitalOcean VPS, we have access to root:

![root](images/root.png)

In order to granulate permissions and avoid commands at free usage, we add a user to the system:

![user](images/user.png)

Then, we add it to **sudoers**:
```bash
usermod -aG sudo murilogabriel
```
Now we test it with ```su -```(the dash ensures environment variables load):

![su](images/su.png)

Let's push some commands:

![shadow](images/shadow.png)

We need to use superuser in order to use these commands. After an issued ```sudo reboot```, we analyze how a normal user face it:

![last](images/last.png)

The configuration to disable login as root is on ```/etc/ssh/sshd_config```.
After that, we need to reboot:

```bash
systemctl restart sshd
```


## Extension
With great power comes great responsibility...

### How to edit sudoers file?
The **/etc/sudoers** file indicates the privileges allowed for each user.

The command ```visudo``` is a way to get directly into edit mode of **sudoers** file in vi or nano mode:

![visudo](images/visudo.png)

The *env_reset* option resets the terminal environment remove leveraging **sudo** for a command. For bad passwords attempts, it mails to **mailto** user, normally the root account.
Finally, the *secure_path* indicates where the operations for the sudo user resides.

![users](images/users.png)

Above, we have the permissions for the users configured. It reads:
* **root** ALL=(ALL:ALL) ALL: user that it is applied
* root **ALL**=(ALL:ALL) ALL: hosts that it is appleid
* root ALL=(**ALL**:ALL) ALL: can run command as these users
* root ALL=(ALL:**ALL**) ALL:  can run command as these groups
* root ALL=(ALL:ALL) **ALL**: commands allowed

Let's create a user *teste* that is only capable to reboot the system:

![teste](images/teste.png)

## ```sudo -i``` vs ```sudo -s```

We will compare based upon the man page:

![interactive](images/interactive.png)

![shell](images/shell.png)

For the shell command, it creates another session but maintains the environment data from the current user. The interactive shell is powerful because it creates a new environment for the root with its configuration files.

## SSH Tunneling

### Local port forwarding

We can tunnel a connection local from a random port to map a known port on the remote host:

![rdp](images/rdp.png)

For example, if our firewall blocks RDP port, we can assign port 8080 locally to map 3389 on the remote host, on this example as the home computer. All this tunneled on a SSH session:
```bash
ssh -L 8080:10.1.1.1:3389 user@IP
```
We simply bind it local to destination.

### Remote port forwarding

We can do it in the same way for a remote socket:
```bash
ssh -R 8080:localhost:4444 user@IP
```

On this command, we bind 8080 port from the remote host to our 4444 port.

![hacker](images/hacker.png)

It can be malicious since all traffic destined to 4444 port will be forwarded to server.
We can practive this allowing it on our VPC under **/etc/ssh/sshd_config**:

![forwarding](images/forwarding.png)

We must allow *GatewayPorts* and *AllowTcpForwarding*.

We can allow some ports, but we test it for local port 8888 to port 80 on our VPS:

![remote](images/remote-forwarding.png)

OBS: The option **-N** is to not execute any command, just to listen.

When we open a web browser and search for **localhost:8888**:

![error](images/error.png)

We get a error, but it confirms a port forwarding.

### Dynamic port forwarding

The ultimate destination is determined runtime, in another words, a SOCKS proxy server will be in place.

A SSH server being the intermediate between a remote server and a backend can listen to a specific port and forward to a dynamic port on the end.

![dynamic](images/dynamic.png)

To reach this, we need to issue:

```bash
ssh -D 8888 user@IP
```

The option -D is the key to dynamically assign a port on the server reached by its IP.
