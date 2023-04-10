// x0 = headPtr

	.global data_count

	.text
data_count:
	STR x19, [SP, #-16]!
	STR x20, [SP, #-16]!
	STR x21, [SP, #-16]!
	STR x30, [SP, #-16]!

	LDR x0,[x0]

	CMP x0, #0
	BEQ zero

	MOV x19, x0	// copy head ptr

count:
	LDR x0, [x0]
	BL  String_length

	ADD x20, x20, x0
	ADD x20, x20, #1
	ADD x20, x20, #16
	ADD x21, x21, #1

	LDR x0,[x19, #8]
	CMP x0, #0
	MOV x19, x0
	BNE count
	B  end_count

zero:
	MOV x20, #0
	MOV x21, #0

end_count:
	MOV x0, x20
	MOV x1, x21

	LDR x30, [SP], #16
	LDR x21, [SP], #16
	LDR x20, [SP], #16
	LDR x19, [SP], #16

	RET
