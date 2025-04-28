   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  43                     ; 10 void display_init(void) // Initialize TM1637 clock and data pins (PC5 and PC6)
  43                     ; 11 {
  45                     	switch	.text
  46  0000               _display_init:
  50                     ; 13     tm1637Init(); // PC5 (CLK), PC6 (DIO)
  52  0000 cd0000        	call	_tm1637Init
  54                     ; 14     tm1637SetBrightness(1);
  56  0003 a601          	ld	a,#1
  57  0005 cd0000        	call	_tm1637SetBrightness
  59                     ; 15 }
  62  0008 81            	ret
  65                     	switch	.bss
  66  0000               L12_displayBuffer:
  67  0000 000000000000  	ds.b	8
 123                     ; 17 void update_display_time(uint8_t hours, uint8_t min, uint8_t secs)
 123                     ; 18 {
 124                     	switch	.text
 125  0009               _update_display_time:
 127  0009 89            	pushw	x
 128       00000000      OFST:	set	0
 131                     ; 21     if (secs & 1)
 133  000a 7b05          	ld	a,(OFST+5,sp)
 134  000c a501          	bcp	a,#1
 135  000e 2741          	jreq	L74
 136                     ; 23         displayBuffer[0] = '0' + hours / 10;
 138  0010 9e            	ld	a,xh
 139  0011 5f            	clrw	x
 140  0012 97            	ld	xl,a
 141  0013 a60a          	ld	a,#10
 142  0015 62            	div	x,a
 143  0016 9f            	ld	a,xl
 144  0017 ab30          	add	a,#48
 145  0019 c70000        	ld	L12_displayBuffer,a
 146                     ; 24         displayBuffer[1] = '0' + hours % 10;
 148  001c 7b01          	ld	a,(OFST+1,sp)
 149  001e 5f            	clrw	x
 150  001f 97            	ld	xl,a
 151  0020 a60a          	ld	a,#10
 152  0022 62            	div	x,a
 153  0023 5f            	clrw	x
 154  0024 97            	ld	xl,a
 155  0025 9f            	ld	a,xl
 156  0026 ab30          	add	a,#48
 157  0028 c70001        	ld	L12_displayBuffer+1,a
 158                     ; 25         displayBuffer[2] = ':';
 160  002b 353a0002      	mov	L12_displayBuffer+2,#58
 161                     ; 26         displayBuffer[3] = '0' + min / 10;
 163  002f 7b02          	ld	a,(OFST+2,sp)
 164  0031 5f            	clrw	x
 165  0032 97            	ld	xl,a
 166  0033 a60a          	ld	a,#10
 167  0035 62            	div	x,a
 168  0036 9f            	ld	a,xl
 169  0037 ab30          	add	a,#48
 170  0039 c70003        	ld	L12_displayBuffer+3,a
 171                     ; 27         displayBuffer[4] = '0' + min % 10;
 173  003c 7b02          	ld	a,(OFST+2,sp)
 174  003e 5f            	clrw	x
 175  003f 97            	ld	xl,a
 176  0040 a60a          	ld	a,#10
 177  0042 62            	div	x,a
 178  0043 5f            	clrw	x
 179  0044 97            	ld	xl,a
 180  0045 9f            	ld	a,xl
 181  0046 ab30          	add	a,#48
 182  0048 c70004        	ld	L12_displayBuffer+4,a
 183                     ; 28         displayBuffer[5] = '\0';
 185  004b 725f0005      	clr	L12_displayBuffer+5
 187  004f 2040          	jra	L15
 188  0051               L74:
 189                     ; 32         displayBuffer[0] = '0' + hours / 10;
 191  0051 7b01          	ld	a,(OFST+1,sp)
 192  0053 5f            	clrw	x
 193  0054 97            	ld	xl,a
 194  0055 a60a          	ld	a,#10
 195  0057 62            	div	x,a
 196  0058 9f            	ld	a,xl
 197  0059 ab30          	add	a,#48
 198  005b c70000        	ld	L12_displayBuffer,a
 199                     ; 33         displayBuffer[1] = '0' + hours % 10;
 201  005e 7b01          	ld	a,(OFST+1,sp)
 202  0060 5f            	clrw	x
 203  0061 97            	ld	xl,a
 204  0062 a60a          	ld	a,#10
 205  0064 62            	div	x,a
 206  0065 5f            	clrw	x
 207  0066 97            	ld	xl,a
 208  0067 9f            	ld	a,xl
 209  0068 ab30          	add	a,#48
 210  006a c70001        	ld	L12_displayBuffer+1,a
 211                     ; 34         displayBuffer[2] = ' ';
 213  006d 35200002      	mov	L12_displayBuffer+2,#32
 214                     ; 35         displayBuffer[3] = '0' + min / 10;
 216  0071 7b02          	ld	a,(OFST+2,sp)
 217  0073 5f            	clrw	x
 218  0074 97            	ld	xl,a
 219  0075 a60a          	ld	a,#10
 220  0077 62            	div	x,a
 221  0078 9f            	ld	a,xl
 222  0079 ab30          	add	a,#48
 223  007b c70003        	ld	L12_displayBuffer+3,a
 224                     ; 36         displayBuffer[4] = '0' + min % 10;
 226  007e 7b02          	ld	a,(OFST+2,sp)
 227  0080 5f            	clrw	x
 228  0081 97            	ld	xl,a
 229  0082 a60a          	ld	a,#10
 230  0084 62            	div	x,a
 231  0085 5f            	clrw	x
 232  0086 97            	ld	xl,a
 233  0087 9f            	ld	a,xl
 234  0088 ab30          	add	a,#48
 235  008a c70004        	ld	L12_displayBuffer+4,a
 236                     ; 37         displayBuffer[5] = '\0';
 238  008d 725f0005      	clr	L12_displayBuffer+5
 239  0091               L15:
 240                     ; 39     tm1637ShowDigits(displayBuffer);
 242  0091 ae0000        	ldw	x,#L12_displayBuffer
 243  0094 cd0000        	call	_tm1637ShowDigits
 245                     ; 40 }
 248  0097 85            	popw	x
 249  0098 81            	ret
 274                     ; 42 void set_brightness_display_high(void)
 274                     ; 43 {
 275                     	switch	.text
 276  0099               _set_brightness_display_high:
 280                     ; 44     tm1637SetBrightness(8);
 282  0099 a608          	ld	a,#8
 283  009b cd0000        	call	_tm1637SetBrightness
 285                     ; 45 }
 288  009e 81            	ret
 313                     ; 47 void set_brightness_display_low(void)
 313                     ; 48 {
 314                     	switch	.text
 315  009f               _set_brightness_display_low:
 319                     ; 49     tm1637SetBrightness(1);
 321  009f a601          	ld	a,#1
 322  00a1 cd0000        	call	_tm1637SetBrightness
 324                     ; 50 }
 327  00a4 81            	ret
 330                     .const:	section	.text
 331  0000               L37_displayWaitIndicator:
 332  0000 20            	dc.b	32
 333  0001 20            	dc.b	32
 334  0002 3a            	dc.b	58
 335  0003 20            	dc.b	32
 336  0004 20            	dc.b	32
 337  0005 00            	dc.b	0
 338  0006 0000          	ds.b	2
 374                     ; 52 void display_show_wait_indicator()
 374                     ; 53 {
 375                     	switch	.text
 376  00a5               _display_show_wait_indicator:
 380                     ; 55     tm1637ShowDigits(displayWaitIndicator);
 382  00a5 ae0000        	ldw	x,#L37_displayWaitIndicator
 383  00a8 cd0000        	call	_tm1637ShowDigits
 385                     ; 56 }
 388  00ab 81            	ret
 401                     	xref	_tm1637ShowDigits
 402                     	xref	_tm1637SetBrightness
 403                     	xref	_tm1637Init
 404                     	xdef	_display_show_wait_indicator
 405                     	xdef	_set_brightness_display_low
 406                     	xdef	_set_brightness_display_high
 407                     	xdef	_update_display_time
 408                     	xdef	_display_init
 427                     	end
