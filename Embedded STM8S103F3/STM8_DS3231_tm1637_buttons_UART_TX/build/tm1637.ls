   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2169                     .const:	section	.text
2170  0000               L3241_cDigit2Seg:
2171  0000 3f            	dc.b	63
2172  0001 06            	dc.b	6
2173  0002 5b            	dc.b	91
2174  0003 4f            	dc.b	79
2175  0004 66            	dc.b	102
2176  0005 6d            	dc.b	109
2177  0006 7d            	dc.b	125
2178  0007 07            	dc.b	7
2179  0008 7f            	dc.b	127
2180  0009 6f            	dc.b	111
2212                     ; 37 void tm1637Init(void)
2212                     ; 38 {
2214                     	switch	.text
2215  0000               _tm1637Init:
2219                     ; 40 	PC_DDR |= (1 << CLK_PIN);  // output
2221  0000 721a500c      	bset	_PC_DDR,#5
2222                     ; 41 	PC_CR1 |= (1 << CLK_PIN);  // push-pull
2224  0004 721a500d      	bset	_PC_CR1,#5
2225                     ; 42 	PC_ODR &= ~(1 << CLK_PIN); // LOW
2227  0008 721b500a      	bres	_PC_ODR,#5
2228                     ; 45 	PC_DDR |= (1 << DIO_PIN);  // output
2230  000c 721c500c      	bset	_PC_DDR,#6
2231                     ; 46 	PC_CR1 |= (1 << DIO_PIN);  // push-pull
2233  0010 721c500d      	bset	_PC_CR1,#6
2234                     ; 47 	PC_ODR &= ~(1 << DIO_PIN); // LOW
2236  0014 721d500a      	bres	_PC_ODR,#6
2237                     ; 48 }
2240  0018 81            	ret
2281                     ; 50 void tm1637SetBrightness(uint8_t b)
2281                     ; 51 {
2282                     	switch	.text
2283  0019               _tm1637SetBrightness:
2285  0019 88            	push	a
2286  001a 88            	push	a
2287       00000001      OFST:	set	1
2290                     ; 53 	if (b == 0)
2292  001b 4d            	tnz	a
2293  001c 2606          	jrne	L5741
2294                     ; 55 		bControl = 0x80;
2296  001e a680          	ld	a,#128
2297  0020 6b01          	ld	(OFST+0,sp),a
2300  0022 2011          	jra	L7741
2301  0024               L5741:
2302                     ; 58 		if (b > 8)
2304  0024 7b02          	ld	a,(OFST+1,sp)
2305  0026 a109          	cp	a,#9
2306  0028 2504          	jrult	L1051
2307                     ; 59 			b = 8;
2309  002a a608          	ld	a,#8
2310  002c 6b02          	ld	(OFST+1,sp),a
2311  002e               L1051:
2312                     ; 60 		bControl = 0x88 | (b - 1);
2314  002e 7b02          	ld	a,(OFST+1,sp)
2315  0030 4a            	dec	a
2316  0031 aa88          	or	a,#136
2317  0033 6b01          	ld	(OFST+0,sp),a
2319  0035               L7741:
2320                     ; 62 	tm1637Write(&bControl, 1);
2322  0035 4b01          	push	#1
2323  0037 96            	ldw	x,sp
2324  0038 1c0002        	addw	x,#OFST+1
2325  003b cd0175        	call	L7341_tm1637Write
2327  003e 84            	pop	a
2328                     ; 63 }
2331  003f 85            	popw	x
2332  0040 81            	ret
2400                     ; 65 void tm1637ShowDigits(char *pString)
2400                     ; 66 {
2401                     	switch	.text
2402  0041               _tm1637ShowDigits:
2404  0041 89            	pushw	x
2405  0042 5215          	subw	sp,#21
2406       00000015      OFST:	set	21
2409                     ; 71 	j = 0;
2411  0044 0f03          	clr	(OFST-18,sp)
2413                     ; 73 	bTemp[0] = 0x40;
2415  0046 a640          	ld	a,#64
2416  0048 6b04          	ld	(OFST-17,sp),a
2418                     ; 74 	tm1637Write(bTemp, 1);
2420  004a 4b01          	push	#1
2421  004c 96            	ldw	x,sp
2422  004d 1c0005        	addw	x,#OFST-16
2423  0050 cd0175        	call	L7341_tm1637Write
2425  0053 84            	pop	a
2426                     ; 77 	bTemp[j++] = 0xc0;
2428  0054 96            	ldw	x,sp
2429  0055 1c0004        	addw	x,#OFST-17
2430  0058 1f01          	ldw	(OFST-20,sp),x
2432  005a 7b03          	ld	a,(OFST-18,sp)
2433  005c 97            	ld	xl,a
2434  005d 0c03          	inc	(OFST-18,sp)
2436  005f 9f            	ld	a,xl
2437  0060 5f            	clrw	x
2438  0061 97            	ld	xl,a
2439  0062 72fb01        	addw	x,(OFST-20,sp)
2440  0065 a6c0          	ld	a,#192
2441  0067 f7            	ld	(x),a
2442                     ; 78 	for (i = 0; i < 5; i++)
2444  0068 0f15          	clr	(OFST+0,sp)
2446  006a               L3351:
2447                     ; 81 		if (i == 2)
2449  006a 7b15          	ld	a,(OFST+0,sp)
2450  006c a102          	cp	a,#2
2451  006e 2614          	jrne	L1451
2452                     ; 84 			if (pString[i] == ':')
2454  0070 7b15          	ld	a,(OFST+0,sp)
2455  0072 5f            	clrw	x
2456  0073 97            	ld	xl,a
2457  0074 72fb16        	addw	x,(OFST+1,sp)
2458  0077 f6            	ld	a,(x)
2459  0078 a13a          	cp	a,#58
2460  007a 264a          	jrne	L5451
2461                     ; 87 				bTemp[2] |= 0x80;
2463  007c 7b06          	ld	a,(OFST-15,sp)
2464  007e aa80          	or	a,#128
2465  0080 6b06          	ld	(OFST-15,sp),a
2467  0082 2042          	jra	L5451
2468  0084               L1451:
2469                     ; 93 			b = 0;
2471                     ; 94 			if (pString[i] >= '0' && pString[i] <= '9')
2473  0084 7b15          	ld	a,(OFST+0,sp)
2474  0086 5f            	clrw	x
2475  0087 97            	ld	xl,a
2476  0088 72fb16        	addw	x,(OFST+1,sp)
2477  008b f6            	ld	a,(x)
2478  008c a130          	cp	a,#48
2479  008e 2520          	jrult	L7451
2481  0090 7b15          	ld	a,(OFST+0,sp)
2482  0092 5f            	clrw	x
2483  0093 97            	ld	xl,a
2484  0094 72fb16        	addw	x,(OFST+1,sp)
2485  0097 f6            	ld	a,(x)
2486  0098 a13a          	cp	a,#58
2487  009a 2414          	jruge	L7451
2488                     ; 98 				b = cDigit2Seg[pString[i] - '0'];
2490  009c 7b15          	ld	a,(OFST+0,sp)
2491  009e 5f            	clrw	x
2492  009f 97            	ld	xl,a
2493  00a0 72fb16        	addw	x,(OFST+1,sp)
2494  00a3 f6            	ld	a,(x)
2495  00a4 5f            	clrw	x
2496  00a5 97            	ld	xl,a
2497  00a6 1d0030        	subw	x,#48
2498  00a9 d60000        	ld	a,(L3241_cDigit2Seg,x)
2499  00ac 6b14          	ld	(OFST-1,sp),a
2502  00ae 2002          	jra	L1551
2503  00b0               L7451:
2504                     ; 102 				b = 0;
2506  00b0 0f14          	clr	(OFST-1,sp)
2508  00b2               L1551:
2509                     ; 104 			bTemp[j++] = b;
2511  00b2 96            	ldw	x,sp
2512  00b3 1c0004        	addw	x,#OFST-17
2513  00b6 1f01          	ldw	(OFST-20,sp),x
2515  00b8 7b03          	ld	a,(OFST-18,sp)
2516  00ba 97            	ld	xl,a
2517  00bb 0c03          	inc	(OFST-18,sp)
2519  00bd 9f            	ld	a,xl
2520  00be 5f            	clrw	x
2521  00bf 97            	ld	xl,a
2522  00c0 72fb01        	addw	x,(OFST-20,sp)
2523  00c3 7b14          	ld	a,(OFST-1,sp)
2524  00c5 f7            	ld	(x),a
2525  00c6               L5451:
2526                     ; 78 	for (i = 0; i < 5; i++)
2528  00c6 0c15          	inc	(OFST+0,sp)
2532  00c8 7b15          	ld	a,(OFST+0,sp)
2533  00ca a105          	cp	a,#5
2534  00cc 259c          	jrult	L3351
2535                     ; 108 	tm1637Write(bTemp, j);
2537  00ce 7b03          	ld	a,(OFST-18,sp)
2538  00d0 88            	push	a
2539  00d1 96            	ldw	x,sp
2540  00d2 1c0005        	addw	x,#OFST-16
2541  00d5 cd0175        	call	L7341_tm1637Write
2543  00d8 84            	pop	a
2544                     ; 109 }
2547  00d9 5b17          	addw	sp,#23
2548  00db 81            	ret
2591                     ; 123 static void delay_ms_tm1637(uint16_t milliseconds)
2591                     ; 124 {
2592                     	switch	.text
2593  00dc               L5241_delay_ms_tm1637:
2595  00dc 89            	pushw	x
2596  00dd 89            	pushw	x
2597       00000002      OFST:	set	2
2600                     ; 125 	volatile uint16_t i = 0;
2602  00de 5f            	clrw	x
2603  00df 1f01          	ldw	(OFST-1,sp),x
2606  00e1 2001          	jra	L7751
2607  00e3               L3751:
2608                     ; 131 			__asm("nop");
2611  00e3 9d            nop
2613  00e4               L7751:
2614                     ; 127 	while (milliseconds--)
2616  00e4 1e03          	ldw	x,(OFST+1,sp)
2617  00e6 1d0001        	subw	x,#1
2618  00e9 1f03          	ldw	(OFST+1,sp),x
2619  00eb 1c0001        	addw	x,#1
2620  00ee a30000        	cpw	x,#0
2621  00f1 26f0          	jrne	L3751
2622                     ; 134 }
2625  00f3 5b04          	addw	sp,#4
2626  00f5 81            	ret
2651                     ; 142 static void tm1637Start(void)
2651                     ; 143 {
2652                     	switch	.text
2653  00f6               L7241_tm1637Start:
2657                     ; 144 	PC_ODR |= (1 << DIO_PIN); // DIO high
2659  00f6 721c500a      	bset	_PC_ODR,#6
2660                     ; 145 	PC_ODR |= (1 << CLK_PIN); // CLK high
2662  00fa 721a500a      	bset	_PC_ODR,#5
2663                     ; 146 	delay_ms_tm1637(CLOCK_DELAY);
2665  00fe ae0001        	ldw	x,#1
2666  0101 add9          	call	L5241_delay_ms_tm1637
2668                     ; 147 	PC_ODR &= ~(1 << DIO_PIN); // DIO low
2670  0103 721d500a      	bres	_PC_ODR,#6
2671                     ; 148 }
2674  0107 81            	ret
2699                     ; 156 static void tm1637Stop(void)
2699                     ; 157 {
2700                     	switch	.text
2701  0108               L1341_tm1637Stop:
2705                     ; 158 	PC_ODR &= ~(1 << CLK_PIN); // CLK low
2707  0108 721b500a      	bres	_PC_ODR,#5
2708                     ; 159 	delay_ms_tm1637(CLOCK_DELAY);
2710  010c ae0001        	ldw	x,#1
2711  010f adcb          	call	L5241_delay_ms_tm1637
2713                     ; 160 	PC_ODR &= ~(1 << DIO_PIN); // DIO low
2715  0111 721d500a      	bres	_PC_ODR,#6
2716                     ; 161 	delay_ms_tm1637(CLOCK_DELAY);
2718  0115 ae0001        	ldw	x,#1
2719  0118 adc2          	call	L5241_delay_ms_tm1637
2721                     ; 162 	PC_ODR |= (1 << CLK_PIN); // CLK high
2723  011a 721a500a      	bset	_PC_ODR,#5
2724                     ; 163 	delay_ms_tm1637(CLOCK_DELAY);
2726  011e ae0001        	ldw	x,#1
2727  0121 adb9          	call	L5241_delay_ms_tm1637
2729                     ; 164 	PC_ODR |= (1 << DIO_PIN); // DIO high
2731  0123 721c500a      	bset	_PC_ODR,#6
2732                     ; 165 }
2735  0127 81            	ret
2760                     ; 175 static uint8_t tm1637GetAck(void)
2760                     ; 176 {
2761                     	switch	.text
2762  0128               L3341_tm1637GetAck:
2766                     ; 177 	PC_ODR &= ~(1 << CLK_PIN);
2768  0128 721b500a      	bres	_PC_ODR,#5
2769                     ; 178 	delay_ms_tm1637(CLOCK_DELAY);
2771  012c ae0001        	ldw	x,#1
2772  012f adab          	call	L5241_delay_ms_tm1637
2774                     ; 179 	PC_ODR |= (1 << CLK_PIN);
2776  0131 721a500a      	bset	_PC_ODR,#5
2777                     ; 180 	delay_ms_tm1637(CLOCK_DELAY);
2779  0135 ae0001        	ldw	x,#1
2780  0138 ada2          	call	L5241_delay_ms_tm1637
2782                     ; 181 	PC_ODR &= ~(1 << CLK_PIN);
2784  013a 721b500a      	bres	_PC_ODR,#5
2785                     ; 182 	return 1;
2787  013e a601          	ld	a,#1
2790  0140 81            	ret
2831                     ; 192 static void tm1637WriteByte(uint8_t b)
2831                     ; 193 {
2832                     	switch	.text
2833  0141               L5341_tm1637WriteByte:
2835  0141 88            	push	a
2836  0142 88            	push	a
2837       00000001      OFST:	set	1
2840                     ; 196 	for (i = 0; i < 8; i++)
2842  0143 0f01          	clr	(OFST+0,sp)
2844  0145               L1561:
2845                     ; 198 		PC_ODR &= ~(1 << CLK_PIN); // CLK low
2847  0145 721b500a      	bres	_PC_ODR,#5
2848                     ; 200 		if (b & 1)
2850  0149 7b02          	ld	a,(OFST+1,sp)
2851  014b a501          	bcp	a,#1
2852  014d 2706          	jreq	L7561
2853                     ; 201 			PC_ODR |= (1 << DIO_PIN); // DIO high
2855  014f 721c500a      	bset	_PC_ODR,#6
2857  0153 2004          	jra	L1661
2858  0155               L7561:
2859                     ; 203 			PC_ODR &= ~(1 << DIO_PIN); // DIO low
2861  0155 721d500a      	bres	_PC_ODR,#6
2862  0159               L1661:
2863                     ; 205 		delay_ms_tm1637(CLOCK_DELAY);
2865  0159 ae0001        	ldw	x,#1
2866  015c cd00dc        	call	L5241_delay_ms_tm1637
2868                     ; 207 		PC_ODR |= (1 << CLK_PIN); // CLK high
2870  015f 721a500a      	bset	_PC_ODR,#5
2871                     ; 208 		delay_ms_tm1637(CLOCK_DELAY);
2873  0163 ae0001        	ldw	x,#1
2874  0166 cd00dc        	call	L5241_delay_ms_tm1637
2876                     ; 210 		b >>= 1;
2878  0169 0402          	srl	(OFST+1,sp)
2879                     ; 196 	for (i = 0; i < 8; i++)
2881  016b 0c01          	inc	(OFST+0,sp)
2885  016d 7b01          	ld	a,(OFST+0,sp)
2886  016f a108          	cp	a,#8
2887  0171 25d2          	jrult	L1561
2888                     ; 212 }
2891  0173 85            	popw	x
2892  0174 81            	ret
2952                     ; 220 static void tm1637Write(uint8_t *pData, uint8_t bLen)
2952                     ; 221 {
2953                     	switch	.text
2954  0175               L7341_tm1637Write:
2956  0175 89            	pushw	x
2957  0176 89            	pushw	x
2958       00000002      OFST:	set	2
2961                     ; 223 	bAck = 1;
2963  0177 a601          	ld	a,#1
2964  0179 6b01          	ld	(OFST-1,sp),a
2966                     ; 224 	tm1637Start();
2968  017b cd00f6        	call	L7241_tm1637Start
2970                     ; 225 	for (b = 0; b < bLen; b++)
2972  017e 0f02          	clr	(OFST+0,sp)
2975  0180 2012          	jra	L3171
2976  0182               L7071:
2977                     ; 227 		tm1637WriteByte(pData[b]);
2979  0182 7b02          	ld	a,(OFST+0,sp)
2980  0184 5f            	clrw	x
2981  0185 97            	ld	xl,a
2982  0186 72fb03        	addw	x,(OFST+1,sp)
2983  0189 f6            	ld	a,(x)
2984  018a adb5          	call	L5341_tm1637WriteByte
2986                     ; 228 		bAck &= tm1637GetAck();
2988  018c ad9a          	call	L3341_tm1637GetAck
2990  018e 1401          	and	a,(OFST-1,sp)
2991  0190 6b01          	ld	(OFST-1,sp),a
2993                     ; 225 	for (b = 0; b < bLen; b++)
2995  0192 0c02          	inc	(OFST+0,sp)
2997  0194               L3171:
3000  0194 7b02          	ld	a,(OFST+0,sp)
3001  0196 1107          	cp	a,(OFST+5,sp)
3002  0198 25e8          	jrult	L7071
3003                     ; 230 	tm1637Stop();
3005  019a cd0108        	call	L1341_tm1637Stop
3007                     ; 231 }
3010  019d 5b04          	addw	sp,#4
3011  019f 81            	ret
3036                     	xdef	_tm1637ShowDigits
3037                     	xdef	_tm1637SetBrightness
3038                     	xdef	_tm1637Init
3057                     	end
