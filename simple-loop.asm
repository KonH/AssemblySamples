%define Count 3
%define SYS_write 0x2000004
%define SYS_exit 0x2000001
%define STDOUT 1

global _main ; Entry point

section .data

msg:    db      "Hello, world!", 10
.len:   equ     $ - msg

section .text

_main:
    call loop
    call exit
    ret

loop:
    xor r15, r15 ; Set zero value
.loop_body:
    inc r15
    call write
    cmp r15, Count ; Compare,
    je .loop_end  ; and break if value less
    jmp .loop_body
.loop_end:
    ret

write:
    mov rax, SYS_write
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, msg.len
    syscall
    ret

exit:
    mov rax, SYS_exit
    mov rdi, 0
    syscall