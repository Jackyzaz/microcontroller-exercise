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
	cpi  VARS2, 0b10000000
	breq count_target
	com  VARS1
count_target:
	ldi  LOOP_COUNT, 8 
loop:	
	rol  VARS1
	adc  COUNTER, ZERO
	dec  LOOP_COUNT
	brne loop			; dec already change zero flag check
	out PORTD, COUNTER	
	clr COUNTER
	rjmp main