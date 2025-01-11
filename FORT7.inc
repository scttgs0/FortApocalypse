
;--------------------------------------
;--------------------------------------
; FILE: FORT7.inc
;--------------------------------------
; VARIABLES
;--------------------------------------
;--------------------------------------


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
