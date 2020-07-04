; Read single character (and \n) from terminal input and write it back

%define SYS_read 0x2000003
%define SYS_write 0x2000004
%define SYS_exit 0x2000001
%define STDIN 0
%define STDOUT 1

global _main ; Entry point

section .text

_main:
    mov rax, SYS_read
    mov rdi, STDIN
    lea rsi, [rsp-2]
    mov rdx, 2
    syscall
    
    mov rax, SYS_write
    mov rdi, STDOUT
    lea rsi, [rsp-2]
    mov rdx, 2
    syscall

    mov rax, SYS_exit
    mov rdi, 0
    syscall