   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2200                     ; 50 void uart_init(void)
2200                     ; 51 {
2202                     	switch	.text
2203  0000               _uart_init:
2207                     ; 57     UART1_CR2 = 0x08;     // Увімкнути лише передавач (TX)
2209  0000 35085235      	mov	_UART1_CR2,#8
2210                     ; 58     UART1_CR3 &= ~(0x30); // Один стоп-біт
2212  0004 c65236        	ld	a,_UART1_CR3
2213  0007 a4cf          	and	a,#207
2214  0009 c75236        	ld	_UART1_CR3,a
2215                     ; 64     UART1_BRR2 = 0x03; // fraction = 0x03, mantissa[3:0] = 0x2 (STM8 формат)
2217  000c 35035233      	mov	_UART1_BRR2,#3
2218                     ; 65     UART1_BRR1 = 0x68; // mantissa[11:4]
2220  0010 35685232      	mov	_UART1_BRR1,#104
2221                     ; 66 }
2224  0014 81            	ret
2261                     ; 69 void uart_send_char(char c)
2261                     ; 70 {
2262                     	switch	.text
2263  0015               _uart_send_char:
2265  0015 88            	push	a
2266       00000000      OFST:	set	0
2269                     ; 72     wait_uart_ready();
2271  0016 ad43          	call	L3241_wait_uart_ready
2273                     ; 73     UART1_DR = c;
2275  0018 7b01          	ld	a,(OFST+1,sp)
2276  001a c75231        	ld	_UART1_DR,a
2278  001d 2001          	jra	L3641
2279  001f               L7541:
2280                     ; 76         __asm("nop");
2283  001f 9d            nop
2285  0020               L3641:
2286                     ; 74     while (!(UART1_SR & UART1_SR_TC))
2288  0020 c65230        	ld	a,_UART1_SR
2289  0023 a540          	bcp	a,#64
2290  0025 27f8          	jreq	L7541
2291                     ; 78 }
2294  0027 84            	pop	a
2295  0028 81            	ret
2342                     ; 81 int uart_write(const char *str)
2342                     ; 82 {
2343                     	switch	.text
2344  0029               _uart_write:
2346  0029 89            	pushw	x
2347  002a 88            	push	a
2348       00000001      OFST:	set	1
2351                     ; 83     uint8_t i = 0;
2353  002b 0f01          	clr	(OFST+0,sp)
2356  002d 201b          	jra	L3151
2357  002f               L7051:
2358                     ; 87         wait_uart_ready();
2360  002f ad2a          	call	L3241_wait_uart_ready
2362                     ; 88         UART1_DR = str[i++];
2364  0031 7b01          	ld	a,(OFST+0,sp)
2365  0033 97            	ld	xl,a
2366  0034 0c01          	inc	(OFST+0,sp)
2368  0036 9f            	ld	a,xl
2369  0037 5f            	clrw	x
2370  0038 97            	ld	xl,a
2371  0039 72fb02        	addw	x,(OFST+1,sp)
2372  003c f6            	ld	a,(x)
2373  003d c75231        	ld	_UART1_DR,a
2375  0040 2001          	jra	L3251
2376  0042               L7151:
2377                     ; 91             __asm("nop");
2380  0042 9d            nop
2382  0043               L3251:
2383                     ; 89         while (!(UART1_SR & UART1_SR_TC))
2385  0043 c65230        	ld	a,_UART1_SR
2386  0046 a540          	bcp	a,#64
2387  0048 27f8          	jreq	L7151
2388  004a               L3151:
2389                     ; 84     while (str[i] != '\0')
2391  004a 7b01          	ld	a,(OFST+0,sp)
2392  004c 5f            	clrw	x
2393  004d 97            	ld	xl,a
2394  004e 72fb02        	addw	x,(OFST+1,sp)
2395  0051 7d            	tnz	(x)
2396  0052 26db          	jrne	L7051
2397                     ; 94     return i;
2399  0054 7b01          	ld	a,(OFST+0,sp)
2400  0056 5f            	clrw	x
2401  0057 97            	ld	xl,a
2404  0058 5b03          	addw	sp,#3
2405  005a 81            	ret
2429                     ; 109 static void wait_uart_ready(void)
2429                     ; 110 {
2430                     	switch	.text
2431  005b               L3241_wait_uart_ready:
2435  005b               L1451:
2436                     ; 111     while (!(UART1_SR & UART1_SR_TXE))
2438  005b c65230        	ld	a,_UART1_SR
2439  005e a580          	bcp	a,#128
2440  0060 27f9          	jreq	L1451
2441                     ; 113 }
2444  0062 81            	ret
2457                     	xdef	_uart_write
2458                     	xdef	_uart_send_char
2459                     	xdef	_uart_init
2478                     	end
