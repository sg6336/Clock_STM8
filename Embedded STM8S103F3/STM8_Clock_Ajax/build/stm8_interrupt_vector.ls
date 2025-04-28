   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.2 - 04 Jun 2024
   3                     ; Generator (Limited) V4.6.4 - 15 Jan 2025
  42                     ; 12 @far @interrupt void NonHandledInterrupt (void)
  42                     ; 13 {
  43                     	switch	.text
  44  0000               f_NonHandledInterrupt:
  48                     ; 17 	return;
  51  0000 80            	iret
  53                     .const:	section	.text
  54  0000               __vectab:
  55  0000 82            	dc.b	130
  57  0001 00            	dc.b	page(__stext)
  58  0002 0000          	dc.w	__stext
  59  0004 82            	dc.b	130
  61  0005 00            	dc.b	page(f_NonHandledInterrupt)
  62  0006 0000          	dc.w	f_NonHandledInterrupt
  63  0008 82            	dc.b	130
  65  0009 00            	dc.b	page(f_NonHandledInterrupt)
  66  000a 0000          	dc.w	f_NonHandledInterrupt
  67  000c 82            	dc.b	130
  69  000d 00            	dc.b	page(f_NonHandledInterrupt)
  70  000e 0000          	dc.w	f_NonHandledInterrupt
  71  0010 82            	dc.b	130
  73  0011 00            	dc.b	page(f_NonHandledInterrupt)
  74  0012 0000          	dc.w	f_NonHandledInterrupt
  75  0014 82            	dc.b	130
  77  0015 00            	dc.b	page(f_NonHandledInterrupt)
  78  0016 0000          	dc.w	f_NonHandledInterrupt
  79  0018 82            	dc.b	130
  81  0019 00            	dc.b	page(f_NonHandledInterrupt)
  82  001a 0000          	dc.w	f_NonHandledInterrupt
  83  001c 82            	dc.b	130
  85  001d 00            	dc.b	page(f_EXTI_PORTC_IRQHandler)
  86  001e 0000          	dc.w	f_EXTI_PORTC_IRQHandler
  87  0020 82            	dc.b	130
  89  0021 00            	dc.b	page(f_EXTI_PORTD_IRQHandler)
  90  0022 0000          	dc.w	f_EXTI_PORTD_IRQHandler
  91  0024 82            	dc.b	130
  93  0025 00            	dc.b	page(f_NonHandledInterrupt)
  94  0026 0000          	dc.w	f_NonHandledInterrupt
  95  0028 82            	dc.b	130
  97  0029 00            	dc.b	page(f_NonHandledInterrupt)
  98  002a 0000          	dc.w	f_NonHandledInterrupt
  99  002c 82            	dc.b	130
 101  002d 00            	dc.b	page(f_NonHandledInterrupt)
 102  002e 0000          	dc.w	f_NonHandledInterrupt
 103  0030 82            	dc.b	130
 105  0031 00            	dc.b	page(f_NonHandledInterrupt)
 106  0032 0000          	dc.w	f_NonHandledInterrupt
 107  0034 82            	dc.b	130
 109  0035 00            	dc.b	page(f_NonHandledInterrupt)
 110  0036 0000          	dc.w	f_NonHandledInterrupt
 111  0038 82            	dc.b	130
 113  0039 00            	dc.b	page(f_NonHandledInterrupt)
 114  003a 0000          	dc.w	f_NonHandledInterrupt
 115  003c 82            	dc.b	130
 117  003d 00            	dc.b	page(f_NonHandledInterrupt)
 118  003e 0000          	dc.w	f_NonHandledInterrupt
 119  0040 82            	dc.b	130
 121  0041 00            	dc.b	page(f_NonHandledInterrupt)
 122  0042 0000          	dc.w	f_NonHandledInterrupt
 123  0044 82            	dc.b	130
 125  0045 00            	dc.b	page(f_NonHandledInterrupt)
 126  0046 0000          	dc.w	f_NonHandledInterrupt
 127  0048 82            	dc.b	130
 129  0049 00            	dc.b	page(f_NonHandledInterrupt)
 130  004a 0000          	dc.w	f_NonHandledInterrupt
 131  004c 82            	dc.b	130
 133  004d 00            	dc.b	page(f_NonHandledInterrupt)
 134  004e 0000          	dc.w	f_NonHandledInterrupt
 135  0050 82            	dc.b	130
 137  0051 00            	dc.b	page(f_NonHandledInterrupt)
 138  0052 0000          	dc.w	f_NonHandledInterrupt
 139  0054 82            	dc.b	130
 141  0055 00            	dc.b	page(f_NonHandledInterrupt)
 142  0056 0000          	dc.w	f_NonHandledInterrupt
 143  0058 82            	dc.b	130
 145  0059 00            	dc.b	page(f_NonHandledInterrupt)
 146  005a 0000          	dc.w	f_NonHandledInterrupt
 147  005c 82            	dc.b	130
 149  005d 00            	dc.b	page(f_NonHandledInterrupt)
 150  005e 0000          	dc.w	f_NonHandledInterrupt
 151  0060 82            	dc.b	130
 153  0061 00            	dc.b	page(f_NonHandledInterrupt)
 154  0062 0000          	dc.w	f_NonHandledInterrupt
 155  0064 82            	dc.b	130
 157  0065 00            	dc.b	page(f_NonHandledInterrupt)
 158  0066 0000          	dc.w	f_NonHandledInterrupt
 159  0068 82            	dc.b	130
 161  0069 00            	dc.b	page(f_NonHandledInterrupt)
 162  006a 0000          	dc.w	f_NonHandledInterrupt
 163  006c 82            	dc.b	130
 165  006d 00            	dc.b	page(f_NonHandledInterrupt)
 166  006e 0000          	dc.w	f_NonHandledInterrupt
 167  0070 82            	dc.b	130
 169  0071 00            	dc.b	page(f_NonHandledInterrupt)
 170  0072 0000          	dc.w	f_NonHandledInterrupt
 171  0074 82            	dc.b	130
 173  0075 00            	dc.b	page(f_NonHandledInterrupt)
 174  0076 0000          	dc.w	f_NonHandledInterrupt
 175  0078 82            	dc.b	130
 177  0079 00            	dc.b	page(f_NonHandledInterrupt)
 178  007a 0000          	dc.w	f_NonHandledInterrupt
 179  007c 82            	dc.b	130
 181  007d 00            	dc.b	page(f_NonHandledInterrupt)
 182  007e 0000          	dc.w	f_NonHandledInterrupt
 233                     	xdef	__vectab
 234                     	xref	f_EXTI_PORTD_IRQHandler
 235                     	xref	f_EXTI_PORTC_IRQHandler
 236                     	xref	__stext
 237                     	xdef	f_NonHandledInterrupt
 256                     	end
