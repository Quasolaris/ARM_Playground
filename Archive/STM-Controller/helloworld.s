                AREA myCode, CODE, READONLY 
 
                THUMB 
 
ADDR_LED        EQU    0x60000100 
ADDR_DIPSW      EQU    0x60000200 
 
main            PROC 
                EXPORT main 
                MOVS R5, #2
                MULS R5, R6, R5
                CMP  R5, #2 
                BEQ  func_double  
                B func_triple
                
                LDR    R0, =ADDR_LED 
                LDR    R1, =ADDR_DIPSW 


loop            LDR    R2, [R1, #0] 
                STR    R2, [R0, #0] 
                B      loop 
 
                ENDP 
 
                ALIGN 
                END 

func_double
                MOVS R7, #2
                MULS R5, R7, R5
                MOVS R3, #15
                B main

func_triple
                MOVS R7, #3
                MULS R5, R7, R5
                B main
