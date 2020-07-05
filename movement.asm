; Move player character on field

%define SYS_read 0x2000003
%define SYS_write 0x2000004
%define SYS_exit 0x2000001
%define STDIN 0
%define STDOUT 1
%define WIDTH_SIZE 10
%define HEIGHT_SIZE 6

%macro syscall_1 2
mov rax, %1 ; syscall number
mov rdi, %2 ; single parameter
syscall
%endmacro

%macro syscall_2 3
mov rax, %1 ; syscall number
mov rdi, %2 ; parameters
mov rsi, %3
syscall
%endmacro

%macro syscall_3 4
mov rax, %1 ; syscall number
mov rdi, %2 ; parameters
mov rsi, %3
mov rdx, %4
syscall
%endmacro

%macro write_player_cell 0
syscall_3 SYS_write,STDOUT,playerCell,1
%endmacro

%macro write_empty_cell 0
syscall_3 SYS_write,STDOUT,emptyCell,1
%endmacro

%macro write_space 0
syscall_3 SYS_write,STDOUT,space,1
%endmacro

%macro write_new_line 0
syscall_3 SYS_write,STDOUT,newLine,1
%endmacro

global _main ; Entry point

section .data
space: db " "
emptyCell: db "_"
playerCell: db "X"
newLine: db 10

section .bss
playerX resb 1
playerY resb 1
inputBuffer resb 2
inputBufferSize equ $-inputBuffer
firstInputChar resb 1

section .text

_main:
    call init
    call game_loop
    call exit
    ret

init:
    mov byte [rel playerX], WIDTH_SIZE / 2
    mov byte [rel playerY], HEIGHT_SIZE / 2
    ret

game_loop:
    .while_loop_body:
        call render
        call input
        call update
        mov al, [rel inputBuffer] ; Repeat until \n is found
        cmp al, [rel newLine]
        jne .while_loop_body
    call exit
    ret

read_input:
    syscall_3 SYS_read,STDIN,inputBuffer,inputBufferSize
    ret
    
render:
    xor cl, cl ; y = 0
    .for_y_body: 
        xor bl, bl ; x = 0
        .for_x_body:
            push rbx           ; Save counters to prevent modifications inside syscall
            push rcx
            call write_cell
            write_space
            pop rcx            ; Restore counters
            pop rbx
            inc bl             ; x++
            cmp bl, WIDTH_SIZE ; x == WIDTH_SIZE
            jne .for_x_body
        push rcx
        write_new_line
        pop rcx
        inc cl             ; y++
        cmp cl, HEIGHT_SIZE ; y == HEIGHT_SIZE
        jne .for_y_body
    ret

; Write empty or player cell
write_cell:
    cmp cl, [rel playerY]
    jne .empty
    cmp bl, [rel playerX]
    jne .empty
        write_player_cell
        ret
    .empty:
        write_empty_cell
        ret

input:
    syscall_3 SYS_read,STDIN,inputBuffer,inputBufferSize
    ret

update:
; %1 - register storage
; %2 - limiter
%macro update_position_inc 2
    inc %1
    cmp %1, %2
    jl .exit
    mov %1, 0
    jmp .exit
%endmacro
; %1 - register storage
; %2 - limiter
%macro update_position_dec 2
    dec %1
    cmp %1, 0
    jge .exit
    mov %1, %2 - 1
    jmp .exit
%endmacro
    mov al, [rel inputBuffer]
    mov bl, [rel playerX] ; Save position to temp registers
    mov cl, [rel playerY]
    cmp al, 97 ; a
    je .dec_x
    cmp al, 100 ; d
    je .inc_x
    cmp al, 119 ; w
    je .dec_y
    cmp al, 115 ; s
    je .inc_y
    ret
    .inc_x:
        update_position_inc bl,WIDTH_SIZE
    .dec_x:
        update_position_dec bl,WIDTH_SIZE
    .inc_y:
        update_position_inc cl,HEIGHT_SIZE
    .dec_y:
        update_position_dec cl,HEIGHT_SIZE
    .exit:
        mov [rel playerX], bl ; Load position from temp registers
        mov [rel playerY], cl
        ret

exit:
    syscall_1 SYS_exit,0
    ret