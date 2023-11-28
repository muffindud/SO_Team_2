call write_names

jmp menu

ram_to_floppy:
    ; TODO
    jmp menu

%include "src/write_names.asm"

%include "src/menu.asm"

%include "src/keyboard_to_floppy.asm"
%include "src/floppy_to_ram.asm"

%include "src/prompts.asm"
%include "src/screen_routines.asm"

%include "src/string_convertors.asm"

%include "src/floppy_params.asm"

; TODO: keyboard_to_floppy.asm
; TODO: Add repetition times
; TODO: Add retruing option
; TODO: Add buffer cleaning

; TODO: floppy_to_ram.asm
; TODO: Implement

; TODO: ram_to_floppy.asm
; TODO: Implement
