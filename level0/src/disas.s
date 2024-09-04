08048ec0 <main>:
		push   %ebp
		mov    %esp,%ebp
		and    $0xfffffff0,%esp
		sub    $0x20,%esp
		mov    0xc(%ebp),%eax
		add    $0x4,%eax
		mov    (%eax),%eax
		mov    %eax,(%esp)
		call   8049710 <atoi>
		cmp    $0x1a7,%eax
		jne    8048f58 <main+0x98>
		movl   $0x80c5348,(%esp)
		call   8050bf0 <__strdup>
		mov    %eax,0x10(%esp)
		movl   $0x0,0x14(%esp)
		
		call   8054680 <__getegid>
		mov    %eax,0x1c(%esp)
		call   8054670 <__geteuid>
		mov    %eax,0x18(%esp)
		mov    0x1c(%esp),%eax
		mov    %eax,0x8(%esp)
		mov    0x1c(%esp),%eax
		mov    %eax,0x4(%esp)
		mov    0x1c(%esp),%eax
		mov    %eax,(%esp)
		call   8054700 <__setresgid>
		mov    0x18(%esp),%eax
		mov    %eax,0x8(%esp)
		mov    0x18(%esp),%eax
		mov    %eax,0x4(%esp)
		mov    0x18(%esp),%eax
		mov    %eax,(%esp)
		call   8054690 <__setresuid>
		lea    0x10(%esp),%eax
		mov    %eax,0x4(%esp)
		movl   $0x80c5348,(%esp)
		call   8054640 <execv>
		jmp    8048f80 <main+0xc0>
		mov    0x80ee170,%eax
		mov    %eax,%edx
		mov    $0x80c5350,%eax
		mov    %edx,0xc(%esp)
		movl   $0x5,0x8(%esp)
		
		movl   $0x1,0x4(%esp)
		
		mov    %eax,(%esp)
		call   804a230 <_IO_fwrite>
		mov    $0x0,%eax
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

