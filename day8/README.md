# The infamous “grep” and other text processors

We will deep dive text manipulation with the well known commands: ```grep```, ```cat```, ```more```, ```less```, ```cut```, ```awk``` and ```tail```, as well redirection.

Since we created a barebones web server, let's scrap its logs.

```bash
cat /var/log/apache2/acces.log
```

Here we have the IP addresses that tried/logged on the server.
Then, from previously classes, we use ```less`` and its mentions *GG*, *gg*, */* with *N* and *n*.  

We can maintain the file output with ```tail```:

```bash
tail -f /var/log/auth.log
```

With this example, we can monitor in real-time which individuals try to log into our server.

We can crap this logs to another command (sdout > sdin) by using "pipe" (```|```):

```bash
cat /var/log/auth.log | grep "authentication"
```

The ```cut``` command is used to select portions of each line based upon a delimiter and  a field:

```bash
cut -f "field" -d "delimiter"
```

We can find login attempts that are not from root with ```-v```option in grep:

```bash
grep "authenticating" /var/log/auth.log | grep -v "root" | cut -f 10- -d" "
```
OBS: 10- is for 10th field and so on

![cut](images/cut.png)

Cool command!

Finally, we can redirect it to file with ```>```operator:

![redirection](images/redirection.png)

To optimize this, we sort the output and remove any repeated log:

```bash
grep "authenticating" /var/log/auth.log | grep -v "root" | cut -f 10d -d" " | sort | uniq
```

## sed

Some nice [manipulations](https://edoras.sdsu.edu/doc/sed-oneliners.html) with sed:

* spaces between each line: ```sed G```
* undo spacing: ```sed 'n;d'```
* count lines: ```sed -n '$='```

## awk

The command ```awk``` is more powerful than ```sed``` in terms that it is capable to understand fields, do calculus and has complex operators integrated.

We start with a simple ```ps``` command to check the active processes:

![ps](images/ps.png)

Let's grab just the first field (the PID):

```bash
ps | awk '{print $1}'
```

![field](images/field.png)

For default, the field separator is the *space*. However, we can change it on the fly with ```-F``` option:
```bash
awk -F ","
```

In this case, we indicated the *,* as the separator for the fields.
We check it under ```/etc/passwd``` file:

![separator](images/separator.png)

To print multiple fields on the same line, we indicate that it must be separated by a space:
```bash
awk -F ":" '{print" "$1" "$3}' /etc/passwd
```

This example prints field 1 and 3. It could be a proper tab (```\t```) between them.
We could type it as a singlle operator:
```bash
awk 'BEGIN{FS=":" ; OFS="-"} {print $1,$3}' /etc/passwd
```

We indicate the field separator (FS) and the output field separator (OFS). The BEGIN function just highlights that ```awk``` has its own *programming language*. Basically, it specify a set of instructions to be issued before the read.

The operations with regular expressions are bulti-in:

```bash
awk -F "/" '/^\// {print $NF}' /etc/shells | uniq
```

In this example, we use a FS equal to /, searches for lines that starts with / and print the last field.
* //: between these are the searching string

![shells](images/cut.png)


## Sad Servers "Saskatoon"

Desciption of the problem:

*Find what's the IP address that has the most requests in this file (there's no tie; the IP is unique).*

*Write the solution into a file /home/admin/highestip.txt. For example, if your solution is "1.2.3.4", you can do echo "1.2.3.4" > /home/admin/highestip.txt*

I run into some solutions:

```bash
awk '{print $1}' /home/admin/access.log | sort | uniq -c | awk 'NF==1 {max=$1} $1>max {max=$1; ip=$2} END {print ip}' > /home/admin/highestip.txt
```

```bash
awk '{count[$1]++} END {for (ip in count) {print count[ip], ip}}' /home/admin/access.log | sort -r | head -1 | cut -d " " -f2 > /home/admin/highestip.txt
```

The official solution:

```bash
cat /home/admin/access.log | awk '{print $1}' | sort | uniq -c | sort -r | head -1 | awk '{print $2}' > /home/admin/highestip.txt
```

## Sad Servers "The Command Line Murders"

