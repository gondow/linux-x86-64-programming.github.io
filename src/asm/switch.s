	.file	"switch.c"
	.text
	.globl	x
	.data
	.align 4
	.type	x, @object
	.size	x, 4
x:
	.long	111
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	pushq	%rbp
	movq	%rsp, %rbp
	movl	x(%rip), %eax
	cmpl	$1, %eax
	je	.L2
	cmpl	$111, %eax
	je	.L3
	jmp	.L7
.L2:
	movl	x(%rip), %eax
	addl	$1, %eax
	movl	%eax, x(%rip)
	jmp	.L5
.L3:
	movl	x(%rip), %eax
	subl	$1, %eax
	movl	%eax, x(%rip)
	jmp	.L5
.L7:
	movl	$0, x(%rip)
	nop
.L5:
	movl	$0, %eax
	popq	%rbp
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
