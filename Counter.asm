;	Interrupt
;	Filename:	Count.asm

;
Indf		equ	00
Timer		equ	01
PCL		equ	02
Status		equ	03
FSR		equ	04
PortA		equ	05
PortB		equ	06

IntCon		equ	0b

Numb		equ	20
Flags		equ	21

Num_Ind		equ	22
Buttons		equ	23
ButtonsM	equ	24

Dig0		equ	25
Dig1		equ	26
Dig2		equ	27
Dig3		equ	28

W_Stack		equ	2d
S_Stack		equ	2e
sec_0		equ	2f

#define 	But0M 	ButtonsM,0
#define 	But1M 	ButtonsM,1
#define 	But2M 	ButtonsM,2
#define 	But3M 	ButtonsM,3
#define		But0	Buttons,0
#define		But1	Buttons,1
#define		But2	Buttons,2
#define		But3	Buttons,3

#define		Button	PortA,4

#define		GIE	IntCon,7
#define		C	Status,0

;****************
	org	h'00'		
;****************
Reset
	call	IniPic
	call 	ClrRAM
	bsf	GIE

	goto	Main

;***************
;   Interrupt ;
	org	h'04'

	movwf	W_Stack		
	movf	Status,w	
	movwf	S_Stack		

	bcf	IntCon,2	
				
	movlw	b'001111'
	movwf	PortA		
	incf	Num_Ind		
	andwf	Num_Ind		

	movfw	Num_Ind		
	addwf	PCL			
	goto	Ld_Ind0		
	goto	Ld_Ind1
	goto	Ld_Ind2
;	goto	Ld_Ind3

Ld_Ind3	movlw	b'0111'		
	movwf	PortA		
	movfw	Dig3		
	bcf	But3		
	btfsc	Button		
	bsf	But3		

Ld_Ind2	movlw	b'1011'		
	movwf	PortA
	movfw	Dig2
	bcf	But2
	btfsc	Button
	bsf	But2
	goto	Ld_Sgm

Ld_Ind1	movlw	b'1101'		
	movwf	PortA
	movfw	Dig1
	bcf	But1
	btfsc	Button
	bsf	But1
	goto	Ld_Sgm

Ld_Ind0	movlw	b'1110'		
	movwf	PortA
	movfw	Dig0
	bcf	But0
	btfsc	Button
	bsf	But0
;	goto	Ld_Sgm
Ld_Sgm	movwf	PortB	

EndInt	movf	S_Stack,w	
	movwf	Status		
	swapf	W_Stack
	swapf	W_Stack,w
	retfie

;***************
;  Основна програма
;
Main
	call	ChkBut		
	movfw	sec_0		
	call	TblSegm
	movwf Dig0

	movlw	b'11111110'
	btfsc	But1
	andlw	b'01111111'
	movwf	Dig1

	movlw	b'11111110'
	btfsc	But2
	andlw	b'01111111'
	movwf	Dig2

	movlw	b'11111110'
	btfsc	But3
	andlw	b'01111111'
	movwf	Dig3

	goto	Main
;**********************
;*       SubRout
;**********************
IniPic
	movlw	b'010000'
	tris	PortA
	movlw	b'1111'
	movwf	PortA
	movlw	000
	tris	PortB
	movlw	b'11111111'
	movwf	PortB
	movlw	b'11010010'
	option
	movlw	b'00100000'
	movwf	IntCon
	return

ClrRAM
	movlw	Flags	
	movwf	FSR		
	movlw	d'20'	
					
	movwf	Numb
Clr1	clrf	Indf	
	incf	FSR			
	decfsz	Numb		
	goto	Clr1
	return
;
ChkBut
	btfsc	But0	
	goto	Chk_1
	bcf	But0M
	return
Chk_1
	btfsc	But0M 
	return
	bsf	But0M
	incf	sec_0	
	movlw	-d'8'
	addwf	sec_0,w
	btfsc	C			
	clrf	sec_0		
	return
;
TblSegm
	addwf PCL
	retlw b'11000000' 
	retlw b'11111001' 
	retlw b'10100100' 
	retlw b'10110000' 
	retlw b'10011001' 
	retlw b'10010010' 
	retlw b'10000010' 
	retlw b'11111000' 
	retlw b'10000000' 
	retlw b'10010000' 
	retlw b'10001000'
	retlw b'10000011' 
	retlw b'11000110' 
	retlw b'10100001' 
	retlw b'10000110' 
	retlw b'11111111' 
;***
	End
;**********************
