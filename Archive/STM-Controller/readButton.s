                AREA myCode, CODE, READONLY 
 
                THUMB 
 
ADDR_LED        EQU    0x60000100 
ADDR_DIPSW      EQU    0x60000200 
ADDR_BUTTON     EQU    0x60000210
ADDR_SEG7_BIN   EQU    0x60000114
 
main            PROC 
                EXPORT main 

                LDR     R0, =ADDR_BUTTON ;get address of buttons
                LDRB    R1, [R0, #0] ; read buttons
                MOV     R5, R1 ; save button state

                LDR      R0, =ADDR_SEG7_BIN
                STRH     R5, [R0, #0]   ; Write halfword of binary data to all displays

                B main
                

                ENDP 
 
                ALIGN 
                END 

======================================================
Buttons get saved into R5
Code:

 LDR     R0, =ADDR_BUTTON
                LDRB    R1, [R0, #0] 
                MOV     R5, R1 


Values in R5:
T0: 1
T1: 2
T2: 4
T3: 8

Multi button press is binary addition:
T0 + T2 = 1 + 4 = 5 ==> 0101
======================================================
