menu:
    call clear_screen

    mov ax, 0x7E00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7E00


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

clear_screen:
    pusha
    mov ah, 07h
    mov al, 0x0
    mov bh, 0x7
    mov cx, 0x0
    mov dx, 0x184F
    int 10h
    popa
    
    ret

section .data
    main_message db "Please select an option: ", 0xA, 0xD, "1. Keyboard to Floppy", 0xA, 0xD, "2. Floppy to RAM", 0xA, 0xD, "3. RAM to Floppy", 0xA, 0xD, 0xA, 0xD, "Your option: "
    main_message_size equ $ - main_message

    unexpected_option_message db "Unexpected option!", 0xA, 0xD, 0xA, 0xD, "Press any key to continue..."
    unexpected_option_message_size equ $ - unexpected_option_message

