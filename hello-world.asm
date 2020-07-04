%define SYS_write 0x2000004
%define SYS_exit 0x2000001
%define STDOUT 1

global _main ; Entry point

section .data

msg:    db      "Hello, world!", 10
.len:   equ     $ - msg

section .text

_main:
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, msg.len
    syscall

    mov rax, SYS_exit
    mov rdi, 0
    syscall