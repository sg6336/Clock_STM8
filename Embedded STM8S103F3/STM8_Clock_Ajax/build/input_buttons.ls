   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  42                     ; 11 void input_init() // Initialize buttons PC3 and PD2
  42                     ; 12 {
  44                     	switch	.text
  45  0000               _input_init:
  49                     ; 14     Buttons_Init(); // PC3 and PD2
  51  0000 cd0000        	call	_Buttons_Init
  53                     ; 15 }
  56  0003 81            	ret
  81                     ; 17 uint8_t button_hour_is_pressed(void)
  81                     ; 18 {
  82                     	switch	.text
  83  0004               _button_hour_is_pressed:
  87                     ; 19     return Button_HourPressed();
  89  0004 cd0000        	call	_Button_HourPressed
  93  0007 81            	ret
 118                     ; 22 uint8_t button_minute_is_pressed(void)
 118                     ; 23 {
 119                     	switch	.text
 120  0008               _button_minute_is_pressed:
 124                     ; 24     return Button_MinutePressed();
 126  0008 cd0000        	call	_Button_MinutePressed
 130  000b 81            	ret
 156                     ; 27 uint8_t button_both_is_pressed_first_hour_second_minute(void)
 156                     ; 28 {
 157                     	switch	.text
 158  000c               _button_both_is_pressed_first_hour_second_minute:
 162                     ; 29     return Button_BothPressed_FirstMinute_SecondHour_WaitRelease();
 164  000c cd0000        	call	_Button_BothPressed_FirstMinute_SecondHour_WaitRelease
 168  000f 81            	ret
 194                     ; 32 uint8_t button_both_is_pressed_first_minute_second_hour(void)
 194                     ; 33 {
 195                     	switch	.text
 196  0010               _button_both_is_pressed_first_minute_second_hour:
 200                     ; 34     return Button_BothPressed_FirstMinute_SecondHour_WaitRelease();
 202  0010 cd0000        	call	_Button_BothPressed_FirstMinute_SecondHour_WaitRelease
 206  0013 81            	ret
 231                     ; 37 uint8_t button_both_is_released()
 231                     ; 38 {
 232                     	switch	.text
 233  0014               _button_both_is_released:
 237                     ; 39     return Button_BothReleased();
 239  0014 cd0000        	call	_Button_BothReleased
 243  0017 81            	ret
 268                     ; 42 void button_minute_wait_release()
 268                     ; 43 {
 269                     	switch	.text
 270  0018               _button_minute_wait_release:
 274                     ; 44     Button_Minute_WaitRelease();
 276  0018 cd0000        	call	_Button_Minute_WaitRelease
 278                     ; 45 }
 281  001b 81            	ret
 306                     ; 47 void button_clear_minute_flag() // TODO: запихнути в button_minute_wait_release();
 306                     ; 48 {
 307                     	switch	.text
 308  001c               _button_clear_minute_flag:
 312                     ; 49     Button_MinutePressed(); // clear flag if still set
 314  001c cd0000        	call	_Button_MinutePressed
 316                     ; 50 }
 319  001f 81            	ret
 344                     ; 52 void button_enable_minute_interrupt() // TODO: запихнути в button_minute_wait_release();
 344                     ; 53 {
 345                     	switch	.text
 346  0020               _button_enable_minute_interrupt:
 350                     ; 54     Button_Minute_EnableInterrupt();
 352  0020 cd0000        	call	_Button_Minute_EnableInterrupt
 354                     ; 55 }
 357  0023 81            	ret
 382                     ; 62 void button_hour_wait_release()
 382                     ; 63 {
 383                     	switch	.text
 384  0024               _button_hour_wait_release:
 388                     ; 64     Button_Hour_WaitRelease();
 390  0024 cd0000        	call	_Button_Hour_WaitRelease
 392                     ; 65 }
 395  0027 81            	ret
 420                     ; 67 void button_clear_hour_flag(void) // TODO: запихнути в button_hour_wait_release();
 420                     ; 68 {
 421                     	switch	.text
 422  0028               _button_clear_hour_flag:
 426                     ; 69     Button_HourPressed(); // clear flag if still set
 428  0028 cd0000        	call	_Button_HourPressed
 430                     ; 70 }
 433  002b 81            	ret
 458                     ; 72 void button_enable_hour_interrupt(void) // TODO: запихнути в button_hour_wait_release();
 458                     ; 73 {
 459                     	switch	.text
 460  002c               _button_enable_hour_interrupt:
 464                     ; 74     Button_Hour_EnableInterrupt();
 466  002c cd0000        	call	_Button_Hour_EnableInterrupt
 468                     ; 75 }
 471  002f 81            	ret
 495                     ; 77 void button_debounce() // TODO: запихнути в button_hour_wait_release(); та button_minute_wait_release();
 495                     ; 78 {
 496                     	switch	.text
 497  0030               _button_debounce:
 501                     ; 79     delay_ms(100);
 503  0030 ae0064        	ldw	x,#100
 504  0033 cd0000        	call	_delay_ms
 506                     ; 80 }
 509  0036 81            	ret
 522                     	xref	_delay_ms
 523                     	xdef	_button_debounce
 524                     	xdef	_button_enable_hour_interrupt
 525                     	xdef	_button_clear_hour_flag
 526                     	xdef	_button_hour_wait_release
 527                     	xdef	_button_enable_minute_interrupt
 528                     	xdef	_button_clear_minute_flag
 529                     	xdef	_button_minute_wait_release
 530                     	xdef	_button_both_is_released
 531                     	xdef	_button_both_is_pressed_first_minute_second_hour
 532                     	xdef	_button_both_is_pressed_first_hour_second_minute
 533                     	xdef	_button_minute_is_pressed
 534                     	xdef	_button_hour_is_pressed
 535                     	xdef	_input_init
 536                     	xref	_Button_BothReleased
 537                     	xref	_Button_BothPressed_FirstMinute_SecondHour_WaitRelease
 538                     	xref	_Button_Minute_WaitRelease
 539                     	xref	_Button_Hour_WaitRelease
 540                     	xref	_Button_Hour_EnableInterrupt
 541                     	xref	_Button_Minute_EnableInterrupt
 542                     	xref	_Button_MinutePressed
 543                     	xref	_Button_HourPressed
 544                     	xref	_Buttons_Init
 563                     	end
