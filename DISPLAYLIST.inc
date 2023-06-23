
; SPDX-FileName: DISPLAYLIST.inc
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


DSP_LST1        = RAM1_STUFF
Z1              ;!! .byte AEMPTY8
                ;!! .byte AEMPTY8
                ;!! .byte ADLI
                ;!! .byte AEMPTY8           ; color gradient

                .byte $04;!! +ALMS          ; Score Panel
                    .addr PANEL

                .byte $04,$04,$04,$04   ; 32 lines of 40 pixels (Navatron display)

                .byte $04;!! +ALMS          ; Navatron Panel
                    .addr NAVA_PANEL

                .byte $04;!! +ALMS+ADLI     ; Message Panel (low on fuel)
                    .addr PLAY_SCRN

                ;!! .byte AEMPTY6           ; color gradient
                ;!! .byte AEMPTY3
                ;!! .byte ADLI

DSP_MAP         = *-Z1+RAM1_STUFF
MAP_LINES       = 17
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000                     ; placeholder
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+AHSCR+AVSCR
                    .word $0000
                .byte $04;!! +ALMS+ADLI+AHSCR           ; no vertical scroll on bottom row
                    .word $0000

                ;!! .byte AVB+AJMP          ; vblank jump
                    .addr DSP_LST1

Z1_LEN          = *-Z1-1

;--------------------------------------

NAVA_PANEL      .byte $00,$00,$00,$00,$00,$00,$00,$00       ; whitespace
                .byte $00,$00,$00
                .byte $AE,$CE,$A1,$C1,$B6,$D6,$A1,$C1       ; 'NAVATRON'
                .byte $B4,$D4,$B2,$D2,$AF,$CF,$AE,$CE
                .byte $00,$00,$00,$00,$00,$00               ; ** intentional overrun [+7 bytes]

;- - - - - - - - - - - ----------------

PANEL           = RAM2_STUFF
Z2              .byte $00,$00,$00,$00,$00,$00,$00           ; whitespace

;--------------------- - - - - - - - - 

                .byte $B3,$D3,$A3,$C3,$AF,$CF,$B2,$D2       ; 'SCORE'
                .byte $A5,$C5
                .byte $00,$00                               ; ** intentional overrun (+21 bytes)

SCORE_DIG       = *-Z2+RAM2_STUFF
                .byte $00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00

;- - - - - - - - - - - ----------------

                .byte $00,$00,$00,$00,$00,$00,$00,$00       ; blank line
                .byte $00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00,$00,$00,$00

;--------------------------------------

                .byte $00,$00,$A6,$C6,$B5,$D5,$A5,$C5       ; '  FUEL  :'
                .byte $AC,$CC,$00,$00,$1A
                .byte $5C,$5D,$5E,$5F,$60,$61,$62,$63       ; <scanner>
                .byte $64,$65,$66,$67
                .byte $1D,$00,$00,$A2,$C2,$AF,$CF,$AE       ; '=  BONUS  '
                .byte $CE,$B5,$D5,$B3,$D3,$00,$00

;--------------------------------------

                .byte $00,$00                               ; '  '

FUEL_DIG        = *-Z2+RAM2_STUFF
                .byte $00,$00,$00,$00,$00,$00,$00,$00       ; 'xxxxxxxx  ;'
                .byte $00,$00,$1B
                .byte $68,$69,$6A,$6B,$6C,$6D,$6E,$6F       ; <scanner>
                .byte $70,$71,$72,$73
                .byte $1E,$00,$00,$00                       ; '>   '    ** intentional overrun (+11 bytes)

;--------------------- - - - - - - - - 

BONUS_DIG       = *-Z2+RAM2_STUFF
                .byte $00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00

;- - - - - - - - - - - ----------------

                .byte $00,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$1C
                .byte $74,$75,$76,$77,$78,$79,$7A,$7B       ; <scanner>
                .byte $7C,$7D,$7E,$7F
                .byte $1F,$00,$00,$00,$00,$00,$00,$00
                .byte $00,$00,$00,$00,$00,$00,$00

;--------------------------------------

Z2_LEN          = *-Z2-1


;--------------------------------------
; Options Screen
;--------------------------------------
DSP_LST2        ;!! .byte AEMPTY8           ; 25 blank lines
                ;!! .byte AEMPTY8
                ;!! .byte ADLI
                ;!! .byte AEMPTY8

                .byte $04;!! +ALMS          ; 40 lines of 40 pixels
                    .addr PANEL
                .byte $04,$04,$04,$04

                ;!! .byte AEMPTY8           ; 26 blank lines
                ;!! .byte AEMPTY8
                ;!! .byte ADLI
                ;!! .byte AEMPTY6
                ;!! .byte AEMPTY3

                .byte $04;!! +ALMS          ; 120 lines of 40 pixels
                    .addr PLAY_SCRN
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04

                ;!! .byte ADLI              ; 10 blank lines
                ;!! .byte AEMPTY8
                ;!! .byte ADLI

                ;!! .byte AVB+AJMP          ; vblank jump
                    .addr DSP_LST2

;--------------------------------------
; Title Screen
;--------------------------------------
DSP_LST3        ;!! .byte AEMPTY8           ; 48 blank lines
                ;!! .byte AEMPTY8
                ;!! .byte AEMPTY8
                ;!! .byte AEMPTY8
                ;!! .byte AEMPTY8
                ;!! .byte AEMPTY8

                .byte $04;!! +ALMS          ; 152 lines of 40 pixels
                    .addr PLAY_SCRN
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04
                .byte $04;!! +ALMS
                    .addr PLAY_SCRN

                ;!! .byte AVB+AJMP          ; vblank jump
                    .addr DSP_LST3

