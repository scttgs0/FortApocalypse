;---------------------------------------
; CONSTANTS
;---------------------------------------

MIS             = $300

PL0             = $400
PL1             = $500
PL2             = $600
PL3             = $700

UP              = $1
DOWN            = $2
LEFT            = $4
RIGHT           = $8


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
PROGRAM         = $A000

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
EXP_WALL        = $47+128

MISS_LEFT       = $71
MISS_RIGHT      = $72
MISS_CHR_LEFT   = CHR_SET2+904
MISS_CHR_RIGHT  = CHR_SET2+912

MIN_UP          = 146
MIN_DOWN        = 166
MIN_LEFT        = 110
MIN_RIGHT       = 130

MAX_UP          = 100
MAX_DOWN        = 212
MAX_LEFT        = 48
MAX_RIGHT       = 192

MAX_FUEL        = $2000
MAX_TANKS       = 6
MAX_PODS        = 39

POD_SPEED       = 15

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
