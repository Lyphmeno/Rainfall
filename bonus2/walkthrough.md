bonus2
======

*	We spawn with a [bonus2](src/bonus2) executable
	```console
	bonus2@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 bonus3 users 5664 Mar  6  2016 bonus2
	bonus2@RainFall:~$ ./bonus2 
	bonus2@RainFall:~$ ./bonus2 test
	bonus2@RainFall:~$ ./bonus2 test test
	Hello test
	```
*	As usual, [base](src/bonus2.c) and [better](src/bonus2_better.c) code. BUT this one is particular and only made for comprehension, there are no `strcpy()` in the `greetuser()` function !
*	No obvious exploit here, let's try a `shellcode` or `ret2libc`
*	Default language here would be `English` but if we modify `LANG` env variable we can cahnge that. The point of this would be to have more space for our payload since `Hello` is the shortest of them all.
	```
	bonus2@RainFall:~$ export LANG=fi
	bonus2@RainFall:~$ 
	```
	seems to work