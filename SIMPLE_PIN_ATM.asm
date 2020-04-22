	;Kelompok	: Cherry Trail
	;Topik		: 15
	;Kelas		: SBK-01
	;Anggota	: 
	;•	Alfian Badrul Isnan	- 1806148643
	;•	Nadhifa Khalista - 1806148800
	;•	Natalia Kristian – 1806200103
	;BUTTON A ENTER
	;BUTTON B -
	;BUTTON C CLEAR ALL/CANCEL
	;BUTTOM D DELETE/CORRECT
	;R0 SHIFT REGISTER FOR PORT 2
	;P2 -> 0-3 BUTTON, 4-7 DISPLAY
	;KEYPAD INTERFACING
	;P0.0	1	2	3	A
	;P0.1	4	5	6	B
	;P0.2	7	8	9	C
	;P0.3	*	0	#	D
	;	P2.3	P2.2	P2.1	P2.0
	;4-DIGIT LED 7SEG
	;P2.7
	;P2.6
	;P2.5
	;P2.4
	;	P1.0 - P1.7
ORG 0H
	MOV P0, #FBIT ;IINPUT KEYPAD
	MOV R0, #0 ;COUNTER
	MOV R1, #10 ;REGISTER TO SAVE LAST DIGIT1
	MOV R2, #10 ;REGISTER TO SAVE LAST DIGIT2
	MOV R3, #10 ;REGISTER TO SAVE LAST DIGIT3
	MOV R4, #10 ;REGISTER TO SAVE LAST DIGIT4
	MOV R5, #0 ;FLAGS
	MOV 18H, #4
	;BANK 2
	;R0 DIGIT COUNTER
	;R1 COUNTER
	;R2 LAST INPUT READ
	;R3 VARIABLE
	;R4 VARIABLE
	MOV DPTR, #SEG
LOOP:	ACALL CHECK
	SJMP LOOP
CHECK:	SETB RS1
	SETB RS0
;;;;;;;;;;;;;;;;;;;;;;;;;
	MOV P2, #11111110B
	MOV B, P0
	MOV A, 13H
	CJNE A, B, ISD4
	SJMP NOTD1
ISD4:	MOV 13H, B
	MOV R2, B
	CJNE R2, #0FEH, NOTA	;ISA
	CJNE R0, #0, TODISP1
	SJMP SDISP1
TODISP1:LJMP DISP
SDISP1:	CLR RS1
	CLR RS0
	MOV R0, #4
	MOV DPTR, #PASS
	MOV R5, #1
LCHECK: MOV B, @R0
	MOV A, R0
	DEC A
	MOVC A, @A+DPTR
	CJNE A,B,ISFAIL
	DJNZ R0, LCHECK
	MOV DPTR, #ACCM
	LJMP DISP
	SETB RS0
	SETB RS1
ISFAIL:	MOV DPTR, #FAILM
	LJMP DISP
NOTA:	CJNE R2, #0FBH, NOTC	;ISC
	CJNE R0, #4, ISDEL
	LJMP DISP
ISDEL:	MOV R3, SP
	MOV R1, #4
	MOV B, #10
	MOV SP, #0
	MOV R0, #4
LOOPC:	PUSH B
	DJNZ R1, LOOPC
	MOV SP, R3
	MOV DPTR, #SEG
	MOV 5H, #0
	LJMP DISP
NOTC:	CJNE R2, #0F7H, NOTD1;ISD
	CJNE R0, #4, ISBCK
	LJMP DISP
ISBCK:	MOV R3, SP
	MOV SP, R0
	MOV A, #10
	PUSH A
	INC R0
	MOV SP, R3
	MOV DPTR, #SEG
	MOV 5H, #0
	LJMP DISP
;;;;;;;;;;;;;;;;;;;;;;;;;
NOTD1:	CJNE R0, #0, ISD2T
	LJMP DISP
ISD2T:	MOV P2, #11111101B
	MOV B, P0
	MOV A, 12H
	CJNE A, B, ISD3
	SJMP NOTD2
ISD3:	MOV 12H, B
	MOV R2, B
	CJNE R2, #0FEH, NOT3	;IS 3
	MOV A, #3
	SJMP SETD
NOT3:	CJNE R2, #0FDH, NOT6	;IS 6
	MOV A, #6
	SJMP SETD
NOT6:	CJNE R2, #0FBH, NOTD2	;IS 9
	MOV A, #9
	SJMP SETD
;;;;;;;;;;;;;;;;;;;;;;;;;
NOTD2:	MOV P2, #11111011B
	MOV B, P0
	MOV A, 11H
	CJNE A, B, ISD2
	SJMP NOTD3
ISD2:	MOV 11H, B
	MOV R2, B
	CJNE R2, #0FEH, NOT2	;IS 2
	MOV A, #2
	SJMP SETD
NOT2:	CJNE R2, #0FDH, NOT5	;IS 5
	MOV A, #5
	SJMP SETD
NOT5:	CJNE R2, #0FBH, NOT8	;IS 8
	MOV A, #8
	SJMP SETD
NOT8:	CJNE R2, #0F7H, NOTD3	;IS 0
	MOV A, #0
	SJMP SETD
;;;;;;;;;;;;;;;;;;;;;;;;;
NOTD3:	MOV P2, #11110111B
	MOV B, P0
	MOV A, 10H
	CJNE A, B, ISD1
	SJMP DISP
ISD1:	MOV 10H, B
	MOV R2, B
	CJNE R2, #0FEH, NOT1 	;IS 1
	MOV A, #1
	SJMP SETD
NOT1:	CJNE R2, #0FDH, NOT4	;IS 4
	MOV A, #4
	SJMP SETD
NOT4:	CJNE R2, #0FBH, DISP	;IS 7
	MOV A, #7
	SJMP SETD
SETD:	MOV @R0, A
	DEC R0
;;;;;;;;;;;;;;;;;;;;;;;;;
DISP:	MOV P2, #11110111B
	CLR RS1
	CLR RS0
	MOV R0, #4
LDISP:	CJNE R5, #1, ISNUM
	MOV A, R0
	DEC A
	SJMP ISNTM
ISNUM:	MOV A, @R0
ISNTM:	MOVC A, @A+DPTR
	MOV B, A
	MOV P1, #FBIT
	MOV A, P2
	RL A
	MOV P2, A
	MOV P1, B
	DJNZ R0, LDISP
	RET
ORG 1A0H
;COMMON ANODE 7SEG
SEG: 	DB 0xC0;0
	DB 0xF9;1
	DB 0xA4;2
	DB 0xB0;3
	DB 0x99;4
	DB 0x92;5
	DB 0x82;6
	DB 0xF8;7
	DB 0x80;8
	DB 0x90;9
	DB NULL;NULL
FAILM:	DB 0xC7,0xCF,0x88,0x8E;DISP "FAIL"
ACCM:	DB 0x8C,0xC6,0xC6,0x88;DISP "ACCP"
PASS:	DB 1,0,6,2;REAL PASS (2601)
NULL EQU 0xBF
FBIT EQU 0xFF
END
