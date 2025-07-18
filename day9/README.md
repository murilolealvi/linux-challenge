# Diving into networking

We have essential services running - *sshd* and *httpd* on ports 22 and 80 respectively.

We need to secure these with firewall.


We start checking the current open sockets with ```ss```:

![ss](images/ss.png)


It has opened DNS, SSH and HTTP ports. Another way to do this is scanning our own server with ```nmap```:

![nmap](images/nmap.png)


