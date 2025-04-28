   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  44                     ; 17 void business_logic_loop(void)
  44                     ; 18 {
  46                     	switch	.text
  47  0000               _business_logic_loop:
  51                     ; 19     init_hardware();
  53  0000 cd0000        	call	_init_hardware
  55  0003               L32:
  56                     ; 23         handle_user_input(); // update display, log, etc.
  58  0003 ad02          	call	L3_handle_user_input
  61  0005 20fc          	jra	L32
  88                     ; 44 static void handle_user_input(void)
  88                     ; 45 {
  89                     	switch	.text
  90  0007               L3_handle_user_input:
  94                     ; 46     handle_hour_button();
  96  0007 cd0000        	call	_handle_hour_button
  98                     ; 47     handle_minute_button();
 100  000a cd0000        	call	_handle_minute_button
 102                     ; 48     handle_both_buttons();
 104  000d cd0000        	call	_handle_both_buttons
 106                     ; 50     exti_watchdog_poll(); // ← чистий виклик
 108  0010 cd0000        	call	_exti_watchdog_poll
 110                     ; 51 }
 113  0013 81            	ret
 126                     	xref	_init_hardware
 127                     	xref	_exti_watchdog_poll
 128                     	xref	_handle_both_buttons
 129                     	xref	_handle_minute_button
 130                     	xref	_handle_hour_button
 131                     	xdef	_business_logic_loop
 150                     	end
