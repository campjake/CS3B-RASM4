// Programmer: Gregory Shane and Jacob Campbell
// CS3B - Spring 2023
// RASM4
// Purppse:
// Last Modified: 4.11.2023

	.global	_start		// set starting point of program

	.data
head:		.quad	0	// headPtr
tail:		.quad	0	// tailPtr
szInput:	.skip	512	// input from user
szPrompt:	.asciz	"Enter a String: "
szInvalid:	.asciz	"Invalid choice, please settle from the options provided\n"

	.text
_start:

main_loop:
// opption 1
	LDR x0,=head		// point to head
	BL  menu		// calls menu to terminal

	CMP w0, #'1'		// compare w0 for ascii '1'
	BNE check2		// Branch if not equal to check2

	LDR x0, =head		// point to head
 	BL  display_strings	// calls display strings t0 terminal
	B  main_loop		// Branch back to main_loop

// option 2
check2:
	CMP w0, #'2'		// compare w0 for ascii '2'
	BNE check3		// Brnach to check3 if not found

	CMP w1, #'a'		// compare w1 for ascii 'a'
	BNE check2b		// Branch to check2b if not found

// option 2a
	LDR x0,=szPrompt	// point to szPrompt
	BL  putstring		// display to terminal

	LDR x0,=szInput		// point to szInput
	MOV x1, #512		// max input is 512 characters
	BL  getstring		// cin >> input

	LDR x0,=szInput		// point to szInput
	LDR x1,=head		// x1 point to head
	LDR x2,=tail		// x2 point to tail

	BL  linked_list		// call lined_list(string, head, tail)
	B  main_loop		// Branch back to main_loop

// option 2b
check2b:
	CMP w1, #'b'		// check w2 for ascii 'b'
	BNE invalid		// branch to invalid if not found

	LDR x0,=head		// x0 points to head
	LDR x1,=tail		// x1 points to tail
	BL  load_file		// calls load_file(head,tail)
	B  main_loop		// Branch back to main_loop

// option 3
check3:
	CMP w0, #'3'		// check w3 for ascii '3'
	BNE check4		// Branch to check4 if not found

//	BL  delete_string
	B  main_loop		// Branch back to main_loop

// option 4
check4:
	CMP w0, #'4'		// check w0 for ascii '4'
	BNE check5		// Branch to check5 if not found

//	BL  edit_string
	B  main_loop		// Branch back to main_loop

// optrion 5
check5:
	CMP w0, #'5'		// check w0 for ascii '5'
	BNE check6		// Branch to check6 if not found

//	BL  string_search
	B  main_loop		// Branch back to main_loop

// option 6
check6:
	CMP w0, #'6'		// check w0 for ascii '6'
	BNE check7		// Branch to check7 if not found

	LDR x0,=head
	BL  save_file		// call save_file(head)
	B   main_loop		// Branch back to main_loop


// option 7
check7:
	CMP w0, #'7'		// check w0 for ascii '7'
	BEQ end			// Branch to end if found

// invalid entry (not 1-7, or 2a, 2b)
invalid:
	LDR x0,=szInvalid	// point to szInvalid
	BL  putstring		// display to terminal

	B   main_loop		// Branch back to main_loop

end:
// clear memory
	LDR x0,=head		// point to head
	BL  clear_memory	// call free function(head)

// exit
	MOV x0, #0		// Return code 0
	MOV x8, #93		// Service code 93 for terminate
	SVC 0			// call Linux to terminate

	.end
