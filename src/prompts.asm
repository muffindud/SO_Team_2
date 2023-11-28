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
    mov bp, buffer
    mov cx, si
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

print_address_prompt:
    mov ax, 1301h
    mov bx, 0x7
    mov dl, 0x0
    mov dh, 0xF
    mov bp, address_prompt
    mov cx, address_prompt_size
    int 10h

    ret

section .data
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

    address_prompt db "Address(0-FFFF:0-FFFF): "
    address_prompt_size equ $ - address_prompt


