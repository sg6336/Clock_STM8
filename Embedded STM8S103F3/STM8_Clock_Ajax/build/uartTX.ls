   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2203                     ; 58 void uart_init(void)
2203                     ; 59 {
2205                     	switch	.text
2206  0000               _uart_init:
2210                     ; 65     UART1_CR2 = 0x08;     // Увімкнути лише передавач (TX)
2212  0000 35085235      	mov	_UART1_CR2,#8
2213                     ; 66     UART1_CR3 &= ~(0x30); // Один стоп-біт
2215  0004 c65236        	ld	a,_UART1_CR3
2216  0007 a4cf          	and	a,#207
2217  0009 c75236        	ld	_UART1_CR3,a
2218                     ; 72     UART1_BRR2 = 0x03; // fraction = 0x03, mantissa[3:0] = 0x2 (STM8 формат)
2220  000c 35035233      	mov	_UART1_BRR2,#3
2221                     ; 73     UART1_BRR1 = 0x68; // mantissa[11:4]
2223  0010 35685232      	mov	_UART1_BRR1,#104
2224                     ; 74 }
2227  0014 81            	ret
2264                     ; 77 void uart_send_char(char c)
2264                     ; 78 {
2265                     	switch	.text
2266  0015               _uart_send_char:
2268  0015 88            	push	a
2269       00000000      OFST:	set	0
2272                     ; 80     wait_uart_ready();
2274  0016 ad43          	call	L3241_wait_uart_ready
2276                     ; 81     UART1_DR = c;
2278  0018 7b01          	ld	a,(OFST+1,sp)
2279  001a c75231        	ld	_UART1_DR,a
2281  001d 2001          	jra	L3641
2282  001f               L7541:
2283                     ; 84         __asm("nop");
2286  001f 9d            nop
2288  0020               L3641:
2289                     ; 82     while (!(UART1_SR & UART1_SR_TC))
2291  0020 c65230        	ld	a,_UART1_SR
2292  0023 a540          	bcp	a,#64
2293  0025 27f8          	jreq	L7541
2294                     ; 86 }
2297  0027 84            	pop	a
2298  0028 81            	ret
2345                     ; 89 int uart_write(const char *str)
2345                     ; 90 {
2346                     	switch	.text
2347  0029               _uart_write:
2349  0029 89            	pushw	x
2350  002a 88            	push	a
2351       00000001      OFST:	set	1
2354                     ; 91     uint8_t i = 0;
2356  002b 0f01          	clr	(OFST+0,sp)
2359  002d 201b          	jra	L3151
2360  002f               L7051:
2361                     ; 95         wait_uart_ready();
2363  002f ad2a          	call	L3241_wait_uart_ready
2365                     ; 96         UART1_DR = str[i++];
2367  0031 7b01          	ld	a,(OFST+0,sp)
2368  0033 97            	ld	xl,a
2369  0034 0c01          	inc	(OFST+0,sp)
2371  0036 9f            	ld	a,xl
2372  0037 5f            	clrw	x
2373  0038 97            	ld	xl,a
2374  0039 72fb02        	addw	x,(OFST+1,sp)
2375  003c f6            	ld	a,(x)
2376  003d c75231        	ld	_UART1_DR,a
2378  0040 2001          	jra	L3251
2379  0042               L7151:
2380                     ; 99             __asm("nop");
2383  0042 9d            nop
2385  0043               L3251:
2386                     ; 97         while (!(UART1_SR & UART1_SR_TC))
2388  0043 c65230        	ld	a,_UART1_SR
2389  0046 a540          	bcp	a,#64
2390  0048 27f8          	jreq	L7151
2391  004a               L3151:
2392                     ; 92     while (str[i] != '\0')
2394  004a 7b01          	ld	a,(OFST+0,sp)
2395  004c 5f            	clrw	x
2396  004d 97            	ld	xl,a
2397  004e 72fb02        	addw	x,(OFST+1,sp)
2398  0051 7d            	tnz	(x)
2399  0052 26db          	jrne	L7051
2400                     ; 102     return i;
2402  0054 7b01          	ld	a,(OFST+0,sp)
2403  0056 5f            	clrw	x
2404  0057 97            	ld	xl,a
2407  0058 5b03          	addw	sp,#3
2408  005a 81            	ret
2432                     ; 116 static void wait_uart_ready(void)
2432                     ; 117 {
2433                     	switch	.text
2434  005b               L3241_wait_uart_ready:
2438  005b               L1451:
2439                     ; 118     while (!(UART1_SR & UART1_SR_TXE))
2441  005b c65230        	ld	a,_UART1_SR
2442  005e a580          	bcp	a,#128
2443  0060 27f9          	jreq	L1451
2444                     ; 120 }
2447  0062 81            	ret
2460                     	xdef	_uart_write
2461                     	xdef	_uart_send_char
2462                     	xdef	_uart_init
2481                     	end
