;
; ex7_7.asm
;
; Created: 26/3/2569 17:08:08
; Author : LENOVO
;

.include "m328pdef.inc"
.device atmega328p

.def temp=r16
.def digit0=r17
.def digit1=r18
.def digit2=r19
.def digit3=r20
.def loop_counter=r21
.def counter=r22

.org 0x0000
	rjmp start

start:
	ldi temp, 0xff		; output c for all port 
	out ddrc, temp

	ldi temp, 0b11111001 ; output d for pd0, pd4-7 and input for pd1 pd2
	out ddrd, temp

	clr counter
	clr digit0
	clr digit1
	clr digit2
	clr digit3
	ldi   digit0, 1
	ldi   digit1, 2
	ldi   digit2, 3
	ldi   digit3, 4
main:
	rcall display_7seg
	rcall do_count
	rjmp main

display_7seg:
	push temp
	ldi loop_counter, 250
	refresh_sync:
		; digit 0
		mov   temp, digit0
		rcall get_segments
		out   PORTC, temp
		sbrc  temp,  6		; g segment use pd0 
		sbi   PORTD, 0
		sbrs  temp,  6
		cbi   PORTD, 0
		in    temp,  PORTD     ; อ่านค่าปัจจุบันของ PORTD มาก่อน
		andi  temp,  0x0F      ; ล้างหัว 4 บิต (Digit selection)
		ori   temp,  0b01110000 ; เลือก Digit 0 (ขา PD7)
		out   PORTD, temp     ; เขียนกลับลงไป
		rcall delay1ms

		; digit 1
		mov   temp, digit1
		rcall get_segments
		out   PORTC, temp
		sbrc  temp,  6		; g segment use pd0 
		sbi   PORTD, 0
		sbrs  temp,  6
		cbi   PORTD, 0
		in    temp,  PORTD     ; อ่านค่าปัจจุบันของ PORTD มาก่อน
		andi  temp,  0x0F      ; ล้างหัว 4 บิต (Digit selection)
		ori   temp,  0b10110000 ; เลือก Digit 1 (ขา PD6)
		out   PORTD, temp     ; เขียนกลับลงไป
		rcall delay1ms
	
		; digit 2
		mov   temp, digit2
		rcall get_segments
		out   PORTC, temp
		sbrc  temp,  6		; g segment use pd0 
		sbi   PORTD, 0
		sbrs  temp,  6
		cbi   PORTD, 0
		in    temp,  PORTD     ; อ่านค่าปัจจุบันของ PORTD มาก่อน
		andi  temp,  0x0F      ; ล้างหัว 4 บิต (Digit selection)
		ori   temp,  0b11010000 ; เลือก Digit 2 (ขา PD5)
		out   PORTD, temp     ; เขียนกลับลงไป
		rcall delay1ms
		
		; digit 3
		mov   temp, digit3
		rcall get_segments
		out   PORTC, temp
		sbrc  temp,  6		; g segment use pd0 
		sbi   PORTD, 0
		sbrs  temp,  6
		cbi   PORTD, 0
		in    temp,  PORTD     ; อ่านค่าปัจจุบันของ PORTD มาก่อน
		andi  temp,  0x0F      ; ล้างหัว 4 บิต (Digit selection)
		ori   temp,  0b11100000 ; เลือก Digit 3 (ขา PD4)
		out   PORTD, temp     ; เขียนกลับลงไป
		rcall delay1ms

		dec loop_counter
		brne refresh_sync
	pop temp
	ret

do_count:
		; digit0
		inc digit0
		cpi digit0, 10
		brne end_do_count
		clr digit0

		; digit1
		inc digit1
		cpi digit1, 10
		brne end_do_count
		clr digit1

		; digit2
		inc digit2
		cpi digit2, 10
		brne end_do_count
		clr digit2
		
		; digit3
		inc digit3
		cpi digit3, 10
		brne end_do_count
		clr digit3
	end_do_count:
		ret

get_segments:
		; input temp
		; return temp
		ldi zh, high(seg_table << 1)
		ldi zl, low(seg_table << 1)
		add zl, temp
		clr temp
		adc zh, temp
		lpm temp, Z
		ret

delay1ms:
	ldi r24, 21 ; Outer loop
	d1: ldi r25, 255 ; Inner loop
	d2: dec r25
		brne d2
		dec r24
		brne d1
	ret
seg_table:
	.db 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

delay10ms:	push	R16				
		push	R17
		ldi	R16, 0x00
LOOP2:		inc	R16
		ldi	R17,  0x00
LOOP1:		inc	R17
		cpi	R17, 249
		brlo	LOOP1
		nop
		cpi	R16, 160
		brlo	LOOP2
		pop	R17
		pop	R16
		ret