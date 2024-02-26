# ARM Assembly Instruction Notes

- Rd: Register Destination
- Rs: Register Source
- Op: Operand


## MOV and MOVN

MOV moves the source into the destination and can also do operations like LSL
```assembly
mov Rd, Rs, Op
mov w0, #1, LSL 5
```
w0 = 0x100000

MOVN does the same but then negates the destination register
```assembly
movn Rd, Rs, Op
movn w0, #1, LSL
```
w0 = 0x011111
