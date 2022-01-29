;*******************
;*       Fort      *
;*    Apocalypse   *
;*                 *
;*  By Steve Hales *
;*                 *
;*    Copyright    *
;*   September 1   *
;*  1982  Synapse  *
;*     Software    *
;*                 *
;* FEBUARY 8, 1983 *
;*                 *
;*******************

;=======================================
;=======================================
;* Port to Foenix Retro Systems C256
;*              JANUARY 2022
;=======================================
;=======================================

;=======================================
; Memory Structure
;=======================================
; Static Usage      18.2 K
; Dynamic Usage     ??? K
;
; Level unpacked    $4000 - ???
;
; Level packed      $8000 - $9220
; Font1             $9300 - $95c8
; Font2             $9600 - $988f
;
; Code              $a000 - $c882
;=======================================

                .cpu "65816"

                .include "equates_system.asm"
                .include "equates_directpage.asm"
                .include "equates_game.asm"
                .include "macros.asm"

                * = $50
                .include "fort7.s"

                * = $8000
                .include "level.asm"

                .align $100
                .include "font1.asm"

                .align $100
                .include "font2.asm"


                .align $1000
                clc
                xce

                jml CART_START

                .include "fort1.s"
                .include "fort2.s"
                .include "fort3.s"
                .include "fort4.s"
                .include "fort5.s"
                .include "fort6.s"
                .include "fort8.s"

                ; Engine
                .include "input.asm"
                .include "sound.asm"
                .include "text.asm"

                ; Mode Screens
                .include "options.asm"
                .include "title.asm"

                ; Baddies
                .include "cruisemissile.asm"
                .include "pod.asm"
                .include "robot.asm"
                .include "tank.asm"

                ; Environment
                .include "elevator.asm"
                .include "fuel.asm"
                .include "hyperchamber.asm"
                .include "landingpad.asm"
                .include "laser.asm"
                .include "navatron.asm"
                .include "slaves.asm"
                .include "world.asm"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
