; lab3.asm

; nasm -f bin -o lab3.img lab3.asm
; trucate lab3.img -S 1474560

; BIOS loads boot sector to 0x7C00
org 0x7C00

; Set source index to buffer
mov si, buffer  

main:
    ; Call BIOS keyboard input
    mov ah, 00h
    int 16h

    ; Check backspace
    cmp ah, 0x0E
    je escape_backspace

    ; Check enter
    cmp ah, 0x1C
    je escape_enter

    ; Check if buffer is full
    cmp si, buffer + 256
    je main

    ; Check if character is printable
    cmp al, 0x20
    jl main
    cmp al, 0x7E
    jg main

    ; TODO: Add scroll support

    ; Store character in buffer
    mov [si], al
    inc si

    ; Call write character
    mov ah, 0Eh     
    int 10h

    ; Loop to main  
    jmp main

escape_backspace:
    ; Call BIOS get cursor
    mov ah, 03h
    int 10h

    ; Check if buffer is empty
    cmp si, buffer
    je main
    
    ; Move si back and delete last char in buffer
    sub si, 1
    mov byte [si], 0x00

    ; Check if cursor is on the first column
    cmp dl, 0x00
    jz new_line_backspace

    ; Move cursor back one column
    mov ah, 02h
    sub dl, 0x01
    int 10h

    ; Delete last character on screen
    mov ah, 0Ah
    mov al, 0x00
    int 10h

    jmp main

new_line_backspace:
    ; Call BIOS get cursor
    mov ah, 03h
    int 10h

    ; Check if cursor is on the first line
    cmp dh, 0x00
    je main

    ; Move cursor to the end of the previous line
    mov ah, 02h
    mov dl, 0x4F
    sub dh, 0x01
    int 10h

    ; Delete last character on screen
    mov ah, 0Ah
    mov al, 0x00
    int 10h

    jmp main

escape_enter:
    ; Call BIOS get cursor
    mov ah, 03h
    int 10h

    ; Check if buffer is empty
    sub si, buffer
    jz empty_enter

    ; TODO: Compare for prompt

    ; Print buffer after new line
    mov ax, 1301h
    mov bl, 07h
    mov bp, buffer
    mov cx, si
    mov dl, 0x00
    add dh, 0x02
    int 10h

    ; Palce cursor at the beginning of the next line
    mov ah, 02h
    mov dl, 0x00
    add dh, 0x01
    int 10h

    ; Set si to the beginning of the buffer
    add si, buffer

clear_buffer:
    ; Delete the current character in buffer
    mov byte [si], 0x00
    add si, 0x01
    cmp si, 0x00
    jne clear_buffer

    ; Reset si to the beginning of the buffer
    mov si, buffer

    jmp main

empty_enter:
    ; Place cursor at the beginning of the next line
    mov ah, 02h
    mov dl, 0x00
    add dh, 0x01
    int 10h

    ; Reset source index
    add si, buffer  

    jmp clear_buffer


section .data
    n_prompt db "N: ", 0
    n_len equ $ - n_prompt

    head_prompt db "Head: ", 0
    head_len equ $ - head_prompt

    track_prompt db "Track: ", 0
    track_len equ $ - track_prompt

    sector_prompt db "Sector: ", 0
    sector_len equ $ - sector_prompt

buffer: times 256 db 0x00
