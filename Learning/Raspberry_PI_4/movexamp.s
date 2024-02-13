// example of move isntructions
.global _start

_start:
//load X2 with 0X1234FEDC4F5D6E3A
mov x2, #0x6e3a
movk x2, #0x4f5d, lsl #16
movk x2, #0xfedc, lsl #32
movk x2, #0x1234, lsl #48

// mov #1 to x2 to better see shifts
mov x2, #1

// MOV shift operations
mov x1, x2, lsl #1 // logical shift left
mov x1, x2, lsr #1 // logical shift right
mov x1, x2, asr #1 // arthimetic shift right
mov x1, x2, ror #1 // rotate shift right

// shift operations
lsl x1, x2, #1 // logigal shift left
lsr x1, x2, #1 // logical shift right
asr x1, x2 , #1 // arthimetic shift right
ror x1, x2, #1 // rotate right

// example that work with 8 bit immediate and shift
mov x1, #0xAB000000 // is too big for #imm16

svc 0
