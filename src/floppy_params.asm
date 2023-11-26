section .data
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
    