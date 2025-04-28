   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  60                     ; 9 void delay_ms(uint16_t ms)
  60                     ; 10 {
  62                     	switch	.text
  63  0000               _delay_ms:
  65  0000 89            	pushw	x
  66  0001 89            	pushw	x
  67       00000002      OFST:	set	2
  70  0002 2014          	jra	L33
  71  0004               L13:
  72                     ; 15         for (i = 0; i < 1600; i++)
  74  0004 5f            	clrw	x
  75  0005 1f01          	ldw	(OFST-1,sp),x
  78  0007 2008          	jra	L34
  79  0009               L73:
  80                     ; 17             __asm("nop");
  83  0009 9d            nop
  85                     ; 15         for (i = 0; i < 1600; i++)
  87  000a 1e01          	ldw	x,(OFST-1,sp)
  88  000c 1c0001        	addw	x,#1
  89  000f 1f01          	ldw	(OFST-1,sp),x
  91  0011               L34:
  94  0011 1e01          	ldw	x,(OFST-1,sp)
  95  0013 a30640        	cpw	x,#1600
  96  0016 25f1          	jrult	L73
  97  0018               L33:
  98                     ; 13     while (ms--)
 100  0018 1e03          	ldw	x,(OFST+1,sp)
 101  001a 1d0001        	subw	x,#1
 102  001d 1f03          	ldw	(OFST+1,sp),x
 103  001f 1c0001        	addw	x,#1
 104  0022 a30000        	cpw	x,#0
 105  0025 26dd          	jrne	L13
 106                     ; 20 }
 109  0027 5b04          	addw	sp,#4
 110  0029 81            	ret
 123                     	xdef	_delay_ms
 142                     	end
