// Tema-2-ASC
.data
	three: .long 3
	
	input: .space 300
	n: .space 4
	m: .space 4
	x: .space 360		# 4*30*3
	lenght: .space 4
	f: .space 120	# 4*30
	
	formatDecimal: .asciz "%d "
	formatCharacter: .asciz "%c"
	characterSpace: .asciz " "
	formatScanf: .asciz "%d"
.text
printVector:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %edi
	movl 12(%ebp), %ecx
	
	pushl lenght
	pushl %edi
	pushl %ebx
	
	movl %ecx, lenght
	
	movl $1, %ecx
	pV_for:
		cmp lenght, %ecx
		jg pV_exit
		
		pushl %ecx
					
		pushl (%edi, %ecx, 4)
		pushl $formatDecimal
		call printf
		popl %ebx
		popl %ebx
		
		popl %ecx
		incl %ecx
		
		jmp pV_for
	pV_exit:
	
	popl %ebx
	popl %edi
	popl lenght
	popl %ebp
	ret


findZero:
	pushl %ebp
	movl %esp, %ebp
	pushl %edi

	xorl %eax, %eax
	xorl %ecx, %ecx
	
	fZ_for:
		cmp lenght, %ecx
		je fZ_exit
		
		incl %ecx
		cmp $0, (%edi, %ecx, 4)
		je zeroFound
		
		jmp fZ_for		
	zeroFound:
		movl %ecx, %eax
		 
	fZ_exit:
	popl %edi
	popl %ebp
	ret

valid:
	pushl %ebp
	movl %esp, %ebp
	pushl %edi
	pushl %esi
	pushl %ebx
	
	movl $1, %eax
	
	movl $f, %esi
	xor %ecx, %ecx
	
	resetFrequency_for:
		cmp n, %ecx
		je resetFrequency_exit
				
		movl $0, (%esi, %ecx, 4)
		incl %ecx
	
		jmp resetFrequency_for
	resetFrequency_exit:
	
	movl $x,  %edi	
	xorl %ecx, %ecx	
	
	checkFrequency_for:
		cmp lenght, %ecx
		je valid_exit
		
		incl %ecx
		cmp $0, (%edi, %ecx, 4)
		je checkFrequency_for
		
		movl (%edi, %ecx, 4), %ebx
		incl (%esi, %ebx, 4)
		
		cmp $3, (%esi, %ebx, 4)
		jg notValidFreq
		
		pushl %eax
		pushl %ecx
		movl %ecx, %eax
		subl m, %eax
		checkDistance_for:
			cmp $1, %ecx
			jle cD_exit
			cmp %eax, %ecx
			je cD_exit
			
			decl %ecx
			cmp (%edi, %ecx, 4), %ebx
			je notValidDist
			
			jmp checkDistance_for
		cD_exit:
		popl %ecx
		popl %eax
		
		jmp checkFrequency_for 
	
	notValidDist:
		popl %ecx
		popl %eax
	notValidFreq:
		xorl %eax, %eax
		
	valid_exit:
	popl %ebx
	popl %esi
	popl %edi
	popl %ebp
	ret
	
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
	pushl %ecx 
	movl $x, %edi
	
	et_strtok:
		cmp $0, %eax
		je exit_strtok
		
		pushl %eax
		call atoi
		popl %ebx
		
		popl %ecx
		incl %ecx
		movl %eax, (%edi, %ecx, 4)
		pushl %ecx
		
		pushl $characterSpace
		pushl $0
		call strtok
		popl %ebx
		popl %ebx
		
		jmp et_strtok	
exit_strtok:

et_exit:
	pushl $10 # '\n'
	pushl $formatCharacter
	call printf
	popl %ebx
	popl %ebx
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
