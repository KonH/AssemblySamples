; Read all input from STDIN and represent it in STDOUT until empty input provided

%define SYS_read 0x2000003
%define SYS_write 0x2000004
%define SYS_exit 0x2000001
%define STDIN 0
%define STDOUT 1

global _main ; Entry point

section .bss
inputBuffer resb 16
inputBufferSize equ $-inputBuffer

section .text

_main:
    call read_write_loop
    call exit
    ret

; To properly handle read process it's required to utilize all peding data
; So read all chunks until empty input found
read_write_loop:
    .while_loop_body:
        call read_input    ; RAX contains SYS_read return value,
        cmp rax, 1         ; in case of 1, then no input provided (\0 only)
        je .while_loop_end ; and we can finish
        call write_input
        jmp .while_loop_body
    .while_loop_end:
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