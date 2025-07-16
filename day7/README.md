# The server and its services

We will manage an web server (Apache2 - *httpd*).
Let's start installing it:

![apache](images/apache.png)

Checking if it is active:

![systemctl](images/systemctl.png)

  Configuration is handled on vast majority at ```\etc``` folder:

  ```bash
  vim /etc/apache2/apache2.conf
  ```

We can check all the conf files included:

![conf](images/conf.png)


On browser, we insert the public IP for the VPS and port 80:

![page](images/page.png)

## Configuration

Based upon [TechHut tutorial](https://techhut.tv/how-to-apache-webserver-ssl/), we configure some steps on our web server.

### Hosts

Let's give our instance a hostname:

```bash
vim /etc/hostname #to install a hostname to be used
vim /etc/hosts #to attach a hostname to an address
```

Step by step:
* We give our system the hostname ```linux-challenge``` on ```etc/hostname```
* We attach to our localhost the same hostname

![hosts](images/hosts.png)

### Website

On ```/etc/apache2/sites-enabled/```, we have our *000-default.conf* that manages the website that shows up. At it, we have some configuration parameters:

![default](images/default.png)

At ```/var/www/html/``` directory, we create a example website to take over the default:

![example](images/example.png)

At ```/etc/apache2/sites-available```, we create a ```example.conf``` to include our new website:

![sites](images/sites-available.png)

Finally, we enable this site with ```ae2ensite``` command. Otherwise, we could use ```ae2dissite``` to disable:

```bash
a2ensite example
```

### Security

Let's install SSL certificates on our web server. In summary, it creates an encrypted link between the server and the browser.

We must install the ```certbot``` and link it to our Apache instance:

```bash
apt install certbot python3-certbot-apache
```

Then, we attach it to our localhost:
```bash
certbot --apache -d example.com
#-d stands for domain
```












