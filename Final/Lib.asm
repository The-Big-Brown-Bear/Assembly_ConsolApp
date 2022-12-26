; PROJECT NAME: Final Project
; AUTHOR: Derek Park & Benjamin Boden

; PURPOSE: This program will output welcome messages and then prompt the
; user either find the area of a sqaure or triangle. After indicating a 1
; or a 2 the program will then prompt the user for the neccessary information
; to calculate the area of either a triangle or a sqaure and will provide
; an appropiate output. Each time an input is recieved it is validated and
; converted from a string to an int. The area (once calcualted) is converted
; from an int to string to be outputted to the concolse.

; This is the function Library for our project
; Primary Auther: Benjmain Boden
; ------------------------------------------------


section .data
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

; some numbers:
bTen	db	10
STRLEN	equ	50


; uninitialised data:
section		.bss
chr 		resb 	1
;inLine 		resb 	STRLEN+2 	; total of 52

section .text
; ****************************************************************
; String to int

; takes a string of numbers ending in NULL = 0
; pushes from beginging to end to stack
; pops one by one off stack
; subtract 48 to get int
; multipy by powers of 10
; add to total number

;or we can say:
;"123"  -> starting from 1
;1 + 0 * 10  = 1
;2 + 1 * 10  = 12
;3 + 12 * 10 = 123

; Perameters:
; pass String via RSI
; returns -> rdi

global toInt
toInt:
    ; prolog
    push rbx
    push rax
    mov rax, 0
    
    convert:
        movzx   rbx, byte[rsi]
        cmp bl, NULL		; if at the end of string (denoted by a 0)
	    je Epolog

        sub bl, "0"
        mov bh, 0
        mul byte[bTen]	
        add ax, bx
        	

        inc rsi
        jmp convert

    Epolog:
        ;mov rdi, 0
		mov word[rdi], ax
        pop rax
        pop rbx
        ret



; *****************************************************************

; Function:
; toString()
; int to string
; usfull for printing

; About:
; convert int to string from chapter 10
; divide the total number by 10 and get the modulus untill 00000
; add 48 to modulus to get askii code
; push to stack to revers order

; Perameters:
; pass int via [RAX]
; pass string via rdi <-  Returns using this string
global toString
toString:
	push rdx			; prolog
	push rcx
	push rbx

	init:
		mov rcx, 0		; digit counter
		mov ebx, 10		; devide by 10
	divideLoop:
		mov edx, 0		; reset remainder
		div ebx			; ebx = eax/ebx mod-> edx
		push rdx
		inc rcx			; count for when its all poped off
		cmp eax, 0
		jne	divideLoop

	partB:
		; rdi points to our string
		mov rbx, 0
	
	popLoop:
		pop	rax
		add al, "0"		; AKA add 48 to rax
		mov	byte[rdi+rbx], al
		inc rbx
		loop	popLoop	; decrament ecx

		mov	byte[rdi+rbx], NULL
		inc rbx
		mov byte[rdi+rbx], LF

	exit:
		pop rbx
		pop rcx
		pop rdx		
		ret



; ********************************************************


; Generic function to display a string to the screen.
; String must be NULL terminated.
; Algorithum:
;   count characters in string (excludding NULL)
;   use syscall to output characters

; Arguments:
;   address => string, passed throug rdi
;  Returns:
;   nuthing

global cprint
    cprint:
			push    rbx         ; Prologe
			push	rdx
			
			; count the characters in string
			mov rbx, rdi        ; get address of first charicter
			mov rdx, 0
		strCountLoop:
			cmp byte[rbx], NULL
			je  strCountDone
			inc rdx             ; counter
			inc rbx             ; incrament to next string charicter
			jmp strCountLoop
		strCountDone:
			cmp rdx, 0
			je  prtDone

			; Call to OS to output string
			mov rax, SYS_write
			mov rsi, rdi        ; load rsi with string
			mov rdi, STDOUT     ; set OS to c-out
			syscall             ; call OS

		; Epolog, rturn registers to how they were
		prtDone:
			pop rdx
			pop rbx
			ret                 ; end function


; peramaters:	pointer to address to store input at RBX
; returns:		string at address passed through RBX
global cinput
	cinput:
		push r12				; prologe
		push rsi
		push rdi
		push rdx
		push rcx
		push rax

			mov r12, 0			; char count
		readCharacters:
			mov rax, SYS_read	; system code for read
			mov rdi, STDIN		; standard in
			lea rsi, byte [chr] ; address of chr
			mov rdx, 1			; count (how many to read)
			syscall 			; do syscall
			
			mov al, byte [chr]	; get character just read
			cmp al, LF			; if linefeed, input done
			je readDone
			
			inc r12				; count++
			cmp r12, STRLEN		; if # chars ≥ STRLEN
			jae readCharacters	; stop placing in buffer
			
			mov byte [rbx], al	; inLine[i] = chr
			inc rbx				; update tmpStr addr
			
			jmp readCharacters
		readDone:

			mov byte [rbx], NULL ; add NULL termination

		
		pop rax
		pop rcx
		pop rdx
		pop rdi
		pop rsi
		pop r12
		ret
