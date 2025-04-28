   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  41                     ; 4 void main(void)
  41                     ; 5 {
  43                     	switch	.text
  44  0000               _main:
  48                     ; 6     business_logic_loop();
  50  0000 cd0000        	call	_business_logic_loop
  52                     ; 7 }
  55  0003 81            	ret
  68                     	xdef	_main
  69                     	xref	_business_logic_loop
  88                     	end
