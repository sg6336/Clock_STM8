   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2169                     	switch	.data
2170  0000               _flag_hour:
2171  0000 00            	dc.b	0
2172  0001               _flag_min:
2173  0001 00            	dc.b	0
2210                     ; 60  void Buttons_Init(void)
2210                     ; 61  {
2212                     	switch	.text
2213  0000               _Buttons_Init:
2217                     ; 63      PC_DDR &= ~(1 << BTN_HOUR_PIN);   // input mode
2219  0000 7217500c      	bres	_PC_DDR,#3
2220                     ; 64      PC_CR1 &= ~(1 << BTN_HOUR_PIN);   // no pull-up (external pull-down used)
2222  0004 7217500d      	bres	_PC_CR1,#3
2223                     ; 65      PC_CR2 |=  (1 << BTN_HOUR_PIN);   // enable EXTI on PC3
2225  0008 7216500e      	bset	_PC_CR2,#3
2226                     ; 68      EXTI_CR1 = (EXTI_CR1 & ~(3 << 4)) | (1 << 4);
2228  000c c650a0        	ld	a,_EXTI_CR1
2229  000f a4cf          	and	a,#207
2230  0011 aa10          	or	a,#16
2231  0013 c750a0        	ld	_EXTI_CR1,a
2232                     ; 71      PD_DDR &= ~(1 << BTN_MIN_PIN);   // input mode
2234  0016 72155011      	bres	_PD_DDR,#2
2235                     ; 72      PD_CR1 &= ~(1 << BTN_MIN_PIN);   // no pull-up (external pull-down used)
2237  001a 72155012      	bres	_PD_CR1,#2
2238                     ; 73      PD_CR2 |=  (1 << BTN_MIN_PIN);   // enable EXTI on PD2
2240  001e 72145013      	bset	_PD_CR2,#2
2241                     ; 76      EXTI_CR1 = (EXTI_CR1 & ~(3 << 6)) | (1 << 6);
2243  0022 c650a0        	ld	a,_EXTI_CR1
2244  0025 a43f          	and	a,#63
2245  0027 aa40          	or	a,#64
2246  0029 c750a0        	ld	_EXTI_CR1,a
2247                     ; 79      EXTI_CR2 |= (1 << 2);
2249  002c 721450a1      	bset	_EXTI_CR2,#2
2250                     ; 82  }
2253  0030 81            	ret
2286                     ; 84  uint8_t Button_HourPressed(void)
2286                     ; 85  {
2287                     	switch	.text
2288  0031               _Button_HourPressed:
2290  0031 88            	push	a
2291       00000001      OFST:	set	1
2294                     ; 86      uint8_t result = flag_hour;
2296  0032 c60000        	ld	a,_flag_hour
2297  0035 6b01          	ld	(OFST+0,sp),a
2299                     ; 87      flag_hour = 0;
2301  0037 725f0000      	clr	_flag_hour
2302                     ; 88      return result;
2304  003b 7b01          	ld	a,(OFST+0,sp)
2307  003d 5b01          	addw	sp,#1
2308  003f 81            	ret
2342                     ; 91  uint8_t Button_MinutePressed(void)
2342                     ; 92  {
2343                     	switch	.text
2344  0040               _Button_MinutePressed:
2346  0040 88            	push	a
2347       00000001      OFST:	set	1
2350                     ; 93      uint8_t result = flag_min;
2352  0041 c60001        	ld	a,_flag_min
2353  0044 6b01          	ld	(OFST+0,sp),a
2355                     ; 94      flag_min = 0;
2357  0046 725f0001      	clr	_flag_min
2358                     ; 95      return result;
2360  004a 7b01          	ld	a,(OFST+0,sp)
2363  004c 5b01          	addw	sp,#1
2364  004e 81            	ret
2389                     ; 98 void Button_Minute_EnableInterrupt(void)
2389                     ; 99 {
2390                     	switch	.text
2391  004f               _Button_Minute_EnableInterrupt:
2395                     ; 100     PD_CR2 |= (1 << BTN_MIN_PIN);  // Enable EXTI on PD2
2397  004f 72145013      	bset	_PD_CR2,#2
2398                     ; 101 }
2401  0053 81            	ret
2426                     ; 103 void Button_Minute_DisableInterrupt(void)
2426                     ; 104 {
2427                     	switch	.text
2428  0054               _Button_Minute_DisableInterrupt:
2432                     ; 105     PD_CR2 &= ~(1 << BTN_MIN_PIN); // Disable EXTI on PD2
2434  0054 72155013      	bres	_PD_CR2,#2
2435                     ; 106 }
2438  0058 81            	ret
2463                     ; 108 void Button_Hour_EnableInterrupt(void)
2463                     ; 109 {
2464                     	switch	.text
2465  0059               _Button_Hour_EnableInterrupt:
2469                     ; 110     PC_CR2 |= (1 << BTN_HOUR_PIN);  // Enable EXTI on PC3
2471  0059 7216500e      	bset	_PC_CR2,#3
2472                     ; 111 }
2475  005d 81            	ret
2500                     ; 113 void Button_Hour_DisableInterrupt(void)
2500                     ; 114 {
2501                     	switch	.text
2502  005e               _Button_Hour_DisableInterrupt:
2506                     ; 115     PC_CR2 &= ~(1 << BTN_HOUR_PIN); // Disable EXTI on PC3
2508  005e 7217500e      	bres	_PC_CR2,#3
2509                     ; 116 }
2512  0062 81            	ret
2537                     ; 118 void Button_Hour_WaitRelease(void)
2537                     ; 119 {
2538                     	switch	.text
2539  0063               _Button_Hour_WaitRelease:
2543  0063               L3451:
2544                     ; 120     while (PC_IDR & (1 << BTN_HOUR_PIN));  // Wait for LOW
2546  0063 c6500b        	ld	a,_PC_IDR
2547  0066 a508          	bcp	a,#8
2548  0068 26f9          	jrne	L3451
2549                     ; 121 }
2552  006a 81            	ret
2577                     ; 123 void Button_Minute_WaitRelease(void)
2577                     ; 124 {
2578                     	switch	.text
2579  006b               _Button_Minute_WaitRelease:
2583  006b               L1651:
2584                     ; 125     while (PD_IDR & (1 << BTN_MIN_PIN));  // Wait for LOW
2586  006b c65010        	ld	a,_PD_IDR
2587  006e a504          	bcp	a,#4
2588  0070 26f9          	jrne	L1651
2589                     ; 126 }
2592  0072 81            	ret
2619                     ; 128 uint8_t Button_BothPressed_FirstMinute_SecondHour_WaitRelease(void)
2619                     ; 129 {
2620                     	switch	.text
2621  0073               _Button_BothPressed_FirstMinute_SecondHour_WaitRelease:
2625  0073 200a          	jra	L7751
2626  0075               L5751:
2627                     ; 132         if (PC_IDR & (1 << BTN_HOUR_PIN)) // if HIGH
2629  0075 c6500b        	ld	a,_PC_IDR
2630  0078 a508          	bcp	a,#8
2631  007a 2703          	jreq	L7751
2632                     ; 134             return 1;
2634  007c a601          	ld	a,#1
2637  007e 81            	ret
2638  007f               L7751:
2639                     ; 130     while (PD_IDR & (1 << BTN_MIN_PIN)) // Wait for LOW, while HIGH
2641  007f c65010        	ld	a,_PD_IDR
2642  0082 a504          	bcp	a,#4
2643  0084 26ef          	jrne	L5751
2644                     ; 137     return 0;
2646  0086 4f            	clr	a
2649  0087 81            	ret
2676                     ; 140 uint8_t Button_BothPressed_FirstHour_SecondMinut_WaitRelease(void)
2676                     ; 141 {
2677                     	switch	.text
2678  0088               _Button_BothPressed_FirstHour_SecondMinut_WaitRelease:
2682  0088 200a          	jra	L7161
2683  008a               L5161:
2684                     ; 144         if (PD_IDR & (1 << BTN_MIN_PIN)) // if HIGH
2686  008a c65010        	ld	a,_PD_IDR
2687  008d a504          	bcp	a,#4
2688  008f 2703          	jreq	L7161
2689                     ; 146             return 1;
2691  0091 a601          	ld	a,#1
2694  0093 81            	ret
2695  0094               L7161:
2696                     ; 142     while (PC_IDR & (1 << BTN_HOUR_PIN)) // Wait for LOW, while HIGH
2698  0094 c6500b        	ld	a,_PC_IDR
2699  0097 a508          	bcp	a,#8
2700  0099 26ef          	jrne	L5161
2701                     ; 149     return 0;
2703  009b 4f            	clr	a
2706  009c 81            	ret
2732                     ; 152 uint8_t Button_BothReleased(void)
2732                     ; 153 {
2733                     	switch	.text
2734  009d               _Button_BothReleased:
2738                     ; 154     if (!(PC_IDR & (1 << BTN_HOUR_PIN)) && !(PD_IDR & (1 << BTN_MIN_PIN)))
2740  009d c6500b        	ld	a,_PC_IDR
2741  00a0 a508          	bcp	a,#8
2742  00a2 260a          	jrne	L5361
2744  00a4 c65010        	ld	a,_PD_IDR
2745  00a7 a504          	bcp	a,#4
2746  00a9 2603          	jrne	L5361
2747                     ; 156         return 1;
2749  00ab a601          	ld	a,#1
2752  00ad 81            	ret
2753  00ae               L5361:
2754                     ; 158     return 0;
2756  00ae 4f            	clr	a
2759  00af 81            	ret
2785                     ; 165 void Button_Hour_EnsureInterruptEnabled(void)
2785                     ; 166 {
2786                     	switch	.text
2787  00b0               _Button_Hour_EnsureInterruptEnabled:
2791                     ; 167     if (!(PC_IDR & (1 << BTN_HOUR_PIN)))  // якщо LOW — кнопка не натиснута
2793  00b0 c6500b        	ld	a,_PC_IDR
2794  00b3 a508          	bcp	a,#8
2795  00b5 2602          	jrne	L7461
2796                     ; 169         Button_Hour_EnableInterrupt();
2798  00b7 ada0          	call	_Button_Hour_EnableInterrupt
2800  00b9               L7461:
2801                     ; 171 }
2804  00b9 81            	ret
2830                     ; 173 void Button_Minute_EnsureInterruptEnabled(void)
2830                     ; 174 {
2831                     	switch	.text
2832  00ba               _Button_Minute_EnsureInterruptEnabled:
2836                     ; 175     if (!(PD_IDR & (1 << BTN_MIN_PIN)))  // LOW = не натиснута
2838  00ba c65010        	ld	a,_PD_IDR
2839  00bd a504          	bcp	a,#4
2840  00bf 2602          	jrne	L1661
2841                     ; 177         Button_Minute_EnableInterrupt();
2843  00c1 ad8c          	call	_Button_Minute_EnableInterrupt
2845  00c3               L1661:
2846                     ; 179 }
2849  00c3 81            	ret
2876                     ; 199 @far @interrupt void EXTI_PORTC_IRQHandler(void)
2876                     ; 200  {
2878                     	switch	.text
2879  00c4               f_EXTI_PORTC_IRQHandler:
2881  00c4 8a            	push	cc
2882  00c5 84            	pop	a
2883  00c6 a4bf          	and	a,#191
2884  00c8 88            	push	a
2885  00c9 86            	pop	cc
2886  00ca 3b0002        	push	c_x+2
2887  00cd be00          	ldw	x,c_x
2888  00cf 89            	pushw	x
2889  00d0 3b0002        	push	c_y+2
2890  00d3 be00          	ldw	x,c_y
2891  00d5 89            	pushw	x
2894                     ; 202      if (PC_IDR & (1 << BTN_HOUR_PIN))
2896  00d6 c6500b        	ld	a,_PC_IDR
2897  00d9 a508          	bcp	a,#8
2898  00db 2707          	jreq	L3761
2899                     ; 204          flag_hour = 1;
2901  00dd 35010000      	mov	_flag_hour,#1
2902                     ; 205          Button_Hour_DisableInterrupt();
2904  00e1 cd005e        	call	_Button_Hour_DisableInterrupt
2906  00e4               L3761:
2907                     ; 207  }
2910  00e4 85            	popw	x
2911  00e5 bf00          	ldw	c_y,x
2912  00e7 320002        	pop	c_y+2
2913  00ea 85            	popw	x
2914  00eb bf00          	ldw	c_x,x
2915  00ed 320002        	pop	c_x+2
2916  00f0 80            	iret
2942                     ; 223  @far @interrupt void EXTI_PORTD_IRQHandler(void)
2942                     ; 224  {
2943                     	switch	.text
2944  00f1               f_EXTI_PORTD_IRQHandler:
2946  00f1 8a            	push	cc
2947  00f2 84            	pop	a
2948  00f3 a4bf          	and	a,#191
2949  00f5 88            	push	a
2950  00f6 86            	pop	cc
2951  00f7 3b0002        	push	c_x+2
2952  00fa be00          	ldw	x,c_x
2953  00fc 89            	pushw	x
2954  00fd 3b0002        	push	c_y+2
2955  0100 be00          	ldw	x,c_y
2956  0102 89            	pushw	x
2959                     ; 226      if (PD_IDR & (1 << BTN_MIN_PIN))
2961  0103 c65010        	ld	a,_PD_IDR
2962  0106 a504          	bcp	a,#4
2963  0108 2707          	jreq	L5071
2964                     ; 228          flag_min = 1;
2966  010a 35010001      	mov	_flag_min,#1
2967                     ; 229          Button_Minute_DisableInterrupt();
2969  010e cd0054        	call	_Button_Minute_DisableInterrupt
2971  0111               L5071:
2972                     ; 231  }
2975  0111 85            	popw	x
2976  0112 bf00          	ldw	c_y,x
2977  0114 320002        	pop	c_y+2
2978  0117 85            	popw	x
2979  0118 bf00          	ldw	c_x,x
2980  011a 320002        	pop	c_x+2
2981  011d 80            	iret
3013                     	xdef	f_EXTI_PORTD_IRQHandler
3014                     	xdef	f_EXTI_PORTC_IRQHandler
3015                     	xdef	_flag_min
3016                     	xdef	_flag_hour
3017                     	xdef	_Button_Minute_EnsureInterruptEnabled
3018                     	xdef	_Button_Hour_EnsureInterruptEnabled
3019                     	xdef	_Button_BothReleased
3020                     	xdef	_Button_BothPressed_FirstHour_SecondMinut_WaitRelease
3021                     	xdef	_Button_BothPressed_FirstMinute_SecondHour_WaitRelease
3022                     	xdef	_Button_Minute_WaitRelease
3023                     	xdef	_Button_Hour_WaitRelease
3024                     	xdef	_Button_Hour_DisableInterrupt
3025                     	xdef	_Button_Hour_EnableInterrupt
3026                     	xdef	_Button_Minute_DisableInterrupt
3027                     	xdef	_Button_Minute_EnableInterrupt
3028                     	xdef	_Button_MinutePressed
3029                     	xdef	_Button_HourPressed
3030                     	xdef	_Buttons_Init
3031                     	xref.b	c_x
3032                     	xref.b	c_y
3051                     	end
