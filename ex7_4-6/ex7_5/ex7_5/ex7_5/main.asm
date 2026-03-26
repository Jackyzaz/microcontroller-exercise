;
; ex7_5.asm
;
; Created: 26/3/2569 15:50:05
; Author : LENOVO
;

.include "m328pdef.inc"
.device atmega328p

.def temp=r16
.def sw1=r17
.def sw2=r18
.def output=r19
.def counter=r20

.org 0x0000 
	rjmp start
start:
	rcall setup_inOutPin
	clr counter
	rcall display

main:
	rcall readsw
	mov r25, counter
	rcall display
	rjmp main

setup_inOutPin:
	ldi temp, 0b1001 ; pd0 out, pd1-2 input
	out ddrd, temp
	
	ldi temp, 0b11111111
	out ddrc, temp
	ret

display:
	mov	r25, counter
	rcall bin_to_7seg
	out portc, r25
	swap r25
	lsr r25
	lsr r25
	andi r25, 0x01
	out portd, r25
	ret

bin_to_7seg:
	push ZL
	push ZH
	push R0
	
	clr r0
	rjmp lookup_table
TB_7SEG:.DB 0b00111111, 0b00000110 ;0 and 1 ----a----
		.DB 0b01011011, 0b01001111 ;2 and 3 f b
		.DB 0b01100110, 0b01101101 ;4 and 5 ----g----
		.DB 0b01111101, 0b00000111 ;6 and 7 e c
		.DB 0b01111111, 0b01101111 ;8 and 9 ----d----
		.DB 0b01110111, 0b01111100
		.DB 0b00111001, 0b01011110
		.DB 0b01111001, 0b01110001
lookup_table:
	ldi	ZL, low(TB_7SEG*2)
	ldi	ZH, high(TB_7SEG*2)
	add ZL, r25
	adc ZH, R0
	lpm ; load to r0
	mov r25, R0
	pop r0
	pop zh
	pop zl
	ret

readsw:
		push r16
		push r25
	startread:
		in	 r25, pind
		andi r25, 0b0110
		cpi  r25, 0b0110
		brne low_detected		 ; if some button press
		rjmp startread
	low_detected:
		rcall DELAY10MS
		in   r16, pind			; *** เก็บสถานะปุ่มที่กดไว้ที่นี่ ***
		andi r16, 0b0110

		in    r25, pind
		andi  r25, 0b0110
		cpi   r25, 0b0110
		brne  stay_low_after10ms ; if some button actually press
		rjmp  startread

	stay_low_after10ms:
		in    r25, pind
		andi  r25, 0b0110
		cpi   r25, 0b0110
		brne  stay_low_after10ms ; if some button still pressed
	key_is_released:
		sbrs  r16, 1
		rjmp  sw1_pressed
		sbrs  r16, 2
		rjmp  sw2_pressed
	sw1_pressed:
		inc  counter
		rjmp end_readsw
	sw2_pressed:
		dec	 counter 
	end_readsw:
		andi counter, 0x0F ; บังคับให้วนกลับมาที่ 15 (F) เสมอ
		pop r25
		pop r16
		ret

;---------------ซับรูทีนสำหรบหน่วงเวลา 10 มิลลิวินาที 
;---การหน่วงเวลา 10 มิลลิวินาทีนี้ ทำงานถูกต้องบนซีพียู 16 MHz เท่านั้น
;---หากนำไปใช้บนซีพียูที่ความเร็วค่าอื่น ค่าเวลาที่หน่วงอาจผิดเพี้ยนได้
DELAY10MS:	
		push R16				
		push R17
		ldi	 R16, 0x00
LOOP2:	inc	 R16
		ldi	 R17, 0x00
LOOP1:	inc	 R17
		cpi	 R17, 249
		brlo LOOP1
		nop
		cpi	 R16, 160
		brlo LOOP2
		pop	 R17
		pop	 R16
		ret