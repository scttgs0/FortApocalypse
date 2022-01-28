;---------------------------------------
; Direct-Page Equates
;---------------------------------------

;---------------------------------------
;---------------------------------------

FRAME           = $14

                * = $15

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

;---------------------------------------
;---------------------------------------

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
