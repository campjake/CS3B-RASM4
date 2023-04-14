// Programmer: Gregory Shane and Jacob Campbell
// CS3B - Spring 2023
// RASM4 - Save File
// Last Modified: 4.11.2023
//
// Save_file routine takes the pointer to the first node of a linked-list and writes
//   the contents to a predetermined file. The subroutine will create the file if it not
//   found in the local directory.
//
//   x0 must contain the pointer to the first node of a linked-list
//   LR must contain return address
//   ALL AAPCS mandated registers are preserved.
//   x0-x3. x8 are changed.

	.global save_file		// set starting point for subroutine

	.data
szPromptOF:	.asciz	"\nSave File as: "
szSaved:	.asciz	"Saved file to local directory.\n"
szOutFile:	.skip	512

	.text
save_file:
	STR x19, [SP, #-16]!		// PUSH
	STR x20, [SP, #-16]!		// PUSH
	STR x21, [SP, #-16]!		// PUSH

	STR x30, [SP, #-16]!		// PUSH LR

	MOV x20, x0			// store copy to first node

	LDR x0,=szPromptOF		// point to szPromptOF
	BL  putstring			// display to terminal

	LDR x0,=szOutFile		// point to szOutFile
	MOV x1, #512			// maximum character input is 512 characters
	BL  getstring			// cin >> OutFile

	MOV x0, -100			// location is local directory
	LDR x1, =szOutFile		// point to szOutFile
	MOV x2, #0101			// Write/Create if file not found
	MOV x3, #0600			// set persmissions
	MOV x8, #56			// Service Code 56 for OpenAt
	SVC 0				// Call Linux to Open file for writing

	MOV x19, x0			// copy iFD
	LDR x20, [x20]			// load node address

write:
	LDR x0, [x20]			// load string stored in node

	BL  String_length		// String_length(string) for # of bytes to write
	MOV x2, x0			// x2 = # 0f bytes to write

	MOV x0, x19			// x0 = iFD
	LDR x1, [x20]			// x1 = string inside of node
	MOV x8, #64			// Service Code 64 for write
	SVC 0				// Call Linux to write to file

	LDR x21, [x20, #8]		// x21 points to next node
	MOV x20, x21			// x20 = next node

	CMP x20, #0x00			// compare for 0
	BNE write			// branch back to write if not found

end_save:
	LDR x0,=szSaved			// point to szSaved
	BL  putstring			// display to terminal

	MOV x0, x19			// x0 = iFD
	MOV x8, #57			// Service Code 57 for close
	SVC 0				// Call Linux to close file

	LDR x30, [SP], #16		// POP LR
	LDR x21, [SP], #16		// POP
	LDR x20, [SP], #16		// POP
	LDR x19, [SP], #16		// POP

	RET				// Return

	.end
