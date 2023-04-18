// Style Sheet
// Programmer   : Jacob Campbell & Gregory Shane
// RASM #       : 4
// Purpose      : Text Editor
// Date         : 4/20/2023

// This function allows the user to search a list for a node 
// that is n spots from the head
// The function then allows the user to edit the string at the node

// Pre-conditions:
//	X1 - Contains the pointer to the head of the list
//	*** Assumes the last 8 bytes of node are next pointer***

// Post-conditions:
//	String in node, if found, is replaced with user input

// Registers X0 - X10 are modified and not preserved (int64asc)

	.data
szNewStrInput:	.skip	512		// New string to get from user
szIndexAsStr:	.skip	21		// Largest number in 64-bit
szGetIndexPr:	.asciz	"Enter search index: "
szCurrentStr:	.asciz	"String found! Printing string...\n\n"
szNoString:		.asciz	"The string was not found\n\n"
szNewStrPrompt:	.asciz	"Enter edited string below: "
szConfirm:		.asciz	"... Done! The string has been replaced.\n\n"
szLine:			.asciz	"Line "
szColon:		.asciz	": "
chLF:			.byte	0xA		// Line Feed
chTAB:			.byte	0x9		// Tab

	.global edit_string
	.text

edit_string:
	STR		X19, [SP, #-16]!	// Push X19
	STR		X20, [SP, #-16]!	// Push X20
	STR		X21, [SP, #-16]!	// Push X21
	STR		X22, [SP, #-16]!	// Push X22
	STR		LR, [SP, #-16]!		// Push LR

// Get listLength
	MOV		X19, X1				// Copy head
	BL		data_count			// X1 = listLength
	MOV		X20, X1				// Copy list length

// Prompt User for index number
	LDR		X0,=szGetIndexPr	// Load address of prompt
	BL		putstring			// Print Prompt

// Get Index Number
	LDR		X0,=szIndexAsStr	// Load address of buffer
	MOV		X1, #21				// Size of buffer
	BL		getstring			// String stored to memory

	LDR		X0,=chLF			// Load Line Feed
	BL		putch				// Print Line Feed

	LDR		X0,=chLF			// Load Line Feed
	BL		putch				// Print Line Feed

// Convert Index to int
	LDR		X0,=szIndexAsStr	// Load address of string
	BL		ascint64			// X0 = index

// Find the node requested by the user	
	MOV		X21, X0					// Copy index to X21
	MOV		X1, X19					// Copy head to X1
	MOV		X2, X20					// Copy listLength to X2
	MOV		X3, #16					// Node size in X3
	BL		sequential_search_list	// Get the node, if it exists, in X0

	CMP		X0, #-1					// Make sure node exists
	BEQ		string_not_found		// Let user know the string isn't there
	MOV		X22, X0					// Copy node address to X20

// Print the string
	LDR		X0,=chTAB				// Load tab
	BL		putch					// Print tab

	LDR		X0,=szLine				// Load "Line "
	BL		putstring				// Print "Line "

	LDR		X0,=szIndexAsStr		// Load indexStr
	BL		putstring				// Print indexStr

	LDR		X0,=szColon				// Load ": "
	BL		putstring				// Print ": "

	LDR		X0, [X22]				// Load address of string to X0 
	BL		putstring				// Print string for user to see

	LDR		X0,=chLF				// Load Line Feed
	BL		putch					// Print Line Feed

	LDR		X0,=chLF				// Load Line Feed
	BL		putch					// Print Line Feed

// Get the new string from user
	LDR		X0,=szNewStrPrompt		// Load Prompt
	BL		putstring				// Print Prompt

	LDR		X0,=chLF				// Load Line Feed
	BL		putch					// Print Line Feed

	LDR		X0,=chLF				// Load Line Feed
	BL		putch					// Print Line Feed

	LDR		X0,=szNewStrInput		// Load buffer
	MOV		X1, #512				// Load sizeBuffer
	BL		getstring				// String saved to memory

// Edit the string in the node
	LDR		X1, [X22]				// Load the node
	LDR		X1, [X1]				// Load the address of the string

	LDR		X0,=szNewStrInput		// Load the address of the new string
	LDR		X0, [X0]				// Load the new string
	STR		X0, [X1]				// Overwrite the old string in node
	B	done						// Branch to done

string_not_found:
	LDR	X0,=szNoString				// Load NoString message for user
	BL	putstring					// Print NoString message for user

done:
	LDR		LR, [SP], #16		// Pop LR
	STR		X22, [SP, #-16]!	// Push X22
	LDR		X21, [SP], #16		// Pop X21
	LDR		X20, [SP], #16		// Pop X20
	LDR		X19, [SP], #16		// Pop X19
	RET
	