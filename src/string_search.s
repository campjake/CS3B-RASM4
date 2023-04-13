// Programmer: Gregory Shane and Jacob Campbell
// CS3B - Spring 2023
// RASM4 - String_search
// Last Modified: 4.13.2023
//
// Requries: String_found subroutine
//
// String_search subroutine takes pointers to a linked-list and a string, and runs a check to see if any
//   of the nodes contain the given string. Uses String_found to return an index of where the string is
//   found, and if is found, displays the results back to the terminal.
//
//   x0 must contain a address of a label that points to the first node of a linked-list
//   x1 must contain the address of the string that is being searched
//   LR must contain the returning address
//   ALL AAPCS mandated registers are preserved
//   x0-x3 are modified

	.global string_search		// point to start of subroutine

	.data
szLT:		.asciz	"<"
szGT:		.asciz	"> "
szIndex:	.skip	21		// string to output index

	.text
string_search:
	STR x19, [SP, #-16]!		// PUSH
	STR x20, [SP, #-16]!		// PUSH
	STR x21, [SP, #-16]!		// PUSH
	STR x22, [SP, #-16]!		// PUSH
	STR x30, [SP, #-16]!		// PUSH LR

	MOV x19, x0			// copy head
	MOV x20, x1			// copy substring
	MOV x21, #0			// index

	LDR x19, [x19]			// load node address

search:
	LDR x0, [x19]			// string address
	MOV x1, x20			// substring
	BL  string_found		// string_found(string, substring)

	CMP w0, #-1			// compare for x0 to have a -1 (nothing found)
	BNE display_index		// Branch if not equal to display_index

	B   next_node			// Brnach to next_node

display_index:
	LDR x0,=szLT			// point to szLT
	BL  putstring			// display to terminal

	MOV x0, x21			// copy index to x0
	LDR x1,=szIndex			// point to szIndex
	BL  int64asc			// convert int index to string

	LDR x0,=szIndex			// point to szIndex
	BL  putstring			// display to terminal

	LDR x0,=szGT			// point to szGT
	BL  putstring			// display to terminal

	LDR x0, [x19]			// point to string inside node
	BL  putstring			// display to terminal

next_node:
	LDR x22, [x19, #8]		// x22 = next node
	MOV x19, x22			// overide x19 with next node
	CMP x19, #0x00			// compare x19 for 0x00
	BEQ search_end			// branch to search_end if found

	ADD x21, x21, #1		// index ++ 1
	B   search			// branch back to search

search_end:
	LDR x30, [SP], #16		// POP LR
	LDR x22, [SP], #16		// POP
	LDR x21, [SP], #16		// POP
	LDR x20, [SP], #16		// POP
	LDR x19, [SP], #16		// POP

	RET				// Return
	.end
