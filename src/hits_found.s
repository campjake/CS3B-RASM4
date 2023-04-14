// x0 = head
// x1 = string being searched

	.global hits_found

	.data

szSearch:		.asciz	"\nSearch \""
szSearch2:		.asciz	"\" ("
szSearch3:		.asciz	" hits in 1 file of 1 searched)\n"

szHits:		.skip	21
szTotal:	.skip	21


	.text
hits_found:
	STR x19, [SP, #-16]!
	STR x20, [SP, #-16]!
	STR x21, [SP, #-16]!
	STR x22, [SP, #-16]!
	STR x30, [SP, #-16]!

	MOV x19, x0		// copy head
	MOV x20, x1		// copy string
	MOV x21, #0		// hit counter

	LDR x19, [x19]

hits_search:
	LDR x0, [x19]
	MOV x1, x20
	BL  string_found

	CMP w0, #-1
	BNE hit_count

	B   next

hit_count:
	ADD x21, x21, #1

next:
	LDR x22, [x19, #8]
	MOV x19, x22
	CMP x19, #0x00
	BNE hits_search

// display results
	LDR x0,=szSearch
	BL  putstring

	MOV x0, x20
	BL  putstring

	LDR x0,=szSearch2
	BL  putstring

	MOV x0, x21
	LDR x1,=szHits
	BL  int64asc

	LDR x0,=szHits
	BL  putstring

	LDR x0,=szSearch3
	BL  putstring

	LDR x30, [SP], #16
	LDR x22, [SP], #16
	LDR x21, [SP], #16
	LDR x20, [SP], #16
	LDR x19, [SP], #16

	RET
	.end

