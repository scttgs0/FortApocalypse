;******************
;*      Fort      *
;*   Apocalypse   *
;*      ROM       *
;*                *
;* By Steve Hales *
;*                *
;*   Copyright    *
;*  September 1   *
;* 1982  Synapse  *
;*    Software    *
;*                *
;******************

;*
;* FEBUARY 8, 1983
;*

;---------------------------------------
; SYSTEM EQUATES
;---------------------------------------

ATTRACT         = $4D


VDSLST          = $200
VVBLKD          = $224
SDMCTL          = $22F
SDLST           = $230
PRIOR           = $26F
STICK           = $278
PCOLR0          = $2C0
PCOLR1          = $2C1
PCOLR2          = $2C2
PCOLR3          = $2C3
COLOR0          = $2C4
COLOR1          = $2C5
COLOR2          = $2C6
COLOR3          = $2C7
COLOR4          = $2C8
CHBAS           = $2F4


HPOSP0          = $D000
HPOSP1          = $D001
HPOSP2          = $D002
HPOSP3          = $D003
P0PF            = $D004
HPOSM0          = $D004
P1PF            = $D005
P2PF            = $D006
P3PF            = $D007
M0PL            = $D008
M1PL            = $D009
M2PL            = $D00A
M3PL            = $D00B
P0PL            = $D00C
SIZEM           = $D00C
P1PL            = $D00D
P2PL            = $D00E
P3PL            = $D00F
TRIG0           = $D010
COLPF0          = $D016
COLPF1          = $D017
COLPF2          = $D018
COLPF3          = $D019
COLBK           = $D01A
GRACTL          = $D01D
HITCLR          = $D01E
CONSOL          = $D01F


AUDF1           = $D200
AUDC1           = $D201
AUDF2           = $D202
AUDC2           = $D203
AUDF3           = $D204
AUDC3           = $D205
AUDF4           = $D206
AUDC4           = $D207
AUDCTL          = $D208
KBCODE          = $D209
RANDOM          = $D20A
SKCTL           = $D20F
SKSTAT          = $D20F


PORTA           = $D300
PORTB           = $D301
PACTL           = $D302
PBCTL           = $D303


DMACLT          = $D400
HSCROL          = $D404
VSCROL          = $D405
PMBASE          = $D407
CHBASE          = $D409
WSYNC           = $D40A
VCOUNT          = $D40B
NMIEN           = $D40E


VVBLKD_RET      = $E462

;---------------------------------------
; CONSTANTS
;---------------------------------------
MIS             = $300
PL0             = $400
PL1             = $500
PL2             = $600
PL3             = $700
RIGHT           = $8
LEFT            = $4
DOWN            = $2
UP              = $1
CHECK_SUM       = $264C

;---------------------------------------
; CHANGE THESE CONSTANTS
; WHEN PROGRAM NEED TO GO MOBILE
;---------------------------------------

;                START                  ; LEN
PLAYER          = $0                    ; $800  R
PLAY_SCRN       = $300                  ; $300  R
CHR_SET1        = $800                  ; $400  R
CHR_SET2        = $C00                  ; $400  R
POD_1           = $C00+920              ; $4E   R
POD_2           = $3925                 ; $9B   R
MAP             = $1100+3               ; $2800 R
SLAVES          = $3904                 ; $20   R
SCANNER         = $39C0                 ; $640  R
RAM1_STUFF      = $C00+144              ; $48
RAM2_STUFF      = $100
PL              = $8000
PACKED_MAP      = PL                    ; $D34
PACKED_SCAN     = PL+$D34               ; $4ED
PROGRAM         = PL+$1221              ; $2D2C
S_LINE1         = CHR_SET1+736
S_LINE2         = CHR_SET1+832
S_LINE3         = CHR_SET1+928
LASERS_1        = CHR_SET2+8
LASERS_2        = CHR_SET2+40
LASER_3         = CHR_SET2+72
BLOCK_1         = CHR_SET2+80
BLOCK_2         = CHR_SET2+88
BLOCK_3         = CHR_SET2+96
BLOCK_4         = CHR_SET2+104
BLOCK_5         = CHR_SET2+112
BLOCK_6         = CHR_SET2+120
BLOCK_7         = CHR_SET2+128
BLOCK_8         = CHR_SET2+136
WINDOW_1        = CHR_SET2+712
WINDOW_2        = CHR_SET2+720
EXP             = $20
EXP2            = $3F
EXPLOSION       = CHR_SET2+256
EXPLOSION2      = CHR_SET2+504
MISS_LEFT       = $71
MISS_RIGHT      = $72
MISS_CHR_LEFT   = CHR_SET2+904
MISS_CHR_RIGHT  = CHR_SET2+912
EXP_WALL        = $47+128

