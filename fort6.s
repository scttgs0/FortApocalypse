;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT6.S
;---------------------------------------
; DATA, SHAPES, DISPLAY LISTS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;---------------------------------------
; Options Screen
;---------------------------------------
DSP_LST2        .byte AEMPTY8           ; 25 blank lines
                .byte AEMPTY8
                .byte ADLI
                .byte AEMPTY8

                .byte $04+ALMS          ; 40 lines of 40 pixels
                    .addr PANEL
                .byte $04,$04,$04,$04

                .byte AEMPTY8           ; 26 blank lines
                .byte AEMPTY8
                .byte ADLI
                .byte AEMPTY6
                .byte AEMPTY3

                .byte $04+ALMS          ; 120 lines of 40 pixels
                    .addr PLAY_SCRN
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04

                .byte ADLI              ; 10 blank lines
                .byte AEMPTY8
                .byte ADLI

                .byte AVB+AJMP          ; vblank jump
                    .addr DSP_LST2

;---------------------------------------
; Title Screen
;---------------------------------------
DSP_LST3        .byte AEMPTY8           ; 48 blank lines
                .byte AEMPTY8
                .byte AEMPTY8
                .byte AEMPTY8
                .byte AEMPTY8
                .byte AEMPTY8

                .byte $04+ALMS          ; 152 lines of 40 pixels
                    .addr PLAY_SCRN
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04,$04,$04,$04
                .byte $04
                .byte $04+ALMS
                    .addr PLAY_SCRN

                .byte AVB+AJMP          ; vblank jump
                    .addr DSP_LST3


;=======================================
;
;=======================================
CartridgeStart  .proc
;v_???          .var ADR1
;---

                sei
                lda #$B3
                pha
                ldx #$00
                txa
_next1          sta $0000,x             ; zero-page
                sta HPOSP0,x
                sta DMACLT,x
                sta AUDF1,x
                sta PORTA,x
                inx
                bne _next1

                ldy #$01
                sty ADR1+1
                dey                     ; Y=0
                sty ADR1
_next2          sta (ADR1),y
                iny
                bne _next2

                inc ADR1+1
                ldx ADR1+1
                cpx #$C0
                bne _next2

                lda #$34
                pha
                ldx #$00
_next3          lda BOOT_STUFF,x
                sta $01C0,x             ; L01C0
                inx
                bpl _next3

                cli
                rts
                .endproc

;---------------------------------------
;---------------------------------------

CHOPPER_SHAPES  .addr CL3_1,CL3_2       ; 0   ANGLE
                .addr CL2_1,CL2_2       ; 2
                .addr CL1_1,CL1_2       ; 4

                .addr CM1_1,CM1_2       ; 6
                .addr CM1_1,CM1_2       ; 8
                .addr CM1_1,CM1_2       ; 10

                .addr CR1_1,CR1_2       ; 12
                .addr CR2_1,CR2_2       ; 14
                .addr CR3_1,CR3_2       ; 16

;---------------------------------------
; Chopper Left-facing
;---------------------------------------
CL1_1           .byte $00,$00,$FF,$01,$01,$0F,$11,$21,$31                   ; ........ ........
                .byte $7F,$70,$3F,$1F,$10,$A0,$7F,$00,$00                   ; ........ ........
                                                                            ; ######## ##......
                .byte $00,$00,$C0,$00,$02,$02,$82,$FE,$0F                   ; .......# ........
                .byte $79,$61,$C1,$C0,$40,$20,$FC           ;,$00,$00       ; .......# ......#.
                                                                            ; ....#### ......#.
                                                                            ; ...#...# #.....#.
                                                                            ; ..#....# #######.
                                                                            ; ..##...# ....####
                                                                            ; .####### .####..#
                                                                            ; .###.... .##....#
                                                                            ; ..###### ##.....#
                                                                            ; ...##### ##......
                                                                            ; ...#.... .#......
                                                                            ; #.#..... ..#.....
                                                                            ; .####### ######..
                                                                            ; ........
                                                                            ; ........

CL1_2           .byte $00,$00,$07,$01,$01,$0F,$11,$21,$31                   ; ........ ........
                .byte $7F,$70,$3F,$1F,$10,$A0,$7F,$00,$00                   ; ........ ........
                                                                            ; .....### #######.
                .byte $00,$00,$FE,$00,$01,$01,$81,$FF,$0E                   ; .......# ........
                .byte $7A,$62,$C2,$C0,$40,$20,$FC           ;,$00,$00       ; .......# .......#
                                                                            ; ....#### .......#
                                                                            ; ...#...# #......#
                                                                            ; ..#....# ########
                                                                            ; ..##...# ....###.
                                                                            ; .####### .####.#.
                                                                            ; .###.... .##...#.
                                                                            ; ..###### ##....#.
                                                                            ; ...##### ##......
                                                                            ; ...#.... .#......
                                                                            ; #.#..... ..#.....
                                                                            ; .####### ######..
                                                                            ; ........
                                                                            ; ........

