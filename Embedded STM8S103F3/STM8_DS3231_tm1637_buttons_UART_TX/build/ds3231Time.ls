   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2216                     ; 100 void DS3231_GetTime(uint8_t *buf, uint8_t size)
2216                     ; 101 {
2218                     	switch	.text
2219  0000               _DS3231_GetTime:
2221  0000 89            	pushw	x
2222       00000000      OFST:	set	0
2225                     ; 102     I2CRead(DS3231_ADDR, DS3231_SECONDS, buf, size);
2227  0001 7b05          	ld	a,(OFST+5,sp)
2228  0003 88            	push	a
2229  0004 89            	pushw	x
2230  0005 aed000        	ldw	x,#53248
2231  0008 cd010f        	call	L7241_I2CRead
2233  000b 5b03          	addw	sp,#3
2234                     ; 103 }
2237  000d 85            	popw	x
2238  000e 81            	ret
2280                     ; 105 void DS3231_SetTime(uint8_t *buf, uint8_t size)
2280                     ; 106 {
2281                     	switch	.text
2282  000f               _DS3231_SetTime:
2284  000f 89            	pushw	x
2285       00000000      OFST:	set	0
2288                     ; 114     (void *) buf;
2290                     ; 115     (void *) size;
2292                     ; 117 }
2295  0010 85            	popw	x
2296  0011 81            	ret
2299                     .const:	section	.text
2300  0000               L3151_buf:
2301  0000 000000        	ds.b	3
2357                     ; 119 void DS3231_SetTimeManual(uint8_t hours_bcd, uint8_t minutes_bcd, uint8_t seconds_bcd)
2357                     ; 120 {
2358                     	switch	.text
2359  0012               _DS3231_SetTimeManual:
2361  0012 89            	pushw	x
2362  0013 5203          	subw	sp,#3
2363       00000003      OFST:	set	3
2366                     ; 121     uint8_t buf[3] = { seconds_bcd, minutes_bcd, hours_bcd };
2368  0015 96            	ldw	x,sp
2369  0016 1c0001        	addw	x,#OFST-2
2370  0019 90ae0000      	ldw	y,#L3151_buf
2371  001d a603          	ld	a,#3
2372  001f cd0000        	call	c_xymov
2374  0022 7b08          	ld	a,(OFST+5,sp)
2375  0024 6b01          	ld	(OFST-2,sp),a
2377  0026 7b05          	ld	a,(OFST+2,sp)
2378  0028 6b02          	ld	(OFST-1,sp),a
2380  002a 7b04          	ld	a,(OFST+1,sp)
2381  002c 6b03          	ld	(OFST+0,sp),a
2383                     ; 122     I2CWrite(DS3231_ADDR, DS3231_SECONDS, buf, 3);
2385  002e 4b03          	push	#3
2386  0030 96            	ldw	x,sp
2387  0031 1c0002        	addw	x,#OFST-1
2388  0034 89            	pushw	x
2389  0035 aed000        	ldw	x,#53248
2390  0038 ad66          	call	L5241_I2CWrite
2392  003a 5b03          	addw	sp,#3
2393                     ; 123 }
2396  003c 5b05          	addw	sp,#5
2397  003e 81            	ret
2426                     ; 125 void I2CInit()
2426                     ; 126 {
2427                     	switch	.text
2428  003f               _I2CInit:
2432                     ; 127     gpio_init();                 // Configure GPIO pins for I2C (PB4, PB5)
2434  003f ad3e          	call	L3241_gpio_init
2436                     ; 129     I2C_CR1 = 0x00;              // Disable I2C peripheral before configuration
2438  0041 725f5210      	clr	_I2C_CR1
2439                     ; 130     I2C_FREQR = 16;              // Set peripheral clock frequency in MHz (16 MHz)
2441  0045 35105212      	mov	_I2C_FREQR,#16
2442                     ; 131     I2C_CCRL = 80;               // Configure clock control: 100 kHz = 16 MHz / (2 * 100 kHz)
2444  0049 3550521b      	mov	_I2C_CCRL,#80
2445                     ; 132     I2C_TRISER = 17;             // Configure TRISE: freq + 1 = 17 for standard mode
2447  004d 3511521d      	mov	_I2C_TRISER,#17
2448                     ; 133     I2C_CR2 = I2C_CR2_ACK;       // Enable ACK generation
2450  0051 35045211      	mov	_I2C_CR2,#4
2451                     ; 134     I2C_CR1 |= I2C_CR1_PE;       // Enable the I2C peripheral
2453  0055 72105210      	bset	_I2C_CR1,#0
2454                     ; 135 }
2457  0059 81            	ret
2489                     ; 137 void I2CDeinit()
2489                     ; 138 {
2490                     	switch	.text
2491  005a               _I2CDeinit:
2495                     ; 139     I2C_CR1 = I2C_CR1_RESET_VALUE;         // Reset control register 1
2497  005a 725f5210      	clr	_I2C_CR1
2498                     ; 140     I2C_CR2 = I2C_CR2_RESET_VALUE;         // Reset control register 2
2500  005e 725f5211      	clr	_I2C_CR2
2501                     ; 141     I2C_FREQR = I2C_FREQR_RESET_VALUE;     // Reset frequency register
2503  0062 725f5212      	clr	_I2C_FREQR
2504                     ; 142     I2C_OARL = I2C_OARL_RESET_VALUE;       // Reset own address register low
2506  0066 725f5213      	clr	_I2C_OARL
2507                     ; 143     I2C_OARH = I2C_OARH_RESET_VALUE;       // Reset own address register high
2509  006a 725f5214      	clr	_I2C_OARH
2510                     ; 144     I2C_ITR = I2C_ITR_RESET_VALUE;         // Reset interrupt register
2512  006e 725f521a      	clr	_I2C_ITR
2513                     ; 145     I2C_CCRL = I2C_CCRL_RESET_VALUE;       // Reset clock control register low
2515  0072 725f521b      	clr	_I2C_CCRL
2516                     ; 146     I2C_CCRH = I2C_CCRH_RESET_VALUE;       // Reset clock control register high
2518  0076 725f521c      	clr	_I2C_CCRH
2519                     ; 147     I2C_TRISER = I2C_TRISER_RESET_VALUE;   // Reset TRISE register
2521  007a 3502521d      	mov	_I2C_TRISER,#2
2522                     ; 148 }
2525  007e 81            	ret
2552                     ; 158 static void gpio_init()
2552                     ; 159 {
2553                     	switch	.text
2554  007f               L3241_gpio_init:
2558                     ; 160   PB_ODR |= (I2C_SCL | I2C_SDA);   // Set HIGH on both lines
2560  007f c65005        	ld	a,_PB_ODR
2561  0082 aa30          	or	a,#48
2562  0084 c75005        	ld	_PB_ODR,a
2563                     ; 161   PB_DDR |= (I2C_SCL | I2C_SDA);   // Configure as output
2565  0087 c65007        	ld	a,_PB_DDR
2566  008a aa30          	or	a,#48
2567  008c c75007        	ld	_PB_DDR,a
2568                     ; 162   PB_CR1 &= ~(I2C_SCL | I2C_SDA);  // Open-drain
2570  008f c65008        	ld	a,_PB_CR1
2571  0092 a4cf          	and	a,#207
2572  0094 c75008        	ld	_PB_CR1,a
2573                     ; 163   PB_CR2 &= ~(I2C_SCL | I2C_SDA);  // Slow-mode (low speed)
2575  0097 c65009        	ld	a,_PB_CR2
2576  009a a4cf          	and	a,#207
2577  009c c75009        	ld	_PB_CR2,a
2578                     ; 174 }
2581  009f 81            	ret
2660                     ; 184 static void I2CWrite(uint8_t slave, uint8_t addr, uint8_t * buffer, uint8_t size)
2660                     ; 185 {
2661                     	switch	.text
2662  00a0               L5241_I2CWrite:
2664  00a0 89            	pushw	x
2665  00a1 89            	pushw	x
2666       00000002      OFST:	set	2
2669                     ; 188     uint8_t index = 0;
2671  00a2 0f02          	clr	(OFST+0,sp)
2673                     ; 190     I2C_Cmd(ENABLE);
2675  00a4 a601          	ld	a,#1
2676  00a6 cd01ad        	call	L1341_I2C_Cmd
2678                     ; 191     I2C_GenerateSTART(ENABLE);
2680  00a9 a601          	ld	a,#1
2681  00ab cd01bb        	call	L5341_I2C_GenerateSTART
2684  00ae               L5261:
2685                     ; 193     while(!(I2C_SR1 & I2C_SR1_SB));
2687  00ae c65217        	ld	a,_I2C_SR1
2688  00b1 a501          	bcp	a,#1
2689  00b3 27f9          	jreq	L5261
2690                     ; 196     I2C_Send7bitAddress(slave, I2C_DIRECTION_TX);
2692  00b5 7b03          	ld	a,(OFST+1,sp)
2693  00b7 5f            	clrw	x
2694  00b8 95            	ld	xh,a
2695  00b9 cd01d7        	call	L3341_I2C_Send7bitAddress
2698  00bc               L3361:
2699                     ; 198     while(!(I2C_SR1 & I2C_SR1_ADDR));
2701  00bc c65217        	ld	a,_I2C_SR1
2702  00bf a502          	bcp	a,#2
2703  00c1 27f9          	jreq	L3361
2704                     ; 200     reg = I2C_SR1;
2706  00c3 c65217        	ld	a,_I2C_SR1
2707  00c6 6b01          	ld	(OFST-1,sp),a
2709                     ; 201     reg = I2C_SR3;
2711  00c8 c65219        	ld	a,_I2C_SR3
2712  00cb 6b01          	ld	(OFST-1,sp),a
2714                     ; 204     I2C_SendData(addr);
2716  00cd 7b04          	ld	a,(OFST+2,sp)
2717  00cf cd01e7        	call	L7341_I2C_SendData
2720  00d2               L1461:
2721                     ; 205     while(!(I2C_SR1 & I2C_SR1_TXE));
2723  00d2 c65217        	ld	a,_I2C_SR1
2724  00d5 a580          	bcp	a,#128
2725  00d7 27f9          	jreq	L1461
2727  00d9 2016          	jra	L7461
2728  00db               L5461:
2729                     ; 209         size--;
2731  00db 0a09          	dec	(OFST+7,sp)
2732                     ; 210         I2C_SendData(buffer[index]);
2734  00dd 7b02          	ld	a,(OFST+0,sp)
2735  00df 5f            	clrw	x
2736  00e0 97            	ld	xl,a
2737  00e1 72fb07        	addw	x,(OFST+5,sp)
2738  00e4 f6            	ld	a,(x)
2739  00e5 cd01e7        	call	L7341_I2C_SendData
2741                     ; 211         index++;
2743  00e8 0c02          	inc	(OFST+0,sp)
2746  00ea               L5561:
2747                     ; 213         while(!(I2C_SR1 & I2C_SR1_TXE));
2749  00ea c65217        	ld	a,_I2C_SR1
2750  00ed a580          	bcp	a,#128
2751  00ef 27f9          	jreq	L5561
2752  00f1               L7461:
2753                     ; 207     while(size)
2755  00f1 0d09          	tnz	(OFST+7,sp)
2756  00f3 26e6          	jrne	L5461
2758  00f5               L3661:
2759                     ; 217     while(!(I2C_SR1 & I2C_SR1_BTF));
2761  00f5 c65217        	ld	a,_I2C_SR1
2762  00f8 a504          	bcp	a,#4
2763  00fa 27f9          	jreq	L3661
2764                     ; 221     I2C_GenerateSTOP(ENABLE);
2766  00fc a601          	ld	a,#1
2767  00fe cd01c9        	call	L1441_I2C_GenerateSTOP
2770  0101               L1761:
2771                     ; 224     while((I2C_SR3 & I2C_SR3_MSL));
2773  0101 c65219        	ld	a,_I2C_SR3
2774  0104 a501          	bcp	a,#1
2775  0106 26f9          	jrne	L1761
2776                     ; 225     I2C_Cmd(DISABLE);
2778  0108 4f            	clr	a
2779  0109 cd01ad        	call	L1341_I2C_Cmd
2781                     ; 226 }
2784  010c 5b04          	addw	sp,#4
2785  010e 81            	ret
2866                     ; 236 static void I2CRead(uint8_t slave, uint8_t addr, uint8_t * buffer, uint8_t size)
2866                     ; 237 {
2867                     	switch	.text
2868  010f               L7241_I2CRead:
2870  010f 89            	pushw	x
2871  0110 89            	pushw	x
2872       00000002      OFST:	set	2
2875                     ; 240     uint8_t index = 0;
2877  0111 0f02          	clr	(OFST+0,sp)
2879                     ; 242     I2C_Cmd(ENABLE);
2881  0113 a601          	ld	a,#1
2882  0115 cd01ad        	call	L1341_I2C_Cmd
2884                     ; 243     I2C_GenerateSTART(ENABLE);
2886  0118 a601          	ld	a,#1
2887  011a cd01bb        	call	L5341_I2C_GenerateSTART
2890  011d               L1371:
2891                     ; 246     while(!(I2C_SR1 & I2C_SR1_SB));
2893  011d c65217        	ld	a,_I2C_SR1
2894  0120 a501          	bcp	a,#1
2895  0122 27f9          	jreq	L1371
2896                     ; 249     I2C_Send7bitAddress(slave, I2C_DIRECTION_TX);
2898  0124 7b03          	ld	a,(OFST+1,sp)
2899  0126 5f            	clrw	x
2900  0127 95            	ld	xh,a
2901  0128 cd01d7        	call	L3341_I2C_Send7bitAddress
2904  012b               L7371:
2905                     ; 252     while(!(I2C_SR1 & I2C_SR1_ADDR));
2907  012b c65217        	ld	a,_I2C_SR1
2908  012e a502          	bcp	a,#2
2909  0130 27f9          	jreq	L7371
2910                     ; 254     reg = I2C_SR1;
2912  0132 c65217        	ld	a,_I2C_SR1
2913  0135 6b01          	ld	(OFST-1,sp),a
2915                     ; 255     reg = I2C_SR3;
2917  0137 c65219        	ld	a,_I2C_SR3
2918  013a 6b01          	ld	(OFST-1,sp),a
2920                     ; 258     I2C_SendData(addr);
2922  013c 7b04          	ld	a,(OFST+2,sp)
2923  013e cd01e7        	call	L7341_I2C_SendData
2926  0141               L5471:
2927                     ; 260     while(!(I2C_SR1 & I2C_SR1_TXE));
2929  0141 c65217        	ld	a,_I2C_SR1
2930  0144 a580          	bcp	a,#128
2931  0146 27f9          	jreq	L5471
2933  0148               L3571:
2934                     ; 262     while(!(I2C_SR1 & I2C_SR1_BTF));
2936  0148 c65217        	ld	a,_I2C_SR1
2937  014b a504          	bcp	a,#4
2938  014d 27f9          	jreq	L3571
2939                     ; 265     I2C_CR2 |= I2C_CR2_ACK;
2941  014f 72145211      	bset	_I2C_CR2,#2
2942                     ; 267     I2C_GenerateSTART(ENABLE);
2944  0153 a601          	ld	a,#1
2945  0155 ad64          	call	L5341_I2C_GenerateSTART
2948  0157               L1671:
2949                     ; 269     while(!(I2C_SR1 & I2C_SR1_SB));
2951  0157 c65217        	ld	a,_I2C_SR1
2952  015a a501          	bcp	a,#1
2953  015c 27f9          	jreq	L1671
2954                     ; 271     I2C_Send7bitAddress(slave, I2C_DIRECTION_RX);
2956  015e 7b03          	ld	a,(OFST+1,sp)
2957  0160 ae0001        	ldw	x,#1
2958  0163 95            	ld	xh,a
2959  0164 ad71          	call	L3341_I2C_Send7bitAddress
2962  0166               L7671:
2963                     ; 274     while(!(I2C_SR1 & I2C_SR1_ADDR));
2965  0166 c65217        	ld	a,_I2C_SR1
2966  0169 a502          	bcp	a,#2
2967  016b 27f9          	jreq	L7671
2968                     ; 276     reg = I2C_SR1;
2970  016d c65217        	ld	a,_I2C_SR1
2971  0170 6b01          	ld	(OFST-1,sp),a
2973                     ; 277     reg = I2C_SR3;
2975  0172 c65219        	ld	a,_I2C_SR3
2976  0175 6b01          	ld	(OFST-1,sp),a
2979  0177 201f          	jra	L7771
2980  0179               L3771:
2981                     ; 281         size--;
2983  0179 0a09          	dec	(OFST+7,sp)
2984                     ; 282         if(size == 0)
2986  017b 0d09          	tnz	(OFST+7,sp)
2987  017d 2604          	jrne	L7002
2988                     ; 285             I2C_CR2 &= ~I2C_CR2_ACK;
2990  017f 72155211      	bres	_I2C_CR2,#2
2991  0183               L7002:
2992                     ; 288         while(!(I2C_SR1 & I2C_SR1_RXNE));
2994  0183 c65217        	ld	a,_I2C_SR1
2995  0186 a540          	bcp	a,#64
2996  0188 27f9          	jreq	L7002
2997                     ; 289         buffer[index] = I2C_ReceiveData();
2999  018a 7b02          	ld	a,(OFST+0,sp)
3000  018c 5f            	clrw	x
3001  018d 97            	ld	xl,a
3002  018e 72fb07        	addw	x,(OFST+5,sp)
3003  0191 89            	pushw	x
3004  0192 ad57          	call	L3441_I2C_ReceiveData
3006  0194 85            	popw	x
3007  0195 f7            	ld	(x),a
3008                     ; 290         index++;
3010  0196 0c02          	inc	(OFST+0,sp)
3012  0198               L7771:
3013                     ; 279     while(size)
3015  0198 0d09          	tnz	(OFST+7,sp)
3016  019a 26dd          	jrne	L3771
3017                     ; 294     I2C_GenerateSTOP(ENABLE);
3019  019c a601          	ld	a,#1
3020  019e ad29          	call	L1441_I2C_GenerateSTOP
3023  01a0               L5102:
3024                     ; 298     while((I2C_SR3 & I2C_SR3_MSL));
3026  01a0 c65219        	ld	a,_I2C_SR3
3027  01a3 a501          	bcp	a,#1
3028  01a5 26f9          	jrne	L5102
3029                     ; 299     I2C_Cmd(DISABLE);
3031  01a7 4f            	clr	a
3032  01a8 ad03          	call	L1341_I2C_Cmd
3034                     ; 300 }
3037  01aa 5b04          	addw	sp,#4
3038  01ac 81            	ret
3071                     ; 307 static void I2C_Cmd(uint8_t NewState)
3071                     ; 308 {
3072                     	switch	.text
3073  01ad               L1341_I2C_Cmd:
3077                     ; 309   if (NewState != DISABLE)
3079  01ad 4d            	tnz	a
3080  01ae 2706          	jreq	L5302
3081                     ; 312     I2C_CR1 |= I2C_CR1_PE;
3083  01b0 72105210      	bset	_I2C_CR1,#0
3085  01b4 2004          	jra	L7302
3086  01b6               L5302:
3087                     ; 317     I2C_CR1 &= (uint8_t)(~I2C_CR1_PE);
3089  01b6 72115210      	bres	_I2C_CR1,#0
3090  01ba               L7302:
3091                     ; 319 }
3094  01ba 81            	ret
3127                     ; 326 static void I2C_GenerateSTART(uint8_t NewState)
3127                     ; 327 {
3128                     	switch	.text
3129  01bb               L5341_I2C_GenerateSTART:
3133                     ; 328   if (NewState != DISABLE)
3135  01bb 4d            	tnz	a
3136  01bc 2706          	jreq	L5502
3137                     ; 331     I2C_CR2 |= I2C_CR2_START;
3139  01be 72105211      	bset	_I2C_CR2,#0
3141  01c2 2004          	jra	L7502
3142  01c4               L5502:
3143                     ; 336     I2C_CR2 &= (uint8_t)(~I2C_CR2_START);
3145  01c4 72115211      	bres	_I2C_CR2,#0
3146  01c8               L7502:
3147                     ; 338 }
3150  01c8 81            	ret
3183                     ; 345 static void I2C_GenerateSTOP(uint8_t NewState)
3183                     ; 346 {
3184                     	switch	.text
3185  01c9               L1441_I2C_GenerateSTOP:
3189                     ; 347   if (NewState != DISABLE)
3191  01c9 4d            	tnz	a
3192  01ca 2706          	jreq	L5702
3193                     ; 350     I2C_CR2 |= I2C_CR2_STOP;
3195  01cc 72125211      	bset	_I2C_CR2,#1
3197  01d0 2004          	jra	L7702
3198  01d2               L5702:
3199                     ; 355     I2C_CR2 &= (uint8_t)(~I2C_CR2_STOP);
3201  01d2 72135211      	bres	_I2C_CR2,#1
3202  01d6               L7702:
3203                     ; 357 }
3206  01d6 81            	ret
3247                     ; 365 static void I2C_Send7bitAddress(uint8_t Address, uint8_t Direction)
3247                     ; 366 {
3248                     	switch	.text
3249  01d7               L3341_I2C_Send7bitAddress:
3251  01d7 89            	pushw	x
3252       00000000      OFST:	set	0
3255                     ; 368   Address &= (uint8_t)0xFE;
3257  01d8 7b01          	ld	a,(OFST+1,sp)
3258  01da a4fe          	and	a,#254
3259  01dc 6b01          	ld	(OFST+1,sp),a
3260                     ; 371   I2C_DR = (uint8_t)(Address | (uint8_t)Direction);
3262  01de 7b01          	ld	a,(OFST+1,sp)
3263  01e0 1a02          	or	a,(OFST+2,sp)
3264  01e2 c75216        	ld	_I2C_DR,a
3265                     ; 372 }
3268  01e5 85            	popw	x
3269  01e6 81            	ret
3302                     ; 379 static void I2C_SendData(uint8_t Data)
3302                     ; 380 {
3303                     	switch	.text
3304  01e7               L7341_I2C_SendData:
3308                     ; 382   I2C_DR = Data;
3310  01e7 c75216        	ld	_I2C_DR,a
3311                     ; 383 }
3314  01ea 81            	ret
3338                     ; 390 static uint8_t I2C_ReceiveData(void)
3338                     ; 391 {
3339                     	switch	.text
3340  01eb               L3441_I2C_ReceiveData:
3344                     ; 393   return ((uint8_t)I2C_DR);
3346  01eb c65216        	ld	a,_I2C_DR
3349  01ee 81            	ret
3362                     	xdef	_I2CDeinit
3363                     	xdef	_I2CInit
3364                     	xdef	_DS3231_SetTimeManual
3365                     	xdef	_DS3231_SetTime
3366                     	xdef	_DS3231_GetTime
3367                     	xref.b	c_x
3386                     	xref	c_xymov
3387                     	end
