ram_to_floppy:
    call clear_screen

    rtf_get_sectors:
        mov ax, 0x0
        mov [num_buffer], ax
        
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0x0
        int 10h

        call clear_row
        call print_volume_prompt

        call read_num

        cmp al, 0x1B
        je menu

        mov ax, [num_buffer]
        mov [volume], ax

    rtf_get_side:
        mov ax, 0x0
        mov [num_buffer], ax

        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xC
        int 10h

        call clear_row
        call print_side_prompt

        call read_num

        cmp al, 0x1B
        je menu

        mov ax, [num_buffer]
        mov [side], ax
    
        mov ax, [side]
        cmp ax, 0x2
        jl rtf_get_track

        call print_side_warning
        mov ax, 0x0
        mov [num_buffer], ax
        mov [side], ax
        jmp rtf_get_side

    rtf_get_track:
        mov ax, 0x0
        mov [num_buffer], ax
        
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xD
        int 10h

        call clear_row
        call print_track_prompt

        call read_num

        cmp al, 0x1B
        je menu

        mov ax, [num_buffer]
        mov [track], ax

        mov ax, [track]
        cmp ax, 0x12
        jg rtf_track_fault
        cmp ax, 0x0
        je rtf_track_fault
        jmp rtf_get_sector

        rtf_track_fault:
            call print_track_warning
            mov ax, 0x0
            mov [num_buffer], ax
            mov [track], ax
            jmp rtf_get_track

    rtf_get_sector:
        mov ax, 0x0
        mov [num_buffer], ax
        
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xE
        int 10h

        call clear_row
        call print_sector_prompt

        call read_num

        cmp al, 0x1B
        je menu
        
        mov ax, [num_buffer]
        mov [sector], ax

        mov ax, [sector]
        cmp ax, 0x50
        jl rft_get_address_1

        call print_sector_warning
        mov ax, 0x0
        mov [num_buffer], ax
        mov [sector], ax
        jmp rtf_get_sector
    
    rft_get_address_1:
        mov ax, 0x0
        mov [num_buffer], ax
        
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xF
        int 10h

        call clear_row
        call print_address_prompt

        call read_address

        cmp al, 0x1B
        je menu
        
        mov ax, [num_buffer]
        mov [xxxx], ax

    rft_get_address_2:
        mov ax, 0x0
        mov [num_buffer], ax

        mov ah, 0Eh
        mov al, ':'
        int 10h

        call read_address

        cmp al, 0x1B
        je menu
        
        mov ax, [num_buffer]
        mov [yyyy], ax

rtf_read_ram:
    call clear_screen

    mov ax, 1301h
    mov bl, 0x7
    mov cx, [volume]
    mov bp, [xxxx]
    mov es, bp
    mov bp, [yyyy]
    int 10h

    mov ah, 03h
    mov cl, [track]
    mov dh, [side]
    mov ch, [sector]
    mov bx, [xxxx]
    mov es, bx
    mov bx, [yyyy]
    int 13h

    push ax
    mov ah, 00h
    int 16h
    pop ax

    call clear_screen

    jnc rtf_write_success
    call print_error

rtf_write_success:
    jmp menu
