; PROJECT NAME: Final Project
; AUTHOR: Derek Park & Benjamin Boden

; PURPOSE: This program will output welcome messages and then prompt the
; user either find the area of a sqaure or triangle. After indicating a 1
; or a 2 the program will then prompt the user for the neccessary information
; to calculate the area of either a triangle or a sqaure and will provide
; an appropiate output. Each time an input is recieved it is validated and
; converted from a string to an int. The area (once calcualted) is converted
; from an int to string to be outputted to the concolse.

; This is the front-end programing for our project
; Primary Auther: Derek Park
; ------------------------------------------------

; from Lib.asm
; #include some stuff
extern cprint
extern toInt
extern toString
extern cinput


section		.data

; -----
; Define standard constants.

LF 				equ 	10 		; line feed
NULL 			equ 	0 		; end of string
TRUE 			equ 	1
FALSE 			equ 	0

EXIT_SUCCESS 	equ		0 		; success code

STDIN 			equ 	0 		; standard input
STDOUT 			equ 	1 		; standard output
STDERR 			equ 	2 		; standard error

SYS_read 		equ 	0 		; read
SYS_write 		equ 	1 		; write
SYS_open 		equ 	2 		; file open
SYS_close 		equ 	3 		; file close
SYS_fork 		equ 	57 		; fork
SYS_exit 		equ 	60 		; terminate
SYS_creat 		equ 	85 		; file open/create
SYS_time 		equ 	201 	; get time
SYS_EXIT		equ		60
EXIT_sucess		equ		1

; -----
; Define some strings. 

STRLEN			equ		50		; string length

newLine			db		LF, NULL

pmpt1			db		"1 = Square 2 = Triangle", LF, NULL
pmpt2			db		"Please enter a 1 or a 2: ", NULL

welcomeMsg1		db		"Welcome to my Final Project!", LF, NULL
welcomeMsg2		db		"Well... you made it this far", LF, NULL
welcomeMsg3		db		"so i must be doing something right.", LF, NULL

shapeData1		db		"What is the side length of the square: ", NULL
shapeData2		db		"What is the base of the triangle: ", NULL
shapeData3		db		"What is the height of the triangle: ", NULL

errorMsg1		db		"Error: invalid input", LF, NULL

output1			db		"The area of the square is: ", NULL
output2			db		"The area of a triangle is: ", NULL

; some numbers:
ddTwo	dd	2
newInt	dw	0



section		.bss
chr 		resb 	1
inLine 		resb 	STRLEN+2 	; total of 52
outLine		resb	STRLEN+2
;newInt		resw	1



; ------------------------------------------------
; MAIN PROGRAM
; ------------------------------------------------
section		.text
global _start
_start:

Initialize:						; print welcome messages
	mov		rdi, welcomeMsg1
	call 	cprint
	mov		rdi, welcomeMsg2
	call	cprint
	mov		rdi, welcomeMsg3
	call	cprint
	jmp prompt

reset:
	mov		rdi, errorMsg1		; displays error message and moves on into prompt
	call	cprint
	
prompt:							; display prompt
	mov		rdi, newLine
	call	cprint
	mov		rdi, pmpt1
	call	cprint
	mov		rdi, pmpt2
	call	cprint
	
	; -----
	; Read characters from user (one at a time)
	
	mov rbx, inLine ; inLine addr
	;
	call cinput
		
	; -----
	
	mov rsi, inLine
	mov	rdi, newInt				; moves string to rax for conversion
	call toInt
	; CONVERT STRING TO INT
	

inputLogic:
	cmp word[newInt], 1			; compares/validates inputs, valid jumps to proper label
	je square					; invalid jumps to label reset
	
	cmp word[newInt], 2			; elif rdi == 2
	je triangle					; jump
	jmp reset					; else jump
	
square:
	mov		rdi, newLine		; end message specific to square or triangle
	call	cprint
	mov rdi, shapeData1
	call	cprint
	
	; -----
	; Read characters from user (one at a time)
	
	mov rbx, inLine ; inLine addr
	call cinput
	; -----
	
	mov rsi, inLine
	mov rdi, newInt
	mov word[rdi], 0
	call toInt					; returns via RDI
	
	; STRING TO INT
	
	movzx rax, word[rdi]		; multiply to get squares area
	mul rax

	mov rdi, outLine
	call toString				; returns via rdi
	
	; INT TO STRING
	
	mov r12, rdi
	
	mov		rdi, newLine
	call	cprint
	mov		rdi, newLine		; end message specific to square
	call	cprint
	mov 	rdi, output1
	call	cprint
	mov		rdi, outLine			; prints area
	call	cprint
	mov		rdi, newLine
	call	cprint
	jmp last
	
triangle:
	mov		rdi, newLine		; display prompt
	call	cprint
	mov 	rdi, shapeData2
	call	cprint
	
	; -----
	; Read characters from user (one at a time)	
	mov rbx, inLine				; inLine addr
	call cinput					; saves to inLine
	
	mov rsi, inLine				; moves string to rax for conversion
	mov rdi, newInt
	call toInt					; converts to type INT
	
	movzx r12, word[rdi]		; BASE stored as int
	
	mov		rdi, newLine
	call	cprint
	mov 	rdi, shapeData3
	call	cprint
	
	; -----
	; Read characters from user (one at a time)
	
	mov rbx, inLine ; inLine addr
	call cinput	
	; -----
	
	mov rsi, inLine				; moves string to rax for conversion
	mov rdi, newInt
	call toInt
	
	movzx r13, word[rdi]		; HEIGHT stored as int

	mov rax, r12				; calculate triangles area
	mul r13
	div	dword[ddTwo]
	mov rdi, outLine
	call toString
	
	;mov r12, rdi				; converted string stored in r12
	
	mov		rdi, newLine		; end message specific to triangle
	call	cprint
	mov 	rdi, output2
	call	cprint
	mov		rdi, outLine			; prints area
	call 	cprint
	mov		rdi, newLine
	call	cprint
	jmp last

last:
	mov rax, SYS_EXIT
	mov rdi, EXIT_sucess
	syscall
