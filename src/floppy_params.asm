section .data
    num_buffer dw 0x0
    sectors dw 0x0
    write_times dw 0x0
    volume dw 0x0
    side dw 0x0
    track dw 0x0
    sector dw 0x0
    xxxx dw 0x0
    yyyy dw 0x0

    dw "--"
    temp_byte_ax dw 0x0
    dw "--"
    temp_byte_dx dw 0x0
    dw "--"

    clean_row times 0x50 db 0x0

    buffer times 0x100 db 0x0

    floppy_buffer db 0x0
