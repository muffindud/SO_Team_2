floppy_to_ram:
    call clear_screen

    ; Prompt the user for sectors
    ftr_get_sectors:
        mov ax, 0x0
        mov [num_buffer], ax

        mov ah, 02h
        mov dl, 0x0
        mov dh, 0x0
        int 10h

        call clear_row
        call print_sectors_prompt

        call read_num

        cmp al, 0x1B
        je menu
        
        mov ax, [num_buffer]
        mov [sectors], ax

    ; Prompt the user for side
    ftr_get_side:
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

        cmp al, 0x1B
        je menu
        
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

        cmp al, 0x1B
        je menu
        
        mov ax, [num_buffer]
        mov [sector], ax

        mov ax, [sector]
        cmp ax, 0x50
        jl ftr_get_address_1

        call print_sector_warning
        mov ax, 0x0
        mov [num_buffer], ax
        mov [sector], ax
        jmp ftr_get_sector

    ftr_get_address_1:
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
    
    ftr_get_address_2:
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

ftr_read_floppy:
    mov ah, 02h
    mov dl, 0x0
    mov al, [sectors]
    mov cl, [track]
    mov dh, [side]
    mov ch, [sector]

    mov bx, [xxxx]
    mov es, bx
    mov bx, [yyyy]

    int 13h

    call clear_screen

    jnc ftr_read_success
    call print_error

ftr_read_success:
    mov dx, [sectors]

    mov bp, [xxxx]
    mov es, bp
    mov bp, [yyyy]

    ftr_print_loop:
        push dx
        call clear_screen
        mov ax, 1301h
        mov bx, 0x7
        mov cx, 0x200
        mov dh, 0x0
        mov dl, 0x0
        int 10h
        pop dx

        sub dx, 0x1
        add bp, 0x200

        mov ah, 00h
        int 16h

        cmp dx, 0x0
        jne ftr_print_loop

    jmp menu
