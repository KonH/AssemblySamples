; Move player character on field

%define SYS_read 0x2000003
%define SYS_write 0x2000004
%define SYS_exit 0x2000001
%define STDIN 0
%define STDOUT 1
%define WIDTH_SIZE 5
%define HEIGHT_SIZE 3

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
playerX resb 8
playerY resb 8
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
    mov rax, 1
    mov [rel playerX], rax
    mov rbx, 0
    mov [rel playerY], rbx
    ret

game_loop:
    .while_loop_body:
        call render
        call input
        call update
        mov al, [rel inputBuffer] ; Repeat until \n is found
        mov bl, [rel newLine]
        cmp al, bl
        jne .while_loop_body
    call exit
    ret

read_input:
    syscall_3 SYS_read,STDIN,inputBuffer,inputBufferSize
    ret
    
render:
    xor rcx, rcx ; y = 0
    .for_y_body: 
        xor rbx, rbx ; x = 0
        .for_x_body:
            push rbx            ; Save counters to prevent modifications inside syscall
            push rcx
            call write_cell
            write_space
            pop rcx             ; Restore counters
            pop rbx
            inc rbx             ; x++
            cmp rbx, WIDTH_SIZE ; x == WIDTH_SIZE
            jne .for_x_body
        push rcx
        write_new_line
        pop rcx
        inc rcx             ; y++
        cmp rcx, HEIGHT_SIZE ; y == HEIGHT_SIZE
        jne .for_y_body
    ret

; Write empty or player cell
write_cell:
    cmp rcx, [rel playerY]
    jne .empty
    cmp rbx, [rel playerX]
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
    mov al, [rel inputBuffer]
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
        inc qword [rel playerX]
        ret
    .dec_x:
        dec qword [rel playerX]
        ret
    .inc_y:
        inc qword [rel playerY]
        ret
    .dec_y:
        dec qword [rel playerY]
        ret

exit:
    syscall_1 SYS_exit,0
    ret