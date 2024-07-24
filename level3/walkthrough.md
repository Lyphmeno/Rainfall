level3
======

*	We spawn with a [level3](source/level3) executable
	```console
	level3@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level4 users 5366 Mar  6  2016 level3
	level3@RainFall:~$ ./level3 
	█
	```
*	Let's take a look at the code in gdb
	```gdb
	(gdb) info functions
	All defined functions:
	...
	0x080484a4  v
	0x0804851a  main
	...
	```
*	We have two functions `v` and `main`
	-	`main` just calls `v`
	-	`v` does many things :
		-	