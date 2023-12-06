keyboard_to_floppy:
    ; Clear the screen
    call clear_screen

    ; Move the buffer pointer to the start of the buffer
    mov si, buffer

    ; Print text prompt
    call print_text_prompt

    ; ; Read the input
    ktf_input:
        ; Call keyboard in
        mov ah, 00h
        int 16h

        ; Check if enter was pressed
        cmp al, 0x0D
        je ktf_input_done
    
        ; Check if backspace was pressed
        cmp al, 0x08
        je ktf_bakcspace

        ; Check if escape was pressed
        cmp al, 0x1B
        je escape

        ; Check if the buffer is full
        cmp si, buffer + 0x100
        je ktf_input

        ; Check if the character is in printable ASCII limit
        cmp al, 0x20
        jl ktf_input
        cmp al, 0x7E
        jg ktf_input

        ; Store the character in the buffer
        mov [si], al
        add si, 0x1

        ; Print the character
        mov ah, 0Eh
        int 10h

        jmp ktf_input

ktf_input_done:
    ; Check if the buffer is empty
    sub si, buffer
    jz menu

    ; Get the current cursor position
    mov ah, 03h
    int 10h

    ; Print the buffer
    call print_buffer
    
    ; Prompt the user for side
    get_side:
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
        je escape
        
        mov ax, [num_buffer]
        mov [side], ax
    
        mov ax, [side]
        cmp ax, 0x2
        jl get_track

        call print_side_warning
        mov ax, 0x0
        mov [num_buffer], ax
        mov [side], ax
        jmp get_side

    ; Prompt the user for track
    get_track:
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
        je escape
        
        mov ax, [num_buffer]
        mov [track], ax

        mov ax, [track]
        cmp ax, 0x12
        jg track_fault
        cmp ax, 0x0
        je track_fault
        jmp get_sector

        track_fault:
            call print_track_warning
            mov ax, 0x0
            mov [num_buffer], ax
            mov [track], ax
            jmp get_track
    
    get_sector:
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
        je escape
        
        mov ax, [num_buffer]
        mov [sector], ax

        mov ax, [sector]
        cmp ax, 0x50
        jl get_times

        call print_sector_warning
        mov ax, 0x0
        mov [num_buffer], ax
        mov [sector], ax
        jmp get_sector

    get_times:
        mov ax, 0x0
        mov [num_buffer], ax
        
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xF
        int 10h

        call clear_row
        call print_times_prompt

        call read_num

        mov ax, [num_buffer]
        mov [write_times], ax

        mov ax, [write_times]
        cmp ax, 0x7531
        jl write_to_floppy

        call print_times_warning
        mov ax, 0x0
        mov [num_buffer], ax
        mov [write_times], ax
        jmp get_times

write_to_floppy:
    ; TODO: Add the times functionality

    mov di, floppy_buffer
    mov ax, [write_times]

    repeated_wirte:
        mov si, buffer
        cmp ax, 0x0
        je to_floppy
        sub ax, 0x1

        char_wirte:
            mov cl, [si]
            mov [di], cl
            add si, 0x1
            add di, 0x1

            cmp byte [si], 0x0
            je repeated_wirte
            jmp char_wirte

    to_floppy:
        ; Write to floppy
        mov ah, 03h
        mov dl, 0x0
        mov al, 0x1 ; TODO: Check if works
        mov cl, [track]
        mov dh, [side]
        mov ch, [sector]
        mov bx, floppy_buffer
        int 13h

        call clear_screen

        mov ax, 1301h
        mov bx, 0x7
        mov cx, 512
        mov dx, 0x0
        mov bp, floppy_buffer
        int 10h

        mov ah, 0
        int 16h

    call clear_screen

    jnc ktf_write_success
    call print_error

ktf_write_success:
    mov si, buffer

clear_buffer:
    mov byte [si], 0x0
    add si, 0x1

    cmp si, buffer + 0x100
    jne clear_buffer

    jmp menu

ktf_bakcspace:
    ; Get the current cursor position
    mov ah, 03h
    int 10h

    ; Check if the cursor is at the start of buffer
    cmp si, buffer
    je ktf_input

    sub si, 0x1
    mov byte [si], 0x0

    ; Check if the cursor is at the start of line
    cmp dl, 0x0
    jz ktf_bakcspace_no_newline

    call remove_last_char

    jmp ktf_input

ktf_bakcspace_no_newline:
    call remove_last_char_line

    jmp ktf_input

escape:
    mov si, buffer
    jmp clear_buffer
