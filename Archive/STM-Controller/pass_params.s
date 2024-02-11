                AREA myCode, CODE, READONLY 
 
                THUMB 

globalParam         SPACE   1
globalResult        SPACE   1
 
main            PROC 
                EXPORT main 
                
                B example_1
example_1
; pass by value 
                MOVS    R1, #4
                BL      adding_two
                B main


adding_two      PUSH    {R3, R4, R5, R6, R7, LR}
                
                ADDS    R1, #2
                MOVS    R0, R1

                PUSH    {R3, R4, R5, R6, R7, LR}
                BX      LR

;===============================================

; table
sample_table1   DCD     0x00010000, 0x00011700, 0x00012088, 0x00028fa0, 0x0003f800, 0x0010cb8a, 0x00600d00, 0x009b1b12

example_2
; pass by reference
                LDR     R0, =sample_table1
                MOVS    R1, #8              ; length of table
                BL       adding_two_table
                B main

adding_two_table
                PUSH    {R3, R4, R5, R6, R7, LR}
                
                CMP     R1, #0
                BLT     end_loop

                MOVS    R4, R0          ; get start address of list
                MOVS    R5, R1          ; calculate last index
                MOVS    R6, #4          ; per number 4 memory slots/places
                MULS    R5, R6, R5      ; multiply element count with 4 to get bits to last index
                ADDS    R4, R5          ; add jump length to start of list

                loop
                CMP     R1, #0
                BLT     end_loop

                SUBS    R4, #4          ; go back one jump to start reading list item
                LDR     R2, [R4]        ; read list item
                ADDS    R2, #2          ; add two to index value
                SUBS    R1, #1          ; decrement loop counter
                B       loop

                end_loop
                PUSH    {R3, R4, R5, R6, R7, LR}
                BX      LR



;===============================================               
example_3
; global variable
                LDR     R4, =globalParam
                MOVS    R5, #5
                STRB    R5, [R4]        ; saves number 5 into address used for global param
                BL       mult_by_two
                LDR     R4, =globalResult
                LDRB    R5, [R4]          ; read global result into R5

                B main

mult_by_two
                PUSH    {R3, R4, R5, R6, R7, LR}
                
                LDR     R4, =globalParam    ; read global param
                LDRB    R1, [R4] 
                MOVS    R3, #2
                MULS    R1, R3, R1
                LDR     R4, =globalResult   ; write result into global result
                STRB    R1, [R4]          
                
                PUSH    {R3, R4, R5, R6, R7, LR}
                BX      LR
