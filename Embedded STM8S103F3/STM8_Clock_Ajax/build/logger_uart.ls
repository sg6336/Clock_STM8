   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  42                     ; 10 void logger_init(void) // Initialize UART TX only, PD5, 9600 baud
  42                     ; 11 {
  44                     	switch	.text
  45  0000               _logger_init:
  49                     ; 13     uart_init(); // TX only, PD5, 9600 baud
  51  0000 cd0000        	call	_uart_init
  53                     ; 14 }
  56  0003 81            	ret
  92                     ; 16 void logger_write(const char *msg)
  92                     ; 17 {
  93                     	switch	.text
  94  0004               _logger_write:
  98                     ; 18     uart_write(msg);
 100  0004 cd0000        	call	_uart_write
 102                     ; 19 }
 105  0007 81            	ret
 118                     	xref	_uart_write
 119                     	xref	_uart_init
 120                     	xdef	_logger_write
 121                     	xdef	_logger_init
 140                     	end
