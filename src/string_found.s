// Style Sheet
// Programmer	: Jacob Campbell & Gregory Shane
// RASM #		: 4
// Purpose		: Run string comparison and returns index of where found,
//			  returns -1 if not found. Seerch is case insensitive
// Date			: 4/12/2023

// int String_found(&string, &substring)
// Preconditions	- Pointer to a string in X0
//			- Pointer to a substring in X1
// Postconditions	- Returns an int in X0 for where the first occurrence of the
//				substring X1 in the string from X0
// All Registers except X0 - X3 are preserved

	.text
	.global string_found

string_found:
	STR	X19, [SP, #-16]!	// Push X19
	STR	X20, [SP, #-16]!	// Push X20
	STR	X21, [SP, #-16]!	// Push X21
	STR	X22, [SP, #-16]!	// Push X22
	STR	X23, [SP, #-16]!	// Push X23
	STR	LR, [SP, #-16]!		// Push LR

	MOV	X19, X0			// Copy string
 	MOV	X20, X1			// Copy substring
 	MOV	X21, #0			// init i = 0
	MOV	X22, #1			// init j = 1

	LDRB	W2, [X20]		// Get base address of substring

	CMP	w2, #0x41		// compare against 'A'
	BLT 	Loop			// branch to loop if less than

	CMP 	w2, #0x5A		// compare against 'Z'
	BGT  	Loop			// branch to loop if greater than

	ADD 	w2, w2, #0x20		// w2 = lowercase version of ascii letter

Loop:
// Find where a matching character i
	LDRB 	w1, [x19, x21]		// load string[i]
	CMP	w1, #0x00		// compare for null
	BEQ	NOT_FOUND		// branch if found

	CMP	w1, #0x41		// compare against 'A'
	BLT	search			// branch to search if less than

	CMP 	w1, #0x5A		// compare against 'Z'
	BGT	search			// Branch to search if greater than

	ADD	w1, w1, #0x20		// w2 = lowercase version of ascii letter
search:
	CMP	w1, w2			// compare string[i] and sub[i]
	ADD 	x21, x21, #1		// i++
	BNE	Loop			// branch back to loop

compare:
	LDRB	w1, [x19, x21]		// string[i]
	LDRB	w2, [x20, x22]		// sub[j]

	CMP	w2, #0x00		// check for null on substring
	BEQ	FOUND			// branch if found

	CMP	w1, #0x41		// compare against 'A'
	BLT	second			// branch to second if less than

	CMP	w1, #0x5A		// compare against 'Z'
	BGT	second			// branch to second if greater than

	ADD	w1, w1, #0x20		// w1 = lowercase version of ascii letter

second:
	CMP	w2, #0x41		// compare aganst 'A'
	BLT	continue		// branch to continue if less than

	CMP	w2, #0x5A		// compare against 'Z'
	BGT	continue		// Branch to continue if gretaer than

	ADD	w2, w2, #0x20		// w2 = lowercase version of letter

continue:
	ADD 	x21, x21, #1		// i++
	ADD	x22, x22, #1		// j++

	CMP	w1, w2			// compare string[i] and sub[j]
	BEQ	compare			// branch back if equal

	LDRB	w2, [x20]		// w2 = sub[0]
	SUB	x21, x21, x22		// i = i - j
	ADD	x21, x21, #1		// i++
	MOV	x22, #1			// j = 1
	BNE	Loop

NOT_FOUND:
	MOV	X0, #-1			// Return -1 if not found
	B	END			// Branch to end

FOUND:
	SUB	X0, X21, x22		// x0 = i - j

END:
	LDR	LR, [SP], #16		// Pop LR
	LDR	X23, [SP], #16		// Pop X23
	LDR	X22, [SP], #16		// Pop X22
	LDR	X21, [SP], #16		// Pop X21
	LDR	X20, [SP], #16		// Pop X20
	LDR	X19, [SP], #16		// Pop X19
	RET

	.end
