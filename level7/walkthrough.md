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
	- `main` takes two arguments and then:
		- two array and one normal var:
			- `arr1` and `arr2` are both `malloc(8)`
			- `varx` also `malloc(8)` to create a seperated memory region
			- this should look something like this:
				```c
				arr1[0] = 1
				arr1[1] = [][][][][][][][] // 8 bytes memory region to store the string argv[1]

				arr2[0] = 2
				arr2[1] = [][][][][][][][] // 8 bytes memory region to store the string argv[2]
				```
				To be fair the issue in this level7 is just understanding that horrible code
		- next we have two `strcpy()`, one for each argument like shown above
		- then `fopen()` and `fgets` respectively fetch and store the password of the next level in a global variable `c`
		- and `puts("~~")`
	- `m` -> useless
*	Here we want to store the address of `puts()` at the end of the second array 
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