MAX_LEFT        = 48
MAX_RIGHT       = 192
MAX_UP          = 100
MAX_DOWN        = 212
MAX_FUEL        = $2000
MIN_LEFT        = 110
MIN_RIGHT       = 130
MIN_UP          = 146
MIN_DOWN        = 166
MAX_TANKS       = 6
POD_SPEED       = 15

;---------------------------------------
; ZERO PAGE USAGE
;---------------------------------------

                * = $14
FRAME           .byte ?
ADR1            .word ?
ADR2            .word ?
TEMP1           .byte ?
TEMP2           .byte ?
TEMP3           .byte ?
TEMP4           .byte ?
TEMP5           .byte ?
TEMP6           .byte ?
TEMP_MODE       .byte ?

ADR1_I          .word ?
ADR2_I          .word ?
TEMP1_I         .byte ?
TEMP2_I         .byte ?
TEMP3_I         .byte ?
TEMP4_I         .byte ?
S_ADR           .word ?
S_TEMP          .byte ?
S_FLG           .byte ?
TANK_START_X    .fill MAX_TANKS
TANK_START_Y    .fill MAX_TANKS
TIM1_VAL        .byte ?                 ; LASER 1
TIM2_VAL        .byte ?                 ; LASER 2
TIM3_VAL        .byte ?                 ; CHOP EXPLODE
TIM4_VAL        .byte ?                 ; RE FUEL
TIM5_VAL        .byte ?                 ; TANK EXPLODE
TIM6_VAL        .byte ?                 ; DEMO TIMER
TIM7_VAL        .byte ?                 ; ROBO EXPLODE
TIM8_VAL        .byte ?                 ; ROBO MISSILE
TIM9_VAL        .byte ?                 ; SLAVE MESS
SSIZEM          .byte ?


                * = $43
S1_1_VAL        .byte ?
S1_2_VAL        .byte ?
S2_VAL          .byte ?
S3_VAL          .byte ?
S4_VAL          .byte ?
S5_VAL          .byte ?
S6_VAL          .byte ?                 ; MISSILE SND
GAME_POINTS     .byte ?
DEMO_STATUS     .byte ?
DEMO_COUNT      .byte ?

MAX_PODS        = 39


                * = POD_1
POD_STATUS      .fill MAX_PODS
POD_DX          .fill MAX_PODS


                * = POD_2
POD_X           .fill MAX_PODS
POD_Y           .fill MAX_PODS
POD_TEMP1       .fill MAX_PODS
POD_TEMP2       .fill MAX_PODS


                * = SLAVES
SLAVE_STATUS    .fill 8
SLAVE_X         .fill 8
SLAVE_Y         .fill 8
SLAVE_DX        .fill 8

                * = $50

                .include "fort7.s"

;---------------------------------------
; REST OF PROGRAM IS
; INSIDE INCLUDE FILES
;---------------------------------------

                * = $8000

                .include "level.s"

                * = PROGRAM

                .include "fort8.s"
                .include "fort6.s"
                .include "fort2.s"

                .include "fnt2.s"

                .include "fort3.s"
                .include "fort1.s"
                .include "fort4.s"

                .include "fnt1.s"

                .include "fort5.s"

END_CART        ;.fill $BFFA-*
                .byte $00

                .addr CART_START
                .byte $00
                .byte %10000100
                .addr CART_START

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
