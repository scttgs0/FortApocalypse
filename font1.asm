;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE font1.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

FNT1
; CHR $00 BLANK
; CHR $01
;               .byte %00000000         ;....       ; right-half of numerals
;               .byte %00000000         ;....
;               .byte %00000000         ;....
;               .byte %00000000         ;....
;               .byte %00000000         ;....
;               .byte %00000000         ;....
;               .byte %00000000         ;....
                .byte %11110000         ;##..
; CHR $02
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111100         ;###.
; CHR $03
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $04
                .byte %00000000         ;....       [4]
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
; CHR $05
                .byte %00000000         ;....
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $06
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $07
                .byte %00000000         ;....       [7]
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %11000000         ;#...
                .byte %11000000         ;#...
                .byte %11000000         ;#...
; CHR $08
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $09
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $0A
                .byte %00000000         ;....       [0]
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $0B
POS_MASK1       .byte %10000000         ;R...
                .byte %10000000         ;R...
                .byte %00100000         ;.R..
                .byte %00100000         ;.R..
                .byte %00001000         ;..R.
                .byte %00001000         ;..R.
                .byte %00000010         ;...R
                .byte %00000010         ;...R
; CHR $0C
FORT_EX1        .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00011000         ;.GR.
                .byte %00011000         ;.GR.
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
; CHR $0D
FORT_EX2        .byte %00000000         ;....
                .byte %00011000         ;.GR.
                .byte %00100100         ;.RG.
                .byte %00100100         ;.RG.
                .byte %00011000         ;.GR.
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
; CHR $0E
FORT_EX3        .byte %00011000         ;.GR.
                .byte %00100100         ;.RG.
                .byte %01011010         ;GGRR
                .byte %01011010         ;GGRR
                .byte %00100100         ;.RG.
                .byte %00011000         ;.GR.
                .byte %00000000         ;....
                .byte %00000000         ;....
; CHR $0F
FORT_EX4        .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
; CHR $10
                .byte %00000000         ;....       ; left-half of numerals
                .byte %00111111         ;.###
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110011         ;##.#
                .byte %11111100         ;###.
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $11
                .byte %00000000         ;....
                .byte %00001111         ;..##
                .byte %00111111         ;.###
                .byte %00001111         ;..##
                .byte %00001111         ;..##
                .byte %00001111         ;..##
                .byte %00001111         ;..##
                .byte %11111111         ;####
; CHR $12
                .byte %00000000         ;....
                .byte %00111111         ;.###
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00111111         ;.###
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11111111         ;####
; CHR $13
                .byte %00000000         ;....       [3]
                .byte %00111111         ;.###
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000011         ;...#
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $14
                .byte %00000000         ;....
                .byte %00001111         ;..##
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %11111111         ;####
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
; CHR $15
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11111111         ;####
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $16
                .byte %00000000         ;....       [6]
                .byte %00111111         ;.###
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11111111         ;####
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $17
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000011         ;...#
                .byte %00000011         ;...#
                .byte %00000011         ;...#
; CHR $18
                .byte %00000000         ;....
                .byte %00111111         ;.###
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %00111111         ;.###
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $19
                .byte %00000000         ;....       [9]
                .byte %00111111         ;.###
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %00111111         ;.###
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $1A
                .byte %00000010         ;...#       ; left bracket navitron
                .byte %00001000         ;..#.
                .byte %00001000         ;..#.
                .byte %00001000         ;..#.
                .byte %00001000         ;..#.
                .byte %00101000         ;.##.
                .byte %00101000         ;.##.
                .byte %00101000         ;.##.
; CHR $1B
                .byte %00001000         ;..R.
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
                .byte %10101000         ;RRR.
                .byte %10101000         ;RRR.
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
                .byte %00001000         ;..R.
; CHR $1C
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
                .byte %00001000         ;..R.
                .byte %00001000         ;..R.
                .byte %00001000         ;..R.
                .byte %00001000         ;..R.
                .byte %00000010         ;...R
