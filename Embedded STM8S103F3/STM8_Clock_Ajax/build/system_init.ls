   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
2206                     ; 19 void init_hardware()
2206                     ; 20 {
2208                     	switch	.text
2209  0000               _init_hardware:
2213                     ; 21     CLK_init(); // Initialize system clock to 16 MHz using internal HSI oscillator
2215  0000 ad0e          	call	L3241_CLK_init
2217                     ; 23     clock_init();   // Initialize I2C (SDA: PB5, SCL: PB4) for DS3231
2219  0002 cd0000        	call	_clock_init
2221                     ; 24     display_init(); // Initialize TM1637 clock and data pins (PC5 and PC6)
2223  0005 cd0000        	call	_display_init
2225                     ; 25     input_init();   // Initialize buttons PC3 and PD2
2227  0008 cd0000        	call	_input_init
2229                     ; 26     logger_init();  // Initialize UART TX only, PD5, 9600 baud
2231  000b cd0000        	call	_logger_init
2233                     ; 28     _asm("rim"); // â† Important! Enable global interrupts
2236  000e 9a            rim
2238                     ; 29 }
2241  000f 81            	ret
2268                     ; 37 static void CLK_init()
2268                     ; 38 {
2269                     	switch	.text
2270  0010               L3241_CLK_init:
2274                     ; 39     CLK_SWR = 0xE1;      // select HSI as the clock source
2276  0010 35e150c4      	mov	_CLK_SWR,#225
2277                     ; 40     CLK_SWCR = (1 << 1); // enable switching (SWEN = 1)
2279  0014 350250c5      	mov	_CLK_SWCR,#2
2281  0018               L7541:
2282                     ; 41     while (CLK_CMSR != 0xE1)
2284  0018 c650c3        	ld	a,_CLK_CMSR
2285  001b a1e1          	cp	a,#225
2286  001d 26f9          	jrne	L7541
2287                     ; 43     CLK_CKDIVR = 0x00; // set HSI divider = 1, CPU divider = 1
2289  001f 725f50c6      	clr	_CLK_CKDIVR
2290                     ; 45 }
2293  0023 81            	ret
2306                     	xref	_input_init
2307                     	xref	_logger_init
2308                     	xref	_display_init
2309                     	xref	_clock_init
2310                     	xdef	_init_hardware
2329                     	end
