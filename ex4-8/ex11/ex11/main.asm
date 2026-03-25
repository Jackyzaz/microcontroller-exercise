;
; ex11.asm
;
; Created: 25/3/2569 21:55:08
; Author : LENOVO
;

.include "m328pdef.inc"
.device atmega328p

.def temp=r16
.def sw1=r17
.def sw2=r18
.def quotient=r19

.org 0x0000 
	rjmp start

start:
    ldi temp, 0xFF
	out ddrd, temp

	ldi temp, 0x00
	out ddrb, temp

	ldi temp, 0b11111110
	out ddrc, temp

main:
	in sw1, pinb
	in sw2, pinc

	andi sw2, 0x01 
	breq low_mode ; if its low Zero FLAG set go to low 
high_mode:
	lsr sw1
	rjmp display
low_mode:
	clr quotient
divide_loop:
	subi sw1, 3
	brcs end_divide_loop
	inc  quotient
	rjmp divide_loop
end_divide_loop:
	mov sw1, quotient
display:
	out PORTD, sw1
	rjmp main