CL2_1           .byte $00,$00,$07,$F9,$01,$07,$09,$11,$21                   ; ........ ........
                .byte $37,$7C,$73,$3F,$18,$10,$A7,$78,$00                   ; ........ ........
                                                                            ; .....### ##......
                .byte $00,$00,$C0,$02,$02,$02,$9E,$FF,$19                   ; #####..# ......#.
                .byte $71,$61,$C0,$C0,$60,$3C,$C0           ;,$00,$00       ; .......# ......#.
                                                                            ; .....### ......#.
                                                                            ; ....#..# #..####.
                                                                            ; ...#...# ########
                                                                            ; ..#....# ...##..#
                                                                            ; ..##.### .###...#
                                                                            ; .#####.. .##....#
                                                                            ; .###..## ##......
                                                                            ; ..###### ##......
                                                                            ; ...##... .##.....
                                                                            ; ...#.... ..####..
                                                                            ; #.#..### ##......
                                                                            ; .####...
                                                                            ; ........

CL2_2           .byte $00,$00,$07,$01,$01,$07,$09,$11,$21                   ; ........ ........
                .byte $37,$7C,$73,$3F,$18,$10,$A7,$78,$00                   ; ........ ..#####.
                                                                            ; .....### ##......
                .byte $00,$3E,$C0,$01,$01,$01,$9F,$FE,$1A                   ; .......# .......#
                .byte $72,$62,$C0,$C0,$60,$3C,$C0           ;,$00,$00       ; .......# .......#
                                                                            ; .....### .......#
                                                                            ; ....#..# #..#####
                                                                            ; ...#...# #######.
                                                                            ; ..#....# ...##.#.
                                                                            ; ..##.### .###..#.
                                                                            ; .#####.. .##...#.
                                                                            ; .###..## ##......
                                                                            ; ..###### ##......
                                                                            ; ...##... .##.....
                                                                            ; ...#.... ..####..
                                                                            ; #.#..### ##......
                                                                            ; .####...
                                                                            ; ........

CL3_1           .byte $00,$00,$03,$3D,$C1,$03,$0D,$11,$21                   ; ........ ........
                .byte $23,$6E,$79,$67,$3E,$10,$11,$9E,$60                   ; ........ ........
                                                                            ; ......## #.......
                .byte $00,$00,$80,$02,$02,$02,$8E,$FF,$39                   ; ..####.# ......#.
                .byte $61,$61,$C0,$C0,$60,$3C,$E0           ;,$00,$00       ; ##.....# ......#.
                                                                            ; ......## ......#.
                                                                            ; ....##.# #...###.
                                                                            ; ...#...# ########
                                                                            ; ..#....# ..###..#
                                                                            ; ..#...## .##....#
                                                                            ; .##.###. .##....#
                                                                            ; .####..# ##......
                                                                            ; .##..### ##......
                                                                            ; ..#####. .##.....
                                                                            ; ...#.... ..####..
                                                                            ; ...#...# ###.....
                                                                            ; #..####.
                                                                            ; .##.....

CL3_2           .byte $00,$00,$03,$01,$01,$03,$0D,$11,$21                   ; ........ .....##.
                .byte $23,$6E,$79,$67,$3E,$10,$11,$9E,$60                   ; ........ .####...
                                                                            ; ......## #.......
                .byte $06,$78,$80,$01,$01,$01,$8F,$FE,$3A                   ; .......# .......#
                .byte $62,$62,$C0,$C0,$60,$3C,$E0           ;,$00,$00       ; .......# .......#
                                                                            ; ......## .......#
                                                                            ; ....##.# #...####
                                                                            ; ...#...# #######.
                                                                            ; ..#....# ..###.#.
                                                                            ; ..#...## .##...#.
                                                                            ; .##.###. .##...#.
                                                                            ; .####..# ##......
                                                                            ; .##..### ##......
                                                                            ; ..#####. .##.....
                                                                            ; ...#.... ..####..
                                                                            ; ...#...# ###.....
                                                                            ; #..####.
                                                                            ; .##.....

