;
; ex4-10.asm
;
; Created: 25/3/2569 21:32:26
; Author : LENOVO
;
.include "m328pdef.inc"
.device atmega328p

.def temp=r16
.def sw1=r17
.def sw2=r18

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
	com sw1
	rjmp display
low_mode:
	neg sw1
display:
	out PORTD, sw1
	rjmp main