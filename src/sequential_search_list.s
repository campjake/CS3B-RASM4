// Style Sheet
// Programmer   : Jacob Campbell & Gregory Shane
// RASM #       : 4
// Purpose      : Text Editor
// Date         : 4/20/2023

// This function allows the user to search a list for a node 
// that is n spots from the head

// The program utilizes a sequential search of an unordered list
// and is provided an index number to search for the string

// Pre-conditions:
//	X0 - Contains the index # of the string
//	X1 - Contains the pointer to the head of the list
//	X2 - Contains the length of the list
//	X3 - Contains the size of each node (16 bytes for RASM4)
//	*** Assumes the last 8 bytes of node are next pointer***

// Post-conditions:
//	X0	- Contains pointer to the node, or -1 if not found

	.global sequential_search_list
	.text

sequential_search_list:
	STR		X19, [SP, #-16]!	// Push X19
	STR		X20, [SP, #-16]!	// Push X20
	STR		X21, [SP, #-16]!	// Push X21
	STR		x30, [SP, #-16]!

// Check if the node could possibly exist (input error check)
	CMP		X0, X2			// Compare index number and listLength
	BGT		node_not_found	// Node cannot exist if index > listLength

// Initialize data
	LDR		X19, [X1]		// Copy address of node1 in X19
	SUB		X20, X3, #8		// Number of bytes before node->next
	MOV		X21, #0			// int i = 0; (index for loop)

// Check if first node is the correct node
	CMP		X21, X0			// Make sure we aren't looking for node1
	BEQ		node_found		// Branch to found node if true

find_node:
	ADD		X19, X19, X20	// Go to node->next
	LDR		X19, [X19]		// Get address of next node
	CMP		X19, 0x00		// Check if we hit the end of the list
	BEQ		node_not_found	// Branch to handle node not found
	ADD		X21, X21, #1	// i++
	CMP		X21, X0			// Compare i == index
	BEQ		node_found		// Branch if the node was found
	B		find_node		// Else keep looking for node

node_not_found:
	MOV	X0, #-1				// -1 if node isn't found
	B	done				// branch to done

node_found:
	MOV	X0, X19				// Address of node in X0

done:
	LDR		x30, [SP], #16
	LDR		X21, [SP], #16		// Pop X21
	LDR		X20, [SP], #16		// Pop X20
	LDR		X19, [SP], #16		// Pop X19
	RET
