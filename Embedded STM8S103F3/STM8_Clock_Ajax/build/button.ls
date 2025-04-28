   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2172                     	switch	.data
2173  0000               _flag_hour:
2174  0000 00            	dc.b	0
2175  0001               _flag_min:
2176  0001 00            	dc.b	0
2213                     ; 65 void Buttons_Init(void)
2213                     ; 66 {
2215                     	switch	.text
2216  0000               _Buttons_Init:
2220                     ; 68     PC_DDR &= ~(1 << BTN_HOUR_PIN); // input mode
2222  0000 7217500c      	bres	_PC_DDR,#3
2223                     ; 69     PC_CR1 &= ~(1 << BTN_HOUR_PIN); // no pull-up (external pull-down used)
2225  0004 7217500d      	bres	_PC_CR1,#3
2226                     ; 70     PC_CR2 |= (1 << BTN_HOUR_PIN);  // enable EXTI on PC3
2228  0008 7216500e      	bset	_PC_CR2,#3
2229                     ; 73     EXTI_CR1 = (EXTI_CR1 & ~(3 << 4)) | (1 << 4);
2231  000c c650a0        	ld	a,_EXTI_CR1
2232  000f a4cf          	and	a,#207
2233  0011 aa10          	or	a,#16
2234  0013 c750a0        	ld	_EXTI_CR1,a
2235                     ; 76     PD_DDR &= ~(1 << BTN_MIN_PIN); // input mode
2237  0016 72155011      	bres	_PD_DDR,#2
2238                     ; 77     PD_CR1 &= ~(1 << BTN_MIN_PIN); // no pull-up (external pull-down used)
2240  001a 72155012      	bres	_PD_CR1,#2
2241                     ; 78     PD_CR2 |= (1 << BTN_MIN_PIN);  // enable EXTI on PD2
2243  001e 72145013      	bset	_PD_CR2,#2
2244                     ; 81     EXTI_CR1 = (EXTI_CR1 & ~(3 << 6)) | (1 << 6);
2246  0022 c650a0        	ld	a,_EXTI_CR1
2247  0025 a43f          	and	a,#63
2248  0027 aa40          	or	a,#64
2249  0029 c750a0        	ld	_EXTI_CR1,a
2250                     ; 84     EXTI_CR2 |= (1 << 2);
2252  002c 721450a1      	bset	_EXTI_CR2,#2
2253                     ; 87 }
2256  0030 81            	ret
2289                     ; 89 uint8_t Button_HourPressed(void)
2289                     ; 90 {
2290                     	switch	.text
2291  0031               _Button_HourPressed:
2293  0031 88            	push	a
2294       00000001      OFST:	set	1
2297                     ; 91     uint8_t result = flag_hour;
2299  0032 c60000        	ld	a,_flag_hour
2300  0035 6b01          	ld	(OFST+0,sp),a
2302                     ; 92     flag_hour = 0;
2304  0037 725f0000      	clr	_flag_hour
2305                     ; 93     return result;
2307  003b 7b01          	ld	a,(OFST+0,sp)
2310  003d 5b01          	addw	sp,#1
2311  003f 81            	ret
2345                     ; 96 uint8_t Button_MinutePressed(void)
2345                     ; 97 {
2346                     	switch	.text
2347  0040               _Button_MinutePressed:
2349  0040 88            	push	a
2350       00000001      OFST:	set	1
2353                     ; 98     uint8_t result = flag_min;
2355  0041 c60001        	ld	a,_flag_min
2356  0044 6b01          	ld	(OFST+0,sp),a
2358                     ; 99     flag_min = 0;
2360  0046 725f0001      	clr	_flag_min
2361                     ; 100     return result;
2363  004a 7b01          	ld	a,(OFST+0,sp)
2366  004c 5b01          	addw	sp,#1
2367  004e 81            	ret
2392                     ; 103 void Button_Minute_EnableInterrupt(void)
2392                     ; 104 {
2393                     	switch	.text
2394  004f               _Button_Minute_EnableInterrupt:
2398                     ; 105     PD_CR2 |= (1 << BTN_MIN_PIN); // Enable EXTI on PD2
2400  004f 72145013      	bset	_PD_CR2,#2
2401                     ; 106 }
2404  0053 81            	ret
2429                     ; 108 void Button_Minute_DisableInterrupt(void)
2429                     ; 109 {
2430                     	switch	.text
2431  0054               _Button_Minute_DisableInterrupt:
2435                     ; 110     PD_CR2 &= ~(1 << BTN_MIN_PIN); // Disable EXTI on PD2
2437  0054 72155013      	bres	_PD_CR2,#2
2438                     ; 111 }
2441  0058 81            	ret
2466                     ; 113 void Button_Hour_EnableInterrupt(void)
2466                     ; 114 {
2467                     	switch	.text
2468  0059               _Button_Hour_EnableInterrupt:
2472                     ; 115     PC_CR2 |= (1 << BTN_HOUR_PIN); // Enable EXTI on PC3
2474  0059 7216500e      	bset	_PC_CR2,#3
2475                     ; 116 }
2478  005d 81            	ret
2503                     ; 118 void Button_Hour_DisableInterrupt(void)
2503                     ; 119 {
2504                     	switch	.text
2505  005e               _Button_Hour_DisableInterrupt:
2509                     ; 120     PC_CR2 &= ~(1 << BTN_HOUR_PIN); // Disable EXTI on PC3
2511  005e 7217500e      	bres	_PC_CR2,#3
2512                     ; 121 }
2515  0062 81            	ret
2540                     ; 123 void Button_Hour_WaitRelease(void)
2540                     ; 124 {
2541                     	switch	.text
2542  0063               _Button_Hour_WaitRelease:
2546  0063               L3451:
2547                     ; 125     while (PC_IDR & (1 << BTN_HOUR_PIN))
2549  0063 c6500b        	ld	a,_PC_IDR
2550  0066 a508          	bcp	a,#8
2551  0068 26f9          	jrne	L3451
2552                     ; 127 }
2555  006a 81            	ret
2580                     ; 129 void Button_Minute_WaitRelease(void)
2580                     ; 130 {
2581                     	switch	.text
2582  006b               _Button_Minute_WaitRelease:
2586  006b               L1651:
2587                     ; 131     while (PD_IDR & (1 << BTN_MIN_PIN))
2589  006b c65010        	ld	a,_PD_IDR
2590  006e a504          	bcp	a,#4
2591  0070 26f9          	jrne	L1651
2592                     ; 133 }
2595  0072 81            	ret
2622                     ; 135 uint8_t Button_BothPressed_FirstMinute_SecondHour_WaitRelease(void)
2622                     ; 136 {
2623                     	switch	.text
2624  0073               _Button_BothPressed_FirstMinute_SecondHour_WaitRelease:
2628  0073 200a          	jra	L7751
2629  0075               L5751:
2630                     ; 139         if (PC_IDR & (1 << BTN_HOUR_PIN)) // if HIGH
2632  0075 c6500b        	ld	a,_PC_IDR
2633  0078 a508          	bcp	a,#8
2634  007a 2703          	jreq	L7751
2635                     ; 141             return 1;
2637  007c a601          	ld	a,#1
2640  007e 81            	ret
2641  007f               L7751:
2642                     ; 137     while (PD_IDR & (1 << BTN_MIN_PIN)) // Wait for LOW, while HIGH
2644  007f c65010        	ld	a,_PD_IDR
2645  0082 a504          	bcp	a,#4
2646  0084 26ef          	jrne	L5751
2647                     ; 144     return 0;
2649  0086 4f            	clr	a
2652  0087 81            	ret
2679                     ; 147 uint8_t Button_BothPressed_FirstHour_SecondMinut_WaitRelease(void)
2679                     ; 148 {
2680                     	switch	.text
2681  0088               _Button_BothPressed_FirstHour_SecondMinut_WaitRelease:
2685  0088 200a          	jra	L7161
2686  008a               L5161:
2687                     ; 151         if (PD_IDR & (1 << BTN_MIN_PIN)) // if HIGH
2689  008a c65010        	ld	a,_PD_IDR
2690  008d a504          	bcp	a,#4
2691  008f 2703          	jreq	L7161
2692                     ; 153             return 1;
2694  0091 a601          	ld	a,#1
2697  0093 81            	ret
2698  0094               L7161:
2699                     ; 149     while (PC_IDR & (1 << BTN_HOUR_PIN)) // Wait for LOW, while HIGH
2701  0094 c6500b        	ld	a,_PC_IDR
2702  0097 a508          	bcp	a,#8
2703  0099 26ef          	jrne	L5161
2704                     ; 156     return 0;
2706  009b 4f            	clr	a
2709  009c 81            	ret
2735                     ; 159 uint8_t Button_BothReleased(void)
2735                     ; 160 {
2736                     	switch	.text
2737  009d               _Button_BothReleased:
2741                     ; 161     if (!(PC_IDR & (1 << BTN_HOUR_PIN)) && !(PD_IDR & (1 << BTN_MIN_PIN)))
2743  009d c6500b        	ld	a,_PC_IDR
2744  00a0 a508          	bcp	a,#8
2745  00a2 260a          	jrne	L5361
2747  00a4 c65010        	ld	a,_PD_IDR
2748  00a7 a504          	bcp	a,#4
2749  00a9 2603          	jrne	L5361
2750                     ; 163         return 1;
2752  00ab a601          	ld	a,#1
2755  00ad 81            	ret
2756  00ae               L5361:
2757                     ; 165     return 0;
2759  00ae 4f            	clr	a
2762  00af 81            	ret
2788                     ; 171 void Button_Hour_EnsureInterruptEnabled(void)
2788                     ; 172 {
2789                     	switch	.text
2790  00b0               _Button_Hour_EnsureInterruptEnabled:
2794                     ; 173     if (!(PC_IDR & (1 << BTN_HOUR_PIN))) // якщо LOW — кнопка не натиснута
2796  00b0 c6500b        	ld	a,_PC_IDR
2797  00b3 a508          	bcp	a,#8
2798  00b5 2602          	jrne	L7461
2799                     ; 175         Button_Hour_EnableInterrupt();
2801  00b7 ada0          	call	_Button_Hour_EnableInterrupt
2803  00b9               L7461:
2804                     ; 177 }
2807  00b9 81            	ret
2833                     ; 179 void Button_Minute_EnsureInterruptEnabled(void)
2833                     ; 180 {
2834                     	switch	.text
2835  00ba               _Button_Minute_EnsureInterruptEnabled:
2839                     ; 181     if (!(PD_IDR & (1 << BTN_MIN_PIN))) // LOW = не натиснута
2841  00ba c65010        	ld	a,_PD_IDR
2842  00bd a504          	bcp	a,#4
2843  00bf 2602          	jrne	L1661
2844                     ; 183         Button_Minute_EnableInterrupt();
2846  00c1 ad8c          	call	_Button_Minute_EnableInterrupt
2848  00c3               L1661:
2849                     ; 185 }
2852  00c3 81            	ret
2879                     ; 204 @far @interrupt void EXTI_PORTC_IRQHandler(void)
2879                     ; 205 {
2881                     	switch	.text
2882  00c4               f_EXTI_PORTC_IRQHandler:
2884  00c4 8a            	push	cc
2885  00c5 84            	pop	a
2886  00c6 a4bf          	and	a,#191
2887  00c8 88            	push	a
2888  00c9 86            	pop	cc
2889  00ca 3b0002        	push	c_x+2
2890  00cd be00          	ldw	x,c_x
2891  00cf 89            	pushw	x
2892  00d0 3b0002        	push	c_y+2
2893  00d3 be00          	ldw	x,c_y
2894  00d5 89            	pushw	x
2897                     ; 207     if (PC_IDR & (1 << BTN_HOUR_PIN))
2899  00d6 c6500b        	ld	a,_PC_IDR
2900  00d9 a508          	bcp	a,#8
2901  00db 2707          	jreq	L3761
2902                     ; 209         flag_hour = 1;
2904  00dd 35010000      	mov	_flag_hour,#1
2905                     ; 210         Button_Hour_DisableInterrupt();
2907  00e1 cd005e        	call	_Button_Hour_DisableInterrupt
2909  00e4               L3761:
2910                     ; 212 }
2913  00e4 85            	popw	x
2914  00e5 bf00          	ldw	c_y,x
2915  00e7 320002        	pop	c_y+2
2916  00ea 85            	popw	x
2917  00eb bf00          	ldw	c_x,x
2918  00ed 320002        	pop	c_x+2
2919  00f0 80            	iret
2945                     ; 228 @far @interrupt void EXTI_PORTD_IRQHandler(void)
2945                     ; 229 {
2946                     	switch	.text
2947  00f1               f_EXTI_PORTD_IRQHandler:
2949  00f1 8a            	push	cc
2950  00f2 84            	pop	a
2951  00f3 a4bf          	and	a,#191
2952  00f5 88            	push	a
2953  00f6 86            	pop	cc
2954  00f7 3b0002        	push	c_x+2
2955  00fa be00          	ldw	x,c_x
2956  00fc 89            	pushw	x
2957  00fd 3b0002        	push	c_y+2
2958  0100 be00          	ldw	x,c_y
2959  0102 89            	pushw	x
2962                     ; 231     if (PD_IDR & (1 << BTN_MIN_PIN))
2964  0103 c65010        	ld	a,_PD_IDR
2965  0106 a504          	bcp	a,#4
2966  0108 2707          	jreq	L5071
2967                     ; 233         flag_min = 1;
2969  010a 35010001      	mov	_flag_min,#1
2970                     ; 234         Button_Minute_DisableInterrupt();
2972  010e cd0054        	call	_Button_Minute_DisableInterrupt
2974  0111               L5071:
2975                     ; 236 }
2978  0111 85            	popw	x
2979  0112 bf00          	ldw	c_y,x
2980  0114 320002        	pop	c_y+2
2981  0117 85            	popw	x
2982  0118 bf00          	ldw	c_x,x
2983  011a 320002        	pop	c_x+2
2984  011d 80            	iret
3016                     	xdef	f_EXTI_PORTD_IRQHandler
3017                     	xdef	f_EXTI_PORTC_IRQHandler
3018                     	xdef	_flag_min
3019                     	xdef	_flag_hour
3020                     	xdef	_Button_Minute_EnsureInterruptEnabled
3021                     	xdef	_Button_Hour_EnsureInterruptEnabled
3022                     	xdef	_Button_BothReleased
3023                     	xdef	_Button_BothPressed_FirstHour_SecondMinut_WaitRelease
3024                     	xdef	_Button_BothPressed_FirstMinute_SecondHour_WaitRelease
3025                     	xdef	_Button_Minute_WaitRelease
3026                     	xdef	_Button_Hour_WaitRelease
3027                     	xdef	_Button_Hour_DisableInterrupt
3028                     	xdef	_Button_Hour_EnableInterrupt
3029                     	xdef	_Button_Minute_DisableInterrupt
3030                     	xdef	_Button_Minute_EnableInterrupt
3031                     	xdef	_Button_MinutePressed
3032                     	xdef	_Button_HourPressed
3033                     	xdef	_Buttons_Init
3034                     	xref.b	c_x
3035                     	xref.b	c_y
3054                     	end