;---------------------------------------
; Chopper Middle-facing
;---------------------------------------
CM1_1           .byte $00,$00,$07,$00,$00,$01,$03,$06,$04                   ; ........ ........
                .byte $08,$0D,$07,$03,$04,$08,$1C,$00,$00                   ; ........ ........
                                                                            ; .....### ########
                .byte $00,$00,$FF,$80,$80,$C0,$E0,$30,$10                   ; ........ #.......
                .byte $08,$D8,$F0,$E0,$10,$08,$1C           ;,$00,$00       ; ........ #.......
                                                                            ; .......# ##......
                                                                            ; ......## ###.....
                                                                            ; .....##. ..##....
                                                                            ; .....#.. ...#....
                                                                            ; ....#... ....#...
                                                                            ; ....##.# ##.##...
                                                                            ; .....### ####....
                                                                            ; ......## ###.....
                                                                            ; .....#.. ...#....
                                                                            ; ....#... ....#...
                                                                            ; ...###.. ...###..
                                                                            ; ........
                                                                            ; ........

CM1_2           .byte $00,$00,$7F,$00,$00,$01,$03,$06,$04                   ; ........ ........
                .byte $08,$0D,$07,$03,$04,$08,$1C,$00,$00                   ; ........ ........
                                                                            ; .####### ###.....
                .byte $00,$00,$E0,$80,$80,$C0,$E0,$30,$10                   ; ........ #.......
                .byte $08,$D8,$F0,$E0,$10,$08,$1C           ;,$00,$00       ; ........ #.......
                                                                            ; .......# ##......
                                                                            ; ......## ###.....
                                                                            ; .....##. ..##....
                                                                            ; .....#.. ...#....
                                                                            ; ....#... ....#...
                                                                            ; ....##.# ##.##...
                                                                            ; .....### ####....
                                                                            ; ......## ###.....
                                                                            ; .....#.. ...#....
                                                                            ; ....#... ....#...
                                                                            ; ...###.. ...###..
                                                                            ; ........
                                                                            ; ........

;---------------------------------------
; Chopper Right-facing
;---------------------------------------
CR1_1           .byte $00,$00,$03,$00,$40,$40,$41,$7F,$F0                   ; ........ ........
                .byte $9E,$86,$83,$03,$02,$04,$3F,$00,$00                   ; ........ ........
                                                                            ; ......## ########
                .byte $00,$00,$FF,$80,$80,$F0,$88,$84,$8C                   ; ........ #.......
                .byte $FE,$0E,$FC,$F8,$08,$05,$FE           ;,$00,$00       ; .#...... #.......
                                                                            ; .#...... ####....
                                                                            ; .#.....# #...#...
                                                                            ; .####### #....#..
                                                                            ; ####.... #...##..
                                                                            ; #..####. #######.
                                                                            ; #....##. ....###.
                                                                            ; #.....## ######..
                                                                            ; ......## #####...
                                                                            ; ......#. ....#...
                                                                            ; .....#.. .....#.#
                                                                            ; ..###### #######.
                                                                            ; ........
                                                                            ; ........

CR1_2
                .byte $00,$00,$7F,$00,$80,$80,$81,$FF,$70                   ; ........ ........
                .byte $5E,$46,$43,$03,$02,$04,$3F,$00,$00                   ; ........ ........
                                                                            ; .####### ###.....
                .byte $00,$00,$E0,$80,$80,$F0,$88,$84,$8C                   ; ........ #.......
                .byte $FE,$0E,$FC,$F8,$08,$05,$FE           ;,$00,$00       ; #....... #.......
                                                                            ; #....... ####....
                                                                            ; #......# #...#...
                                                                            ; ######## #....#..
                                                                            ; .###.... #...##..
                                                                            ; .#.####. #######.
                                                                            ; .#...##. ....###.
                                                                            ; .#....## ######..
                                                                            ; ......## #####...
                                                                            ; ......#. ....#...
                                                                            ; .....#.. .....#.#
                                                                            ; ..###### #######.
                                                                            ; ........
                                                                            ; ........

CR2_1           .byte $00,$00,$03,$40,$40,$40,$79,$FF,$98                   ; ........ ........
                .byte $8E,$86,$03,$03,$06,$3C,$03,$00,$00                   ; ........ ........
                                                                            ; ......## ###.....
                .byte $00,$00,$E0,$9F,$80,$E0,$90,$88,$84                   ; .#...... #..#####
                .byte $EC,$3E,$CE,$FC,$18,$08,$E5,$1E           ;,$00       ; .#...... #.......
                                                                            ; .#...... ###.....
                                                                            ; .####..# #..#....
                                                                            ; ######## #...#...
                                                                            ; #..##... #....#..
                                                                            ; #...###. ###.##..
                                                                            ; #....##. ..#####.
                                                                            ; ......## ##..###.
                                                                            ; ......## ######..
                                                                            ; .....##. ...##...
                                                                            ; ..####.. ....#...
                                                                            ; ......## ###..#.#
                                                                            ; ........ ...####.
                                                                            ; ........

