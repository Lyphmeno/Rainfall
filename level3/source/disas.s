080484a4 <v>:
		push   %ebp
		mov    %esp,%ebp
		sub    $0x218,%esp
		mov    0x8049860,%eax
		mov    %eax,0x8(%esp)
		movl   $0x200,0x4(%esp)
		
		lea    -0x208(%ebp),%eax
		mov    %eax,(%esp)
		call   80483a0 <fgets@plt>
		lea    -0x208(%ebp),%eax
		mov    %eax,(%esp)
		call   8048390 <printf@plt>
		mov    0x804988c,%eax
		cmp    $0x40,%eax
		jne    8048518 <v+0x74>
		mov    0x8049880,%eax
		mov    %eax,%edx
		mov    $0x8048600,%eax
		mov    %edx,0xc(%esp)
		movl   $0xc,0x8(%esp)
		
		movl   $0x1,0x4(%esp)
		
		mov    %eax,(%esp)
		call   80483b0 <fwrite@plt>
		movl   $0x804860d,(%esp)
		call   80483c0 <system@plt>
		leave  
		ret    

0804851a <main>:
		push   %ebp
		mov    %esp,%ebp
		and    $0xfffffff0,%esp
		call   80484a4 <v>
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

