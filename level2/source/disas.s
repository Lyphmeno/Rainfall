080484d4 <p>:
		push   %ebp
		mov    %esp,%ebp
		sub    $0x68,%esp
		mov    0x8049860,%eax
		mov    %eax,(%esp)
		call   80483b0 <fflush@plt>
		lea    -0x4c(%ebp),%eax
		mov    %eax,(%esp)
		call   80483c0 <gets@plt>
		mov    0x4(%ebp),%eax
		mov    %eax,-0xc(%ebp)
		mov    -0xc(%ebp),%eax
		and    $0xb0000000,%eax
		cmp    $0xb0000000,%eax
		jne    8048527 <p+0x53>
		mov    $0x8048620,%eax
		mov    -0xc(%ebp),%edx
		mov    %edx,0x4(%esp)
		mov    %eax,(%esp)
		call   80483a0 <printf@plt>
		movl   $0x1,(%esp)
		call   80483d0 <_exit@plt>
		lea    -0x4c(%ebp),%eax
		mov    %eax,(%esp)
		call   80483f0 <puts@plt>
		lea    -0x4c(%ebp),%eax
		mov    %eax,(%esp)
		call   80483e0 <strdup@plt>
		leave  
		ret    

0804853f <main>:
		push   %ebp
		mov    %esp,%ebp
		and    $0xfffffff0,%esp
		call   80484d4 <p>
		leave  
		ret    
		nop
		nop
		nop
		nop

