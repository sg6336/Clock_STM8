   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2169                     	switch	.data
2170  0000               L5241_hours:
2171  0000 00            	dc.b	0
2172  0001               L7241_min:
2173  0001 00            	dc.b	0
2174  0002               L1341_secs:
2175  0002 00            	dc.b	0
2176                     .const:	section	.text
2177  0000               L3341_displayWaitIndicator:
2178  0000 20            	dc.b	32
2179  0001 20            	dc.b	32
2180  0002 3a            	dc.b	58
2181  0003 20            	dc.b	32
2182  0004 20            	dc.b	32
2183  0005 00            	dc.b	0
2184  0006 0000          	ds.b	2
2185                     	switch	.data
2186  0003               L5341_is_setting_time:
2187  0003 00            	dc.b	0
2229                     ; 97 void main(void)
2229                     ; 98 {
2231                     	switch	.text
2232  0000               _main:
2236                     ; 99     init_hardware();
2238  0000 ad6f          	call	L7341_init_hardware
2240                     ; 101     tm1637SetBrightness(1);
2242  0002 a601          	ld	a,#1
2243  0004 cd0000        	call	_tm1637SetBrightness
2245                     ; 103     uart_write("Test\r\n");
2247  0007 ae00ac        	ldw	x,#L3151
2248  000a cd0000        	call	_uart_write
2250                     ; 104     delay_ms(100);
2252  000d ae0064        	ldw	x,#100
2253  0010 ad21          	call	L3441_delay_ms
2255                     ; 106     _asm("rim"); // ← Important! Enable global interrupts
2258  0012 9a            rim
2260  0013               L5151:
2261                     ; 113         handle_hour_button();
2263  0013 cd016f        	call	L7441_handle_hour_button
2265                     ; 115         handle_minute_button();
2267  0016 cd01cd        	call	L1541_handle_minute_button
2269                     ; 117         if (Button_BothReleased())
2271  0019 cd0000        	call	_Button_BothReleased
2273  001c 4d            	tnz	a
2274  001d 270c          	jreq	L1251
2275                     ; 119             if (!is_setting_time)
2277  001f 725d0003      	tnz	L5341_is_setting_time
2278  0023 2603          	jrne	L3251
2279                     ; 121                 sync_time_from_ds3231();
2281  0025 cd027f        	call	L5641_sync_time_from_ds3231
2283  0028               L3251:
2284                     ; 124             update_display_time();
2286  0028 cd00d7        	call	L5441_update_display_time
2288  002b               L1251:
2289                     ; 128         Button_Hour_EnsureInterruptEnabled();
2291  002b cd0000        	call	_Button_Hour_EnsureInterruptEnabled
2293                     ; 129         Button_Minute_EnsureInterruptEnabled();
2295  002e cd0000        	call	_Button_Minute_EnsureInterruptEnabled
2298  0031 20e0          	jra	L5151
2341                     ; 153 static void delay_ms(uint16_t ms)
2341                     ; 154 {
2342                     	switch	.text
2343  0033               L3441_delay_ms:
2345  0033 89            	pushw	x
2346  0034 89            	pushw	x
2347       00000002      OFST:	set	2
2350  0035 2014          	jra	L7451
2351  0037               L5451:
2352                     ; 159         for (i = 0; i < 1600; i++)
2354  0037 5f            	clrw	x
2355  0038 1f01          	ldw	(OFST-1,sp),x
2358  003a 2008          	jra	L7551
2359  003c               L3551:
2360                     ; 161             __asm("nop");
2363  003c 9d            nop
2365                     ; 159         for (i = 0; i < 1600; i++)
2367  003d 1e01          	ldw	x,(OFST-1,sp)
2368  003f 1c0001        	addw	x,#1
2369  0042 1f01          	ldw	(OFST-1,sp),x
2371  0044               L7551:
2374  0044 1e01          	ldw	x,(OFST-1,sp)
2375  0046 a30640        	cpw	x,#1600
2376  0049 25f1          	jrult	L3551
2377  004b               L7451:
2378                     ; 157     while (ms--)
2380  004b 1e03          	ldw	x,(OFST+1,sp)
2381  004d 1d0001        	subw	x,#1
2382  0050 1f03          	ldw	(OFST+1,sp),x
2383  0052 1c0001        	addw	x,#1
2384  0055 a30000        	cpw	x,#0
2385  0058 26dd          	jrne	L5451
2386                     ; 164 }
2389  005a 5b04          	addw	sp,#4
2390  005c 81            	ret
2417                     ; 169 static void CLK_init()
2417                     ; 170 {
2418                     	switch	.text
2419  005d               L1441_CLK_init:
2423                     ; 171     CLK_SWR = 0xE1;      // select HSI as the clock source
2425  005d 35e150c4      	mov	_CLK_SWR,#225
2426                     ; 172     CLK_SWCR = (1 << 1); // enable switching (SWEN = 1)
2428  0061 350250c5      	mov	_CLK_SWCR,#2
2430  0065               L7751:
2431                     ; 173     while (CLK_CMSR != 0xE1)
2433  0065 c650c3        	ld	a,_CLK_CMSR
2434  0068 a1e1          	cp	a,#225
2435  006a 26f9          	jrne	L7751
2436                     ; 175     CLK_CKDIVR = 0x00; // set HSI divider = 1, CPU divider = 1
2438  006c 725f50c6      	clr	_CLK_CKDIVR
2439                     ; 177 }
2442  0070 81            	ret
2470                     ; 182 static void init_hardware()
2470                     ; 183 {
2471                     	switch	.text
2472  0071               L7341_init_hardware:
2476                     ; 184     CLK_init();
2478  0071 adea          	call	L1441_CLK_init
2480                     ; 187     tm1637Init(); // PC5 (CLK), PC6 (DIO)
2482  0073 cd0000        	call	_tm1637Init
2484                     ; 190     uart_init();    // TX only, PD5, 9600 baud
2486  0076 cd0000        	call	_uart_init
2488                     ; 191     Buttons_Init(); // PC3 and PD2
2490  0079 cd0000        	call	_Buttons_Init
2492                     ; 194     I2CInit(); // PB4 (SCL), PB5 (SDA) for DS3231
2494  007c cd0000        	call	_I2CInit
2496                     ; 195 }
2499  007f 81            	ret
2502                     	switch	.data
2503  0004               L3161_hex_digits:
2504  0004 009b          	dc.w	L5161
2555                     ; 210 static void uart_write_hex(uint8_t val)
2555                     ; 211 {
2556                     	switch	.text
2557  0080               L3541_uart_write_hex:
2559  0080 88            	push	a
2560  0081 5203          	subw	sp,#3
2561       00000003      OFST:	set	3
2564                     ; 214     hex[0] = hex_digits[(val >> 4) & 0x0F];
2566  0083 4e            	swap	a
2567  0084 a40f          	and	a,#15
2568  0086 5f            	clrw	x
2569  0087 97            	ld	xl,a
2570  0088 72d60004      	ld	a,([L3161_hex_digits.w],x)
2571  008c 6b01          	ld	(OFST-2,sp),a
2573                     ; 215     hex[1] = hex_digits[val & 0x0F];
2575  008e 7b04          	ld	a,(OFST+1,sp)
2576  0090 a40f          	and	a,#15
2577  0092 5f            	clrw	x
2578  0093 97            	ld	xl,a
2579  0094 72d60004      	ld	a,([L3161_hex_digits.w],x)
2580  0098 6b02          	ld	(OFST-1,sp),a
2582                     ; 216     hex[2] = '\0';
2584  009a 0f03          	clr	(OFST+0,sp)
2586                     ; 217     uart_write(hex);
2588  009c 96            	ldw	x,sp
2589  009d 1c0001        	addw	x,#OFST-2
2590  00a0 cd0000        	call	_uart_write
2592                     ; 218 }
2595  00a3 5b04          	addw	sp,#4
2596  00a5 81            	ret
2628                     ; 229 static uint8_t bcd_to_dec(uint8_t bcd)
2628                     ; 230 {
2629                     	switch	.text
2630  00a6               L5541_bcd_to_dec:
2632  00a6 88            	push	a
2633  00a7 88            	push	a
2634       00000001      OFST:	set	1
2637                     ; 231     return ((bcd >> 4) * 10) + (bcd & 0x0F);
2639  00a8 a40f          	and	a,#15
2640  00aa 6b01          	ld	(OFST+0,sp),a
2642  00ac 7b02          	ld	a,(OFST+1,sp)
2643  00ae 4e            	swap	a
2644  00af a40f          	and	a,#15
2645  00b1 97            	ld	xl,a
2646  00b2 a60a          	ld	a,#10
2647  00b4 42            	mul	x,a
2648  00b5 9f            	ld	a,xl
2649  00b6 1b01          	add	a,(OFST+0,sp)
2652  00b8 85            	popw	x
2653  00b9 81            	ret
2685                     ; 242 static uint8_t dec_to_bcd(uint8_t dec)
2685                     ; 243 {
2686                     	switch	.text
2687  00ba               L7541_dec_to_bcd:
2689  00ba 88            	push	a
2690  00bb 88            	push	a
2691       00000001      OFST:	set	1
2694                     ; 244     return ((dec / 10) << 4) | (dec % 10);
2696  00bc 5f            	clrw	x
2697  00bd 97            	ld	xl,a
2698  00be a60a          	ld	a,#10
2699  00c0 62            	div	x,a
2700  00c1 5f            	clrw	x
2701  00c2 97            	ld	xl,a
2702  00c3 9f            	ld	a,xl
2703  00c4 6b01          	ld	(OFST+0,sp),a
2705  00c6 7b02          	ld	a,(OFST+1,sp)
2706  00c8 5f            	clrw	x
2707  00c9 97            	ld	xl,a
2708  00ca a60a          	ld	a,#10
2709  00cc 62            	div	x,a
2710  00cd 9f            	ld	a,xl
2711  00ce 97            	ld	xl,a
2712  00cf a610          	ld	a,#16
2713  00d1 42            	mul	x,a
2714  00d2 9f            	ld	a,xl
2715  00d3 1a01          	or	a,(OFST+0,sp)
2718  00d5 85            	popw	x
2719  00d6 81            	ret
2722                     	switch	.bss
2723  0000               L3761_displayBuffer:
2724  0000 000000000000  	ds.b	8
2762                     ; 252 static void update_display_time()
2762                     ; 253 {
2763                     	switch	.text
2764  00d7               L5441_update_display_time:
2768                     ; 256     if (secs & 1)
2770  00d7 c60002        	ld	a,L1341_secs
2771  00da a501          	bcp	a,#1
2772  00dc 2746          	jreq	L3171
2773                     ; 258         displayBuffer[0] = '0' + hours / 10;
2775  00de c60000        	ld	a,L5241_hours
2776  00e1 5f            	clrw	x
2777  00e2 97            	ld	xl,a
2778  00e3 a60a          	ld	a,#10
2779  00e5 62            	div	x,a
2780  00e6 9f            	ld	a,xl
2781  00e7 ab30          	add	a,#48
2782  00e9 c70000        	ld	L3761_displayBuffer,a
2783                     ; 259         displayBuffer[1] = '0' + hours % 10;
2785  00ec c60000        	ld	a,L5241_hours
2786  00ef 5f            	clrw	x
2787  00f0 97            	ld	xl,a
2788  00f1 a60a          	ld	a,#10
2789  00f3 62            	div	x,a
2790  00f4 5f            	clrw	x
2791  00f5 97            	ld	xl,a
2792  00f6 9f            	ld	a,xl
2793  00f7 ab30          	add	a,#48
2794  00f9 c70001        	ld	L3761_displayBuffer+1,a
2795                     ; 260         displayBuffer[2] = ':';
2797  00fc 353a0002      	mov	L3761_displayBuffer+2,#58
2798                     ; 261         displayBuffer[3] = '0' + min / 10;
2800  0100 c60001        	ld	a,L7241_min
2801  0103 5f            	clrw	x
2802  0104 97            	ld	xl,a
2803  0105 a60a          	ld	a,#10
2804  0107 62            	div	x,a
2805  0108 9f            	ld	a,xl
2806  0109 ab30          	add	a,#48
2807  010b c70003        	ld	L3761_displayBuffer+3,a
2808                     ; 262         displayBuffer[4] = '0' + min % 10;
2810  010e c60001        	ld	a,L7241_min
2811  0111 5f            	clrw	x
2812  0112 97            	ld	xl,a
2813  0113 a60a          	ld	a,#10
2814  0115 62            	div	x,a
2815  0116 5f            	clrw	x
2816  0117 97            	ld	xl,a
2817  0118 9f            	ld	a,xl
2818  0119 ab30          	add	a,#48
2819  011b c70004        	ld	L3761_displayBuffer+4,a
2820                     ; 263         displayBuffer[5] = '\0';
2822  011e 725f0005      	clr	L3761_displayBuffer+5
2824  0122 2044          	jra	L5171
2825  0124               L3171:
2826                     ; 267         displayBuffer[0] = '0' + hours / 10;
2828  0124 c60000        	ld	a,L5241_hours
2829  0127 5f            	clrw	x
2830  0128 97            	ld	xl,a
2831  0129 a60a          	ld	a,#10
2832  012b 62            	div	x,a
2833  012c 9f            	ld	a,xl
2834  012d ab30          	add	a,#48
2835  012f c70000        	ld	L3761_displayBuffer,a
2836                     ; 268         displayBuffer[1] = '0' + hours % 10;
2838  0132 c60000        	ld	a,L5241_hours
2839  0135 5f            	clrw	x
2840  0136 97            	ld	xl,a
2841  0137 a60a          	ld	a,#10
2842  0139 62            	div	x,a
2843  013a 5f            	clrw	x
2844  013b 97            	ld	xl,a
2845  013c 9f            	ld	a,xl
2846  013d ab30          	add	a,#48
2847  013f c70001        	ld	L3761_displayBuffer+1,a
2848                     ; 269         displayBuffer[2] = ' ';
2850  0142 35200002      	mov	L3761_displayBuffer+2,#32
2851                     ; 270         displayBuffer[3] = '0' + min / 10;
2853  0146 c60001        	ld	a,L7241_min
2854  0149 5f            	clrw	x
2855  014a 97            	ld	xl,a
2856  014b a60a          	ld	a,#10
2857  014d 62            	div	x,a
2858  014e 9f            	ld	a,xl
2859  014f ab30          	add	a,#48
2860  0151 c70003        	ld	L3761_displayBuffer+3,a
2861                     ; 271         displayBuffer[4] = '0' + min % 10;
2863  0154 c60001        	ld	a,L7241_min
2864  0157 5f            	clrw	x
2865  0158 97            	ld	xl,a
2866  0159 a60a          	ld	a,#10
2867  015b 62            	div	x,a
2868  015c 5f            	clrw	x
2869  015d 97            	ld	xl,a
2870  015e 9f            	ld	a,xl
2871  015f ab30          	add	a,#48
2872  0161 c70004        	ld	L3761_displayBuffer+4,a
2873                     ; 272         displayBuffer[5] = '\0';
2875  0164 725f0005      	clr	L3761_displayBuffer+5
2876  0168               L5171:
2877                     ; 274     tm1637ShowDigits(displayBuffer);
2879  0168 ae0000        	ldw	x,#L3761_displayBuffer
2880  016b cd0000        	call	_tm1637ShowDigits
2882                     ; 275 }
2885  016e 81            	ret
2922                     ; 283 static void handle_hour_button()
2922                     ; 284 {
2923                     	switch	.text
2924  016f               L7441_handle_hour_button:
2928                     ; 285     if (Button_HourPressed())
2930  016f cd0000        	call	_Button_HourPressed
2932  0172 4d            	tnz	a
2933  0173 2757          	jreq	L7271
2934                     ; 287         delay_ms(100); // debounce
2936  0175 ae0064        	ldw	x,#100
2937  0178 cd0033        	call	L3441_delay_ms
2939                     ; 289         if (Button_BothPressed_FirstHour_SecondMinut_WaitRelease())
2941  017b cd0000        	call	_Button_BothPressed_FirstHour_SecondMinut_WaitRelease
2943  017e 4d            	tnz	a
2944  017f 2720          	jreq	L1371
2945                     ; 291             uart_write("Both buttons are pressed after Hour button\r\n");
2947  0181 ae006e        	ldw	x,#L3371
2948  0184 cd0000        	call	_uart_write
2950                     ; 292             toggle_time_setting_mode();
2952  0187 cd022a        	call	L1641_toggle_time_setting_mode
2954                     ; 293             tm1637ShowDigits(displayWaitIndicator);
2956  018a ae0000        	ldw	x,#L3341_displayWaitIndicator
2957  018d cd0000        	call	_tm1637ShowDigits
2959                     ; 296             Button_Minute_WaitRelease();
2961  0190 cd0000        	call	_Button_Minute_WaitRelease
2963                     ; 297             Button_MinutePressed(); // clear flag if still set
2965  0193 cd0000        	call	_Button_MinutePressed
2967                     ; 298             delay_ms(100);          // debounce
2969  0196 ae0064        	ldw	x,#100
2970  0199 cd0033        	call	L3441_delay_ms
2972                     ; 299             Button_Minute_EnableInterrupt();
2974  019c cd0000        	call	_Button_Minute_EnableInterrupt
2977  019f 201f          	jra	L5371
2978  01a1               L1371:
2979                     ; 303             uart_write("Hour button pressed\r\n");
2981  01a1 ae0058        	ldw	x,#L7371
2982  01a4 cd0000        	call	_uart_write
2984                     ; 305             if (is_setting_time)
2986  01a7 725d0003      	tnz	L5341_is_setting_time
2987  01ab 2713          	jreq	L5371
2988                     ; 307                 hours++;
2990  01ad 725c0000      	inc	L5241_hours
2991                     ; 308                 hours %= HOURS_IN_DAY;
2993  01b1 c60000        	ld	a,L5241_hours
2994  01b4 5f            	clrw	x
2995  01b5 97            	ld	xl,a
2996  01b6 a618          	ld	a,#24
2997  01b8 62            	div	x,a
2998  01b9 5f            	clrw	x
2999  01ba 97            	ld	xl,a
3000  01bb 01            	rrwa	x,a
3001  01bc c70000        	ld	L5241_hours,a
3002  01bf 02            	rlwa	x,a
3003  01c0               L5371:
3004                     ; 312         Button_Hour_WaitRelease();     // wait for button release
3006  01c0 cd0000        	call	_Button_Hour_WaitRelease
3008                     ; 313         delay_ms(100);                 // debounce
3010  01c3 ae0064        	ldw	x,#100
3011  01c6 cd0033        	call	L3441_delay_ms
3013                     ; 314         Button_Hour_EnableInterrupt(); // re-enable interrupt
3015  01c9 cd0000        	call	_Button_Hour_EnableInterrupt
3017  01cc               L7271:
3018                     ; 320 }
3021  01cc 81            	ret
3059                     ; 328 static void handle_minute_button()
3059                     ; 329 {
3060                     	switch	.text
3061  01cd               L1541_handle_minute_button:
3065                     ; 330     if (Button_MinutePressed())
3067  01cd cd0000        	call	_Button_MinutePressed
3069  01d0 4d            	tnz	a
3070  01d1 2756          	jreq	L3571
3071                     ; 332         delay_ms(100); // debounce
3073  01d3 ae0064        	ldw	x,#100
3074  01d6 cd0033        	call	L3441_delay_ms
3076                     ; 334         if (Button_BothPressed_FirstMinute_SecondHour_WaitRelease())
3078  01d9 cd0000        	call	_Button_BothPressed_FirstMinute_SecondHour_WaitRelease
3080  01dc 4d            	tnz	a
3081  01dd 271f          	jreq	L5571
3082                     ; 336             uart_write("Both buttons are pressed after Min button\r\n");
3084  01df ae002c        	ldw	x,#L7571
3085  01e2 cd0000        	call	_uart_write
3087                     ; 337             toggle_time_setting_mode();
3089  01e5 ad43          	call	L1641_toggle_time_setting_mode
3091                     ; 338             tm1637ShowDigits(displayWaitIndicator);
3093  01e7 ae0000        	ldw	x,#L3341_displayWaitIndicator
3094  01ea cd0000        	call	_tm1637ShowDigits
3096                     ; 341             Button_Hour_WaitRelease();
3098  01ed cd0000        	call	_Button_Hour_WaitRelease
3100                     ; 342             Button_HourPressed(); // clear flag if still set
3102  01f0 cd0000        	call	_Button_HourPressed
3104                     ; 343             delay_ms(100);        // debounce
3106  01f3 ae0064        	ldw	x,#100
3107  01f6 cd0033        	call	L3441_delay_ms
3109                     ; 344             Button_Hour_EnableInterrupt();
3111  01f9 cd0000        	call	_Button_Hour_EnableInterrupt
3114  01fc 201f          	jra	L1671
3115  01fe               L5571:
3116                     ; 348             uart_write("Minute button pressed\r\n");
3118  01fe ae0014        	ldw	x,#L3671
3119  0201 cd0000        	call	_uart_write
3121                     ; 350             if (is_setting_time)
3123  0204 725d0003      	tnz	L5341_is_setting_time
3124  0208 2713          	jreq	L1671
3125                     ; 352                 min++;
3127  020a 725c0001      	inc	L7241_min
3128                     ; 353                 min %= MINUTES_IN_HOUR;
3130  020e c60001        	ld	a,L7241_min
3131  0211 5f            	clrw	x
3132  0212 97            	ld	xl,a
3133  0213 a63c          	ld	a,#60
3134  0215 62            	div	x,a
3135  0216 5f            	clrw	x
3136  0217 97            	ld	xl,a
3137  0218 01            	rrwa	x,a
3138  0219 c70001        	ld	L7241_min,a
3139  021c 02            	rlwa	x,a
3140  021d               L1671:
3141                     ; 357         Button_Minute_WaitRelease();     // wait for button release
3143  021d cd0000        	call	_Button_Minute_WaitRelease
3145                     ; 358         delay_ms(100);                   // debounce
3147  0220 ae0064        	ldw	x,#100
3148  0223 cd0033        	call	L3441_delay_ms
3150                     ; 359         Button_Minute_EnableInterrupt(); // re-enable interrupt
3152  0226 cd0000        	call	_Button_Minute_EnableInterrupt
3154  0229               L3571:
3155                     ; 365 }
3158  0229 81            	ret
3186                     ; 378 static void toggle_time_setting_mode(void)
3186                     ; 379 {
3187                     	switch	.text
3188  022a               L1641_toggle_time_setting_mode:
3192                     ; 380     is_setting_time = !is_setting_time;
3194  022a 725d0003      	tnz	L5341_is_setting_time
3195  022e 2604          	jrne	L23
3196  0230 a601          	ld	a,#1
3197  0232 2001          	jra	L43
3198  0234               L23:
3199  0234 4f            	clr	a
3200  0235               L43:
3201  0235 c70003        	ld	L5341_is_setting_time,a
3202                     ; 381     if (is_setting_time)
3204  0238 725d0003      	tnz	L5341_is_setting_time
3205  023c 2709          	jreq	L7771
3206                     ; 383         secs = 0;
3208  023e 725f0002      	clr	L1341_secs
3209                     ; 384         tm1637SetBrightness(8);
3211  0242 a608          	ld	a,#8
3212  0244 cd0000        	call	_tm1637SetBrightness
3214  0247               L7771:
3215                     ; 386     if (!is_setting_time)
3217  0247 725d0003      	tnz	L5341_is_setting_time
3218  024b 2607          	jrne	L1002
3219                     ; 388         set_time();
3221  024d ad06          	call	L3641_set_time
3223                     ; 389         tm1637SetBrightness(1);
3225  024f a601          	ld	a,#1
3226  0251 cd0000        	call	_tm1637SetBrightness
3228  0254               L1002:
3229                     ; 391 }
3232  0254 81            	ret
3283                     ; 398 static void set_time()
3283                     ; 399 {
3284                     	switch	.text
3285  0255               L3641_set_time:
3287  0255 5203          	subw	sp,#3
3288       00000003      OFST:	set	3
3291                     ; 400     uint8_t hours_bcd = dec_to_bcd(hours);
3293  0257 c60000        	ld	a,L5241_hours
3294  025a cd00ba        	call	L7541_dec_to_bcd
3296  025d 6b01          	ld	(OFST-2,sp),a
3298                     ; 401     uint8_t minutes_bcd = dec_to_bcd(min);
3300  025f c60001        	ld	a,L7241_min
3301  0262 cd00ba        	call	L7541_dec_to_bcd
3303  0265 6b02          	ld	(OFST-1,sp),a
3305                     ; 402     uint8_t seconds_bcd = dec_to_bcd(secs);
3307  0267 c60002        	ld	a,L1341_secs
3308  026a cd00ba        	call	L7541_dec_to_bcd
3310  026d 6b03          	ld	(OFST+0,sp),a
3312                     ; 403     DS3231_SetTimeManual(hours_bcd, minutes_bcd, seconds_bcd);
3314  026f 7b03          	ld	a,(OFST+0,sp)
3315  0271 88            	push	a
3316  0272 7b03          	ld	a,(OFST+0,sp)
3317  0274 97            	ld	xl,a
3318  0275 7b02          	ld	a,(OFST-1,sp)
3319  0277 95            	ld	xh,a
3320  0278 cd0000        	call	_DS3231_SetTimeManual
3322  027b 84            	pop	a
3323                     ; 404 }
3326  027c 5b03          	addw	sp,#3
3327  027e 81            	ret
3359                     ; 409 static void sync_time_from_ds3231(void)
3359                     ; 410 {
3360                     	switch	.text
3361  027f               L5641_sync_time_from_ds3231:
3365                     ; 411     ds3231_read_raw_time();
3367  027f ad20          	call	L7641_ds3231_read_raw_time
3369                     ; 412     rtc_reorder_bytes();
3371  0281 ad28          	call	L1741_rtc_reorder_bytes
3373                     ; 413     log_time_over_uart();
3375  0283 ad36          	call	L3741_log_time_over_uart
3377                     ; 415     hours = bcd_to_dec(rtc_buf[0]);
3379  0285 c60009        	ld	a,L3241_rtc_buf
3380  0288 cd00a6        	call	L5541_bcd_to_dec
3382  028b c70000        	ld	L5241_hours,a
3383                     ; 416     min = bcd_to_dec(rtc_buf[1]);
3385  028e c6000a        	ld	a,L3241_rtc_buf+1
3386  0291 cd00a6        	call	L5541_bcd_to_dec
3388  0294 c70001        	ld	L7241_min,a
3389                     ; 417     secs = bcd_to_dec(rtc_buf[2]);
3391  0297 c6000b        	ld	a,L3241_rtc_buf+2
3392  029a cd00a6        	call	L5541_bcd_to_dec
3394  029d c70002        	ld	L1341_secs,a
3395                     ; 418 }
3398  02a0 81            	ret
3424                     ; 423 static void ds3231_read_raw_time(void)
3424                     ; 424 {
3425                     	switch	.text
3426  02a1               L7641_ds3231_read_raw_time:
3430                     ; 425     DS3231_GetTime(rtc_buf, RTC_BUF_SIZE);
3432  02a1 4b03          	push	#3
3433  02a3 ae0009        	ldw	x,#L3241_rtc_buf
3434  02a6 cd0000        	call	_DS3231_GetTime
3436  02a9 84            	pop	a
3437                     ; 426 }
3440  02aa 81            	ret
3443                     	switch	.bss
3444  0008               L3402_tmp:
3445  0008 00            	ds.b	1
3476                     ; 431 static void rtc_reorder_bytes(void)
3476                     ; 432 {
3477                     	switch	.text
3478  02ab               L1741_rtc_reorder_bytes:
3482                     ; 435     tmp = rtc_buf[0];
3484  02ab 5500090008    	mov	L3402_tmp,L3241_rtc_buf
3485                     ; 436     rtc_buf[0] = rtc_buf[2];
3487  02b0 55000b0009    	mov	L3241_rtc_buf,L3241_rtc_buf+2
3488                     ; 437     rtc_buf[2] = tmp;
3490  02b5 550008000b    	mov	L3241_rtc_buf+2,L3402_tmp
3491                     ; 438 }
3494  02ba 81            	ret
3520                     ; 443 static void log_time_over_uart(void)
3520                     ; 444 {
3521                     	switch	.text
3522  02bb               L3741_log_time_over_uart:
3526                     ; 445     uart_write("Time: ");
3528  02bb ae000d        	ldw	x,#L1702
3529  02be cd0000        	call	_uart_write
3531                     ; 446     uart_write_hex(rtc_buf[0]);
3533  02c1 c60009        	ld	a,L3241_rtc_buf
3534  02c4 cd0080        	call	L3541_uart_write_hex
3536                     ; 447     uart_write(":");
3538  02c7 ae000b        	ldw	x,#L3702
3539  02ca cd0000        	call	_uart_write
3541                     ; 448     uart_write_hex(rtc_buf[1]);
3543  02cd c6000a        	ld	a,L3241_rtc_buf+1
3544  02d0 cd0080        	call	L3541_uart_write_hex
3546                     ; 449     uart_write(":");
3548  02d3 ae000b        	ldw	x,#L3702
3549  02d6 cd0000        	call	_uart_write
3551                     ; 450     uart_write_hex(rtc_buf[2]);
3553  02d9 c6000b        	ld	a,L3241_rtc_buf+2
3554  02dc cd0080        	call	L3541_uart_write_hex
3556                     ; 451     uart_write("\r\n");
3558  02df ae0008        	ldw	x,#L5702
3559  02e2 cd0000        	call	_uart_write
3561                     ; 452 }
3564  02e5 81            	ret
3628                     	xdef	_main
3629                     	switch	.bss
3630  0009               L3241_rtc_buf:
3631  0009 000000        	ds.b	3
3632                     	xref	_Button_Minute_EnsureInterruptEnabled
3633                     	xref	_Button_Hour_EnsureInterruptEnabled
3634                     	xref	_Button_BothReleased
3635                     	xref	_Button_BothPressed_FirstHour_SecondMinut_WaitRelease
3636                     	xref	_Button_BothPressed_FirstMinute_SecondHour_WaitRelease
3637                     	xref	_Button_Minute_WaitRelease
3638                     	xref	_Button_Hour_WaitRelease
3639                     	xref	_Button_Hour_EnableInterrupt
3640                     	xref	_Button_Minute_EnableInterrupt
3641                     	xref	_Button_MinutePressed
3642                     	xref	_Button_HourPressed
3643                     	xref	_Buttons_Init
3644                     	xref	_uart_write
3645                     	xref	_uart_init
3646                     	xref	_tm1637ShowDigits
3647                     	xref	_tm1637SetBrightness
3648                     	xref	_tm1637Init
3649                     	xref	_I2CInit
3650                     	xref	_DS3231_SetTimeManual
3651                     	xref	_DS3231_GetTime
3652                     	switch	.const
3653  0008               L5702:
3654  0008 0d0a00        	dc.b	13,10,0
3655  000b               L3702:
3656  000b 3a00          	dc.b	":",0
3657  000d               L1702:
3658  000d 54696d653a20  	dc.b	"Time: ",0
3659  0014               L3671:
3660  0014 4d696e757465  	dc.b	"Minute button pres"
3661  0026 7365640d      	dc.b	"sed",13
3662  002a 0a00          	dc.b	10,0
3663  002c               L7571:
3664  002c 426f74682062  	dc.b	"Both buttons are p"
3665  003e 726573736564  	dc.b	"ressed after Min b"
3666  0050 7574746f6e0d  	dc.b	"utton",13
3667  0056 0a00          	dc.b	10,0
3668  0058               L7371:
3669  0058 486f75722062  	dc.b	"Hour button presse"
3670  006a 640d          	dc.b	"d",13
3671  006c 0a00          	dc.b	10,0
3672  006e               L3371:
3673  006e 426f74682062  	dc.b	"Both buttons are p"
3674  0080 726573736564  	dc.b	"ressed after Hour "
3675  0092 627574746f6e  	dc.b	"button",13
3676  0099 0a00          	dc.b	10,0
3677  009b               L5161:
3678  009b 303132333435  	dc.b	"0123456789ABCDEF",0
3679  00ac               L3151:
3680  00ac 546573740d    	dc.b	"Test",13
3681  00b1 0a00          	dc.b	10,0
3701                     	end
