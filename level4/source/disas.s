08048444 <p>:
		push   %ebp
		mov    %esp,%ebp
		sub    $0x18,%esp
		mov    0x8(%ebp),%eax
		mov    %eax,(%esp)
		call   8048340 <printf@plt>
		leave  
		ret    

08048457 <n>:
		push   %ebp
		mov    %esp,%ebp
		sub    $0x218,%esp
		mov    0x8049804,%eax
		mov    %eax,0x8(%esp)
		movl   $0x200,0x4(%esp)
		
		lea    -0x208(%ebp),%eax
		mov    %eax,(%esp)
		call   8048350 <fgets@plt>
		lea    -0x208(%ebp),%eax
		mov    %eax,(%esp)
		call   8048444 <p>
		mov    0x8049810,%eax
		cmp    $0x1025544,%eax
		jne    80484a5 <n+0x4e>
		movl   $0x8048590,(%esp)
		call   8048360 <system@plt>
		leave  
		ret    

080484a7 <main>:
		push   %ebp
		mov    %esp,%ebp
		and    $0xfffffff0,%esp
		call   8048457 <n>
		leave  
		ret    
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop

