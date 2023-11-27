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

read_num:
    here:
    mov ah, 00h
    int 16h

    ; Check if the key is enter
    cmp al, 0x0D
    je read_num_return

    ; Check if the key is backspace
    cmp al, 0x08
    je read_num_backspace

    ; Check if the key is in range 0-9
    cmp al, 0x30
    jl read_num
    cmp al, 0x39
    jg read_num

    ; Add the character to the buffer
    sub al, 0x30
    mov cl, al
    mov ax, [num_buffer]

    cmp ax, 0xCCC
    je limit_num ; (accept between 0 and 5)
    cmp ax, 0xCCC
    jl accept_num
    ; cmp ax, 0xFFFF
    ; je read_num 

    jmp read_num

    accept_num:
        mov ax, [num_buffer]
        mov dx, 0xA
        mul dx
        add ax, cx
        mov [num_buffer], ax

        mov ah, 0Eh
        mov al, cl
        add al, 0x30
        int 10h

        jmp read_num

    read_num_return:
        ; mov cx, [num_buffer]
        ; cmp cx, 0x0
        ; je read_num
        ret

    read_num_backspace:
        ; Check if the buffer is empty
        mov dx, 0x0
        mov ax, [num_buffer]
        cmp ax, 0x0
        je read_num
        mov cx, 0xA
        div cx
        mov [num_buffer], ax
        
        pusha
        ; Remove the character from the screen
        mov ah, 03h
        mov bh, 0x0
        int 10h
        mov ah, 02h
        sub dl, 0x1
        int 10h
        mov ah, 0Ah
        mov al, 0x0
        int 10h
        popa

        ; jmp read_num
        jmp here

    limit_num:
        cmp cl, 0x5
        jg read_num
        jmp accept_num

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

print_side_warning:
    mov ah, 03h
    int 10h

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    add dh, 0x1
    mov bp, side_warning
    mov cx, side_warning_size
    int 10h

    mov ah, 02h
    sub dh, 0x1
    int 10h

    ret

print_track_warning:
    mov ah, 03h
    int 10h

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    add dh, 0x1
    mov bp, track_warning
    mov cx, track_warning_size
    int 10h

    mov ah, 02h
    sub dh, 0x1
    int 10h

    ret

print_sector_warning:
    mov ah, 03h
    int 10h

    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    add dh, 0x1
    mov bp, sector_warning
    mov cx, sector_warning_size
    int 10h

    mov ah, 02h
    sub dh, 0x1
    int 10h

    ret

read_address:
    ; TODO
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

    side_warning db "Side must be 0 or 1"
    side_warning_size equ $ - side_warning

    track_prompt db "Track(1-18): "
    track_prompt_size equ $ - track_prompt

    track_warning db "Track must be in range 1-18"
    track_warning_size equ $ - track_warning

    sector_prompt db "Sector(0-79): "
    sector_prompt_size equ $ - sector_prompt

    sector_warning db "Sector must be in range 0-79"
    sector_warning_size equ $ - sector_warning

    ktf_buffer times 0x100 db 0x0
    clean_row times 0x50 db 0x0
    
    num_buffer dw 0x0
    side dw 0x0
    track dw 0x0
    sector dw 0x0
