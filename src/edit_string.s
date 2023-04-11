// Style Sheet
// Programmer   : Jacob Campbell & Gregory Shane
// RASM #       : 4
// Purpose      : Text Editor
// Date         : 4/20/2023

// This function allows the user to search a list for a node 
// that is n spots from the head
// The function then allows the user to edit the string at the node

// Pre-conditions:
//	X0 - Contains the index # of the string
//	X1 - Contains the pointer to the head of the list
//	X2 - Contains the length of the list
//	X3 - Contains the size of each node (16 bytes for RASM4)
//	*** Assumes the last 8 bytes of node are next pointer***

// Post-conditions:
//	String in node, if found, is replaced with user input

// Registers X0 - X10 are modified and not preserved (int64asc)

	.data
szNewStrInput:	.skip	512		// New string to get from user
szIndexAsStr	.skip	21		// Largest number in 64-bit
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
	STR		LR, [SP, #-16]!		// Push LR

// Find the node requested by the user	
	MOV		X19, X0					// Copy index to X19
	BL		sequential_search_list	// Get the node, if it exists, in X0
	CMP		X0, #-1					// Make sure it exists
	BEQ		string_not_found		// Let user know the string isn't there
	MOV		X20, X0					// Copy node address to X20

// Convert index number to string
	MOV		X0, X19					// Copy index back to X0
	LDR		X1,=szIndexAsStr		// Load pointer to index as a string
	BL		int64asc				// X1 points to indexStr

// Print the string
	LDR		X0,=chTAB				// Load tab
	BL		putch					// Print tab

	LDR		X0,=szLine				// Load "Line "
	BL		putstring				// Print "Line "

	LDR		X0,=szIndexAsStr		// Load indexStr
	BL		putstring				// Print indexStr

	LDR		X0,=szColon				// Load ": "
	BL		putstring				// Print ": "

	LDR		X0, [X19]				// Load address of string to X0 
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
	LDR		X1, [X19]				// Load the node
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
	LDR		X21, [SP], #16		// Pop X21
	LDR		X20, [SP], #16		// Pop X20
	LDR		X19, [SP], #16		// Pop X19
	RET