// Tema-2-ASC
.data

.text

.global main

main:


et_exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
