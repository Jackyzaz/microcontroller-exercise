;
; ex4-12_13.asm
;
; Created: 24/3/2569 23:06:17
; Author : LENOVO
;
.include "m328pdef.inc"
.device ATMEGA328p
.def TEMP=R16
.def VARS1=R17
.def VARS2=R18
.def COUNTER=R19
.def LOOP_COUNT=R20
.def ZERO=R21
.cseg
.org 0x0000
	rjmp start

start:
	ldi TEMP, 0x00
	out DDRB, TEMP

	ldi TEMP, 0b01111111
	out DDRD, TEMP

	clr COUNTER
	clr ZERO
main:
	in VARS1, PINB
	in VARS2, PIND
	andi VARS2, 0b10000000
	
	ldi  LOOP_COUNT, 8 
loop:	
	rol  VARS1
	adc  COUNTER, ZERO
	dec  LOOP_COUNT
	brne loop			; dec already change zero flag check
	; lastly add a bit from sw2
	ror  VARS2
	adc  COUNTER, ZERO
	
	andi COUNTER, 0b00000001 ; check odd or even
	breq set_even			 ; if it even zero flag is set
set_odd:
	ldi TEMP, 0001
	rjmp display
set_even:
	ldi TEMP, 0011
display:
	out PORTD, TEMP
	rjmp main