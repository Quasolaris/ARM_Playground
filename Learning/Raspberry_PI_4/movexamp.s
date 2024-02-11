// example of move isntructions
.global _start

_start:
//load X2 with 0X1234FEDC4F5D6E3A
mov x2, #0x6e3a
movk x2, #0x4f5d, lsl #16
movk x2, #0xfedc, lsl #32
movk x2, #0x1234, lsl #48
svc 0
