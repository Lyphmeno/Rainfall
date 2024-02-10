08048444 <run>:
		push   %ebp
		mov    %esp,%ebp
		sub    $0x18,%esp
		mov    0x80497c0,%eax
		mov    %eax,%edx
		mov    $0x8048570,%eax
		mov    %edx,0xc(%esp)
		movl   $0x13,0x8(%esp)
		
		movl   $0x1,0x4(%esp)
		
		mov    %eax,(%esp)
		call   8048350 <fwrite@plt>
		movl   $0x8048584,(%esp)
		call   8048360 <system@plt>
		leave  
		ret    

08048480 <main>:
		push   %ebp
		mov    %esp,%ebp
		and    $0xfffffff0,%esp
		sub    $0x50,%esp
		lea    0x10(%esp),%eax
		mov    %eax,(%esp)
		call   8048340 <gets@plt>
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

