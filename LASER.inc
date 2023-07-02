
; SPDX-FileName: LASER.inc
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


LASER_DIAG      .byte %11000000
                .byte %11000000
                .byte %00110000
                .byte %00110000
                .byte %00001100
                .byte %00001100
                .byte %00000011
                .byte %00000011

                .byte %00000011
                .byte %00000011
                .byte %00001100
                .byte %00001100
                .byte %00110000
                .byte %00110000
                .byte %11000000
                .byte %11000000

LASER_HORZ      .byte %00000000
                .byte %00000000
                .byte %00000000
                .byte %11111111
                .byte %11111111
                .byte %00000000
                .byte %00000000
                .byte %00000000

LASER_VERT      .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
