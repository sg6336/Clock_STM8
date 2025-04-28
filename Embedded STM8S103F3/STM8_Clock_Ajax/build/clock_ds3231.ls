   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  42                     ; 41 void clock_init(void) // Initialize I2C (SDA: PB5, SCL: PB4) for DS3231
  42                     ; 42 {
  44                     	switch	.text
  45  0000               _clock_init:
  49                     ; 44     I2CInit(); // PB4 (SCL), PB5 (SDA) for DS3231
  51  0000 cd0000        	call	_I2CInit
  53                     ; 45 }
  56  0003 81            	ret
  81                     ; 47 void get_time_from_clock(void)
  81                     ; 48 {
  82                     	switch	.text
  83  0004               _get_time_from_clock:
  87                     ; 49     sync_time_from_ds3231();
  89  0004 ad3d          	call	L51_sync_time_from_ds3231
  91                     ; 50 }
  94  0006 81            	ret
 118                     ; 52 void set_time_to_clock(/* uint8_t hours, uint8_t min, uint8_t secs */)
 118                     ; 53 {
 119                     	switch	.text
 120  0007               _set_time_to_clock:
 124                     ; 54     set_time();
 126  0007 ad01          	call	L31_set_time
 128                     ; 55 }
 131  0009 81            	ret
 183                     ; 65 static void set_time()
 183                     ; 66 {
 184                     	switch	.text
 185  000a               L31_set_time:
 187  000a 5203          	subw	sp,#3
 188       00000003      OFST:	set	3
 191                     ; 71     hours = current_time.hours;
 193  000c 5500070006    	mov	L3_hours,_current_time
 194                     ; 72     min = current_time.minutes;
 196  0011 5500080005    	mov	L5_min,_current_time+1
 197                     ; 73     secs = current_time.seconds;
 199  0016 5500090004    	mov	L7_secs,_current_time+2
 200                     ; 75     hours_bcd = dec_to_bcd(hours);
 202  001b c60006        	ld	a,L3_hours
 203  001e cd00ef        	call	L13_dec_to_bcd
 205  0021 6b01          	ld	(OFST-2,sp),a
 207                     ; 76     minutes_bcd = dec_to_bcd(min);
 209  0023 c60005        	ld	a,L5_min
 210  0026 cd00ef        	call	L13_dec_to_bcd
 212  0029 6b02          	ld	(OFST-1,sp),a
 214                     ; 77     seconds_bcd = dec_to_bcd(secs);
 216  002b c60004        	ld	a,L7_secs
 217  002e cd00ef        	call	L13_dec_to_bcd
 219  0031 6b03          	ld	(OFST+0,sp),a
 221                     ; 78     DS3231_SetTimeManual(hours_bcd, minutes_bcd, seconds_bcd);
 223  0033 7b03          	ld	a,(OFST+0,sp)
 224  0035 88            	push	a
 225  0036 7b03          	ld	a,(OFST+0,sp)
 226  0038 97            	ld	xl,a
 227  0039 7b02          	ld	a,(OFST-1,sp)
 228  003b 95            	ld	xh,a
 229  003c cd0000        	call	_DS3231_SetTimeManual
 231  003f 84            	pop	a
 232                     ; 79 }
 235  0040 5b03          	addw	sp,#3
 236  0042 81            	ret
 269                     ; 84 static void sync_time_from_ds3231(void)
 269                     ; 85 {
 270                     	switch	.text
 271  0043               L51_sync_time_from_ds3231:
 275                     ; 86     ds3231_read_raw_time();
 277  0043 ad2e          	call	L71_ds3231_read_raw_time
 279                     ; 87     rtc_reorder_bytes();
 281  0045 ad36          	call	L12_rtc_reorder_bytes
 283                     ; 88     log_time_over_uart();
 285  0047 ad44          	call	L32_log_time_over_uart
 287                     ; 90     hours = bcd_to_dec(rtc_buf[0]);
 289  0049 c60001        	ld	a,L11_rtc_buf
 290  004c cd00db        	call	L72_bcd_to_dec
 292  004f c70006        	ld	L3_hours,a
 293                     ; 91     min = bcd_to_dec(rtc_buf[1]);
 295  0052 c60002        	ld	a,L11_rtc_buf+1
 296  0055 cd00db        	call	L72_bcd_to_dec
 298  0058 c70005        	ld	L5_min,a
 299                     ; 92     secs = bcd_to_dec(rtc_buf[2]);
 301  005b c60003        	ld	a,L11_rtc_buf+2
 302  005e ad7b          	call	L72_bcd_to_dec
 304  0060 c70004        	ld	L7_secs,a
 305                     ; 94     current_time.hours = hours;
 307  0063 5500060007    	mov	_current_time,L3_hours
 308                     ; 95     current_time.minutes = min;
 310  0068 5500050008    	mov	_current_time+1,L5_min
 311                     ; 96     current_time.seconds = secs;
 313  006d 5500040009    	mov	_current_time+2,L7_secs
 314                     ; 97 }
 317  0072 81            	ret
 343                     ; 102 static void ds3231_read_raw_time(void)
 343                     ; 103 {
 344                     	switch	.text
 345  0073               L71_ds3231_read_raw_time:
 349                     ; 104     DS3231_GetTime(rtc_buf, RTC_BUF_SIZE);
 351  0073 4b03          	push	#3
 352  0075 ae0001        	ldw	x,#L11_rtc_buf
 353  0078 cd0000        	call	_DS3231_GetTime
 355  007b 84            	pop	a
 356                     ; 105 }
 359  007c 81            	ret
 362                     	switch	.bss
 363  0000               L131_tmp:
 364  0000 00            	ds.b	1
 395                     ; 110 static void rtc_reorder_bytes(void)
 395                     ; 111 {
 396                     	switch	.text
 397  007d               L12_rtc_reorder_bytes:
 401                     ; 114     tmp = rtc_buf[0];
 403  007d 5500010000    	mov	L131_tmp,L11_rtc_buf
 404                     ; 115     rtc_buf[0] = rtc_buf[2];
 406  0082 5500030001    	mov	L11_rtc_buf,L11_rtc_buf+2
 407                     ; 116     rtc_buf[2] = tmp;
 409  0087 5500000003    	mov	L11_rtc_buf+2,L131_tmp
 410                     ; 117 }
 413  008c 81            	ret
 439                     ; 122 static void log_time_over_uart(void)
 439                     ; 123 {
 440                     	switch	.text
 441  008d               L32_log_time_over_uart:
 445                     ; 124     logger_write("Time: ");
 447  008d ae0016        	ldw	x,#L751
 448  0090 cd0000        	call	_logger_write
 450                     ; 125     uart_write_hex(rtc_buf[0]);
 452  0093 c60001        	ld	a,L11_rtc_buf
 453  0096 ad1d          	call	L52_uart_write_hex
 455                     ; 126     logger_write(":");
 457  0098 ae0014        	ldw	x,#L161
 458  009b cd0000        	call	_logger_write
 460                     ; 127     uart_write_hex(rtc_buf[1]);
 462  009e c60002        	ld	a,L11_rtc_buf+1
 463  00a1 ad12          	call	L52_uart_write_hex
 465                     ; 128     logger_write(":");
 467  00a3 ae0014        	ldw	x,#L161
 468  00a6 cd0000        	call	_logger_write
 470                     ; 129     uart_write_hex(rtc_buf[2]);
 472  00a9 c60003        	ld	a,L11_rtc_buf+2
 473  00ac ad07          	call	L52_uart_write_hex
 475                     ; 130     logger_write("\r\n");
 477  00ae ae0011        	ldw	x,#L361
 478  00b1 cd0000        	call	_logger_write
 480                     ; 131 }
 483  00b4 81            	ret
 486                     	switch	.data
 487  0000               L561_hex_digits:
 488  0000 0000          	dc.w	L761
 539                     ; 146 static void uart_write_hex(uint8_t val)
 539                     ; 147 {
 540                     	switch	.text
 541  00b5               L52_uart_write_hex:
 543  00b5 88            	push	a
 544  00b6 5203          	subw	sp,#3
 545       00000003      OFST:	set	3
 548                     ; 150     hex[0] = hex_digits[(val >> 4) & 0x0F];
 550  00b8 4e            	swap	a
 551  00b9 a40f          	and	a,#15
 552  00bb 5f            	clrw	x
 553  00bc 97            	ld	xl,a
 554  00bd 72d60000      	ld	a,([L561_hex_digits.w],x)
 555  00c1 6b01          	ld	(OFST-2,sp),a
 557                     ; 151     hex[1] = hex_digits[val & 0x0F];
 559  00c3 7b04          	ld	a,(OFST+1,sp)
 560  00c5 a40f          	and	a,#15
 561  00c7 5f            	clrw	x
 562  00c8 97            	ld	xl,a
 563  00c9 72d60000      	ld	a,([L561_hex_digits.w],x)
 564  00cd 6b02          	ld	(OFST-1,sp),a
 566                     ; 152     hex[2] = '\0';
 568  00cf 0f03          	clr	(OFST+0,sp)
 570                     ; 153     logger_write(hex);
 572  00d1 96            	ldw	x,sp
 573  00d2 1c0001        	addw	x,#OFST-2
 574  00d5 cd0000        	call	_logger_write
 576                     ; 154 }
 579  00d8 5b04          	addw	sp,#4
 580  00da 81            	ret
 612                     ; 165 static uint8_t bcd_to_dec(uint8_t bcd)
 612                     ; 166 {
 613                     	switch	.text
 614  00db               L72_bcd_to_dec:
 616  00db 88            	push	a
 617  00dc 88            	push	a
 618       00000001      OFST:	set	1
 621                     ; 167     return ((bcd >> 4) * 10) + (bcd & 0x0F);
 623  00dd a40f          	and	a,#15
 624  00df 6b01          	ld	(OFST+0,sp),a
 626  00e1 7b02          	ld	a,(OFST+1,sp)
 627  00e3 4e            	swap	a
 628  00e4 a40f          	and	a,#15
 629  00e6 97            	ld	xl,a
 630  00e7 a60a          	ld	a,#10
 631  00e9 42            	mul	x,a
 632  00ea 9f            	ld	a,xl
 633  00eb 1b01          	add	a,(OFST+0,sp)
 636  00ed 85            	popw	x
 637  00ee 81            	ret
 669                     ; 178 static uint8_t dec_to_bcd(uint8_t dec)
 669                     ; 179 {
 670                     	switch	.text
 671  00ef               L13_dec_to_bcd:
 673  00ef 88            	push	a
 674  00f0 88            	push	a
 675       00000001      OFST:	set	1
 678                     ; 180     return ((dec / 10) << 4) | (dec % 10);
 680  00f1 5f            	clrw	x
 681  00f2 97            	ld	xl,a
 682  00f3 a60a          	ld	a,#10
 683  00f5 62            	div	x,a
 684  00f6 5f            	clrw	x
 685  00f7 97            	ld	xl,a
 686  00f8 9f            	ld	a,xl
 687  00f9 6b01          	ld	(OFST+0,sp),a
 689  00fb 7b02          	ld	a,(OFST+1,sp)
 690  00fd 5f            	clrw	x
 691  00fe 97            	ld	xl,a
 692  00ff a60a          	ld	a,#10
 693  0101 62            	div	x,a
 694  0102 9f            	ld	a,xl
 695  0103 97            	ld	xl,a
 696  0104 a610          	ld	a,#16
 697  0106 42            	mul	x,a
 698  0107 9f            	ld	a,xl
 699  0108 1a01          	or	a,(OFST+0,sp)
 702  010a 85            	popw	x
 703  010b 81            	ret
 787                     	switch	.bss
 788  0001               L11_rtc_buf:
 789  0001 000000        	ds.b	3
 790  0004               L7_secs:
 791  0004 00            	ds.b	1
 792  0005               L5_min:
 793  0005 00            	ds.b	1
 794  0006               L3_hours:
 795  0006 00            	ds.b	1
 796                     	xref	_logger_write
 797                     	xref	_I2CInit
 798                     	xref	_DS3231_SetTimeManual
 799                     	xref	_DS3231_GetTime
 800                     	xdef	_set_time_to_clock
 801                     	xdef	_get_time_from_clock
 802                     	xdef	_clock_init
 803  0007               _current_time:
 804  0007 000000        	ds.b	3
 805                     	xdef	_current_time
 806                     .const:	section	.text
 807  0000               L761:
 808  0000 303132333435  	dc.b	"0123456789ABCDEF",0
 809  0011               L361:
 810  0011 0d0a00        	dc.b	13,10,0
 811  0014               L161:
 812  0014 3a00          	dc.b	":",0
 813  0016               L751:
 814  0016 54696d653a20  	dc.b	"Time: ",0
 834                     	end
