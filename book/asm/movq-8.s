# asm/movq-8.s
    .data
x:
    .quad 999 
    .text
    .globl main
    .type main, @function
main:
    movq $x, %rax
    ret
    .size main, .-main
