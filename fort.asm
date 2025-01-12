
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
;* FEBRUARY 8, 1983
;*

                .include "equates/system_atari8.equ"
                .include "equates/game.equ"
                .include "equates/zeropage.equ"


            .enc "atari-screen"
                .cdef " Z",$00
                .cdef "az",$61
            .enc "atari-screen-inverse"
                .cdef "  ",$00
                .cdef "!Z",$81
                .cdef "az",$E1
            .enc "none"


;--------------------------------------
;--------------------------------------
                * = POD_1
;--------------------------------------

POD_STATUS      .fill MAX_PODS
POD_DX          .fill MAX_PODS

;--------------------------------------
;--------------------------------------
                * = POD_2
;--------------------------------------

POD_X           .fill MAX_PODS
POD_Y           .fill MAX_PODS
POD_TEMP1       .fill MAX_PODS
POD_TEMP2       .fill MAX_PODS

;--------------------------------------
;--------------------------------------
                * = SLAVES
;--------------------------------------

SLAVE_STATUS    .fill 8
SLAVE_X         .fill 8
SLAVE_Y         .fill 8
SLAVE_DX        .fill 8


;--------------------------------------
;--------------------------------------
                * = $50
;--------------------------------------

                .include "FORT7.inc"

;--------------------------------------
; REST OF PROGRAM IS
; INSIDE INCLUDE FILES
;--------------------------------------


;--------------------------------------
;--------------------------------------
                * = $8000
;--------------------------------------

                .include "LEVEL.inc"


;--------------------------------------
;--------------------------------------
                * = PROGRAM
;--------------------------------------

                .include "FORT8.inc"

                .include "fort6.asm"
                .include "fort2.asm"

                .include "FONT2.inc"

                .include "fort3.asm"
                .include "fort1.asm"
                .include "fort4.asm"

                .include "FONT1.inc"

                .include "fort5.asm"


;--------------------------------------
;--------------------------------------

END_CART        .fill $BFFA-*

                .addr CartridgeStart
                .byte $00
                .byte %10000100
                .addr CartridgeStart
