// x0 = head


	.global display_strings

	.data
chSP:		.byte	32
chLS:		.byte	60
chRS:		.byte	62
szIndDS:	.skip	21

	.text
display_strings:

	STR x19, [SP, #-16]!
	STR x20, [SP, #-16]!
	STR x30, [SP, #-16]!

	MOV x19, x0
	LDR x19, [x19]
	MOV x21, #0

display:
	MOV x0, x21
	LDR x1,=szIndDS
	BL  int64asc

	LDR x0,=chLS
	BL  putch

	LDR x0,=szIndDS
	BL  putstring

	LDR x0,=chRS
	BL  putch

	LDR x0,=chSP
	BL  putch

	LDR x0, [x19]
	BL  putstring

	LDR x20, [x19, #8]
	MOV x19, x20

	ADD x21, x21, #1

	CMP x19, #0x00
	BNE display

	LDR x30, [SP], #16
	LDR x20, [SP], #16
	LDR x19, [SP], #16

	RET
