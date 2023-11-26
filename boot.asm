; [bits 16]
org 0x7C00

mov [disk], dl
mov dh, 0x1

mov bx, 0x7E00
mov es, bx
mov bx, 0x0
mov dl, [disk]

mov ch, 0x0
mov dh, 0x0
mov cl, 0x2

mov ah, 0x2
mov al, 0x4
int 0x13

mov ax, 0x7E00
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7E00

mov dl, [disk]
jmp 0x7E00:0x0

; jmp 0x7E00:0x8000
; jmp start

disk db 0x0

times 510-($-$$) db 0
dw 0xaa55

; %include "lab3.asm"
