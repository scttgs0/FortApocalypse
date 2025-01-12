
; SPDX-FileName: vbinterrupts.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; VBlank Deferred Handler
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
irqVBlankD      .proc
                sei
                php
                cld

                lda #$00
                ;!! lda M2PL
                ;!! ora M3PL
                and #%00000011
                ;!! ora P0PL
                ;!! ora P1PL
                asl
                asl
                asl
                asl
                ;!! ora P0PF
                ;!! ora P1PF
                sta CHOPPER_COL

                ;!! lda M0PL
                ;!! ora M1PL
                and #%00001100
                ;!! ora P2PL
                ;!! ora P2PF
                ;!! ora P3PL
                ;!! ora P3PF
                sta ROBOT_COL
                ;!! sta HITCLR

                jsr DoNumbers
                jsr DrawMap
                jsr UpdateChopper
                jsr UpdateRobotChopper
                jsr ReadTrigger
                jsr DoExplode

                lda MODE
                cmp #GO_MODE
                bne _1

                jsr DoRobotChopper
                jsr UpdateRockets
                jsr DoLaser1
                jsr DoLaser2
                jsr DoBlocks
                jsr DoElevator
                jsr DoChopper
                jsr RobotAI
                jsr ReadJoystick

_1              plp
                cli
                ;!! jmp VVBLKD_RET

                .endproc


;--------------------------------------
;--------------------------------------

HIT_LIST        .byte $40,$5B,$5C,$5D,$5E,$5F
                .byte $3B,$3C,$3D,$3E,$49,$4A

HIT_LIST_LEN    = *-HIT_LIST-1

                .byte $61,$00                   ; 'a ' atari-ascii
                .byte EXP

HIT_LIST2_LEN   = *-HIT_LIST-1
