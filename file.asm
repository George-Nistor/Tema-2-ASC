// Tema-2-ASC
.data
	three: .long 3
	
	input: .space 4000
	n: .space 4
	m: .space 4
	x: .space 360		# 4*30*3
	lenght: .space 4
	xf: .space 120	# 4*30
	
	formatString: .asciz "%s"
	formatDecimal: .asciz "%d "
	formatCharacter: .asciz "%c"
	characterSpace: .asciz " "
	formatScanf: .asciz "%d"
.text

.global main

main:
	pushl $n		# read n
	pushl $formatDecimal
	call scanf
	popl %ebx
	popl %ebx
	
	movl n, %eax	# lenght of x = n*3
	mull three
	movl %eax, lenght 
	
	pushl $m		# read m
	pushl $formatDecimal
	call scanf
	popl %ebx
	popl %ebx
	
	pushl $input	# read vector
	call gets
	popl %ebx
	
	pushl $characterSpace
	pushl $input
	call strtok
	popl %ebx
	popl %ebx
	
	xorl %ecx, %ecx
	pushl %ecx 	# ECX PUSH
	movl $x, %edi
	
	et_strtok:
		cmp $0, %eax
		je exit_strtok
		
		pushl %eax
		call atoi
		popl %ebx
		
		popl %ecx		# ECX POP
		incl %ecx
		movl %eax, (%edi, %ecx, 4)
		pushl %ecx	# ECX PUSH
		
		pushl $characterSpace
		pushl $0
		call strtok
		popl %ebx
		popl %ebx
		
		jmp et_strtok	
exit_strtok:

printPermutation:
	movl $1, %ecx
	et_for:
		cmp lenght, %ecx
		jg et_exit
		
		pushl %ecx
					
		pushl (%edi, %ecx, 4)
		pushl $formatDecimal
		call printf
		popl %ebx
		popl %ebx
		
		popl %ecx
		incl %ecx
		
		jmp et_for
et_exit:
	pushl $10 # '\n'
	pushl $formatCharacter
	call printf
	popl %ebx
	popl %ebx
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
