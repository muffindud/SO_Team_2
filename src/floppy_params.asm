print_esc_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0x0
    mov bp, escape_prompt
    mov cx, escape_prompt_size
    int 10h
    
    ret

print_text_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0x2
    mov bp, text_prompt
    mov cx, text_prompt_size
    int 10h
    
    ret

print_buffer:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0x6
    mov bp, ktf_buffer
    mov cx, si
    int 10h
    
    ret

print_reset_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xA
    mov bp, reset_prompt
    mov cx, reset_prompt_size
    int 10h
    
    ret

print_side_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xC
    mov bp, side_prompt
    mov cx, side_prompt_size
    int 10h
    
    ret

print_track_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xD
    mov bp, track_prompt
    mov cx, track_prompt_size
    int 10h

    ret

print_sector_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xE
    mov bp, sector_prompt
    mov cx, sector_prompt_size
    int 10h

    ret

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

section .data
    escape_prompt db "Press ESC to cancel"
    escape_prompt_size equ $ - escape_prompt

    reset_prompt db "Press R to reset"
    reset_prompt_size equ $ - reset_prompt

    text_prompt db "Text: "
    text_prompt_size equ $ - text_prompt
    
    side_prompt db "Side(0-1): "
    side_prompt_size equ $ - side_prompt

    track_prompt db "Track(01-18): "
    track_prompt_size equ $ - track_prompt

    sector_prompt db "Sector(00-79): "
    sector_prompt_size equ $ - sector_prompt

    ktf_buffer times 0x100 db 0x0

    side db 0x0
    track db 0x0
    sector db 0x0
    