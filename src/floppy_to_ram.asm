floppy_to_ram:
    call clear_screen

    ; call print_esc_prompt

    ftr_get_side:
        mov ax, 0x0
        mov [num_buffer], ax

        mov ah, 02h
        mov dl, 0x0
        mov dh, 0x0
        int 10h

        call clear_row
        call print_side_prompt

        call read_num
        mov ax, [num_buffer]
        mov [side], ax
    
        mov ax, [side]
        cmp ax, 0x2
        jl ftr_get_track

        call print_side_warning
        mov ax, 0x0
        mov [num_buffer], ax
        mov [side], ax
        jmp ftr_get_side

    ; Prompt the user for track
    ftr_get_track:
        mov ax, 0x0
        mov [num_buffer], ax
        
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xD
        int 10h

        call clear_row
        call print_track_prompt

        call read_num
        mov ax, [num_buffer]
        mov [track], ax

        mov ax, [track]
        cmp ax, 0x12
        jg ftr_track_fault
        cmp ax, 0x0
        je ftr_track_fault
        jmp ftr_get_sector

        ftr_track_fault:
            call print_track_warning
            mov ax, 0x0
            mov [num_buffer], ax
            mov [track], ax
            jmp ftr_get_track
    
    ftr_get_sector:
        mov ax, 0x0
        mov [num_buffer], ax
        
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xE
        int 10h

        call clear_row
        call print_sector_prompt

        call read_num
        mov ax, [num_buffer]
        mov [sector], ax

        mov ax, [sector]
        cmp ax, 0x50
        jl ftr_get_address

        call print_sector_warning
        mov ax, 0x0
        mov [num_buffer], ax
        mov [sector], ax
        jmp ftr_get_sector

    ftr_get_address:
        mov ax, 0x0
        mov [num_buffer], ax
        
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xF
        int 10h

        call clear_row
        call print_address_prompt

        call read_address
        mov ax, [num_buffer]
        mov [xxxx], ax

        mov ax, [xxxx]
        cmp ax, 0x0
        je ftr_read_floppy

ftr_read_floppy:
    ; TODO
    jmp $
