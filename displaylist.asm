;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: displaylist.asm
;---------------------------------------
; DISPLAY LIST RAM BASED STUFF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DSP_LST1        = RAM1_STUFF
Z1              .byte $70,$70,$80,$70
                .byte $44,$00,$01       ; .DA #$44,PANEL
                .byte $04,$04,$04,$04
                .byte $44,$6B,$92       ; .DA #$44,NAVA.PANEL
                .byte $C4,$00,$03       ; .DA #$44+$80,PLAY_SCRN
                .byte $50,$20,$80
DSP_MAP         = *-Z1+RAM1_STUFF
MAP_LINES       = 17
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $74,$00,$00
                .byte $D4,$00,$00
                .byte $41,$90,$0C       ; .DA #$41,DSP_LST1
Z1_LEN          = *-Z1-1

NAVA_PANEL      .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00       ; whitespace
                .byte $AE,$CE,$A1,$C1,$B6,$D6,$A1,$C1                   ; 'NAVA'
                .byte $B4,$D4,$B2,$D2,$AF,$CF,$AE,$CE                   ; 'TRON'
                .byte $00,$00,$00,$00,$00,$00

PANEL           = RAM2_STUFF
Z2              .byte $00,$00,$00,$00,$00,$00,$00                       ; whitespace
                .byte $B3,$D3,$A3,$C3,$AF,$CF,$B2,$D2,$A5,$C5           ; 'SCORE'
                .byte $00,$00
SCORE_DIG       = *-Z2+RAM2_STUFF
                .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00
                .byte $A6,$C6,$B5,$D5,$A5,$C5,$AC,$CC                   ; 'FUEL'
                .byte $00,$00,$1A                                       ; '  :'
                .byte $5C,$5D,$5E,$5F,$60,$61,$62,$63,$64,$65,$66,$67
                .byte $1D,$00,$00                                       ; '=  '
                .byte $A2,$C2,$AF,$CF,$AE,$CE,$B5,$D5,$B3,$D3           ; 'BONUS'
                .byte $00,$00,$00,$00
FUEL_DIG        = *-Z2+RAM2_STUFF
                .byte $00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$1B                                       ; '  ;'
                .byte $68,$69,$6A,$6B,$6C,$6D,$6E,$6F,$70,$71,$72,$73
                .byte $1E,$00,$00,$00                                   ; '>   '
BONUS_DIG       = *-Z2+RAM2_STUFF
                .byte $00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00
                .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1C
                .byte $74,$75,$76,$77,$78,$79,$7A,$7B,$7C,$7D,$7E,$7F
                .byte $1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
Z2_LEN          = *-Z2-1

;---------------------------------------

DSP_LST2        .byte $70,$70,$80,$70
                .byte $44,$00,$01       ; .DA #$44,PANEL
                .byte $04,$04,$04,$04
                .byte $70,$70
                .byte $80,$50,$20
                .byte $44,$00,$03       ; .DA #$44,PLAY_SCRN
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04
                .byte $80,$70,$80
                .byte $41,$54,$93       ; .DA #$41,DSP_LST2

;---------------------------------------

DSP_LST3        .byte $70,$70,$70,$70,$70,$70
                .byte $44,$00,$03       ; .DA #$44,PLAY_SCRN
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04
                .byte $44,$00,$03       ; .DA #$44,PLAY_SCRN
                .byte $41,$7B,$93       ; .DA #$41,DSP_LST3

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
