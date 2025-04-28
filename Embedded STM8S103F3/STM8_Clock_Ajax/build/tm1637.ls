   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2172                     .const:	section	.text
2173  0000               L3241_cDigit2Seg:
2174  0000 3f            	dc.b	63
2175  0001 06            	dc.b	6
2176  0002 5b            	dc.b	91
2177  0003 4f            	dc.b	79
2178  0004 66            	dc.b	102
2179  0005 6d            	dc.b	109
2180  0006 7d            	dc.b	125
2181  0007 07            	dc.b	7
2182  0008 7f            	dc.b	127
2183  0009 6f            	dc.b	111
2215                     ; 48 void tm1637Init(void)
2215                     ; 49 {
2217                     	switch	.text
2218  0000               _tm1637Init:
2222                     ; 51 	PC_DDR |= (1 << CLK_PIN);  // output
2224  0000 721a500c      	bset	_PC_DDR,#5
2225                     ; 52 	PC_CR1 |= (1 << CLK_PIN);  // push-pull
2227  0004 721a500d      	bset	_PC_CR1,#5
2228                     ; 53 	PC_ODR &= ~(1 << CLK_PIN); // LOW
2230  0008 721b500a      	bres	_PC_ODR,#5
2231                     ; 56 	PC_DDR |= (1 << DIO_PIN);  // output
2233  000c 721c500c      	bset	_PC_DDR,#6
2234                     ; 57 	PC_CR1 |= (1 << DIO_PIN);  // push-pull
2236  0010 721c500d      	bset	_PC_CR1,#6
2237                     ; 58 	PC_ODR &= ~(1 << DIO_PIN); // LOW
2239  0014 721d500a      	bres	_PC_ODR,#6
2240                     ; 59 }
2243  0018 81            	ret
2284                     ; 61 void tm1637SetBrightness(uint8_t b)
2284                     ; 62 {
2285                     	switch	.text
2286  0019               _tm1637SetBrightness:
2288  0019 88            	push	a
2289  001a 88            	push	a
2290       00000001      OFST:	set	1
2293                     ; 64 	if (b == 0)
2295  001b 4d            	tnz	a
2296  001c 2606          	jrne	L5741
2297                     ; 66 		bControl = 0x80;
2299  001e a680          	ld	a,#128
2300  0020 6b01          	ld	(OFST+0,sp),a
2303  0022 2011          	jra	L7741
2304  0024               L5741:
2305                     ; 69 		if (b > 8)
2307  0024 7b02          	ld	a,(OFST+1,sp)
2308  0026 a109          	cp	a,#9
2309  0028 2504          	jrult	L1051
2310                     ; 70 			b = 8;
2312  002a a608          	ld	a,#8
2313  002c 6b02          	ld	(OFST+1,sp),a
2314  002e               L1051:
2315                     ; 71 		bControl = 0x88 | (b - 1);
2317  002e 7b02          	ld	a,(OFST+1,sp)
2318  0030 4a            	dec	a
2319  0031 aa88          	or	a,#136
2320  0033 6b01          	ld	(OFST+0,sp),a
2322  0035               L7741:
2323                     ; 73 	tm1637Write(&bControl, 1);
2325  0035 4b01          	push	#1
2326  0037 96            	ldw	x,sp
2327  0038 1c0002        	addw	x,#OFST+1
2328  003b cd0175        	call	L7341_tm1637Write
2330  003e 84            	pop	a
2331                     ; 74 }
2334  003f 85            	popw	x
2335  0040 81            	ret
2403                     ; 76 void tm1637ShowDigits(char *pString)
2403                     ; 77 {
2404                     	switch	.text
2405  0041               _tm1637ShowDigits:
2407  0041 89            	pushw	x
2408  0042 5215          	subw	sp,#21
2409       00000015      OFST:	set	21
2412                     ; 82 	j = 0;
2414  0044 0f03          	clr	(OFST-18,sp)
2416                     ; 84 	bTemp[0] = 0x40;
2418  0046 a640          	ld	a,#64
2419  0048 6b04          	ld	(OFST-17,sp),a
2421                     ; 85 	tm1637Write(bTemp, 1);
2423  004a 4b01          	push	#1
2424  004c 96            	ldw	x,sp
2425  004d 1c0005        	addw	x,#OFST-16
2426  0050 cd0175        	call	L7341_tm1637Write
2428  0053 84            	pop	a
2429                     ; 88 	bTemp[j++] = 0xc0;
2431  0054 96            	ldw	x,sp
2432  0055 1c0004        	addw	x,#OFST-17
2433  0058 1f01          	ldw	(OFST-20,sp),x
2435  005a 7b03          	ld	a,(OFST-18,sp)
2436  005c 97            	ld	xl,a
2437  005d 0c03          	inc	(OFST-18,sp)
2439  005f 9f            	ld	a,xl
2440  0060 5f            	clrw	x
2441  0061 97            	ld	xl,a
2442  0062 72fb01        	addw	x,(OFST-20,sp)
2443  0065 a6c0          	ld	a,#192
2444  0067 f7            	ld	(x),a
2445                     ; 89 	for (i = 0; i < 5; i++)
2447  0068 0f15          	clr	(OFST+0,sp)
2449  006a               L3351:
2450                     ; 92 		if (i == 2)
2452  006a 7b15          	ld	a,(OFST+0,sp)
2453  006c a102          	cp	a,#2
2454  006e 2614          	jrne	L1451
2455                     ; 95 			if (pString[i] == ':')
2457  0070 7b15          	ld	a,(OFST+0,sp)
2458  0072 5f            	clrw	x
2459  0073 97            	ld	xl,a
2460  0074 72fb16        	addw	x,(OFST+1,sp)
2461  0077 f6            	ld	a,(x)
2462  0078 a13a          	cp	a,#58
2463  007a 264a          	jrne	L5451
2464                     ; 98 				bTemp[2] |= 0x80;
2466  007c 7b06          	ld	a,(OFST-15,sp)
2467  007e aa80          	or	a,#128
2468  0080 6b06          	ld	(OFST-15,sp),a
2470  0082 2042          	jra	L5451
2471  0084               L1451:
2472                     ; 104 			b = 0;
2474                     ; 105 			if (pString[i] >= '0' && pString[i] <= '9')
2476  0084 7b15          	ld	a,(OFST+0,sp)
2477  0086 5f            	clrw	x
2478  0087 97            	ld	xl,a
2479  0088 72fb16        	addw	x,(OFST+1,sp)
2480  008b f6            	ld	a,(x)
2481  008c a130          	cp	a,#48
2482  008e 2520          	jrult	L7451
2484  0090 7b15          	ld	a,(OFST+0,sp)
2485  0092 5f            	clrw	x
2486  0093 97            	ld	xl,a
2487  0094 72fb16        	addw	x,(OFST+1,sp)
2488  0097 f6            	ld	a,(x)
2489  0098 a13a          	cp	a,#58
2490  009a 2414          	jruge	L7451
2491                     ; 109 				b = cDigit2Seg[pString[i] - '0'];
2493  009c 7b15          	ld	a,(OFST+0,sp)
2494  009e 5f            	clrw	x
2495  009f 97            	ld	xl,a
2496  00a0 72fb16        	addw	x,(OFST+1,sp)
2497  00a3 f6            	ld	a,(x)
2498  00a4 5f            	clrw	x
2499  00a5 97            	ld	xl,a
2500  00a6 1d0030        	subw	x,#48
2501  00a9 d60000        	ld	a,(L3241_cDigit2Seg,x)
2502  00ac 6b14          	ld	(OFST-1,sp),a
2505  00ae 2002          	jra	L1551
2506  00b0               L7451:
2507                     ; 113 				b = 0;
2509  00b0 0f14          	clr	(OFST-1,sp)
2511  00b2               L1551:
2512                     ; 115 			bTemp[j++] = b;
2514  00b2 96            	ldw	x,sp
2515  00b3 1c0004        	addw	x,#OFST-17
2516  00b6 1f01          	ldw	(OFST-20,sp),x
2518  00b8 7b03          	ld	a,(OFST-18,sp)
2519  00ba 97            	ld	xl,a
2520  00bb 0c03          	inc	(OFST-18,sp)
2522  00bd 9f            	ld	a,xl
2523  00be 5f            	clrw	x
2524  00bf 97            	ld	xl,a
2525  00c0 72fb01        	addw	x,(OFST-20,sp)
2526  00c3 7b14          	ld	a,(OFST-1,sp)
2527  00c5 f7            	ld	(x),a
2528  00c6               L5451:
2529                     ; 89 	for (i = 0; i < 5; i++)
2531  00c6 0c15          	inc	(OFST+0,sp)
2535  00c8 7b15          	ld	a,(OFST+0,sp)
2536  00ca a105          	cp	a,#5
2537  00cc 259c          	jrult	L3351
2538                     ; 119 	tm1637Write(bTemp, j);
2540  00ce 7b03          	ld	a,(OFST-18,sp)
2541  00d0 88            	push	a
2542  00d1 96            	ldw	x,sp
2543  00d2 1c0005        	addw	x,#OFST-16
2544  00d5 cd0175        	call	L7341_tm1637Write
2546  00d8 84            	pop	a
2547                     ; 120 }
2550  00d9 5b17          	addw	sp,#23
2551  00db 81            	ret
2594                     ; 133 static void delay_ms_tm1637(uint16_t milliseconds)
2594                     ; 134 {
2595                     	switch	.text
2596  00dc               L5241_delay_ms_tm1637:
2598  00dc 89            	pushw	x
2599  00dd 89            	pushw	x
2600       00000002      OFST:	set	2
2603                     ; 135 	volatile uint16_t i = 0;
2605  00de 5f            	clrw	x
2606  00df 1f01          	ldw	(OFST-1,sp),x
2609  00e1 2001          	jra	L7751
2610  00e3               L3751:
2611                     ; 141 			__asm("nop");
2614  00e3 9d            nop
2616  00e4               L7751:
2617                     ; 137 	while (milliseconds--)
2619  00e4 1e03          	ldw	x,(OFST+1,sp)
2620  00e6 1d0001        	subw	x,#1
2621  00e9 1f03          	ldw	(OFST+1,sp),x
2622  00eb 1c0001        	addw	x,#1
2623  00ee a30000        	cpw	x,#0
2624  00f1 26f0          	jrne	L3751
2625                     ; 144 }
2628  00f3 5b04          	addw	sp,#4
2629  00f5 81            	ret
2654                     ; 152 static void tm1637Start(void)
2654                     ; 153 {
2655                     	switch	.text
2656  00f6               L7241_tm1637Start:
2660                     ; 154 	PC_ODR |= (1 << DIO_PIN); // DIO high
2662  00f6 721c500a      	bset	_PC_ODR,#6
2663                     ; 155 	PC_ODR |= (1 << CLK_PIN); // CLK high
2665  00fa 721a500a      	bset	_PC_ODR,#5
2666                     ; 156 	delay_ms_tm1637(CLOCK_DELAY);
2668  00fe ae0001        	ldw	x,#1
2669  0101 add9          	call	L5241_delay_ms_tm1637
2671                     ; 157 	PC_ODR &= ~(1 << DIO_PIN); // DIO low
2673  0103 721d500a      	bres	_PC_ODR,#6
2674                     ; 158 }
2677  0107 81            	ret
2702                     ; 166 static void tm1637Stop(void)
2702                     ; 167 {
2703                     	switch	.text
2704  0108               L1341_tm1637Stop:
2708                     ; 168 	PC_ODR &= ~(1 << CLK_PIN); // CLK low
2710  0108 721b500a      	bres	_PC_ODR,#5
2711                     ; 169 	delay_ms_tm1637(CLOCK_DELAY);
2713  010c ae0001        	ldw	x,#1
2714  010f adcb          	call	L5241_delay_ms_tm1637
2716                     ; 170 	PC_ODR &= ~(1 << DIO_PIN); // DIO low
2718  0111 721d500a      	bres	_PC_ODR,#6
2719                     ; 171 	delay_ms_tm1637(CLOCK_DELAY);
2721  0115 ae0001        	ldw	x,#1
2722  0118 adc2          	call	L5241_delay_ms_tm1637
2724                     ; 172 	PC_ODR |= (1 << CLK_PIN); // CLK high
2726  011a 721a500a      	bset	_PC_ODR,#5
2727                     ; 173 	delay_ms_tm1637(CLOCK_DELAY);
2729  011e ae0001        	ldw	x,#1
2730  0121 adb9          	call	L5241_delay_ms_tm1637
2732                     ; 174 	PC_ODR |= (1 << DIO_PIN); // DIO high
2734  0123 721c500a      	bset	_PC_ODR,#6
2735                     ; 175 }
2738  0127 81            	ret
2763                     ; 185 static uint8_t tm1637GetAck(void)
2763                     ; 186 {
2764                     	switch	.text
2765  0128               L3341_tm1637GetAck:
2769                     ; 187 	PC_ODR &= ~(1 << CLK_PIN);
2771  0128 721b500a      	bres	_PC_ODR,#5
2772                     ; 188 	delay_ms_tm1637(CLOCK_DELAY);
2774  012c ae0001        	ldw	x,#1
2775  012f adab          	call	L5241_delay_ms_tm1637
2777                     ; 189 	PC_ODR |= (1 << CLK_PIN);
2779  0131 721a500a      	bset	_PC_ODR,#5
2780                     ; 190 	delay_ms_tm1637(CLOCK_DELAY);
2782  0135 ae0001        	ldw	x,#1
2783  0138 ada2          	call	L5241_delay_ms_tm1637
2785                     ; 191 	PC_ODR &= ~(1 << CLK_PIN);
2787  013a 721b500a      	bres	_PC_ODR,#5
2788                     ; 192 	return 1;
2790  013e a601          	ld	a,#1
2793  0140 81            	ret
2834                     ; 202 static void tm1637WriteByte(uint8_t b)
2834                     ; 203 {
2835                     	switch	.text
2836  0141               L5341_tm1637WriteByte:
2838  0141 88            	push	a
2839  0142 88            	push	a
2840       00000001      OFST:	set	1
2843                     ; 206 	for (i = 0; i < 8; i++)
2845  0143 0f01          	clr	(OFST+0,sp)
2847  0145               L1561:
2848                     ; 208 		PC_ODR &= ~(1 << CLK_PIN); // CLK low
2850  0145 721b500a      	bres	_PC_ODR,#5
2851                     ; 210 		if (b & 1)
2853  0149 7b02          	ld	a,(OFST+1,sp)
2854  014b a501          	bcp	a,#1
2855  014d 2706          	jreq	L7561
2856                     ; 211 			PC_ODR |= (1 << DIO_PIN); // DIO high
2858  014f 721c500a      	bset	_PC_ODR,#6
2860  0153 2004          	jra	L1661
2861  0155               L7561:
2862                     ; 213 			PC_ODR &= ~(1 << DIO_PIN); // DIO low
2864  0155 721d500a      	bres	_PC_ODR,#6
2865  0159               L1661:
2866                     ; 215 		delay_ms_tm1637(CLOCK_DELAY);
2868  0159 ae0001        	ldw	x,#1
2869  015c cd00dc        	call	L5241_delay_ms_tm1637
2871                     ; 217 		PC_ODR |= (1 << CLK_PIN); // CLK high
2873  015f 721a500a      	bset	_PC_ODR,#5
2874                     ; 218 		delay_ms_tm1637(CLOCK_DELAY);
2876  0163 ae0001        	ldw	x,#1
2877  0166 cd00dc        	call	L5241_delay_ms_tm1637
2879                     ; 220 		b >>= 1;
2881  0169 0402          	srl	(OFST+1,sp)
2882                     ; 206 	for (i = 0; i < 8; i++)
2884  016b 0c01          	inc	(OFST+0,sp)
2888  016d 7b01          	ld	a,(OFST+0,sp)
2889  016f a108          	cp	a,#8
2890  0171 25d2          	jrult	L1561
2891                     ; 222 }
2894  0173 85            	popw	x
2895  0174 81            	ret
2955                     ; 230 static void tm1637Write(uint8_t *pData, uint8_t bLen)
2955                     ; 231 {
2956                     	switch	.text
2957  0175               L7341_tm1637Write:
2959  0175 89            	pushw	x
2960  0176 89            	pushw	x
2961       00000002      OFST:	set	2
2964                     ; 233 	bAck = 1;
2966  0177 a601          	ld	a,#1
2967  0179 6b01          	ld	(OFST-1,sp),a
2969                     ; 234 	tm1637Start();
2971  017b cd00f6        	call	L7241_tm1637Start
2973                     ; 235 	for (b = 0; b < bLen; b++)
2975  017e 0f02          	clr	(OFST+0,sp)
2978  0180 2012          	jra	L3171
2979  0182               L7071:
2980                     ; 237 		tm1637WriteByte(pData[b]);
2982  0182 7b02          	ld	a,(OFST+0,sp)
2983  0184 5f            	clrw	x
2984  0185 97            	ld	xl,a
2985  0186 72fb03        	addw	x,(OFST+1,sp)
2986  0189 f6            	ld	a,(x)
2987  018a adb5          	call	L5341_tm1637WriteByte
2989                     ; 238 		bAck &= tm1637GetAck();
2991  018c ad9a          	call	L3341_tm1637GetAck
2993  018e 1401          	and	a,(OFST-1,sp)
2994  0190 6b01          	ld	(OFST-1,sp),a
2996                     ; 235 	for (b = 0; b < bLen; b++)
2998  0192 0c02          	inc	(OFST+0,sp)
3000  0194               L3171:
3003  0194 7b02          	ld	a,(OFST+0,sp)
3004  0196 1107          	cp	a,(OFST+5,sp)
3005  0198 25e8          	jrult	L7071
3006                     ; 240 	tm1637Stop();
3008  019a cd0108        	call	L1341_tm1637Stop
3010                     ; 241 }
3013  019d 5b04          	addw	sp,#4
3014  019f 81            	ret
3039                     	xdef	_tm1637ShowDigits
3040                     	xdef	_tm1637SetBrightness
3041                     	xdef	_tm1637Init
3060                     	end
