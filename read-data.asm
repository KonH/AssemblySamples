%define SYS_exit 0x2000001
%define STDOUT 1

global _main ; Entry point

section .data

data: db 10

section .text

_main:
    mov rax, SYS_exit
    mov rdi, [rel data]
    syscall