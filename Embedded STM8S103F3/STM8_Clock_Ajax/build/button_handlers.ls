   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  12                     	switch	.data
  13  0000               L3_is_setting_time:
  14  0000 00            	dc.b	0
  57                     ; 36 void handle_hour_button()
  57                     ; 37 {
  59                     	switch	.text
  60  0000               _handle_hour_button:
  64                     ; 38     if (button_hour_is_pressed())
  66  0000 cd0000        	call	_button_hour_is_pressed
  68  0003 4d            	tnz	a
  69  0004 274b          	jreq	L52
  70                     ; 40         button_debounce(); // TODO: запихнути в button_hour_is_pressed()
  72  0006 cd0000        	call	_button_debounce
  74                     ; 42         if (button_both_is_pressed_first_hour_second_minute())
  76  0009 cd0000        	call	_button_both_is_pressed_first_hour_second_minute
  78  000c 4d            	tnz	a
  79  000d 271a          	jreq	L72
  80                     ; 44             logger_write("Both buttons are pressed after Hour button\r\n");
  82  000f ae005a        	ldw	x,#L13
  83  0012 cd0000        	call	_logger_write
  85                     ; 45             toggle_time_setting_mode();
  87  0015 cd00c2        	call	L5_toggle_time_setting_mode
  89                     ; 46             display_show_wait_indicator();
  91  0018 cd0000        	call	_display_show_wait_indicator
  93                     ; 49             button_minute_wait_release();
  95  001b cd0000        	call	_button_minute_wait_release
  97                     ; 51             button_clear_minute_flag();       // TODO: запихнути в button_minute_wait_release();
  99  001e cd0000        	call	_button_clear_minute_flag
 101                     ; 52             button_debounce();                // TODO: запихнути в button_minute_wait_release();
 103  0021 cd0000        	call	_button_debounce
 105                     ; 53             button_enable_minute_interrupt(); // TODO: запихнути в button_minute_wait_release();
 107  0024 cd0000        	call	_button_enable_minute_interrupt
 110  0027 201f          	jra	L33
 111  0029               L72:
 112                     ; 57             logger_write("Hour button pressed\r\n");
 114  0029 ae0044        	ldw	x,#L53
 115  002c cd0000        	call	_logger_write
 117                     ; 61             if (is_setting_time)
 119  002f 725d0000      	tnz	L3_is_setting_time
 120  0033 2713          	jreq	L33
 121                     ; 63                 current_time.hours++;
 123  0035 725c0000      	inc	_current_time
 124                     ; 64                 current_time.hours %= HOURS_IN_DAY;
 126  0039 c60000        	ld	a,_current_time
 127  003c 5f            	clrw	x
 128  003d 97            	ld	xl,a
 129  003e a618          	ld	a,#24
 130  0040 62            	div	x,a
 131  0041 5f            	clrw	x
 132  0042 97            	ld	xl,a
 133  0043 01            	rrwa	x,a
 134  0044 c70000        	ld	_current_time,a
 135  0047 02            	rlwa	x,a
 136  0048               L33:
 137                     ; 68         button_hour_wait_release();
 139  0048 cd0000        	call	_button_hour_wait_release
 141                     ; 69         button_debounce();              // TODO: запихнути в button_hour_wait_release();
 143  004b cd0000        	call	_button_debounce
 145                     ; 70         button_enable_hour_interrupt(); // TODO: запихнути в button_hour_wait_release();
 147  004e cd0000        	call	_button_enable_hour_interrupt
 149  0051               L52:
 150                     ; 72 }
 153  0051 81            	ret
 190                     ; 80 void handle_minute_button()
 190                     ; 81 {
 191                     	switch	.text
 192  0052               _handle_minute_button:
 196                     ; 82     if (button_minute_is_pressed())
 198  0052 cd0000        	call	_button_minute_is_pressed
 200  0055 4d            	tnz	a
 201  0056 274a          	jreq	L15
 202                     ; 84         button_debounce();
 204  0058 cd0000        	call	_button_debounce
 206                     ; 86         if (button_both_is_pressed_first_minute_second_hour())
 208  005b cd0000        	call	_button_both_is_pressed_first_minute_second_hour
 210  005e 4d            	tnz	a
 211  005f 2719          	jreq	L35
 212                     ; 88             logger_write("Both buttons are pressed after Min button\r\n");
 214  0061 ae0018        	ldw	x,#L55
 215  0064 cd0000        	call	_logger_write
 217                     ; 89             toggle_time_setting_mode();
 219  0067 ad59          	call	L5_toggle_time_setting_mode
 221                     ; 90             display_show_wait_indicator();
 223  0069 cd0000        	call	_display_show_wait_indicator
 225                     ; 93             button_hour_wait_release();
 227  006c cd0000        	call	_button_hour_wait_release
 229                     ; 95             button_clear_hour_flag();       // TODO: запихнути в button_hour_wait_release();
 231  006f cd0000        	call	_button_clear_hour_flag
 233                     ; 96             button_debounce();              // TODO: запихнути в button_hour_wait_release();
 235  0072 cd0000        	call	_button_debounce
 237                     ; 97             button_enable_hour_interrupt(); // TODO: запихнути в button_hour_wait_release();
 239  0075 cd0000        	call	_button_enable_hour_interrupt
 242  0078 201f          	jra	L75
 243  007a               L35:
 244                     ; 101             logger_write("Minute button pressed\r\n");
 246  007a ae0000        	ldw	x,#L16
 247  007d cd0000        	call	_logger_write
 249                     ; 105             if (is_setting_time)
 251  0080 725d0000      	tnz	L3_is_setting_time
 252  0084 2713          	jreq	L75
 253                     ; 107                 current_time.minutes++;
 255  0086 725c0001      	inc	_current_time+1
 256                     ; 108                 current_time.minutes %= MINUTES_IN_HOUR;
 258  008a c60001        	ld	a,_current_time+1
 259  008d 5f            	clrw	x
 260  008e 97            	ld	xl,a
 261  008f a63c          	ld	a,#60
 262  0091 62            	div	x,a
 263  0092 5f            	clrw	x
 264  0093 97            	ld	xl,a
 265  0094 01            	rrwa	x,a
 266  0095 c70001        	ld	_current_time+1,a
 267  0098 02            	rlwa	x,a
 268  0099               L75:
 269                     ; 112         button_minute_wait_release();
 271  0099 cd0000        	call	_button_minute_wait_release
 273                     ; 113         button_debounce();
 275  009c cd0000        	call	_button_debounce
 277                     ; 114         button_enable_minute_interrupt();
 279  009f cd0000        	call	_button_enable_minute_interrupt
 281  00a2               L15:
 282                     ; 116 }
 285  00a2 81            	ret
 314                     ; 118 void handle_both_buttons(void)
 314                     ; 119 {
 315                     	switch	.text
 316  00a3               _handle_both_buttons:
 320                     ; 120     if (button_both_is_released())
 322  00a3 cd0000        	call	_button_both_is_released
 324  00a6 4d            	tnz	a
 325  00a7 2718          	jreq	L57
 326                     ; 122         if (!is_setting_time)
 328  00a9 725d0000      	tnz	L3_is_setting_time
 329  00ad 2603          	jrne	L77
 330                     ; 124             get_time_from_clock(); // sync_time_from_ds3231();
 332  00af cd0000        	call	_get_time_from_clock
 334  00b2               L77:
 335                     ; 127         update_display_time(current_time.hours, current_time.minutes, current_time.seconds);
 337  00b2 3b0002        	push	_current_time+2
 338  00b5 c60001        	ld	a,_current_time+1
 339  00b8 97            	ld	xl,a
 340  00b9 c60000        	ld	a,_current_time
 341  00bc 95            	ld	xh,a
 342  00bd cd0000        	call	_update_display_time
 344  00c0 84            	pop	a
 345  00c1               L57:
 346                     ; 129 }
 349  00c1 81            	ret
 378                     ; 145 static void toggle_time_setting_mode(void)
 378                     ; 146 {
 379                     	switch	.text
 380  00c2               L5_toggle_time_setting_mode:
 384                     ; 147     is_setting_time = !is_setting_time;
 386  00c2 725d0000      	tnz	L3_is_setting_time
 387  00c6 2604          	jrne	L41
 388  00c8 a601          	ld	a,#1
 389  00ca 2001          	jra	L61
 390  00cc               L41:
 391  00cc 4f            	clr	a
 392  00cd               L61:
 393  00cd c70000        	ld	L3_is_setting_time,a
 394                     ; 148     if (is_setting_time)
 396  00d0 725d0000      	tnz	L3_is_setting_time
 397  00d4 2707          	jreq	L111
 398                     ; 150         current_time.seconds = 0;
 400  00d6 725f0002      	clr	_current_time+2
 401                     ; 151         set_brightness_display_high();
 403  00da cd0000        	call	_set_brightness_display_high
 405  00dd               L111:
 406                     ; 153     if (!is_setting_time)
 408  00dd 725d0000      	tnz	L3_is_setting_time
 409  00e1 2606          	jrne	L311
 410                     ; 155         set_time_to_clock();
 412  00e3 cd0000        	call	_set_time_to_clock
 414                     ; 156         set_brightness_display_low();
 416  00e6 cd0000        	call	_set_brightness_display_low
 418  00e9               L311:
 419                     ; 158 }
 422  00e9 81            	ret
 444                     	xref	_button_debounce
 445                     	xref	_button_enable_hour_interrupt
 446                     	xref	_button_clear_hour_flag
 447                     	xref	_button_hour_wait_release
 448                     	xref	_button_enable_minute_interrupt
 449                     	xref	_button_clear_minute_flag
 450                     	xref	_button_minute_wait_release
 451                     	xref	_button_both_is_released
 452                     	xref	_button_both_is_pressed_first_minute_second_hour
 453                     	xref	_button_both_is_pressed_first_hour_second_minute
 454                     	xref	_button_minute_is_pressed
 455                     	xref	_button_hour_is_pressed
 456                     	xref	_logger_write
 457                     	xref	_display_show_wait_indicator
 458                     	xref	_set_brightness_display_low
 459                     	xref	_set_brightness_display_high
 460                     	xref	_update_display_time
 461                     	xref	_set_time_to_clock
 462                     	xref	_get_time_from_clock
 463                     	xref	_current_time
 464                     	xdef	_handle_both_buttons
 465                     	xdef	_handle_minute_button
 466                     	xdef	_handle_hour_button
 467                     .const:	section	.text
 468  0000               L16:
 469  0000 4d696e757465  	dc.b	"Minute button pres"
 470  0012 7365640d      	dc.b	"sed",13
 471  0016 0a00          	dc.b	10,0
 472  0018               L55:
 473  0018 426f74682062  	dc.b	"Both buttons are p"
 474  002a 726573736564  	dc.b	"ressed after Min b"
 475  003c 7574746f6e0d  	dc.b	"utton",13
 476  0042 0a00          	dc.b	10,0
 477  0044               L53:
 478  0044 486f75722062  	dc.b	"Hour button presse"
 479  0056 640d          	dc.b	"d",13
 480  0058 0a00          	dc.b	10,0
 481  005a               L13:
 482  005a 426f74682062  	dc.b	"Both buttons are p"
 483  006c 726573736564  	dc.b	"ressed after Hour "
 484  007e 627574746f6e  	dc.b	"button",13
 485  0085 0a00          	dc.b	10,0
 505                     	end
