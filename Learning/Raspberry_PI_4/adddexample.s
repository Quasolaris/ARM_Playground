.global _start
_start:

	// multiply 4 by -1 witzh movn and then adding 1
	// means: 0010 (little endian) -> movn -> 1101 
	// 1101 add 0001 -> 11111111111111111111111111111110 = -2
	movn w0, #16
	add w0, w0, #1

