call write_names

jmp menu

ram_to_floppy:
    ; TODO
    jmp menu

%include "src/keyboard_to_floppy.asm"
%include "src/write_names.asm"
%include "src/menu.asm"
%include "src/floppy_params.asm"
%include "src/floppy_to_ram.asm"

; TODO: keyboard_to_floppy.asm
; TODO: Add repetition times
; TODO: Add retruing option
; TODO: Add buffer cleaning

; TODO: floppy_to_ram.asm
; TODO: Implement

; TODO: ram_to_floppy.asm
; TODO: Implement
