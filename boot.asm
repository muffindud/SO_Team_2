[bits 16]
org 0x7C00

mov bx, 0x7E00
mov es, bx
mov bx, 0x0

mov ch, 0x0
mov dh, 0x0
mov cl, 0x2

read_loop:
    mov ah, 0x2
    mov al, 0x2
    int 0x13

    mov al, [sectors_to_read]
    mov ah, [sectors_read]
    cmp al, ah
    jle finish_read

    cmp cl, 0x12
    jl read_continue
    mov cl, 0x0
    add dh, 0x1

    cmp dh, 0x1
    jl read_continue
    mov dh, 0x0
    add ch, 0x1

    read_continue:
        add cl, 0x1
        mov ah, [sectors_read]
        add ah, 0x2
        mov [sectors_read], ah
        add bx, 0x200

    jmp read_loop

finish_read:
    mov ax, 0x7E00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7E00

jmp 0x7E00:0x0

; TODO: add disk read error handling

sectors_to_read db 0x20
sectors_read db 0x0

times 510-($-$$) db 0
dw 0xaa55
