
	.global clear_memory

	.text
clear_memory:
	STR x19, [SP, #-16]!
	STR x20, [SP, #-16]!
	STR x21, [SP, #-16]!
	STR x30, [SP, #-16]!


	MOV x19, x0
	LDR x19, [x19]

cleanup:
	LDR x21, [x19]
	LDR x20, [x19, #8]

	MOV x0, x21
	BL  free

	MOV x0, x19
	BL  free

	MOV x19, x20
	CMP x19, #0x00
	BNE cleanup

	LDR x30, [SP], #16
	LDR x21, [SP], #16
	LDR x20, [SP], #16
	LDR x19, [SP], #16


	RET
