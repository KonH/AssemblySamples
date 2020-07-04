.data
str: .asciz "Hello world!\n"

.text
.globl _main
_main:
    movl $0x2000004, %eax # SYS_write
    movl $1, %edi         # STDOUT file descriptor is 1
    leaq str(%rip), %rsi  # The value to print
    movq $100, %rdx       # Maximum size of the value to print (.asciz zero-terminated)
    syscall

    movl $0, %ebx
    movl $0x2000001, %eax  # SYS_exit
    syscall