call write_names

jmp menu

floppy_to_ram:
    ; TODO
    jmp menu

ram_to_floppy:
    ; TODO
    jmp menu

%include "src/keyboard_to_floppy.asm"
%include "src/write_names.asm"
%include "src/menu.asm"
%include "src/floppy_params.asm"
