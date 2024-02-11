                THUMB 
 
ADDR_LED        EQU    0x60000100 ;LED
ADDR_BUTTON     EQU    0x60000210 ;Buttons t0-t3
ADDR_SEG7_BIN   EQU    0x60000114 ;Segment screen
ADDR_LCD_BG     EQU    0x60000340 ;LCD background
ADDR_LCD_ASCII  EQU    0x60000300 ;LCD ascii write
ADDR_LCD_BIN    EQU    0x60000330 ;LCD binary write
ADDR_DIPSW      EQU    0x60000200 ;DIP switches

ADDR_LCD_COLOUR           EQU        0x60000340
ADDR_LCD_ASCII            EQU        0x60000300
ADDR_LCD_ASCII_BIT_POS    EQU        0x60000302
ADDR_LCD_ASCII_2ND_LINE   EQU        0x60000314

 AREA myConstants, DATA, READONLY

; display defines for hex / dec

DISPLAY_BIT               DCB        "Bit "
DISPLAY_2_BIT             DCB        "2"
DISPLAY_4_BIT             DCB        "4"
DISPLAY_8_BIT             DCB        "8"
DISPLAY_CLEAR_SPACE       DCB        "    "

 AREA myCode, CODE, READONLY 
 
 ALIGN
; Memory use
; R3 => DipSwitch Value
; R4 => ADC Value
; R5 => DipSwitchValue - ADC value
; R6 => Button state
; R7 => LED/Count


