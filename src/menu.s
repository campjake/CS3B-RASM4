
	.global menu


	.data
szData:		.asciz	"\n        Data Structure Heap Memory Comsumption: "
szByte:		.asciz	" bytes\n"
szNode:		.asciz	"        Number of Nodes: "

dbNode:		.quad	0
szCount:	.skip	21
szInput:	.skip	21

szOpt1:		.asciz	"<1> View all strings\n"
szOpt2:		.asciz	"<2> Add String\n"
szOptA:		.asciz	"    <a> Keyboard\n"
szOptB:		.asciz	"    <b> from File. Static file named input.txt\n"
szOpt3:		.asciz	"<3> Delete String\n"
szOpt4:		.asciz  "<4> Edit String\n"
szOpt5:		.asciz	"<5> String serach\n"
szOpt6:		.asciz	"<6> Save file (ouput.txt)\n"
szOpt7:		.asciz	"<7> Quit\n"
szPrompt:	.asciz	"Enter choice: "
chCr:		.byte	10

	.text
menu:
	STR x19, [SP, #-16]!
	STR x20, [SP, #-16]!
	STR LR, [SP, #-16]!

	BL  data_count
	LDR x2,=dbNode
	STR x1,[x2]

	LDR x1,=szCount
	BL  int64asc

	LDR x0,=szData
	BL  putstring

	LDR x0,=szCount
	BL  putstring

	LDR x0,=szByte
	BL  putstring

	LDR x0, =dbNode
	LDR x0, [x0]
	LDR x1, =szCount
	BL  int64asc

	LDR x0,=szNode
	BL  putstring

	LDR x0,=szCount
	BL  putstring

	LDR x0,=chCr
	BL  putch

	LDR x0,=szOpt1
	BL  putstring

	LDR x0,=szOpt2
	BL  putstring

	LDR x0,=szOptA
	BL  putstring

	LDR x0,=szOptB
	BL  putstring

	LDR x0,=szOpt3
	BL  putstring

	LDR x0,=szOpt4
	BL  putstring

	LDR x0,=szOpt5
	BL  putstring

	LDR x0,=szOpt6
	BL  putstring

	LDR x0,=szOpt7
	BL  putstring

	LDR x0,=szPrompt
	BL  putstring

	LDR x0,=szInput
	MOV x1, #21
	BL  getstring

	LDR x0,=szInput
	LDRB w1, [x0,#1]
	LDRB w0, [x0]


	LDR LR, [SP], #16
	LDR x20, [SP], #16
	LDR x21, [SP], #16

	RET

.end
