

	.global	_start

	.data
head:		.quad	0
tail:		.quad	0
szInput:	.skip	512
szPrompt:	.asciz	"Enter a String: "
szInvalid:	.asciz	"Invalid choice, please settle from the options provided\n"

	.text
_start:

main_loop:
// opption 1
	LDR x0,=head
	BL  menu

	CMP w0, #'1'
	BNE check2

	LDR x0, =head
 	BL  display_strings
	B  main_loop
// option 2
check2:
	CMP w0, #'2'
	BNE check3

	CMP w1, #'a'
	BNE check2b

// option 2a
	LDR x0,=szPrompt
	BL  putstring

	LDR x0,=szInput
	MOV x1, #512
	BL  getstring

	LDR x0,=szInput
	LDR x1,=head
	LDR x2,=tail

	BL  linked_list
	B  main_loop

// option 2b
check2b:
	CMP w1, #'b'
	BNE invalid

//	BL  load_file
	B  main_loop

// option 3
check3:
	CMP w0, #'3'
	BNE check4

//	BL  delete_string
	B  main_loop

// option 4
check4:
	CMP w0, #'4'
	BNE check5

//	BL  edit_string
	B  main_loop

// optrion 5
check5:
	CMP w0, #'5'
	BNE check6

//	BL  string_search
	B  main_loop

// option 6
check6:
	CMP w0, #'6'
	BNE check7

//	BL  save_file
	B   main_loop


// option 7
check7:
	CMP w0, #'7'
	BEQ end

// invalid entry (not 1-7, or 2a, 2b)
invalid:
	LDR x0,=szInvalid
	BL  putstring

	B   main_loop


end:
// clear memory
	LDR x0,=head
	BL  clear_memory

// exit
	MOV x0, #0
	MOV x8, #93
	SVC 0


	.end
