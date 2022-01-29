;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT3.S
;---------------------------------------
; MAIN INTERUPT DRIVER
;       PART (I)
; UpdateChopper
; DoChopper
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
VERTBLKD        sei
                php
                cld
                lda #0
                sta ATTRACT
                lda M2PL
                ora M3PL
                and #%00000011
                ora P0PL
                ora P1PL
                asl
                asl
                asl
                asl
                ora P0PF
                ora P1PF
                sta CHOPPER_COL
                lda M0PL
                ora M1PL
                and #%00001100
                ora P2PL
                ora P2PF
                ora P3PL
                ora P3PF
                sta ROBOT_COL
                sta HITCLR

                jsr DO_NUMBERS
                jsr DrawMap
                jsr UpdateChopper
                jsr UpdateRobotChopper
                jsr ReadTrigger
                jsr DO_EXP

                lda MODE
                cmp #GO_MODE
                bne _1

                jsr DoRobotChopper
                jsr UpdateRockets
                jsr DoLaser1
                jsr DoLaser2
                jsr DO_BLOCKS
                jsr DoElevator
                jsr DoChopper
                jsr RobotAI
                jsr ReadJoystick

_1
                plp
                cli
                jmp VVBLKD_RET

;---------------------------------------
;---------------------------------------

HIT_LIST        .byte $40,$5B,$5C,$5D,$5E,$5F
                .byte $3B,$3C,$3D,$3E,$49,$4A

HIT_LIST_LEN    = *-HIT_LIST-1
                .byte $61,$00                   ; 'a ' atari-ascii
                .byte EXP
HIT_LIST2_LEN   = *-HIT_LIST-1

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
