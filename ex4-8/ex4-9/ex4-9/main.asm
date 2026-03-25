;
; ex4-9.asm
;
; Created: 25/3/2569 20:38:26
; Author : LENOVO
;
.include "m328pdef.inc"
.device ATMEGA328p

.def temp=r16
.def s1=r17
.def s2=r18
.def zero=r19
.def v1=r20
.def v2=r21
start:
	clr zero
    ldi temp, 0x00	; all input
	out DDRB, temp

	ldi temp, 0b11111110
	out DDRC, temp

	ldi temp, 0xff
	out DDRD, temp

main:
	in s1, PINB
	in s2, PINC
	
	mov v1, s1
	mov v2, s1
	
	andi v1, 0x0F
	andi v2, 0xF0
	
	lsr v2
	lsr v2
	lsr v2
	lsr v2 ; or use swap v2

	andi s2, 0x01 ; low = zero flag,	high = no zero flag
	breq low_mode
high_mode:	; high = sign mode
	sbrc v1, 3
	ori v1, 0xF0
	sbrc v2, 3
	ori v2, 0xF0

	muls v1, v2
	rjmp display
low_mode:	; low = low mode
	mul v1, v2
display:
	out PORTD, r0
	rjmp main

