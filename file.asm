// Tema-2-ASC
.data
	three: .long 3
	negativeOne: .long -1
	
	input: .space 300
	element: .space 4
	n: .space 4
	lenght: .space 4
	m: .space 4
	v: .space 372		# 4 * 31 * 3
	vf: .space 124		# 4 * 31
	
	formatDecimal: .asciz "%d "
	formatCharacter: .asciz "%c"
	characterSpace: .asciz " "
	formatScanf: .asciz "%d"
.text
printVector:			# printVector(vector, lenght)
	pushl %ebp
	movl %esp, %ebp
	pushl lenght
	pushl %edi
	pushl %ebx
	
	movl 8(%ebp), %edi	
	movl 12(%ebp), %ecx
	
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

	movl $1, %eax
			
	popl %ebx
	popl %edi
	popl lenght
	popl %ebp
	ret

findZero:
	pushl %ebp
	movl %esp, %ebp
	pushl %edi

	xorl %eax, %eax		# no zero found
	xorl %ecx, %ecx
	
	fZ_for:
		cmp lenght, %ecx
		je fZ_exit
		
		incl %ecx
		cmp $0, (%edi, %ecx, 4)
		je zeroFound
		
		jmp fZ_for		
	zeroFound:
		movl %ecx, %eax 	# v[%eax] = 0
			 
	fZ_exit:
	popl %edi
	popl %ebp
	ret

valid:					# valid(element, position)
	pushl %ebp
	movl %esp, %ebp
	pushl %edi
	pushl %ebx
	
	movl 8(%ebp), %ebx		# element
	movl 12(%ebp), %ecx 	# position
		
	movl $vf, %edi
	cmp $3, (%edi, %ebx, 4)
	je notValid
	
	movl %ecx, %eax
	addl m, %eax
	subl m, %ecx
	subl $1, %ecx
	
	movl $v,  %edi	
	
	cmp $0, %ecx
	jl limitOne
	
	jmp checkDistance_for
	
	limitOne:
		xor %ecx, %ecx

	checkDistance_for:
		cmp %eax, %ecx
		je cD_exit
		
		incl %ecx
		cmp (%edi, %ecx, 4), %ebx
		je notValid
			
		jmp checkDistance_for
	cD_exit:
	
	movl $1, %eax
	jmp valid_exit			# true
			
	notValid:
		xorl %eax, %eax	# false
	valid_exit:
	popl %ebx
	popl %edi
	popl %ebp
	ret

solve:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	pushl %edi
	pushl %esi
	
	call findZero
	movl %eax, %ebx		# v[%ebx] = 0
	
	cmp $0, %eax
	je solve_success		# no zero found
	
	movl $v, %edi
	movl $vf, %esi
	xorl %ecx, %ecx
	
	back_for:
		cmp n, %ecx
		je back_exit
		
		incl %ecx
		
		push %ebx		# position
		pushl %ecx	# element
		call valid
		pushl %eax
				
		popl %eax
		popl %ecx
		popl %ebx
		
		cmp $1, %eax
		je back_valid
		
		jmp back_for
		
		back_valid:
			movl %ecx, (%edi, %ebx, 4)	# v[%ebx] = %ecx
			incl (%esi, %ecx, 4)		# vf[%ecx]++
				
			push %ecx
			push %ebx
			call solve
			popl %ebx
			popl %ecx
	
			cmp $1, %eax
			je solve_success
			
			movl $0, (%edi, %ebx, 4)		# v[%ebx] = 0
			decl (%esi, %ecx, 4)		# vf[%ecx]--
			jmp back_for
	back_exit:
	
	movl $0, %eax
	jmp solve_exit
	
	solve_success:
		movl $1, %eax
	
	solve_exit:
	popl %esi
	popl %edi
	popl %ebx
	popl %ebp
	ret

.global main
main:
	pushl $n			# read n
	pushl $formatDecimal
	call scanf
	popl %ebx
	popl %ebx
	
	movl n, %eax	
	mull three
	movl %eax, lenght 	# lenght x = n*3
	
	pushl $m			# read m
	pushl $formatDecimal
	call scanf
	popl %ebx
	popl %ebx
	
	pushl $input		# read vector
	call gets
	popl %ebx
	
	pushl $characterSpace
	pushl $input
	call strtok
	popl %ebx
	popl %ebx
	
	xorl %ecx, %ecx
	pushl %ecx 
	movl $v, %edi
	movl $vf, %esi
	et_strtok:
		cmp $0, %eax
		je exit_strtok
		
		pushl %eax
		call atoi
		popl %ebx
		
		popl %ecx
		incl %ecx
		movl %eax, (%edi, %ecx, 4)	# v[%ecx] = %eax
		incl (%esi, %eax, 4)		# vf[%eax]++
		pushl %ecx
		
		pushl $characterSpace
		pushl $0
		call strtok
		popl %ebx
		popl %ebx
		
		jmp et_strtok	
exit_strtok:

call solve 						# backtracking

cmp $1, %eax
je success

pushl negativeOne
pushl $formatDecimal
call printf
popl %ebx
popl %ebx

jmp et_exit

success:
	pushl lenght
	pushl $v
	call printVector
	popl %ebx
	popl %ebx

et_exit:
	pushl $10 # '\n'
	pushl $formatCharacter
	call printf
	popl %ebx
	popl %ebx
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
