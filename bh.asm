
disp macro msg
	mov ah,09h
	lea dx,msg
	int 21h
	endm
.model small
.data
	msg1 db 10,13,"Menu $"
	msg2 db 10,13,"Enter your choice:  $"
	msg3 db 10,13,"Hex to Bcd: $"
	msg4 db 10,13,"Bcd to Hex: $"
	msg5 db 10,13,"Enter 5 digit Bcd number : $"
	msg6 db 10,13,"Enter 5 digit hex number: $"
	msg7 db 10,13,"Equivalent hex number is: $"
	msg8 db 10,13,"Equivalent Bcd number is : $"
	msg9 db 10,13,"Invalid entry $"
	msg10 db 10,13,"Exit $"
	
	
	arr dw 2710h,03E8h,0064h,000Ah,0001h
	cnt db 05h
	res dw 0000h
	op1 dw ?
	count db 00h
	.code
		bh1 proc near
		disp msg5
		lea si,arr
		mov cnt,05h
		mov res,0000h
		back: 	mov ah,01h
			int 21h
			cmp al,30h
			jb invalid1
			cmp al,39h
			jg invalid1
			cmp al,39h
			jbe next1
			sub al,07h
		next1:
			sub al,30h
			mov ah,00h
			mov cx,[si]
			mul cx
			add res,ax
			inc si
			inc si
			dec cnt
			jnz back
			disp msg7
			jmp dis
		ret1: ret
		invalid1: disp msg9
			  ret
			  bh1 endp
		bh2 proc near
		disp msg6
		mov cx,0404h
		mov dx,0000h
		back6: mov ah,01h
			int 21h
			cmp al,30h
			jb invalid
			cmp al,39h
			ja next6
			sub al,30h
			jmp below
		next6: cmp al,41h
			jb invalid
			cmp al,46h
			ja next7
			sub al,37h
			jmp below
		next7: cmp al,61h
			jb invalid
			cmp al,66h
			ja invalid
			sub al,57h
		below: rol dx,cl
			mov ah,00h
			add dx,ax
			dec ch
			jnz back6
			mov op1,dx
			disp msg8
			mov ax,op1
		up: mov dx,0000h
			mov bx,000Ah
			div bx
			push dx
			inc count
			cmp ax,0000h
			jnz up
		back5: pop dx
			add dl,30h
			mov ah,02h
			int 21h
			dec count
			jnz back5
			ret
		invalid: disp msg9
			ret
			bh2 endp
		start : mov ax,@data
			mov ds,ax
		menu : disp msg1
			disp msg3
			disp msg4
			disp msg10
			disp msg2
			mov ah,01h
			int 21h
			mov bl,al
			cmp bl,31h
			jne next
			call bh1
			jmp menu
		next : cmp bl,32h
			jne last
			call bh2
			jmp menu
		dis : mov cx,0404h
			mov bx,res
		back1 : rol bx,cl
			mov dl,bl
			and dl,0fh
			cmp dl,09h
			jbe next3
			add dl,07h
		next3 : add dl,30h
			mov ah,02h
			int 21h
			dec ch
			jnz back1
			jmp ret1
		last : mov ah,4ch
			int 21h
			end start
			end		