main            PROC 
                EXPORT main 
                MOVS    R4, #10             ; reads FAKE ADC value
                                            ; adc_get_value() would be here
                                            ; from the documentation we see that the value will bi inside R0
                                            ; therefore a MOVS R4, R0 noods to be written after the function call
                                            ; to save the value to R4 so it is saved in a seperate memory slot
                
                LDR     R0, =ADDR_BUTTON    ; get address of buttons
                LDRB    R1, [R0, #0]        ; read buttons
                MOV     R6, R1              ; save button state
                CMP     R6, #1              ; check if t0 is pressed, if yes jump to t0_pressed

                BEQ     t0_pressed
                B       read_switches             ; jumps to switch read and save vlaue in R3
                 

                B       main

; Tunrs LCD on and sets background color to green
; Displays value that is stored in R4 on segment
; jumps back to main when finished
t0_pressed      
                BL      clear_LCD
                LDR     R0, =ADDR_LCD_BG   ; turn LCD screen on and set background to green
                LDR     R1, =0xffff
                STRH    R1, [R0, #2]

                LDR     R1, =0x0000        ; turn off other colors
                STRH    R1, [R0, #0]
                STRH    R1, [R0, #4]

                LDR     R0, =ADDR_SEG7_BIN    ; write DipSwitch value to Segment display
                STRH    R4, [R0, #0]  
                B       led_state

                
; Reads DipsSwitches S7 to S0 and saves value into R3
; Subtracts ACD (R4) from DipSwitch value (R3) and saves it into R5
; Is value in R5 >= 0, then LCD background will be set to BLUE
; Otherwise set to RED
; The R5 value will be written to Segment Display
; jups to main after finished
read_switches
                LDR     R0, =ADDR_DIPSW
                LDRB    R3, [R0, #0]          ; Read byte from S7..0. and write to R3
                
   

                SUBS    R5, R3, R4            ; subtract ADC from DipSwitches save to R5
                
                LDR     R0, =ADDR_SEG7_BIN    ; write DipSwitch - ADC value to Segment display
                STRH    R5, [R0, #0] 
                
                CMP     R5, #1                ; if R5 less than 0 jump to display_RED
                BLT     display_RED

                LDR     R0, =ADDR_LCD_BG   ; turn LCD screen on and set background to BLUE
                LDR     R1, =0xffff
                STRH    R1, [R0, #4]

                LDR     R1, =0x0000        ; turn off other colors
                STRH    R1, [R0, #0]
                STRH    R1, [R0, #2]
                BL      write_bit_ascii
                B       set_bit_LCD

; sets LCD background to RED
; jumps to main after finished
display_RED     
                BL      clear_LCD
                LDR     R0, =ADDR_LCD_BG   ; turn LCD screen on and set background to green
                LDR     R1, =0xffff
                STRH    R1, [R0, #0]

                LDR     R1, =0x0000        ; turn off other colors
                STRH    R1, [R0, #2]
                STRH    R1, [R0, #4]

                B       count_zero_entry

; checks if ADC is 2, 4 or 8 bit
; jumps to two_bit or four_bit or sets 8_bit
set_bit_LCD
                CMP     R4, #4
                BLT     two_bit
                CMP     R4, #16
                BLT     four_bit    
                LDR     R1, =DISPLAY_8_BIT
                B       write_bit_number 

two_bit
                LDR     R1, =DISPLAY_2_BIT 
                B       write_bit_number 

four_bit
                LDR     R1, =DISPLAY_4_BIT
                B       write_bit_number 

write_bit_number
                LDR        R0, =ADDR_LCD_ASCII
                LDR        R1, [R1]
                STRB       R1, [R0] 
                B          main

; sets LEDs for ADC value
; calculates needed 1s to fill LED segment
; jumps through three functions: led_state -> led_set -> turn_led_on
led_state
                MOVS    R7, R4             
                ASRS    R7, R7, #4      ; division by 8 gives number of LEDS
                MOVS    R0, #1          ; set for loop
                MOVS    R2, #1          ; set for loop
                ADDS    R7, #1          ; add one for 0 value
                B set_led               ; go into loop for LED set

turn_led_on     
                MOVS     R7, R0             ; read needed value from R0 (was set in set_led loop)
                LDR      R0, =ADDR_LED
                STRH     R7, [R0, #2]      ; Write half word of data to LED31...

                B main

set_led
                CMP     R7, #0              ; check if loop is finished
                BEQ     turn_led_on         ; if loop finished jump to turn_led_on
                MOVS    R1, #2              ; allocate 2 for adding a 1 to binary string
                MULS    R2, R1, R2          ; multiply current value by 2 (R1)
                ADDS    R0, R2              ; add multiple of value to old value
                SUBS    R7, R7, #1          ; decrement loop counter
                B set_led


; counts zeros in binary number stored in R1
; R0 decides loop depth
; R4 stores count of zeros
; prints out zero count on secvodn LCD line
count_zero_entry
                
                LDR     R0, =ADDR_DIPSW
                LDRB    R3, [R0, #0]          ; Read byte from S7..0. and write to R3
                
                SUBS    R5, R3, R4            ; subtract ADC from DipSwitches save to R5
                MOVS    R0, R5 
                
                MVNS    R0, R0              ; make R0 positive because RED-State is negative DIFF 
                ADDS    R0, #1

                PUSH    {R3, R4, R5}        ; save R3, and R4 state

                MOVS    R1, R0     
                MOVS    R0, #16             ; we have 16 bit number, count 16 possible zeros
                                            ; for 31 bit set to 31

                MOVS    R4, #0              ; make sure R4 is zero, counts of zeros will eb stored here
                BL      count_zero_loop


count_zero_end  
                MOVS    R1, R4
                LDR     R0, =ADDR_LCD_BIN   ; write zero count to LCD second line
                STR     R1, [R0] 

                POP     {R3, R4, R5}        ; reconstruct state of R3 and R4 before function call
                B       main

count_zero_loop
                CMP     R0, #0
                BEQ     count_zero_end

                MOVS    R3, R1
                MOVS    R5, #1    
                ANDS    R3, R3, R5          ; AND the number with 1 to set all Bits to 0
                                            ; only the first one will stay as a 1 if it is a 1
                                            ; example:
                                            ; 1011 &
                                            ; 0001
                                            ; -----
                                            ; 0001

                CMP     R3, #0              ; if AND number is 0, then LSB was 0, therefore add 1 to zero-counter
                BEQ     add_to_R4          

                LSRS    R1, R1, #1          ; shift number one to the right (fill with zeros)
                SUBS    R0, R0, #1          ; decrement loop counter 
               
                B       count_zero_loop
 
; this loop is a bit confusing because it jumps here conditionally
; the last two lines are the same as above in count_zero_loop
; because they get skipped if jump occures
; but they need to be run for the loop
; thats wehy they are here as duplicates                
add_to_R4
                ADDS    R4, #1
                LSRS    R1, R1, #1          ; shift number one to the right (fill with zeros)
                SUBS    R0, R0, #1          ; decrement loop counter 
                B       count_zero_loop   
;======================[Functions]=====================

; clears LCD screen of text
clear_LCD
                PUSH       {R0, R1}
                LDR        R0, =ADDR_LCD_ASCII          ; Position of bit 
                LDR        R1, =DISPLAY_CLEAR_SPACE     ; set write word to space
                STR        R1, [R0]
                LDR        R0, =ADDR_LCD_ASCII_BIT_POS
                LDR        R1, =DISPLAY_CLEAR_SPACE 
                STR        R1, [R0]
                STR        R1, [R0]  
                POP        {R0, R1}
                BX         LR    


; writes the word "Bit" on the LCD screen 
; with a space left for the number at the beginning
write_bit_ascii
                PUSH       {R0, R1}
                LDR        R0, =ADDR_LCD_ASCII_BIT_POS
                LDR        R1, =DISPLAY_BIT
                LDR        R1, [R1]
                STR        R1, [R0]
                POP        {R0, R1}
                BX         LR

        ENDP

        ALIGN

        END