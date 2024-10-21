Rainfall Project
===================

Welcome to the Rainfall project!

This is the CTF following Snow-Crash.

Description
-----------

This project aims to make dig deeper into CTF challenges and learn more about memory, shellcode, Ret2libc and more.
You will log on a Virtual Machine as `level0` user. The goal is to find the password of the next user until `level9`.
To do so you have to cat the file corresponding to the password of the next user.

Exemple :
```console
level00@SnowCrash:~$ *exploit giving a shell*
$ whoami
level1
$ cat /home/user/level1/.pass
```

Requierements
-------------

-  Explain clearly how you found the pass
-  You cannot bruteforce the ssh connection
-  You will have to do it all during the correction so you can help yourself with your own documentation

Levels
------
#### Mandatory :

- [level00](level0) : Reverse execution
- [level01](level1) : Stack buffer overflow
- [level02](level2) : Heap buffer overflow
- [level03](level3) : Format string
- [level04](level4) : Format string
- [level05](level5) : Format string
- [level06](level6) : Heap buffer overflow
- [level07](level7) : Heap buffer overflow
- [level08](level8) : Reverse execution
- [level09](level9) : Heap buffer overflow

#### Bonus :
- [bonus0](bonus0) : Stack buffer overflow
- [bonus1](bonus1) : Reverse execution
- [bonus2](bonus2) : Stack buffer overflow
- [bonus3](bonus3) : Reverse execution

Getting started
---------------

- First of all I recommend to do the [snowcrash](https://github.com/Lyphmeno/snow-crash) project before this one
- Even if Ret2libc is better, it is nice to to some shellcode now and then

Ressources
----------

[Ret2libc in french](https://beta.hackndo.com/retour-a-la-libc/)
*The rest of my sources can be find in the code itself*