;---------------------------------------
; SYSTEM EQUATES Foenix C256
;---------------------------------------

KBD_INPT_BUF            = $AF_1803
FNX1_INT00_KBD          = $01                   ; keyboard Interrupt
KEYBOARD_SCAN_CODE      = $AF_115F

JOYSTICK0               = $AF_E800              ; (R) Joystick 0 - J7 (next to SD Card)
SIO_JOY                 = $AF_1200

FONT_MEMORY_BANK0       = $AF_8000              ; $AF8000 - $AF87FF

MASTER_CTRL_REG_L	    = $AF_0000
Mstr_Ctrl_Text_Mode_En  = $01                   ; Enable the Text Mode
Mstr_Ctrl_Text_Overlay  = $02                   ; Enable the Overlay of the text mode on top of Graphic Mode (the Background Color is ignored)
Mstr_Ctrl_Graph_Mode_En = $04                   ; Enable the Graphic Mode
Mstr_Ctrl_Bitmap_En     = $08                   ; Enable the Bitmap Module In Vicky
Mstr_Ctrl_TileMap_En    = $10                   ; Enable the Tile Module in Vicky
Mstr_Ctrl_Sprite_En     = $20                   ; Enable the Sprite Module in Vicky
Mstr_Ctrl_Disable_Vid   = $80                   ; This will disable the Scanning of the Video hence giving 100% bandwith to the CPU

MASTER_CTRL_REG_H       = $AF_0001
Mstr_Ctrl_Video_Mode0   = $01                   ; 0 - 640x480 (Clock @ 25.175Mhz), 1 - 800x600 (Clock @ 40Mhz)
Mstr_Ctrl_Video_Mode1   = $02                   ; 0 - No Pixel Doubling, 1- Pixel Doubling (Reduce the Pixel Resolution by 2)

C256F_MODEL_MAJOR       = $AF_070B
C256F_MODEL_MINOR       = $AF_070C