; CHR $1D
                .byte %10000000         ;R...       ; right bracket navitron
                .byte %00100000         ;.R..
                .byte %00100000         ;.R..
                .byte %00100000         ;.R..
                .byte %00100000         ;.R..
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
; CHR $1E
                .byte %00100000         ;.R..
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
                .byte %00101010         ;.RRR
                .byte %00101010         ;.RRR
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
                .byte %00100000         ;.R..
; CHR $1F
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
                .byte %00100000         ;.R..
                .byte %00100000         ;.R..
                .byte %00100000         ;.R..
                .byte %00100000         ;.R..
                .byte %10000000         ;R...

;---------------------------------------

; CHR $20
T_5             .byte $91,$81,$99,$89,$98,$88,$92,$82           ; '1!9)8(2"' atari-ascii

;---------------------------------------

; CHR $21
                .byte %00000000         ;....       ; left-half of letters
                .byte %00111111         ;.###
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
; CHR $22
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11111111         ;####
; CHR $23
                .byte %00000000         ;....       [C]
                .byte %00111111         ;.###
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $24
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11111111         ;####
; CHR $25
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11111111         ;####
; CHR $26
                .byte %00000000         ;....       [F]
                .byte %11111111         ;####
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
; CHR $27
                .byte %00000000         ;....
                .byte %00111111         ;.###
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $28
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
; CHR $29
                .byte %00000000         ;....       [I]
                .byte %00001111         ;..##
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000011         ;...#
                .byte %00000011         ;...#
                .byte %00000011         ;...#
                .byte %00001111         ;..##
; CHR $2A
                .byte %00000000         ;....
                .byte %00000011         ;...#
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $2B
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000011         ;...#
                .byte %11111111         ;####
                .byte %11110011         ;##.#
                .byte %11110000         ;##..
                .byte %11110000         ;##..
; CHR $2C
                .byte %00000000         ;....       [L]
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11111111         ;####
; CHR $2D
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00001100         ;..#.
                .byte %00001111         ;..##
                .byte %11110011         ;##.#
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
; CHR $2E
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00001100         ;..#.
                .byte %00001111         ;..##
                .byte %11110011         ;##.#
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
; CHR $2F
                .byte %00000000         ;....       [O]
                .byte %00111111         ;.###
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $30
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
; CHR $31
                .byte %00000000         ;....
                .byte %00111111         ;.###
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %11110011         ;##.#
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $32
                .byte %00000000         ;....       [R]
                .byte %11111111         ;####
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %11110011         ;##.#
                .byte %11110000         ;##..
                .byte %11110000         ;##..
; CHR $33
                .byte %00000000         ;....
                .byte %00111111         ;.###
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00111111         ;.###
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111111         ;####
; CHR $34
                .byte %00000000         ;....
                .byte %00111111         ;.###
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000011         ;...#
                .byte %00000011         ;...#
                .byte %00000011         ;...#
                .byte %00000011         ;...#
; CHR $35
                .byte %00000000         ;....       [U]
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %00111111         ;.###
; CHR $36
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00001111         ;..##
; CHR $37
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110011         ;##.#
                .byte %11111111         ;####
                .byte %11111100         ;###.
                .byte %11110000         ;##..
; CHR $38
                .byte %00000000         ;....       [X]
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00001111         ;..##
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %11110000         ;##..
; CHR $39
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000011         ;...#
                .byte %00001111         ;..##
                .byte %00001111         ;..##
                .byte %00001111         ;..##
                .byte %00001111         ;..##
; CHR $3A
                .byte %00000000         ;....
                .byte %11111111         ;####
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00001111         ;..##
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %11111111         ;####
; CHR $3B
                .byte %00101000         ;.RR.       ; red marquee dot
                .byte %00101000         ;.RR.
                .byte %10101010         ;RRRR
                .byte %10101010         ;RRRR
                .byte %10101010         ;RRRR
                .byte %10101010         ;RRRR
                .byte %00101000         ;.RR.
                .byte %00101000         ;.RR.