CR2_2           .byte $00,$7C,$03,$80,$80,$80,$F9,$7F,$58                   ; ........ ........
                .byte $4E,$46,$03,$03,$06,$3C,$03,$00,$00                   ; .#####.. ........
                                                                            ; ......## ###.....
                .byte $00,$00,$E0,$80,$80,$E0,$90,$88,$84                   ; #....... #.......
                .byte $EC,$3E,$CE,$FC,$18,$08,$E5,$1E           ;,$00       ; #....... #.......
                                                                            ; #....... ###.....
                                                                            ; #####..# #..#....
                                                                            ; .####### #...#...
                                                                            ; .#.##... #....#..
                                                                            ; .#..###. ###.##..
                                                                            ; .#...##. ..#####.
                                                                            ; ......## ##..###.
                                                                            ; ......## ######..
                                                                            ; .....##. ...##...
                                                                            ; ..####.. ....#...
                                                                            ; ......## ###..#.#
                                                                            ; ........ ...####.
                                                                            ; ........

CR3_1           .byte $00,$00,$01,$40,$40,$40,$71,$FF,$9C                   ; ........ ........
                .byte $86,$86,$03,$03,$06,$3C,$07,$00,$00                   ; ........ ........
                                                                            ; .......# ##......
                .byte $00,$00,$C0,$BC,$83,$C0,$B0,$88,$84                   ; .#...... #.####..
                .byte $C4,$76,$9E,$E6,$7C,$08,$88,$79,$06                   ; .#...... #.....##
                                                                            ; .#...... ##......
                                                                            ; .###...# #.##....
                                                                            ; ######## #...#...
                                                                            ; #..###.. #....#..
                                                                            ; #....##. ##...#..
                                                                            ; #....##. .###.##.
                                                                            ; ......## #..####.
                                                                            ; ......## ###..##.
                                                                            ; .....##. .#####..
                                                                            ; ..####.. ....#...
                                                                            ; .....### #...#...
                                                                            ; ........ .####..#
                                                                            ; ........ .....##.

CR3_2           .byte $60,$1E,$01,$80,$80,$80,$F1,$7F,$5C                   ; .##..... ........
                .byte $46,$46,$03,$03,$06,$3C,$07,$00,$00                   ; ...####. ........
                                                                            ; .......# ##......
                .byte $00,$00,$C0,$80,$80,$C0,$B0,$88                       ; #....... #.......
BOOT_STUFF      .byte $84,$C4,$76,$9E,$E6,$7C,$08,$88,$79,$06               ; #....... #.......
                                                                            ; #....... ##......
                                                                            ; ####...# #.##....
                                                                            ; .####### #...#...
                                                                            ; .#.###.. #....#..
                                                                            ; .#...##. ##...#..
                                                                            ; .#...##. .###.##.
                                                                            ; ......## #..####.
                                                                            ; ......## ###..##.
                                                                            ; .....##. .#####..
                                                                            ; ..####.. ....#...
                                                                            ; .....### #...#...
                                                                            ; ........ .####..#
                                                                            ; ........ .....##.


;=======================================
;
;=======================================
INIT_OS         ;.proc                  ; never called
                ldx #$25
_next1          lda $E480,x             ; PUPDIV
                sta VDSLST,x
                dex
                bpl _next1

                lda #$40
                sta NMIEN

                ldx #$3B
                stx PACTL
                stx PBCTL

                lda #$00
                sta PORTA
                sta PORTB

                inx
                stx PACTL
                stx PBCTL

                rts
                ;.endproc

;---------------------------------------
;---------------------------------------

                .byte $66,$65,$70,$6C,$4C,$44,$50,$4C,$61,$3B,$DC,$95,$3A,$A8

LASER_SHAPES    .byte %11000000
                .byte %11000000
                .byte %00110000
                .byte %00110000
                .byte %00001100
                .byte %00001100
                .byte %00000011
                .byte %00000011

                .byte %00000011
                .byte %00000011
                .byte %00001100
                .byte %00001100
                .byte %00110000
                .byte %00110000
                .byte %11000000
                .byte %11000000

                .byte %00000000
                .byte %00000000
                .byte %00000000
                .byte %11111111
                .byte %11111111
                .byte %00000000
                .byte %00000000
                .byte %00000000

                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
