; Read single character (and \n) from terminal input and write it back

%define SYS_read 0x2000003
%define SYS_write 0x2000004
%define SYS_exit 0x2000001
%define STDIN 0
%define STDOUT 1

global _main ; Entry point

section .bss
inputBuffer resb 2
inputBufferSize equ $-inputBuffer

section .text

_main:
    call read_input
    call write_input
    call exit
    ret

read_input:
    mov rax, SYS_read
    mov rdi, STDIN
    mov rsi, inputBuffer
    mov rdx, inputBufferSize
    syscall
    ret
    
write_input:
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, inputBuffer
    mov rdx, inputBufferSize
    syscall
    ret

exit:
    mov rax, SYS_exit
    mov rdi, 0
    syscall