; CHR $3C
EXP_SHAPE       .byte %00111100         ;.##.       ; white marquee dot
                .byte %00111100         ;.##.
                .byte %11111111         ;####
                .byte %11111111         ;####
                .byte %11111111         ;####
                .byte %11111111         ;####
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
; CHR $3D
                .byte %00010100         ;.GG.       ; green marquee dot
                .byte %00010100         ;.GG.
                .byte %01010101         ;GGGG
                .byte %01010101         ;GGGG
                .byte %01010101         ;GGGG
                .byte %01010101         ;GGGG
                .byte %00010100         ;.GG.
                .byte %00010100         ;.GG.
; CHR $3E
                .byte %00000000         ;........
                .byte %00001000         ;....#...
                .byte %00011100         ;...###..
                .byte %00110110         ;..##.##.
                .byte %01100011         ;.##...##
                .byte %00000000         ;........
                .byte %00000000         ;........
                .byte %00000000         ;........
; CHR $3F
                .byte %00000000         ;........
                .byte %00000000         ;........
                .byte %00000000         ;........
                .byte %00000000         ;........
                .byte %00000000         ;........
                .byte %00000000         ;........
                .byte %11111111         ;########
                .byte %00000000         ;........
; CHR $40
SHP_HEART       .byte %00000000         ;........
                .byte %00110110         ;..##.##.
                .byte %01111111         ;.#######
                .byte %01111111         ;.#######
                .byte %00111110         ;..#####.
                .byte %00011100         ;...###..
                .byte %00001000         ;....#...
                .byte %00000000         ;........
; CHR $41
                .byte %00000000         ;....       ; right-half of letters
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
; CHR $42
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $43
                .byte %00000000         ;....       [C]
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $44
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $45
                .byte %00000000         ;....
                .byte %11111100         ;###.
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11000000         ;#...
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111100         ;###.
; CHR $46
                .byte %00000000         ;....       [F]
                .byte %11111100         ;###.
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11000000         ;#...
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
; CHR $47
                .byte %00000000         ;....
                .byte %11111100         ;###.
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $48
                .byte %00000000         ;....
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
; CHR $49
                .byte %00000000         ;....       [I]
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11000000         ;#...
                .byte %11000000         ;#...
                .byte %11000000         ;#...
                .byte %11110000         ;##..
; CHR $4A
                .byte %00000000         ;....
                .byte %11111100         ;###.
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11000000         ;#...
; CHR $4B
                .byte %00000000         ;....
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %11000000         ;#...
                .byte %00000000         ;....
                .byte %11000000         ;#...
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
; CHR $4C
                .byte %00000000         ;....       [L]
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111100         ;###.
; CHR $4D
                .byte %00000000         ;....
                .byte %00111100         ;.##.
                .byte %11111100         ;###.
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
; CHR $4E
                .byte %00000000         ;....
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11111100         ;###.
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
; CHR $4F
                .byte %00000000         ;....       [O]
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $50
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
; CHR $51
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
; CHR $52
                .byte %00000000         ;....       [R]
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %11000000         ;#...
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
; CHR $53
                .byte %00000000         ;....
                .byte %11111100         ;###.
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
; CHR $54
                .byte %00000000         ;....
                .byte %11111100         ;###.
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11000000         ;#...
                .byte %11000000         ;#...
                .byte %11000000         ;#...
                .byte %11000000         ;#...
; CHR $55
                .byte %00000000         ;....       [U]
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.       ; $B980
                .byte %11110000         ;##..
; CHR $56
                .byte %00000000         ;....
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11000000         ;#...
; CHR $57
                .byte %00000000         ;....
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11111100         ;###.
                .byte %11111100         ;###.
                .byte %00111100         ;.##.
; CHR $58
                .byte %00000000         ;....       [X]
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
                .byte %11110000         ;##..
                .byte %11000000         ;#...
                .byte %11110000         ;##..
                .byte %00111100         ;.##.
                .byte %00111100         ;.##.
; CHR $59
                .byte %00000000         ;....
                .byte %11110000         ;##..
                .byte %11110000         ;##..
                .byte %11000000         ;#...
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
; CHR $5A
                .byte %00000000         ;....
                .byte %11111100         ;###.
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %00000000         ;....
                .byte %11111100         ;###.
; CHR $5B-$7F BLANK

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
