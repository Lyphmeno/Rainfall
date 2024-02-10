level0
======

*	We spawn with a [level0](source/level0) executable
	```console
	level0@RainFall:~$ ls -l
	total 732
	-rwsr-x---+ 1 level1 users 747441 Mar  6  2016 level0
	level0@RainFall:~$ ./level0 
	Segmentation fault (core dumped)
	level0@RainFall:~$ ./level0  test
	No !
	```
*	First thing I did was retrieving the executable and took a look at it
	```console
	root@DESKTOP-69N2SL4:~# scp -P 4242 level0@192.168.29.4:~/level0 .
	root@DESKTOP-69N2SL4:~# ./getFunctions.sh
	```
	My [getFunctions](source/getFunctions.sh) script will allow me to get the [disas](source/disas.s)
*	In this part we can see the program uses `atoi` on the argument we gave him and then `cmp` with `423` in hexadecimal
	```assembly
	mov    %eax,(%esp)
	call   8049710 <atoi>
	cmp    $0x1a7,%eax
	```
*	So first thing we can try is to enter this value as argument as first argument, let's try that
	```conosole
	level0@RainFall:~$ ./level0 423
	$ whoami
	level1
	```
	Looks like we were right now let's think this through. In the code it seems that they use `uid` related function so knowing that and what happened earlier we can conclude this program launch `/bin/sh` with the `execve`
	```assembly
	call   8054640 <execv>
	```
*	All we need to do now is to retrieve the flag as the subject shows us
	```console
	$ pwd
	/home/user/level0
	$ cat /home/user/level1/.pass
	1fe8a524fa4bec01ca4ea2a869af2a02260d4a7d5fe7e7c24d8617e6dca12d3a
	```
