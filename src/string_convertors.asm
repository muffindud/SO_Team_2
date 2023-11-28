read_num:
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

        jmp read_num

    limit_num:
        cmp cl, 0x5
        jg read_num
        jmp accept_num

read_address:
    mov ah, 00h
    int 16h

    cmp al, 0x0D
    je read_address_return

    cmp al, 0x08
    je read_address_backspace

    cmp al, 0x30
    jl read_address

    cmp al, 0x3A
    jl handle_number

    cmp al, 0x41
    jl read_address

    cmp al, 0x47
    jl handle_uppercase

    cmp al, 0x61
    jl read_address

    cmp al, 0x67
    jl handle_lowercase

    jmp read_address

    handle_number:
        sub al, 0x30
        jmp handle_value

    handle_uppercase:
        sub al, 0x37
        jmp handle_value

    handle_lowercase:
        sub al, 0x57
        jmp handle_value

    handle_value:
        mov cl, al

        mov ax, [num_buffer]
        cmp ax, 0xFFF
        ja read_address

        mov dx, 0x10
        mul dx
        add ax, cx
        mov [num_buffer], ax

        mov ah, 0Eh
        mov al, cl
        cmp cx, 0x9
        jg print_letter

            add al, 0x30
            int 10h

            jmp read_address

        print_letter:
            add al, 0x37

            int 10h

            jmp read_address

    read_address_return:
        ret
    
    read_address_backspace:
        mov dx, 0x0
        mov ax, [num_buffer]
        cmp ax, 0x0
        je read_address
        mov cx, 0x10
        div cx
        mov [num_buffer], ax
        
        pusha
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

        jmp read_address
