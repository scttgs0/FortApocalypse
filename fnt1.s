
00010 *
00020 * FILE FNT1.S
00030 *
00040 FNT1
00050 * CHR $00 BLANK
00060 * CHR $01
00070 ;.DA #%00000000           ;....       ; right-half of numerals
00080 ;.DA #%00000000           ;....
00090 ;.DA #%00000000           ;....
00100 ;.DA #%00000000           ;....
00110 ;.DA #%00000000           ;....
00120 ;.DA #%00000000           ;....
00130 ;.DA #%00000000           ;....
00140  .DA #%11110000           ;##..
00150 * CHR $02
00160  .DA #%00000000           ;....
00170  .DA #%11110000           ;##..
00180  .DA #%00111100           ;.##.
00190  .DA #%00111100           ;.##.
00200  .DA #%11110000           ;##..
00210  .DA #%00000000           ;....
00220  .DA #%00000000           ;....
00230  .DA #%11111100           ;###.
00240 * CHR $03
00250  .DA #%00000000           ;....
00260  .DA #%11110000           ;##..
00270  .DA #%00111100           ;.##.
00280  .DA #%00111100           ;.##.
00290  .DA #%11110000           ;##..
00300  .DA #%00111100           ;.##.
00310  .DA #%00111100           ;.##.
00320  .DA #%11110000           ;##..
00330 * CHR $04
00340  .DA #%00000000           ;....
00350  .DA #%11111100           ;###.
00360  .DA #%00111100           ;.##.
00370  .DA #%00111100           ;.##.
00380  .DA #%11111100           ;###.
00390  .DA #%00111100           ;.##.
00400  .DA #%00111100           ;.##.
00410  .DA #%00111100           ;.##.
00420 * CHR $05
00430  .DA #%00000000           ;....       [5]
00440  .DA #%11111100           ;###.
00450  .DA #%00111100           ;.##.
00460  .DA #%00000000           ;....
00470  .DA #%11110000           ;##..
00480  .DA #%00111100           ;.##.
00490  .DA #%00111100           ;.##.
00500  .DA #%11110000           ;##..
00510 * CHR $06
00520  .DA #%00000000           ;....
00530  .DA #%11110000           ;##..
00540  .DA #%00111100           ;.##.
00550  .DA #%00000000           ;....
00560  .DA #%11110000           ;##..
00570  .DA #%00111100           ;.##.
00580  .DA #%00111100           ;.##.
00590  .DA #%11110000           ;##..
00600 * CHR $07
00610  .DA #%00000000           ;....
00620  .DA #%11111100           ;###.
00630  .DA #%00111100           ;.##.
00640  .DA #%00111100           ;.##.
00650  .DA #%11110000           ;##..
00660  .DA #%11000000           ;#...
00670  .DA #%11000000           ;#...
00680  .DA #%11000000           ;#...
00690 * CHR $08
00700  .DA #%00000000           ;....
00710  .DA #%11110000           ;##..
00720  .DA #%00111100           ;.##.
00730  .DA #%00111100           ;.##.
00740  .DA #%11110000           ;##..
00750  .DA #%00111100           ;.##.
00760  .DA #%00111100           ;.##.
00770  .DA #%11110000           ;##..
00780 * CHR $09
00790  .DA #%00000000           ;....
00800  .DA #%11110000           ;##..
00810  .DA #%00111100           ;.##.
00820  .DA #%00111100           ;.##.
00830  .DA #%11111100           ;###.
00840  .DA #%00111100           ;.##.
00850  .DA #%00111100           ;.##.
00860  .DA #%11110000           ;##..
00870 * CHR $0A
00880  .DA #%00000000           ;....       [0]
00890  .DA #%11110000           ;##..
00900  .DA #%00111100           ;.##.
00910  .DA #%11111100           ;###.
00920  .DA #%00111100           ;.##.
00930  .DA #%00111100           ;.##.
00940  .DA #%00111100           ;.##.
00950  .DA #%11110000           ;##..
00960 * CHR $0B
00970 POS.MASK1
00980  .DA #%10000000           ;R...
00990  .DA #%10000000           ;R...
01000  .DA #%00100000           ;.R..
01010  .DA #%00100000           ;.R..
01020  .DA #%00001000           ;..R.
01030  .DA #%00001000           ;..R.
01040  .DA #%00000010           ;...R
01050  .DA #%00000010           ;...R
01060 * CHR $0C
01070 FORT.EX1
01080  .DA #%00000000           ;....
01090  .DA #%00000000           ;....
01100  .DA #%00011000           ;.GR.
01110  .DA #%00011000           ;.GR.
01120  .DA #%00000000           ;....
01130  .DA #%00000000           ;....
01140  .DA #%00000000           ;....
01150  .DA #%00000000           ;....
01160 * CHR $0D
01170 FORT.EX2
01180  .DA #%00000000           ;....
01190  .DA #%00011000           ;.GR.
01200  .DA #%00100100           ;.RG.
01210  .DA #%00100100           ;.RG.
01220  .DA #%00011000           ;.GR.
01230  .DA #%00000000           ;....
01240  .DA #%00000000           ;....
01250  .DA #%00000000           ;....
01260 * CHR $0E
01270 FORT.EX3
01280  .DA #%00011000           ;.GR.
01290  .DA #%00100100           ;.RG.
01300  .DA #%01011010           ;GGRR
01310  .DA #%01011010           ;GGRR
01320  .DA #%00100100           ;.RG.
01330  .DA #%00011000           ;.GR.
01340  .DA #%00000000           ;....
01350  .DA #%00000000           ;....
01360 * CHR $0F
01370 FORT.EX4
01380  .DA #%00000000           ;....
01390  .DA #%00000000           ;....
01400  .DA #%00000000           ;....
01410  .DA #%00000000           ;....
01420  .DA #%00000000           ;....
01430  .DA #%00000000           ;....
01440  .DA #%00000000           ;....
01450  .DA #%00000000           ;....
01460 * CHR $10
01470  .DA #%00000000           ;....       ; left-half of numerals
01480  .DA #%00111111           ;.###
01490  .DA #%11110000           ;##..
01500  .DA #%11110000           ;##..
01510  .DA #%11110011           ;##.#
01520  .DA #%11111100           ;###.
01530  .DA #%11110000           ;##..
01540  .DA #%00111111           ;.###
01550 * CHR $11
01560  .DA #%00000000           ;....
01570  .DA #%00001111           ;..##
01580  .DA #%00111111           ;.###
01590  .DA #%00001111           ;..##
01600  .DA #%00001111           ;..##
01610  .DA #%00001111           ;..##
01620  .DA #%00001111           ;..##
01630  .DA #%11111111           ;####
01640 * CHR $12
01650  .DA #%00000000           ;....
01660  .DA #%00111111           ;.###
01670  .DA #%11110000           ;##..
01680  .DA #%00000000           ;....
01690  .DA #%00111111           ;.###
01700  .DA #%11110000           ;##..
01710  .DA #%11110000           ;##..
01720  .DA #%11111111           ;####
01730 * CHR $13
01740  .DA #%00000000           ;....
01750  .DA #%00111111           ;.###
01760  .DA #%11110000           ;##..
01770  .DA #%00000000           ;....
01780  .DA #%00000011           ;...#
01790  .DA #%00000000           ;....
01800  .DA #%11110000           ;##..
01810  .DA #%00111111           ;.###
01820 * CHR $14
01830  .DA #%00000000           ;....
01840  .DA #%00001111           ;..##
01850  .DA #%00111100           ;.##.
01860  .DA #%11110000           ;##..
01870  .DA #%11111111           ;####
01880  .DA #%00000000           ;....
01890  .DA #%00000000           ;....
01900  .DA #%00000000           ;....
01910 * CHR $15
01920  .DA #%00000000           ;....       [5]
01930  .DA #%11111111           ;####
01940  .DA #%11110000           ;##..
01950  .DA #%11110000           ;##..
01960  .DA #%11111111           ;####
01970  .DA #%00000000           ;....
01980  .DA #%11110000           ;##..
01990  .DA #%00111111           ;.###
02000 * CHR $16
02010  .DA #%00000000           ;....
02020  .DA #%00111111           ;.###
02030  .DA #%11110000           ;##..
02040  .DA #%11110000           ;##..
02050  .DA #%11111111           ;####
02060  .DA #%11110000           ;##..
02070  .DA #%11110000           ;##..
02080  .DA #%00111111           ;.###
02090 * CHR $17
02100  .DA #%00000000           ;....
02110  .DA #%11111111           ;####
02120  .DA #%11110000           ;##..
02130  .DA #%00000000           ;....
02140  .DA #%00000000           ;....
02150  .DA #%00000011           ;...#
02160  .DA #%00000011           ;...#
02170  .DA #%00000011           ;...#
02180 * CHR $18
02190  .DA #%00000000           ;....
02200  .DA #%00111111           ;.###
02210  .DA #%11110000           ;##..
02220  .DA #%11110000           ;##..
02230  .DA #%00111111           ;.###
02240  .DA #%11110000           ;##..
02250  .DA #%11110000           ;##..
02260  .DA #%00111111           ;.###
02270 * CHR $19
02280  .DA #%00000000           ;....
02290  .DA #%00111111           ;.###
02300  .DA #%11110000           ;##..
02310  .DA #%11110000           ;##..
02320  .DA #%00111111           ;.###
02330  .DA #%00000000           ;....
02340  .DA #%11110000           ;##..
02350  .DA #%00111111           ;.###
02360 * CHR $1A
02370  .DA #%00000010           ;...#       ; left bracket navitron
02380  .DA #%00001000           ;..#.
02390  .DA #%00001000           ;..#.
02400  .DA #%00001000           ;..#.
02410  .DA #%00001000           ;..#.
02420  .DA #%00101000           ;.##.
02430  .DA #%00101000           ;.##.
02440  .DA #%00101000           ;.##.
02450 * CHR $1B
02460  .DA #%00001000           ;..R.
02470  .DA #%00101000           ;.RR.
02480  .DA #%00101000           ;.RR.
02490  .DA #%10101000           ;RRR.
02500  .DA #%10101000           ;RRR.
02510  .DA #%00101000           ;.RR.
02520  .DA #%00101000           ;.RR.
02530  .DA #%00001000           ;..R.
02540 * CHR $1C
02550  .DA #%00101000           ;.RR.
02560  .DA #%00101000           ;.RR.
02570  .DA #%00101000           ;.RR.
02580  .DA #%00001000           ;..R.
02590  .DA #%00001000           ;..R.
02600  .DA #%00001000           ;..R.
02610  .DA #%00001000           ;..R.
02620  .DA #%00000010           ;...R
02630 * CHR $1D
02640  .DA #%10000000           ;R...       ; right bracket navitron
02650  .DA #%00100000           ;.R..
02660  .DA #%00100000           ;.R..
02670  .DA #%00100000           ;.R..
02680  .DA #%00100000           ;.R..
02690  .DA #%00101000           ;.RR.
02700  .DA #%00101000           ;.RR.
02710  .DA #%00101000           ;.RR.
02720 * CHR $1E
02730  .DA #%00100000           ;.R..
02740  .DA #%00101000           ;.RR.
02750  .DA #%00101000           ;.RR.
02760  .DA #%00101010           ;.RRR
02770  .DA #%00101010           ;.RRR
02780  .DA #%00101000           ;.RR.
02790  .DA #%00101000           ;.RR.
02800  .DA #%00100000           ;.R..
02810 * CHR $1F
02820  .DA #%00101000           ;.RR.
02830  .DA #%00101000           ;.RR.
02840  .DA #%00101000           ;.RR.
02850  .DA #%00100000           ;.R..
02860  .DA #%00100000           ;.R..
02870  .DA #%00100000           ;.R..
02880  .DA #%00100000           ;.R..
02890  .DA #%10000000           ;R...
02900 * CHR $20
02910 T.5
02920  .AT -/1!9)8(2"/
02930 * CHR $21
02940  .DA #%00000000           ;....       ; left-half of letters
02950  .DA #%00111111           ;.###
02960  .DA #%00000000           ;....
02970  .DA #%00000000           ;....
02980  .DA #%11111111           ;####
02990  .DA #%11110000           ;##..
03000  .DA #%11110000           ;##..
03010  .DA #%11110000           ;##..
03020 * CHR $22
03030  .DA #%00000000           ;....
03040  .DA #%11111111           ;####
03050  .DA #%00000000           ;....
03060  .DA #%00000000           ;....
03070  .DA #%11111111           ;####
03080  .DA #%11110000           ;##..
03090  .DA #%11110000           ;##..
03100  .DA #%11111111           ;####
03110 * CHR $23
03120  .DA #%00000000           ;....       [C]
03130  .DA #%00111111           ;.###
03140  .DA #%00000000           ;....
03150  .DA #%00000000           ;....
03160  .DA #%11110000           ;##..
03170  .DA #%11110000           ;##..
03180  .DA #%11110000           ;##..
03190  .DA #%00111111           ;.###
03200 * CHR $24
03210  .DA #%00000000           ;....
03220  .DA #%11111111           ;####
03230  .DA #%00000000           ;....
03240  .DA #%00000000           ;....
03250  .DA #%11110000           ;##..
03260  .DA #%11110000           ;##..
03270  .DA #%11110000           ;##..
03280  .DA #%11111111           ;####
03290 * CHR $25
03300  .DA #%00000000           ;....
03310  .DA #%11111111           ;####
03320  .DA #%00000000           ;....
03330  .DA #%00000000           ;....
03340  .DA #%11111111           ;####
03350  .DA #%11110000           ;##..
03360  .DA #%11110000           ;##..
03370  .DA #%11111111           ;####
03380 * CHR $26
03390  .DA #%00000000           ;....       [F]
03400  .DA #%11111111           ;####
03410  .DA #%00000000           ;....
03420  .DA #%00000000           ;....
03430  .DA #%11111111           ;####
03440  .DA #%11110000           ;##..
03450  .DA #%11110000           ;##..
03460  .DA #%11110000           ;##..
03470 * CHR $27
03480  .DA #%00000000           ;....
03490  .DA #%00111111           ;.###
03500  .DA #%00000000           ;....
03510  .DA #%00000000           ;....
03520  .DA #%11110000           ;##..
03530  .DA #%11110000           ;##..
03540  .DA #%11110000           ;##..
03550  .DA #%00111111           ;.###
03560 * CHR $28
03570  .DA #%00000000           ;....
03580  .DA #%11110000           ;##..
03590  .DA #%00000000           ;....
03600  .DA #%00000000           ;....
03610  .DA #%11111111           ;####
03620  .DA #%11110000           ;##..
03630  .DA #%11110000           ;##..
03640  .DA #%11110000           ;##..
03650 * CHR $29
03660  .DA #%00000000           ;....       [I]
03670  .DA #%00001111           ;..##
03680  .DA #%00000000           ;....
03690  .DA #%00000000           ;....
03700  .DA #%00000011           ;...#
03710  .DA #%00000011           ;...#
03720  .DA #%00000011           ;...#
03730  .DA #%00001111           ;..##
03740 * CHR $2A
03750  .DA #%00000000           ;....
03760  .DA #%00000011           ;...#
03770  .DA #%00000000           ;....
03780  .DA #%00000000           ;....
03790  .DA #%00000000           ;....
03800  .DA #%00000000           ;....
03810  .DA #%11110000           ;##..
03820  .DA #%00111111           ;.###
03830 * CHR $2B
03840  .DA #%00000000           ;....
03850  .DA #%11110000           ;##..
03860  .DA #%00000000           ;....
03870  .DA #%00000011           ;...#
03880  .DA #%11111111           ;####
03890  .DA #%11110011           ;##.#
03900  .DA #%11110000           ;##..
03910  .DA #%11110000           ;##..
03920 * CHR $2C
03930  .DA #%00000000           ;....       [L]
03940  .DA #%11110000           ;##..
03950  .DA #%00000000           ;....
03960  .DA #%00000000           ;....
03970  .DA #%11110000           ;##..
03980  .DA #%11110000           ;##..
03990  .DA #%11110000           ;##..
04000  .DA #%11111111           ;####
04010 * CHR $2D
04020  .DA #%00000000           ;....
04030  .DA #%11110000           ;##..
04040  .DA #%00001100           ;..#.
04050  .DA #%00001111           ;..##
04060  .DA #%11110011           ;##.#
04070  .DA #%11110000           ;##..
04080  .DA #%11110000           ;##..
04090  .DA #%11110000           ;##..
04100 * CHR $2E
04110  .DA #%00000000           ;....
04120  .DA #%11110000           ;##..
04130  .DA #%00001100           ;..#.
04140  .DA #%00001111           ;..##
04150  .DA #%11110011           ;##.#
04160  .DA #%11110000           ;##..
04170  .DA #%11110000           ;##..
04180  .DA #%11110000           ;##..
04190 * CHR $2F
04200  .DA #%00000000           ;....       [O]
04210  .DA #%00111111           ;.###
04220  .DA #%00000000           ;....
04230  .DA #%00000000           ;....
04240  .DA #%11110000           ;##..
04250  .DA #%11110000           ;##..
04260  .DA #%11110000           ;##..
04270  .DA #%00111111           ;.###
04280 * CHR $30
04290  .DA #%00000000           ;....
04300  .DA #%11111111           ;####
04310  .DA #%00000000           ;....
04320  .DA #%00000000           ;....
04330  .DA #%11111111           ;####
04340  .DA #%11110000           ;##..
04350  .DA #%11110000           ;##..
04360  .DA #%11110000           ;##..
04370 * CHR $31
04380  .DA #%00000000           ;....
04390  .DA #%00111111           ;.###
04400  .DA #%00000000           ;....
04410  .DA #%00000000           ;....
04420  .DA #%11110000           ;##..
04430  .DA #%11110011           ;##.#
04440  .DA #%11110000           ;##..
04450  .DA #%00111111           ;.###
04460 * CHR $32
04470  .DA #%00000000           ;....       [R]
04480  .DA #%11111111           ;####
04490  .DA #%00000000           ;....
04500  .DA #%00000000           ;....
04510  .DA #%11111111           ;####
04520  .DA #%11110011           ;##.#
04530  .DA #%11110000           ;##..
04540  .DA #%11110000           ;##..
04550 * CHR $33
04560  .DA #%00000000           ;....
04570  .DA #%00111111           ;.###
04580  .DA #%00000000           ;....
04590  .DA #%00000000           ;....
04600  .DA #%00111111           ;.###
04610  .DA #%00000000           ;....
04620  .DA #%00000000           ;....
04630  .DA #%11111111           ;####
04640 * CHR $34
04650  .DA #%00000000           ;....
04660  .DA #%00111111           ;.###
04670  .DA #%00000000           ;....
04680  .DA #%00000000           ;....
04690  .DA #%00000011           ;...#
04700  .DA #%00000011           ;...#
04710  .DA #%00000011           ;...#
04720  .DA #%00000011           ;...#
04730 * CHR $35
04740  .DA #%00000000           ;....       [U]
04750  .DA #%11110000           ;##..
04760  .DA #%00000000           ;....
04770  .DA #%00000000           ;....
04780  .DA #%11110000           ;##..
04790  .DA #%11110000           ;##..
04800  .DA #%11110000           ;##..
04810  .DA #%00111111           ;.###
04820 * CHR $36
04830  .DA #%00000000           ;....
04840  .DA #%11110000           ;##..
04850  .DA #%00000000           ;....
04860  .DA #%00000000           ;....
04870  .DA #%11110000           ;##..
04880  .DA #%00111100           ;.##.
04890  .DA #%00111100           ;.##.
04900  .DA #%00001111           ;..##
04910 * CHR $37
04920  .DA #%00000000           ;....
04930  .DA #%11110000           ;##..
04940  .DA #%00000000           ;....
04950  .DA #%00000000           ;....
04960  .DA #%11110011           ;##.#
04970  .DA #%11111111           ;####
04980  .DA #%11111100           ;###.
04990  .DA #%11110000           ;##..
05000 * CHR $38
05010  .DA #%00000000           ;....       [X]
05020  .DA #%11110000           ;##..
05030  .DA #%00000000           ;....
05040  .DA #%00000000           ;....
05050  .DA #%00001111           ;..##
05060  .DA #%00111100           ;.##.
05070  .DA #%11110000           ;##..
05080  .DA #%11110000           ;##..
05090 * CHR $39
05100  .DA #%00000000           ;....
05110  .DA #%11110000           ;##..
05120  .DA #%00000000           ;....
05130  .DA #%00000011           ;...#
05140  .DA #%00001111           ;..##
05150  .DA #%00001111           ;..##
05160  .DA #%00001111           ;..##
05170  .DA #%00001111           ;..##
05180 * CHR $3A
05190  .DA #%00000000           ;....
05200  .DA #%11111111           ;####
05210  .DA #%00000000           ;....
05220  .DA #%00000000           ;....
05230  .DA #%00001111           ;..##
05240  .DA #%00111100           ;.##.
05250  .DA #%11110000           ;##..
05260  .DA #%11111111           ;####
05270 * CHR $3B
05280  .DA #%00101000           ;.RR.       ; red marquee dot
05290  .DA #%00101000           ;.RR.
05300  .DA #%10101010           ;RRRR
05310  .DA #%10101010           ;RRRR
05320  .DA #%10101010           ;RRRR
05330  .DA #%10101010           ;RRRR
05340  .DA #%00101000           ;.RR.
05350  .DA #%00101000           ;.RR.
05360 * CHR $3C
05370 EXP.SHAPE
05380  .DA #%00111100           ;.##.       ; white marquee dot
05390  .DA #%00111100           ;.##.
05400  .DA #%11111111           ;####
05410  .DA #%11111111           ;####
05420  .DA #%11111111           ;####
05430  .DA #%11111111           ;####
05440  .DA #%00111100           ;.##.
05450  .DA #%00111100           ;.##.
05460 * CHR $3D
05470  .DA #%00010100           ;.GG.       ; green marquee dot
05480  .DA #%00010100           ;.GG.
05490  .DA #%01010101           ;GGGG
05500  .DA #%01010101           ;GGGG
05510  .DA #%01010101           ;GGGG
05520  .DA #%01010101           ;GGGG
05530  .DA #%00010100           ;.GG.
05540  .DA #%00010100           ;.GG.
05550 * CHR $3E
05560  .DA #%00000000           ;........
05570  .DA #%00001000           ;....#...
05580  .DA #%00011100           ;...###..
05590  .DA #%00110110           ;..##.##.
05600  .DA #%01100011           ;.##...##
05610  .DA #%00000000           ;........
05620  .DA #%00000000           ;........
05630  .DA #%00000000           ;........
05640 * CHR $3F
05650  .DA #%00000000           ;........
05660  .DA #%00000000           ;........
05670  .DA #%00000000           ;........
05680  .DA #%00000000           ;........
05690  .DA #%00000000           ;........
05700  .DA #%00000000           ;........
05710  .DA #%11111111           ;########
05720  .DA #%00000000           ;........
05730 * CHR $40
05740  .DA #%00000000           ;........
05750  .DA #%00110110           ;..##.##.
05760  .DA #%01111111           ;.#######
05770  .DA #%01111111           ;.#######
05780  .DA #%00111110           ;..#####.
05790  .DA #%00011100           ;...###..
05800  .DA #%00001000           ;....#...
05810  .DA #%00000000           ;........
05820 * CHR $41
05830  .DA #%00000000           ;....       ; right-half of letters
05840  .DA #%11110000           ;##..
05850  .DA #%00111100           ;.##.
05860  .DA #%00111100           ;.##.
05870  .DA #%11111100           ;###.
05880  .DA #%00111100           ;.##.
05890  .DA #%00111100           ;.##.
05900  .DA #%00111100           ;.##.
05910 * CHR $42
05920  .DA #%00000000           ;....
05930  .DA #%11110000           ;##..
05940  .DA #%00111100           ;.##.
05950  .DA #%00111100           ;.##.
05960  .DA #%11110000           ;##..
05970  .DA #%00111100           ;.##.
05980  .DA #%00111100           ;.##.
05990  .DA #%11110000           ;##..
06000 * CHR $43
06010  .DA #%00000000           ;....       [C]
06020  .DA #%11110000           ;##..
06030  .DA #%00000000           ;....
06040  .DA #%00000000           ;....
06050  .DA #%00000000           ;....
06060  .DA #%00000000           ;....
06070  .DA #%00111100           ;.##.
06080  .DA #%11110000           ;##..
06090 * CHR $44
06100  .DA #%00000000           ;....
06110  .DA #%11110000           ;##..
06120  .DA #%00111100           ;.##.
06130  .DA #%00111100           ;.##.
06140  .DA #%00111100           ;.##.
06150  .DA #%00111100           ;.##.
06160  .DA #%00111100           ;.##.
06170  .DA #%11110000           ;##..
06180 * CHR $45
06190  .DA #%00000000           ;....
06200  .DA #%11111100           ;###.
06210  .DA #%00000000           ;....
06220  .DA #%00000000           ;....
06230  .DA #%11000000           ;#...
06240  .DA #%00000000           ;....
06250  .DA #%00000000           ;....
06260  .DA #%11111100           ;###.
06270 * CHR $46
06280  .DA #%00000000           ;....       [F]
06290  .DA #%11111100           ;###.
06300  .DA #%00000000           ;....
06310  .DA #%00000000           ;....
06320  .DA #%11000000           ;#...
06330  .DA #%00000000           ;....
06340  .DA #%00000000           ;....
06350  .DA #%00000000           ;....
06360 * CHR $47
06370  .DA #%00000000           ;....
06380  .DA #%11111100           ;###.
06390  .DA #%00000000           ;....
06400  .DA #%00000000           ;....
06410  .DA #%11110000           ;##..
06420  .DA #%00111100           ;.##.
06430  .DA #%00111100           ;.##.
06440  .DA #%11110000           ;##..
06450 * CHR $48
06460  .DA #%00000000           ;....
06470  .DA #%00111100           ;.##.
06480  .DA #%00111100           ;.##.
06490  .DA #%00111100           ;.##.
06500  .DA #%11111100           ;###.
06510  .DA #%00111100           ;.##.
06520  .DA #%00111100           ;.##.
06530  .DA #%00111100           ;.##.
06540 * CHR $49
06550  .DA #%00000000           ;....       [I]
06560  .DA #%11110000           ;##..
06570  .DA #%00000000           ;....
06580  .DA #%00000000           ;....
06590  .DA #%11000000           ;#...
06600  .DA #%11000000           ;#...
06610  .DA #%11000000           ;#...
06620  .DA #%11110000           ;##..
06630 * CHR $4A
06640  .DA #%00000000           ;....
06650  .DA #%11111100           ;###.
06660  .DA #%00000000           ;....
06670  .DA #%00000000           ;....
06680  .DA #%11110000           ;##..
06690  .DA #%11110000           ;##..
06700  .DA #%11110000           ;##..
06710  .DA #%11000000           ;#...
06720 * CHR $4B
06730  .DA #%00000000           ;....
06740  .DA #%00111100           ;.##.
06750  .DA #%11110000           ;##..
06760  .DA #%11000000           ;#...
06770  .DA #%00000000           ;....
06780  .DA #%11000000           ;#...
06790  .DA #%11110000           ;##..
06800  .DA #%00111100           ;.##.
06810 * CHR $4C
06820  .DA #%00000000           ;....       [L]
06830  .DA #%00000000           ;....
06840  .DA #%00000000           ;....
06850  .DA #%00000000           ;....
06860  .DA #%00000000           ;....
06870  .DA #%00000000           ;....
06880  .DA #%00000000           ;....
06890  .DA #%11111100           ;###.
06900 * CHR $4D
06910  .DA #%00000000           ;....
06920  .DA #%00111100           ;.##.
06930  .DA #%11111100           ;###.
06940  .DA #%11111100           ;###.
06950  .DA #%00111100           ;.##.
06960  .DA #%00111100           ;.##.
06970  .DA #%00111100           ;.##.
06980  .DA #%00111100           ;.##.
06990 * CHR $4E
07000  .DA #%00000000           ;....
07010  .DA #%00111100           ;.##.
07020  .DA #%00111100           ;.##.
07030  .DA #%00111100           ;.##.
07040  .DA #%11111100           ;###.
07050  .DA #%11111100           ;###.
07060  .DA #%00111100           ;.##.
07070  .DA #%00111100           ;.##.
07080 * CHR $4F
07090  .DA #%00000000           ;....       [O]
07100  .DA #%11110000           ;##..
07110  .DA #%00111100           ;.##.
07120  .DA #%00111100           ;.##.
07130  .DA #%00111100           ;.##.
07140  .DA #%00111100           ;.##.
07150  .DA #%00111100           ;.##.
07160  .DA #%11110000           ;##..
07170 * CHR $50
07180  .DA #%00000000           ;....
07190  .DA #%11110000           ;##..
07200  .DA #%00111100           ;.##.
07210  .DA #%00111100           ;.##.
07220  .DA #%11110000           ;##..
07230  .DA #%00000000           ;....
07240  .DA #%00000000           ;....
07250  .DA #%00000000           ;....
07260 * CHR $51
07270  .DA #%00000000           ;....
07280  .DA #%11110000           ;##..
07290  .DA #%00111100           ;.##.
07300  .DA #%00111100           ;.##.
07310  .DA #%00111100           ;.##.
07320  .DA #%00111100           ;.##.
07330  .DA #%11110000           ;##..
07340  .DA #%00111100           ;.##.
07350 * CHR $52
07360  .DA #%00000000           ;....       [R]
07370  .DA #%11110000           ;##..
07380  .DA #%00111100           ;.##.
07390  .DA #%00111100           ;.##.
07400  .DA #%11110000           ;##..
07410  .DA #%11000000           ;#...
07420  .DA #%11110000           ;##..
07430  .DA #%00111100           ;.##.
07440 * CHR $53
07450  .DA #%00000000           ;....
07460  .DA #%11111100           ;###.
07470  .DA #%00000000           ;....
07480  .DA #%00000000           ;....
07490  .DA #%11110000           ;##..
07500  .DA #%00111100           ;.##.
07510  .DA #%00111100           ;.##.
07520  .DA #%11110000           ;##..
07530 * CHR $54
07540  .DA #%00000000           ;....
07550  .DA #%11111100           ;###.
07560  .DA #%00000000           ;....
07570  .DA #%00000000           ;....
07580  .DA #%11000000           ;#...
07590  .DA #%11000000           ;#...
07600  .DA #%11000000           ;#...
07610  .DA #%11000000           ;#...
07620 * CHR $55
07630  .DA #%00000000           ;....       [U]
07640  .DA #%00111100           ;.##.
07650  .DA #%00111100           ;.##.
07660  .DA #%00111100           ;.##.
07670  .DA #%00111100           ;.##.
07680  .DA #%00111100           ;.##.
07690  .DA #%00111100           ;.##.
07700  .DA #%11110000           ;##..
07710 * CHR $56
07720  .DA #%00000000           ;....
07730  .DA #%00111100           ;.##.
07740  .DA #%00111100           ;.##.
07750  .DA #%00111100           ;.##.
07760  .DA #%00111100           ;.##.
07770  .DA #%11110000           ;##..
07780  .DA #%11110000           ;##..
07790  .DA #%11000000           ;#...
07800 * CHR $57
07810  .DA #%00000000           ;....
07820  .DA #%00111100           ;.##.
07830  .DA #%00111100           ;.##.
07840  .DA #%00111100           ;.##.
07850  .DA #%00111100           ;.##.
07860  .DA #%11111100           ;###.
07870  .DA #%11111100           ;###.
07880  .DA #%00111100           ;.##.
07890 * CHR $58
07900  .DA #%00000000           ;....       [X]
07910  .DA #%00111100           ;.##.
07920  .DA #%00111100           ;.##.
07930  .DA #%11110000           ;##..
07940  .DA #%11000000           ;#...
07950  .DA #%11110000           ;##..
07960  .DA #%00111100           ;.##.
07970  .DA #%00111100           ;.##.
07980 * CHR $59
07990  .DA #%00000000           ;....
08000  .DA #%11110000           ;##..
08010  .DA #%11110000           ;##..
08020  .DA #%11000000           ;#...
08030  .DA #%00000000           ;....
08040  .DA #%00000000           ;....
08050  .DA #%00000000           ;....
08060  .DA #%00000000           ;....
08070 * CHR $5A
08080  .DA #%00000000           ;....
08090  .DA #%11111100           ;###.
08100  .DA #%00000000           ;....
08110  .DA #%00000000           ;....
08120  .DA #%00000000           ;....
08130  .DA #%00000000           ;....
08140  .DA #%00000000           ;....
08150  .DA #%11111100           ;###.
08160 * CHR $5B-$7F BLANK
