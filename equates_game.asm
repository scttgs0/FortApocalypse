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

OFF             = 1
ON              = 2
FLY             = 3
CRASH           = 4
EXPLODE         = 5
LAND            = 6
BEGIN           = 7
FULL            = 8
EMPTY           = 9
REFUEL          = 10
PICKUP          = 11

TITLE_MODE      = 1
GO_MODE         = 2
START_MODE      = 3
NEW_LEVEL_MODE  = 4
NEW_PLAYER_MODE = 5
GAME_OVER_MODE  = 6
STOP_MODE       = 7
PAUSE_MODE      = 8
OPTION_MODE     = 9
HYPERSPACE_MODE = 10

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

POD_SPEED       = 15

;---------------------------------------

                * = $50

SCAN_ADR1       .word ?
SCAN_ADR2       .word ?
SX              .byte ?
SX_F            .byte ?
SY              .byte ?
SY_F            .byte ?
CONSOL_FLAG     .byte ?
TRIG_FLAG       .byte ?
LEVEL           .byte ?
LAND_X          .byte ?
LAND_Y          .byte ?
LAND_FX         .byte ?
LAND_FY         .byte ?
LAND_CHOP_X     .byte ?
LAND_CHOP_Y     .byte ?
LAND_CHOP_ANGLE .byte ?

CHOPPER_STATUS  .byte ?

CHOPPER_X       .byte ?
CHOPPER_Y       .byte ?
OCHOPPER_Y      .byte ?
CHOPPER_ANGLE   .byte ?
CHOPPER_COL     .byte ?
CHOP_X          .byte ?
CHOP_Y          .byte ?
CHOP_OX         .byte ?
CHOP_OY         .byte ?
ROBOT_STATUS    .byte ?
R_STATUS        .byte ?
ROBOT_X         .byte ?
ROBOT_Y         .byte ?
OROBOT_Y        .byte ?
ROBOT_ANGLE     .byte ?
ROBOT_SPD       .byte ?
ROBOT_COL       .byte ?
R_FX            .byte ?
R_FY            .byte ?
R_X             .byte ?
R_Y             .byte ?
ROCKET_STATUS   .fill 3
ROCKET_X        .fill 3
ROCKET_Y        .fill 3
ROCKET_TEMP     .fill 3
ROCKET_TEMPX    .fill 3
ROCKET_TEMPY    .fill 3
ROCKET_TIM      .fill 3
OROCKET_Y       .fill 3
ELEVATOR_NUM    .byte ?
ELEVATOR_DX     .byte ?
ELEVATOR_TIM    .byte ?
ELEVATOR_SPD    .byte ?
SCORE1          .byte ?
SCORE2          .byte ?
SCORE3          .byte ?
HI1             .byte ?
HI2             .byte ?
HI3             .byte ?
BONUS1          .byte ?
BONUS2          .byte ?
FUEL_STATUS     .byte ?
FUEL_TEMP       .byte ?
FUEL1           .byte ?
FUEL2           .byte ?

MODE            .byte ?
BAK_COLOR       .byte ?
BAK2_COLOR      .byte ?

CM_STATUS       .fill MAX_TANKS
CM_X            .fill MAX_TANKS
CM_Y            .fill MAX_TANKS
CM_TIME         .fill MAX_TANKS
CM_TEMP         .fill MAX_TANKS

TANK_STATUS     .fill MAX_TANKS
TANK_X          .fill MAX_TANKS
TANK_Y          .fill MAX_TANKS
TANK_DX         .fill MAX_TANKS
TANK_TEMP       .fill 18                ; MAX_TANKS*3     6*3=18

POD_NUM         .byte ?
POD_COM         .byte ?
SLAVE_NUM       .byte ?
SLAVES_LEFT     .byte ?
SLAVES_SAVED    .byte ?

FORT_STATUS     .byte ?
LASER_STATUS    .byte ?
LASER_SPD       .byte ?
TANK_SPD        .byte ?
TANK_SPEED      .byte ?
MISSILE_SPD     .byte ?
MISSILE_SPEED   .byte ?
GRAV_SKILL      .byte ?
GRAV_SKL        .byte ?
PILOT_SKILL     .byte ?
PILOT_SKL       .byte ?
CHOPS           .byte ?
CHOP_LEFT       .byte ?
OPT_NUM         .byte ?
START_PODS      .byte ?

;---------------------------------------

                * = POD_1
POD_STATUS      .fill MAX_PODS
POD_DX          .fill MAX_PODS

;---------------------------------------

                * = POD_2
POD_X           .fill MAX_PODS
POD_Y           .fill MAX_PODS
POD_TEMP1       .fill MAX_PODS
POD_TEMP2       .fill MAX_PODS

;---------------------------------------

                * = SLAVES
SLAVE_STATUS    .fill 8
SLAVE_X         .fill 8
SLAVE_Y         .fill 8
SLAVE_DX        .fill 8
