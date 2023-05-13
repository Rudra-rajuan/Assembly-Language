ORG 100h

MOV AX, @DATA       ; initialize data segment
MOV DS, AX

MOV AH, 01h         ; ask user for order unit
INT 21h
SUB AL, 30h         ; convert ASCII digit to binary
MOV BL, AL          ; store order unit in BL

MOV BX, 5000        ; load the address of the unit price into BX
MOV CX, [BX]        ; load the unit price from memory into CX
MUL CX              ; multiply order unit (in AX) with unit price (in CX)
MOV BX, AX          ; move the result to BX
MOV AX, 100         ; prepare to divide by 100 (to move the decimal point)
DIV BX              ; divide by 100 to move the decimal point

CALL DISPLAY_NUM    ; call subroutine to display the subtotal

MOV AH, 4Ch         ; function number for exit
INT 21h             ; call DOS interrupt 21h to exit program

DISPLAY_NUM PROC    ; subroutine to display a number on the screen
    PUSH AX         ; save registers
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, 4       ; loop counter for displaying 4 digits
    MOV BX, 1000    ; divisor for the first digit
    MOV DX, 0       ; initialize remainder to 0

DISPLAY_LOOP:
    XOR AX, AX      ; clear AX for division
    DIV BX          ; divide AX by BX
    ADD DL, '0'     ; convert the remainder to an ASCII digit
    MOV AH, 02h     ; function number for output char
    MOV DL, DL      ; move the digit to DL
    INT 21h         ; call DOS interrupt 21h to output the digit
    DEC CX          ; decrement the loop counter
    CMP CX, 0       ; compare the loop counter with 0
    JNE DISPLAY_LOOP ; if loop counter is not zero, continue displaying digits

    MOV AH, 02h     ; function number for output char
    MOV DL, '.'     ; output decimal point
    INT 21h         ; call DOS interrupt 21h to output the decimal point

    MOV CX, 2       ; loop counter for displaying 2 decimal places
    MOV BX, 100     ; divisor for the first decimal place
    MOV DX, 0       ; initialize remainder to 0

DISPLAY_DECIMAL_LOOP:
    XOR AX, AX      ; clear AX for division
    DIV BX          ; divide AX by BX
    ADD DL, '0'     ; convert the remainder to an ASCII digit
    MOV AH, 02h     ; function number for output char
    MOV DL, DL      ; move the digit to DL
    INT 21h         ; call DOS interrupt 21h to output the digit
    DEC CX          ; decrement the loop counter
    CMP CX, 0       ; compare the loop counter with 0
    JNE DISPLAY_DECIMAL_LOOP ; if loop counter is not zero, continue displaying digits

    POP DX          ; restore registers
    POP CX
    POP BX
    POP AX
    RET
DISPLAY_NUM ENDP

END
