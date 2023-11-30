remove_last_char:
    ; Move the cursor back
    mov ah, 02h
    sub dl, 0x1
    int 10h

    ; Remove the character from the screen
    mov ah, 0Ah
    mov al, 0x0
    int 10h

    ret

remove_last_char_line:
    ; Move the cursor to the end of the previous line
    mov ah, 02h
    mov dl, 0x4F
    sub dh, 0x1
    int 10h

    ; Remove the character from the screen
    mov ah, 0Ah
    mov al, 0x0
    int 10h

    ret

clear_row:
    mov ah, 03h
    int 10h 

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov bp, clean_row
    mov cx, 0x50
    int 10h

    ret

section .data
    clean_row times 0x50 db 0x0
