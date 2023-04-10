// x0 = string
// x1= head
// x2 = tail

	.global linked_list

	.text
linked_list:
	STR x19, [SP, #-16]!
	STR x20, [SP, #-16]!
	STR x21, [SP, #-16]!
	STR x30, [SP, #-16]!

	MOV x19, x1		// address of head
	MOV x20, x2		// address of tail

	BL  String_copy		// copy string

	MOV x21, x0		// copy of malloc string

	MOV x0, #16		// 16 bytes for node
	BL  malloc		// create node

	STR x21, [x0]		// store string inside of node
	MOV x3, #0		// load x3 with 0
	STR x3, [x0, #8]	// store inside 2 part of node

	LDR x1, [x19]		// load address in head
	CMP x1, #0		// compare address
	BNE link

	STR x0, [x19]		// store inside head
	STR x0, [x20]		// store inside tail

	B   finish

link:
	LDR x1, [x20]		// load address store in tail
	STR x0, [x1, #8]	// store inside second half of tail node
	STR x0, [x20]		// store new tail


finish:
	LDR x30, [SP], #16
	LDR x21, [SP], #16
	LDR x20, [SP], #16
	LDR x19, [SP], #16


	RET
