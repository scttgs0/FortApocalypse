;---------------------------------------
; SYSTEM EQUATES
;---------------------------------------

; ANTIC instructions
AJMP            = $0001
AVB             = $0040
AHSCR           = $0010
AVSCR           = $0020
ALMS            = $0040
ADLI            = $0080
AEMPTY3         = $0020
AEMPTY6         = $0050
AEMPTY8         = $0070

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
