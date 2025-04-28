   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  43                     ; 10 void exti_watchdog_poll()
  43                     ; 11 {
  45                     	switch	.text
  46  0000               _exti_watchdog_poll:
  50                     ; 13     Button_Hour_EnsureInterruptEnabled();
  52  0000 cd0000        	call	_Button_Hour_EnsureInterruptEnabled
  54                     ; 14     Button_Minute_EnsureInterruptEnabled();
  56  0003 cd0000        	call	_Button_Minute_EnsureInterruptEnabled
  58                     ; 15 }
  61  0006 81            	ret
  74                     	xref	_Button_Minute_EnsureInterruptEnabled
  75                     	xref	_Button_Hour_EnsureInterruptEnabled
  76                     	xdef	_exti_watchdog_poll
  95                     	end
