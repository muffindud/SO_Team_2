keyboard_to_floppy:
    ; Clear the screen
    call clear_screen

    ; Move the buffer pointer to the start of the buffer
    mov si, ktf_buffer

    ; Print the escape prompt
    call print_esc_prompt

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
        cmp si, ktf_buffer + 0x100
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
    sub si, ktf_buffer
    jz menu

    ; Get the current cursor position
    mov ah, 03h
    int 10h

    ; Print reset prompt
    call print_reset_prompt

    ; Print the buffer
    call print_buffer
    
    ; Prompt the user for side
    get_side:
        mov ah, 02h
        mov dl, 0x0
        mov dh, 0xC
        int 10h

        call clear_row
        call print_side_prompt

        call read_num
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

    
    ; TODO: Adapt to the new buffer
    ; Prompt the user for track
    call print_track_prompt
    
    get_track:
        mov ah, 00h
        int 16h

        ; Check if reset was pressed
        cmp al, 'r'
        je reset
        cmp al, 'R'
        je reset

        ; Check if escape was pressed
        cmp al, 0x1B
        je escape

        cmp al, '0'
        jl get_track
        cmp al, '1'
        jg get_track

        mov ah, 0Eh
        int 10h

        sub al, 0x30
        call multiply_by_10
        mov [track], al

        cmp al, 0xA
        je get_track_1

        ; Get the second digit of the track when the first digit is 0
        get_track_0:
            mov ah, 00h
            int 16h

            ; Check if reset was pressed
            cmp al, 'r'
            je reset
            cmp al, 'R'
            je reset

            ; Check if escape was pressed
            cmp al, 0x1B
            je escape


            cmp al, '1'
            jl get_track_0
            cmp al, '9'
            jg get_track_0

            mov ah, 0Eh
            int 10h

            sub al, 0x30
            add [track], al

            jmp get_sector_prompt

        ; Get the second digit of the track when the first digit is 1
        get_track_1:
            mov ah, 00h
            int 16h

            ; Check if reset was pressed
            cmp al, 'r'
            je reset
            cmp al, 'R'
            je reset

            ; Check if escape was pressed
            cmp al, 0x1B
            je escape

            cmp al, '0'
            jl get_track_1
            cmp al, '8'
            jg get_track_1

            mov ah, 0Eh
            int 10h

            sub al, 0x30
            add [track], al

            jmp get_sector_prompt
    
    ; Prompt the user for sector
    get_sector_prompt:
        call print_sector_prompt
        
    get_sector:
        mov ah, 00h
        int 16h

        ; Check if reset was pressed
        cmp al, 'r'
        je reset
        cmp al, 'R'
        je reset

        ; Check if escape was pressed
        cmp al, 0x1B
        je escape

        cmp al, '0'
        jl get_sector
        cmp al, '7'
        jg get_sector

        mov ah, 0Eh
        int 10h

        sub al, 0x30
        call multiply_by_10
        mov [sector], al

        cmp al, 0x46
        je get_sector_1

        ; Get the second digit of the sector when the first digit is 0
        get_sector_0:
            mov ah, 00h
            int 16h

            ; Check if reset was pressed
            cmp al, 'r'
            je reset
            cmp al, 'R'
            je reset

            ; Check if escape was pressed
            cmp al, 0x1B
            je escape

            cmp al, '0'
            jl get_sector_0
            cmp al, '9'
            jg get_sector_0

            mov ah, 0Eh
            int 10h

            sub al, 0x30
            add [sector], al

            jmp write_to_floppy
        
        ; Get the second digit of the sector when the first digit is 1-7
        get_sector_1:
            mov ah, 00h
            int 16h

            ; Check if reset was pressed
            cmp al, 'r'
            je reset
            cmp al, 'R'
            je reset

            ; Check if escape was pressed
            cmp al, 0x1B
            je escape

            cmp al, '0'
            jl get_sector_1
            cmp al, '9'
            jg get_sector_1

            mov ah, 0Eh
            int 10h

            sub al, 0x30
            add [sector], al

            jmp write_to_floppy

write_to_floppy:
    ; TODO: Add the times functionality

    ; Write to floppy
    mov ah, 03h
    mov dl, 0x0
    mov al, 0x1
    mov cl, [track]
    mov dh, [side]
    mov ch, [sector]
    mov bx, ktf_buffer
    int 13h

    mov si, ktf_buffer

clear_buffer:
    mov byte [si], 0x0
    add si, 0x1

    cmp si, ktf_buffer + 0x100
    jne clear_buffer

    jmp menu

ktf_bakcspace:
    ; Get the current cursor position
    mov ah, 03h
    int 10h

    ; Check if the cursor is at the start of buffer
    cmp si, ktf_buffer
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

reset:
    call clear_screen
    jmp keyboard_to_floppy

escape:
    mov si, ktf_buffer
    jmp clear_buffer

multiply_by_10:
    mov ah, al
    add al, ah
    add al, ah
    add al, ah
    add al, ah
    add al, ah
    add al, ah
    add al, ah
    add al, ah
    add al, ah
    ret
