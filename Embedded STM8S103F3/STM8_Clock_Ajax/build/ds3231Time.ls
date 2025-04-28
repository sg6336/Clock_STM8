   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2219                     ; 107 void DS3231_GetTime(uint8_t *buf, uint8_t size)
2219                     ; 108 {
2221                     	switch	.text
2222  0000               _DS3231_GetTime:
2224  0000 89            	pushw	x
2225       00000000      OFST:	set	0
2228                     ; 109   I2CRead(DS3231_ADDR, DS3231_SECONDS, buf, size);
2230  0001 7b05          	ld	a,(OFST+5,sp)
2231  0003 88            	push	a
2232  0004 89            	pushw	x
2233  0005 aed000        	ldw	x,#53248
2234  0008 cd010f        	call	L7241_I2CRead
2236  000b 5b03          	addw	sp,#3
2237                     ; 110 }
2240  000d 85            	popw	x
2241  000e 81            	ret
2283                     ; 112 void DS3231_SetTime(uint8_t *buf, uint8_t size)
2283                     ; 113 {
2284                     	switch	.text
2285  000f               _DS3231_SetTime:
2287  000f 89            	pushw	x
2288       00000000      OFST:	set	0
2291                     ; 121   (void *)buf;
2293                     ; 122   (void *)size;
2295                     ; 124 }
2298  0010 85            	popw	x
2299  0011 81            	ret
2302                     .const:	section	.text
2303  0000               L3151_buf:
2304  0000 000000        	ds.b	3
2360                     ; 126 void DS3231_SetTimeManual(uint8_t hours_bcd, uint8_t minutes_bcd, uint8_t seconds_bcd)
2360                     ; 127 {
2361                     	switch	.text
2362  0012               _DS3231_SetTimeManual:
2364  0012 89            	pushw	x
2365  0013 5203          	subw	sp,#3
2366       00000003      OFST:	set	3
2369                     ; 128   uint8_t buf[3] = {seconds_bcd, minutes_bcd, hours_bcd};
2371  0015 96            	ldw	x,sp
2372  0016 1c0001        	addw	x,#OFST-2
2373  0019 90ae0000      	ldw	y,#L3151_buf
2374  001d a603          	ld	a,#3
2375  001f cd0000        	call	c_xymov
2377  0022 7b08          	ld	a,(OFST+5,sp)
2378  0024 6b01          	ld	(OFST-2,sp),a
2380  0026 7b05          	ld	a,(OFST+2,sp)
2381  0028 6b02          	ld	(OFST-1,sp),a
2383  002a 7b04          	ld	a,(OFST+1,sp)
2384  002c 6b03          	ld	(OFST+0,sp),a
2386                     ; 129   I2CWrite(DS3231_ADDR, DS3231_SECONDS, buf, 3);
2388  002e 4b03          	push	#3
2389  0030 96            	ldw	x,sp
2390  0031 1c0002        	addw	x,#OFST-1
2391  0034 89            	pushw	x
2392  0035 aed000        	ldw	x,#53248
2393  0038 ad66          	call	L5241_I2CWrite
2395  003a 5b03          	addw	sp,#3
2396                     ; 130 }
2399  003c 5b05          	addw	sp,#5
2400  003e 81            	ret
2429                     ; 132 void I2CInit()
2429                     ; 133 {
2430                     	switch	.text
2431  003f               _I2CInit:
2435                     ; 134   gpio_init(); // Configure GPIO pins for I2C (PB4, PB5)
2437  003f ad3e          	call	L3241_gpio_init
2439                     ; 136   I2C_CR1 = 0x00;        // Disable I2C peripheral before configuration
2441  0041 725f5210      	clr	_I2C_CR1
2442                     ; 137   I2C_FREQR = 16;        // Set peripheral clock frequency in MHz (16 MHz)
2444  0045 35105212      	mov	_I2C_FREQR,#16
2445                     ; 138   I2C_CCRL = 80;         // Configure clock control: 100 kHz = 16 MHz / (2 * 100 kHz)
2447  0049 3550521b      	mov	_I2C_CCRL,#80
2448                     ; 139   I2C_TRISER = 17;       // Configure TRISE: freq + 1 = 17 for standard mode
2450  004d 3511521d      	mov	_I2C_TRISER,#17
2451                     ; 140   I2C_CR2 = I2C_CR2_ACK; // Enable ACK generation
2453  0051 35045211      	mov	_I2C_CR2,#4
2454                     ; 141   I2C_CR1 |= I2C_CR1_PE; // Enable the I2C peripheral
2456  0055 72105210      	bset	_I2C_CR1,#0
2457                     ; 142 }
2460  0059 81            	ret
2492                     ; 144 void I2CDeinit()
2492                     ; 145 {
2493                     	switch	.text
2494  005a               _I2CDeinit:
2498                     ; 146   I2C_CR1 = I2C_CR1_RESET_VALUE;       // Reset control register 1
2500  005a 725f5210      	clr	_I2C_CR1
2501                     ; 147   I2C_CR2 = I2C_CR2_RESET_VALUE;       // Reset control register 2
2503  005e 725f5211      	clr	_I2C_CR2
2504                     ; 148   I2C_FREQR = I2C_FREQR_RESET_VALUE;   // Reset frequency register
2506  0062 725f5212      	clr	_I2C_FREQR
2507                     ; 149   I2C_OARL = I2C_OARL_RESET_VALUE;     // Reset own address register low
2509  0066 725f5213      	clr	_I2C_OARL
2510                     ; 150   I2C_OARH = I2C_OARH_RESET_VALUE;     // Reset own address register high
2512  006a 725f5214      	clr	_I2C_OARH
2513                     ; 151   I2C_ITR = I2C_ITR_RESET_VALUE;       // Reset interrupt register
2515  006e 725f521a      	clr	_I2C_ITR
2516                     ; 152   I2C_CCRL = I2C_CCRL_RESET_VALUE;     // Reset clock control register low
2518  0072 725f521b      	clr	_I2C_CCRL
2519                     ; 153   I2C_CCRH = I2C_CCRH_RESET_VALUE;     // Reset clock control register high
2521  0076 725f521c      	clr	_I2C_CCRH
2522                     ; 154   I2C_TRISER = I2C_TRISER_RESET_VALUE; // Reset TRISE register
2524  007a 3502521d      	mov	_I2C_TRISER,#2
2525                     ; 155 }
2528  007e 81            	ret
2555                     ; 164 static void gpio_init()
2555                     ; 165 {
2556                     	switch	.text
2557  007f               L3241_gpio_init:
2561                     ; 166   PB_ODR |= (I2C_SCL | I2C_SDA);  // Set HIGH on both lines
2563  007f c65005        	ld	a,_PB_ODR
2564  0082 aa30          	or	a,#48
2565  0084 c75005        	ld	_PB_ODR,a
2566                     ; 167   PB_DDR |= (I2C_SCL | I2C_SDA);  // Configure as output
2568  0087 c65007        	ld	a,_PB_DDR
2569  008a aa30          	or	a,#48
2570  008c c75007        	ld	_PB_DDR,a
2571                     ; 168   PB_CR1 &= ~(I2C_SCL | I2C_SDA); // Open-drain
2573  008f c65008        	ld	a,_PB_CR1
2574  0092 a4cf          	and	a,#207
2575  0094 c75008        	ld	_PB_CR1,a
2576                     ; 169   PB_CR2 &= ~(I2C_SCL | I2C_SDA); // Slow-mode (low speed)
2578  0097 c65009        	ld	a,_PB_CR2
2579  009a a4cf          	and	a,#207
2580  009c c75009        	ld	_PB_CR2,a
2581                     ; 180 }
2584  009f 81            	ret
2663                     ; 190 static void I2CWrite(uint8_t slave, uint8_t addr, uint8_t *buffer, uint8_t size)
2663                     ; 191 {
2664                     	switch	.text
2665  00a0               L5241_I2CWrite:
2667  00a0 89            	pushw	x
2668  00a1 89            	pushw	x
2669       00000002      OFST:	set	2
2672                     ; 194   uint8_t index = 0;
2674  00a2 0f02          	clr	(OFST+0,sp)
2676                     ; 196   I2C_Cmd(ENABLE);
2678  00a4 a601          	ld	a,#1
2679  00a6 cd01ad        	call	L1341_I2C_Cmd
2681                     ; 197   I2C_GenerateSTART(ENABLE);
2683  00a9 a601          	ld	a,#1
2684  00ab cd01bb        	call	L5341_I2C_GenerateSTART
2687  00ae               L5261:
2688                     ; 199   while (!(I2C_SR1 & I2C_SR1_SB))
2690  00ae c65217        	ld	a,_I2C_SR1
2691  00b1 a501          	bcp	a,#1
2692  00b3 27f9          	jreq	L5261
2693                     ; 203   I2C_Send7bitAddress(slave, I2C_DIRECTION_TX);
2695  00b5 7b03          	ld	a,(OFST+1,sp)
2696  00b7 5f            	clrw	x
2697  00b8 95            	ld	xh,a
2698  00b9 cd01d7        	call	L3341_I2C_Send7bitAddress
2701  00bc               L3361:
2702                     ; 205   while (!(I2C_SR1 & I2C_SR1_ADDR))
2704  00bc c65217        	ld	a,_I2C_SR1
2705  00bf a502          	bcp	a,#2
2706  00c1 27f9          	jreq	L3361
2707                     ; 208   reg = I2C_SR1;
2709  00c3 c65217        	ld	a,_I2C_SR1
2710  00c6 6b01          	ld	(OFST-1,sp),a
2712                     ; 209   reg = I2C_SR3;
2714  00c8 c65219        	ld	a,_I2C_SR3
2715  00cb 6b01          	ld	(OFST-1,sp),a
2717                     ; 212   I2C_SendData(addr);
2719  00cd 7b04          	ld	a,(OFST+2,sp)
2720  00cf cd01e7        	call	L7341_I2C_SendData
2723  00d2               L1461:
2724                     ; 213   while (!(I2C_SR1 & I2C_SR1_TXE))
2726  00d2 c65217        	ld	a,_I2C_SR1
2727  00d5 a580          	bcp	a,#128
2728  00d7 27f9          	jreq	L1461
2730  00d9 2016          	jra	L7461
2731  00db               L5461:
2732                     ; 218     size--;
2734  00db 0a09          	dec	(OFST+7,sp)
2735                     ; 219     I2C_SendData(buffer[index]);
2737  00dd 7b02          	ld	a,(OFST+0,sp)
2738  00df 5f            	clrw	x
2739  00e0 97            	ld	xl,a
2740  00e1 72fb07        	addw	x,(OFST+5,sp)
2741  00e4 f6            	ld	a,(x)
2742  00e5 cd01e7        	call	L7341_I2C_SendData
2744                     ; 220     index++;
2746  00e8 0c02          	inc	(OFST+0,sp)
2749  00ea               L5561:
2750                     ; 222     while (!(I2C_SR1 & I2C_SR1_TXE))
2752  00ea c65217        	ld	a,_I2C_SR1
2753  00ed a580          	bcp	a,#128
2754  00ef 27f9          	jreq	L5561
2755  00f1               L7461:
2756                     ; 216   while (size)
2758  00f1 0d09          	tnz	(OFST+7,sp)
2759  00f3 26e6          	jrne	L5461
2761  00f5               L3661:
2762                     ; 227   while (!(I2C_SR1 & I2C_SR1_BTF))
2764  00f5 c65217        	ld	a,_I2C_SR1
2765  00f8 a504          	bcp	a,#4
2766  00fa 27f9          	jreq	L3661
2767                     ; 232   I2C_GenerateSTOP(ENABLE);
2769  00fc a601          	ld	a,#1
2770  00fe cd01c9        	call	L1441_I2C_GenerateSTOP
2773  0101               L1761:
2774                     ; 235   while ((I2C_SR3 & I2C_SR3_MSL))
2776  0101 c65219        	ld	a,_I2C_SR3
2777  0104 a501          	bcp	a,#1
2778  0106 26f9          	jrne	L1761
2779                     ; 237   I2C_Cmd(DISABLE);
2781  0108 4f            	clr	a
2782  0109 cd01ad        	call	L1341_I2C_Cmd
2784                     ; 238 }
2787  010c 5b04          	addw	sp,#4
2788  010e 81            	ret
2869                     ; 248 static void I2CRead(uint8_t slave, uint8_t addr, uint8_t *buffer, uint8_t size)
2869                     ; 249 {
2870                     	switch	.text
2871  010f               L7241_I2CRead:
2873  010f 89            	pushw	x
2874  0110 89            	pushw	x
2875       00000002      OFST:	set	2
2878                     ; 252   uint8_t index = 0;
2880  0111 0f02          	clr	(OFST+0,sp)
2882                     ; 254   I2C_Cmd(ENABLE);
2884  0113 a601          	ld	a,#1
2885  0115 cd01ad        	call	L1341_I2C_Cmd
2887                     ; 255   I2C_GenerateSTART(ENABLE);
2889  0118 a601          	ld	a,#1
2890  011a cd01bb        	call	L5341_I2C_GenerateSTART
2893  011d               L1371:
2894                     ; 258   while (!(I2C_SR1 & I2C_SR1_SB))
2896  011d c65217        	ld	a,_I2C_SR1
2897  0120 a501          	bcp	a,#1
2898  0122 27f9          	jreq	L1371
2899                     ; 262   I2C_Send7bitAddress(slave, I2C_DIRECTION_TX);
2901  0124 7b03          	ld	a,(OFST+1,sp)
2902  0126 5f            	clrw	x
2903  0127 95            	ld	xh,a
2904  0128 cd01d7        	call	L3341_I2C_Send7bitAddress
2907  012b               L7371:
2908                     ; 265   while (!(I2C_SR1 & I2C_SR1_ADDR))
2910  012b c65217        	ld	a,_I2C_SR1
2911  012e a502          	bcp	a,#2
2912  0130 27f9          	jreq	L7371
2913                     ; 268   reg = I2C_SR1;
2915  0132 c65217        	ld	a,_I2C_SR1
2916  0135 6b01          	ld	(OFST-1,sp),a
2918                     ; 269   reg = I2C_SR3;
2920  0137 c65219        	ld	a,_I2C_SR3
2921  013a 6b01          	ld	(OFST-1,sp),a
2923                     ; 272   I2C_SendData(addr);
2925  013c 7b04          	ld	a,(OFST+2,sp)
2926  013e cd01e7        	call	L7341_I2C_SendData
2929  0141               L5471:
2930                     ; 274   while (!(I2C_SR1 & I2C_SR1_TXE))
2932  0141 c65217        	ld	a,_I2C_SR1
2933  0144 a580          	bcp	a,#128
2934  0146 27f9          	jreq	L5471
2936  0148               L3571:
2937                     ; 277   while (!(I2C_SR1 & I2C_SR1_BTF))
2939  0148 c65217        	ld	a,_I2C_SR1
2940  014b a504          	bcp	a,#4
2941  014d 27f9          	jreq	L3571
2942                     ; 281   I2C_CR2 |= I2C_CR2_ACK;
2944  014f 72145211      	bset	_I2C_CR2,#2
2945                     ; 283   I2C_GenerateSTART(ENABLE);
2947  0153 a601          	ld	a,#1
2948  0155 ad64          	call	L5341_I2C_GenerateSTART
2951  0157               L1671:
2952                     ; 285   while (!(I2C_SR1 & I2C_SR1_SB))
2954  0157 c65217        	ld	a,_I2C_SR1
2955  015a a501          	bcp	a,#1
2956  015c 27f9          	jreq	L1671
2957                     ; 288   I2C_Send7bitAddress(slave, I2C_DIRECTION_RX);
2959  015e 7b03          	ld	a,(OFST+1,sp)
2960  0160 ae0001        	ldw	x,#1
2961  0163 95            	ld	xh,a
2962  0164 ad71          	call	L3341_I2C_Send7bitAddress
2965  0166               L7671:
2966                     ; 291   while (!(I2C_SR1 & I2C_SR1_ADDR))
2968  0166 c65217        	ld	a,_I2C_SR1
2969  0169 a502          	bcp	a,#2
2970  016b 27f9          	jreq	L7671
2971                     ; 294   reg = I2C_SR1;
2973  016d c65217        	ld	a,_I2C_SR1
2974  0170 6b01          	ld	(OFST-1,sp),a
2976                     ; 295   reg = I2C_SR3;
2978  0172 c65219        	ld	a,_I2C_SR3
2979  0175 6b01          	ld	(OFST-1,sp),a
2982  0177 201f          	jra	L7771
2983  0179               L3771:
2984                     ; 299     size--;
2986  0179 0a09          	dec	(OFST+7,sp)
2987                     ; 300     if (size == 0)
2989  017b 0d09          	tnz	(OFST+7,sp)
2990  017d 2604          	jrne	L7002
2991                     ; 303       I2C_CR2 &= ~I2C_CR2_ACK;
2993  017f 72155211      	bres	_I2C_CR2,#2
2994  0183               L7002:
2995                     ; 306     while (!(I2C_SR1 & I2C_SR1_RXNE))
2997  0183 c65217        	ld	a,_I2C_SR1
2998  0186 a540          	bcp	a,#64
2999  0188 27f9          	jreq	L7002
3000                     ; 308     buffer[index] = I2C_ReceiveData();
3002  018a 7b02          	ld	a,(OFST+0,sp)
3003  018c 5f            	clrw	x
3004  018d 97            	ld	xl,a
3005  018e 72fb07        	addw	x,(OFST+5,sp)
3006  0191 89            	pushw	x
3007  0192 ad57          	call	L3441_I2C_ReceiveData
3009  0194 85            	popw	x
3010  0195 f7            	ld	(x),a
3011                     ; 309     index++;
3013  0196 0c02          	inc	(OFST+0,sp)
3015  0198               L7771:
3016                     ; 297   while (size)
3018  0198 0d09          	tnz	(OFST+7,sp)
3019  019a 26dd          	jrne	L3771
3020                     ; 313   I2C_GenerateSTOP(ENABLE);
3022  019c a601          	ld	a,#1
3023  019e ad29          	call	L1441_I2C_GenerateSTOP
3026  01a0               L5102:
3027                     ; 317   while ((I2C_SR3 & I2C_SR3_MSL))
3029  01a0 c65219        	ld	a,_I2C_SR3
3030  01a3 a501          	bcp	a,#1
3031  01a5 26f9          	jrne	L5102
3032                     ; 319   I2C_Cmd(DISABLE);
3034  01a7 4f            	clr	a
3035  01a8 ad03          	call	L1341_I2C_Cmd
3037                     ; 320 }
3040  01aa 5b04          	addw	sp,#4
3041  01ac 81            	ret
3074                     ; 327 static void I2C_Cmd(uint8_t NewState)
3074                     ; 328 {
3075                     	switch	.text
3076  01ad               L1341_I2C_Cmd:
3080                     ; 329   if (NewState != DISABLE)
3082  01ad 4d            	tnz	a
3083  01ae 2706          	jreq	L5302
3084                     ; 332     I2C_CR1 |= I2C_CR1_PE;
3086  01b0 72105210      	bset	_I2C_CR1,#0
3088  01b4 2004          	jra	L7302
3089  01b6               L5302:
3090                     ; 337     I2C_CR1 &= (uint8_t)(~I2C_CR1_PE);
3092  01b6 72115210      	bres	_I2C_CR1,#0
3093  01ba               L7302:
3094                     ; 339 }
3097  01ba 81            	ret
3130                     ; 346 static void I2C_GenerateSTART(uint8_t NewState)
3130                     ; 347 {
3131                     	switch	.text
3132  01bb               L5341_I2C_GenerateSTART:
3136                     ; 348   if (NewState != DISABLE)
3138  01bb 4d            	tnz	a
3139  01bc 2706          	jreq	L5502
3140                     ; 351     I2C_CR2 |= I2C_CR2_START;
3142  01be 72105211      	bset	_I2C_CR2,#0
3144  01c2 2004          	jra	L7502
3145  01c4               L5502:
3146                     ; 356     I2C_CR2 &= (uint8_t)(~I2C_CR2_START);
3148  01c4 72115211      	bres	_I2C_CR2,#0
3149  01c8               L7502:
3150                     ; 358 }
3153  01c8 81            	ret
3186                     ; 365 static void I2C_GenerateSTOP(uint8_t NewState)
3186                     ; 366 {
3187                     	switch	.text
3188  01c9               L1441_I2C_GenerateSTOP:
3192                     ; 367   if (NewState != DISABLE)
3194  01c9 4d            	tnz	a
3195  01ca 2706          	jreq	L5702
3196                     ; 370     I2C_CR2 |= I2C_CR2_STOP;
3198  01cc 72125211      	bset	_I2C_CR2,#1
3200  01d0 2004          	jra	L7702
3201  01d2               L5702:
3202                     ; 375     I2C_CR2 &= (uint8_t)(~I2C_CR2_STOP);
3204  01d2 72135211      	bres	_I2C_CR2,#1
3205  01d6               L7702:
3206                     ; 377 }
3209  01d6 81            	ret
3250                     ; 385 static void I2C_Send7bitAddress(uint8_t Address, uint8_t Direction)
3250                     ; 386 {
3251                     	switch	.text
3252  01d7               L3341_I2C_Send7bitAddress:
3254  01d7 89            	pushw	x
3255       00000000      OFST:	set	0
3258                     ; 388   Address &= (uint8_t)0xFE;
3260  01d8 7b01          	ld	a,(OFST+1,sp)
3261  01da a4fe          	and	a,#254
3262  01dc 6b01          	ld	(OFST+1,sp),a
3263                     ; 391   I2C_DR = (uint8_t)(Address | (uint8_t)Direction);
3265  01de 7b01          	ld	a,(OFST+1,sp)
3266  01e0 1a02          	or	a,(OFST+2,sp)
3267  01e2 c75216        	ld	_I2C_DR,a
3268                     ; 392 }
3271  01e5 85            	popw	x
3272  01e6 81            	ret
3305                     ; 399 static void I2C_SendData(uint8_t Data)
3305                     ; 400 {
3306                     	switch	.text
3307  01e7               L7341_I2C_SendData:
3311                     ; 402   I2C_DR = Data;
3313  01e7 c75216        	ld	_I2C_DR,a
3314                     ; 403 }
3317  01ea 81            	ret
3341                     ; 410 static uint8_t I2C_ReceiveData(void)
3341                     ; 411 {
3342                     	switch	.text
3343  01eb               L3441_I2C_ReceiveData:
3347                     ; 413   return ((uint8_t)I2C_DR);
3349  01eb c65216        	ld	a,_I2C_DR
3352  01ee 81            	ret
3365                     	xdef	_I2CDeinit
3366                     	xdef	_I2CInit
3367                     	xdef	_DS3231_SetTimeManual
3368                     	xdef	_DS3231_SetTime
3369                     	xdef	_DS3231_GetTime
3370                     	xref.b	c_x
3389                     	xref	c_xymov
3390                     	end
