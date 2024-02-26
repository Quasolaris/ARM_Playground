.global _start
_start:

	// multiply 4 by -1 witzh movn and then adding 1
	// means: 0010 (little endian) -> movn -> 1101 
	// 1101 add 0001 -> 11111111111111111111111111111110 = -2
	movn 	w0, #16
	add		w0, w0, #1

	// add can take an operand2 like lsl
	add 	w0, w0, w0, lsl 3
	mov 	w0, w0
	
	// make program retun result as return code
	// w0 is retun register
	mov 	w0, #10
	add 	w0, w0, #1

	// service command code 93, move into x8
	mov 	x8, #93
	// call linux to terminate
	svc		0


