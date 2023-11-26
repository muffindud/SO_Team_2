; lab3.asm

; nasm -f bin -o lab3.img lab3.asm
; trucate lab3.img -S 1474560

; BIOS loads boot sector to 0x7C00
org 0x7C00

start:
    ; Write sector 1
    ; to 2041
    mov ah, 03h
    mov al, 0x1
    mov ch, 0x38
    mov dh, 0x1
    mov cl, 0x8
    mov bx, sector_1
    int 13h

    ; to 2070
    mov ah, 03h
    mov al, 0x1
    mov ch, 0x39
    mov dh, 0x1
    mov cl, 0x1
    mov bx, sector_1
    int 13h

    jmp $

section .data
    sector_1 db "@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###"
    times 0x200 - ($ - sector_1) db 0x00
