// Style Sheet
// Programmer   : Jacob Campbell & Gregory Shane
// RASM #       : 4
// Purpose      : Text Editor
// Date         : 4/20/2023

// This function allows the user to search a list for a node 
// that is n spots from the head
// The function then allows the user to delete the node

// Pre-conditions:
//	X1 - Contains the pointer to the head of the list
//	*** Assumes the last 8 bytes of node are next pointer***

// Post-conditions:
//	String in node, if found, is replaced with user input

// Registers X0 - X10 are modified and not preserved (int64asc)

	.data
szCurrentStr:	.asciz	"String found! Printing string...\n\n"
szNoString:		.asciz	"The string was not found\n\n"
szGetIndexPr:	.asciz	"Enter search index: "
szIndexAsStr	.skip	21		// Largest number in 64-bit
szGetConfirm:	.asciz	"Are you sure you want to delete this string? (Y/N): "
szUserConfirm:	.skip	2		// 'Y'/'N' from user + null
szConfirm:		.asciz	"... Done! The string has been deleted.\n\n"
szLine:			.asciz	"Line "
szColon:		.asciz	": "
szAbort:		.asciz	"Deletion was canceled"
chLF:			.byte	0xA		// Line Feed
chTAB:			.byte	0x9		// Tab

	.global delete_string
	.text

delete_string:
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
	LDR		szIndexAsStr		// Load address of string
	BL		ascint64			// X0 = index

// Find the node requested by the user	
	MOV		X21, X0					// Copy index to X21
	MOV		X1, X19					// Copy head to X1
	MOV		X2, X20					// Copy listLength to X2
	MOV		X3, #16					// Node size in X3
	BL		sequential_search_list	// Get the node, if it exists, in X0

	CMP		X0, #-1					// Make sure node exists
	BEQ		string_not_found		// Let user know the string isn't there
	MOV		X22, X0					// Copy node address to X22

// Find the node right before it	
	SUB		X21, X0, #1				// Copy (index - 1) to X21
	MOV		X1, X19					// Copy head to X1
	MOV		X2, X20					// Copy listLength to X2
	MOV		X3, #16					// Node size in X3
	BL		sequential_search_list	// Get the node, if it exists, in X0

	CMP		X0, #-1					// Make sure node exists
	BEQ		string_not_found		// Let user know the string isn't there
	MOV		X23, X0					// Copy node address to X23
	ADD		X23, X23, #8			// X23 points to tail
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

// Get confirmation from the user
	LDR		X0,=szGetConfirm		// Load confirmation request
	BL		putstring				// Print confirmation req.

	LDR		X0,=szUserConfirm		// Load buffer
	MOV		X1, #2					// Size of buffer
	BL		getstring				// String saved to memory

// Convert confirmation to uppercase in case user input is lowercase
	LDR		X0,=szGetConfirm		// Load string
	BL		toUpperCase				// Convert to uppercase

	LDRB	W0, [X0]				// Dereference to get Y/N
	CMP		X0, 0x59				// Compare to 'Y'
	BNE		abort_delete			// Jump to abort

// free() the string
	MOV		X1, #0				// Make sure we don't get rid of something we need
	MOV		X2, #0				// Make sure we don't get rid of something we need
	MOV		X3, #0				// Make sure we don't get rid of something we need
	LDR		X0, [X22]			// Dereference node for string address
	STR		X19, [SP, #-16]!	// Push X19
	STR		X20, [SP, #-16]!	// Push X20
	STR		X21, [SP, #-16]!	// Push X21
	STR		X22, [SP, #-16]!	// Push X22
	STR		LR, [SP, #-16]!		// Push LR
	BL		free				// free() the string
	LDR		LR, [SP], #16		// Pop LR
	STR		X22, [SP, #-16]!	// Push X22
	LDR		X21, [SP], #16		// Pop X21
	LDR		X20, [SP], #16		// Pop X20
	LDR		X19, [SP], #16		// Pop X19

// prev node.next = current node.next
	MOV		X0, X22				// Copy node address to X0
	ADD		X24, X22, #8		// Get tailPtr in X24
	LDR		X24, [X24]			// Get address of next node
	STR		X24, [X23]			// Store next node to tail of prev node

// free() the node	
	STR		X19, [SP, #-16]!	// Push X19
	STR		X20, [SP, #-16]!	// Push X20
	STR		X21, [SP, #-16]!	// Push X21
	STR		LR, [SP, #-16]!		// Push LR
	BL		free				// free() the node
	LDR		LR, [SP], #16		// Pop LR
	LDR		X21, [SP], #16		// Pop X21
	LDR		X20, [SP], #16		// Pop X20
	LDR		X19, [SP], #16		// Pop X19

abort_delete:
	LDR		X0,=szAbort				// Load cancel message
	BL		putstring				// Print cancel message

	LDR		X0,=chLF				// Load Line Feed
	BL		putch					// Print Line Feed

	LDR		X0,=chLF				// Load Line Feed
	BL		putch					// Print Line Feed
	