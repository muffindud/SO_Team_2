start:
    ; Write sector 1
    ; to 2041
    mov ah, 03h
    mov dl, 0x0
    mov al, 0x1
    mov ch, 0x38
    mov dh, 0x1
    mov cl, 0x8
    mov bx, sector_1
    int 13h

    ; to 2070
    mov ah, 03h
    mov dl, 0x0
    mov al, 0x1
    mov ch, 0x39
    mov dh, 0x1
    mov cl, 0x1
    mov bx, sector_1
    int 13h

    ; Write sector 2
    ; to 2281
    mov ah, 03h
    mov dl, 0x0
    mov al, 0x1
    mov ch, 0x3F
    mov dh, 0x0
    mov cl, 0xE
    mov bx, sector_2
    int 13h

    ; to 2310
    mov ah, 03h
    mov dl, 0x0
    mov al, 0x1
    mov ch, 0x40
    mov dh, 0x0
    mov cl, 0x7
    mov bx, sector_2
    int 13h

    ; Write sector 3
    ; to 2311
    mov ah, 03h
    mov dl, 0x0
    mov al, 0x1
    mov ch, 0x40
    mov dh, 0x0
    mov cl, 0x8
    mov bx, sector_3
    int 13h

    ; to 2340
    mov ah, 03h
    mov dl, 0x0
    mov al, 0x1
    mov ch, 0x41
    mov dh, 0x0
    mov cl, 0x1
    mov bx, sector_3
    int 13h

menu:
    call clear_screen

    mov ax, 1301h
    mov bx, 0x7
    mov bp, main_message
    mov cx, main_message_size
    mov dl, 0x0
    mov dh, 0x0
    int 10h

    mov ah, 00h
    int 16h

    cmp al, '1'
    je keyboard_to_floppy

    cmp al, '2'
    je floppy_to_ram

    cmp al, '3'
    je ram_to_floppy

    jmp unexpected_option

    jmp $

unexpected_option:
    call clear_screen

    mov ax, 1301h
    mov bx, 0x7
    mov bp, unexpected_option_message
    mov cx, unexpected_option_message_size
    mov dl, 0x0
    mov dh, 0x0
    int 10h

    mov ah, 00h
    int 16h

    jmp menu

keyboard_to_floppy:
    ; Clear the screen
    call clear_screen

    ; Move the buffer pointer to the start of the buffer
    mov si, ktf_buffer

    ; Print keyboard_to_floppy prompt
    mov ax, 1301h
    mov bx, 0x7
    mov bp, ktf_prompt
    mov cx, ktf_prompt_size
    mov dl, 0x0
    mov dh, 0x0
    int 10h

    ; Read the input
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
        mov ah, 0x0E
        int 10h

        jmp ktf_input

ktf_input_done:
    ; Check if the buffer is empty
    sub si, ktf_buffer
    jz menu

    ; Get the current cursor position
    mov ah, 03h
    int 10h

    ; Print the buffer
    mov ax, 1301h
    mov bx, 0x7
    mov bp, ktf_buffer
    mov cx, si
    mov dl, 0x0
    add dh, 0x2
    int 10h

    mov ax, 1301h
    mov bx, 0x7
    mov bp, side_prompt
    mov cx, side_prompt_size
    mov dl, 0x0
    add dh, 0x2
    int 10h

    get_side:
        mov ah, 00h
        int 16h

        cmp al, '0'
        jl get_side
        cmp al, '1'
        jg get_side

        mov ah, 0Eh
        int 10h

        sub al, 0x30
        mov [side], al
         
    mov ax, 1301h
    mov bx, 0x7
    mov bp, track_prompt
    mov cx, track_prompt_size
    mov dl, 0x0
    add dh, 0x1
    int 10h
    
    get_track:
        mov ah, 00h
        int 16h

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

            cmp al, '0'
            jl get_track_1
            cmp al, '8'
            jg get_track_1

            mov ah, 0Eh
            int 10h

            sub al, 0x30
            add [track], al

            jmp get_sector_prompt
    
    get_sector_prompt:
        mov ax, 1301h
        mov bx, 0x7
        mov bp, sector_prompt
        mov cx, sector_prompt_size
        mov dl, 0x0
        add dh, 0x1
        int 10h

    get_sector:
        mov ah, 00h
        int 16h

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

    mov ah, 03h
    mov dl, 0x0
    mov al, 0x1
    mov cl, [track]
    mov dh, [side]
    mov ch, [sector]
    mov bx, ktf_buffer
    int 13h

    jmp $

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

    ; Move the cursor back
    mov ah, 02h
    sub dl, 0x1
    int 10h

    ; Remove the character from the screen
    mov ah, 0Ah
    mov al, 0x0
    int 10h

    jmp ktf_input

ktf_bakcspace_no_newline:
    ; Move the cursor to the end of the previous line
    mov ah, 02h
    mov dl, 0x4F
    sub dh, 0x1
    int 10h

    ; Remove the character from the screen
    mov ah, 0Ah
    mov al, 0x0
    int 10h

    jmp ktf_input

floppy_to_ram:
        
    jmp menu

ram_to_floppy:
        
    jmp menu

clear_screen:
    mov ah, 07h
    mov al, 0x0
    mov bh, 0x7
    mov cx, 0x0
    mov dx, 0x184F
    int 10h
    ret

clear_last_char:
    mov ah, 03h
    int 10h

    mov ah, 02h
    sub dl, 0x1
    int 10h

    mov ah, 0Ah
    mov al, 0x0
    int 10h

    ret

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

section .data
    sector_1 db "@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###@@@FAF-213 Corneliu Catlabuga###"
    times 0x200 - ($ - sector_1) db 0x0

    sector_2 db "@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###@@@FAF-213 Beatricia Golban###"
    times 0x200 - ($ - sector_2) db 0x0

    sector_3 db "@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###@@@FAF-213 Gabriel Gitlan###"
    times 0x200 - ($ - sector_3) db 0x0

    main_message db "Please select an option: ", 0xA, 0xD, "1. Keyboard to Floppy", 0xA, 0xD, "2. Floppy to RAM", 0xA, 0xD, "3. RAM to Floppy", 0xA, 0xD, 0xA, 0xD, "Your option: "
    main_message_size equ $ - main_message

    unexpected_option_message db "Unexpected option!", 0xA, 0xD, 0xA, 0xD, "Press any key to continue..."
    unexpected_option_message_size equ $ - unexpected_option_message

    ktf_prompt db "Text: "
    ktf_prompt_size equ $ - ktf_prompt
    
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
