; lab3.asm

; nasm -f bin -o lab3.img lab3.asm
; trucate lab3.img -S 1474560

; BIOS loads boot sector to 0x7C00
org 0x7C00

start:
    ; mov ah, 03h
    ; mov al, 0x01
    ; mov bx, sector_1
    ; mov cl, sector_1_cl
    ; mov dh, sector_1_dh
    ; mov ch, sector_1_ch
    ; int 13h

    ; Copy sector 1 to buffer
    mov cx, sector_1_len
    mov di, disk_sector
    mov si, sector_1
    cld
    rep movsb
    mov ah, 0x0
    copy_sector1:
        mov cx, sector_1_len
        mov si, sector_1
        cld
        rep movsb

        inc ah
        cmp ah, 0x9
        jne copy_sector1

    write_sector1:
        mov ah, 03h
        mov al, 0x01
        mov bx, disk_sector
        mov cl, sector_1_cl
        mov dh, sector_1_dh
        mov ch, sector_1_ch
        int 13h

    mov di, disk_sector
    clear_buffer_1:
        ; Delete the current character in disk buffer
        mov byte [di], 0x00
        add di, 0x01
        cmp di, 0x00
        jne clear_buffer_1

        ; Reset si to the beginning of the disk buffer
        mov di, disk_sector

    ; Copy sector 2 to buffer
    mov cx, sector_2_len
    mov di, disk_sector
    mov si, sector_2
    cld
    rep movsb
    mov ah, 0x0
    copy_sector2:
        mov cx, sector_2_len
        mov si, sector_2
        cld
        rep movsb

        inc ah
        cmp ah, 0x9
        jne copy_sector2

    write_sector2:
        mov ah, 03h
        mov al, 0x01
        mov bx, disk_sector
        mov cl, sector_2_cl
        mov dh, sector_2_dh
        mov ch, sector_2_ch
        int 13h
    
    mov di, disk_sector
    clear_buffer_2:
        ; Delete the current character in disk buffer
        mov byte [di], 0x00
        add di, 0x01
        cmp di, 0x00
        jne clear_buffer_2

        ; Reset si to the beginning of the disk buffer
        mov di, disk_sector
    
    ; Copy sector 3 to buffer
    mov cx, sector_3_len
    mov di, disk_sector
    mov si, sector_3
    cld
    rep movsb
    mov ah, 0x0
    copy_sector3:
        ; add di, sector_1_len
        mov cx, sector_3_len
        mov si, sector_3
        cld
        rep movsb

        inc ah
        cmp ah, 0x9
        jne copy_sector3

    write_sector3:
        mov ah, 03h
        mov al, 0x01
        mov bx, disk_sector
        mov cl, sector_3_cl
        mov dh, sector_3_dh
        mov ch, sector_3_ch
        int 13h

    jmp $

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

    ; Check arrow-up
    cmp ah, 0x48
    je scroll_up_one

    ; Check if character is printable
    cmp al, 0x20
    jl main
    cmp al, 0x7E
    jg main

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

    mov ah, 03h
    int 10h

    mov ax, 1301h
    mov bl, 07h
    mov bp, new_line
    mov cx, new_line_len
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

    cmp dh, 0x15
    jg scroll_up_four

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


scroll_up_four:
    mov al, 0x04
    jmp scroll_up

scroll_up_one:
    mov al, 0x01

scroll_up:
    ; Call BIOS get cursor
    mov ah, 03h
    int 10h

    ; Check if cursor is on the second line
    cmp dh, 0x03
    jl main

    ; Move cursor one line
    mov ah, 02h
    sub dh, al
    int 10h

    ; Call BIOS scroll up
    mov ah, 06h
    mov bh, 0x07
    mov cx, 0x00
    mov dx, 0x184F
    int 10h

    mov bh, 0x00

    jmp main

section .data
    sector_1 db "@@@FAF-213 Corneliu Catlabuga###"
    sector_1_len equ $ - sector_1
    sector_1_ch equ 0x38
    sector_1_dh equ 0x1
    sector_1_cl equ 0x8
    ;0xFF000 + 0x200
    

    sector_2 db "@@@FAF-213 Beatricia Golban###"
    sector_2_len equ $ - sector_2
    sector_2_ch equ 0x3F
    sector_2_dh equ 0x0
    sector_2_cl equ 0xE
    ; 0x11D000 + 0x200

    sector_3 db "@@@FAF-213 Gabriel Gitlan###"
    sector_3_len equ $ - sector_3
    sector_3_ch equ 0x40
    sector_3_dh equ 0x0
    sector_3_cl equ 0x8
    ; 0x120C00 + 0x200

    n_prompt db "N: ", 0
    n_len equ $ - n_prompt

    head_prompt db "Head: ", 0
    head_len equ $ - head_prompt

    track_prompt db "Track: ", 0
    track_len equ $ - track_prompt

    sector_prompt db "Sector: ", 0
    sector_len equ $ - sector_prompt

    new_line db 0x0D, 0x0A
    new_line_len equ $ - new_line

buffer: times 256 db 0x00
disk_sector: times 512 db 0x00
