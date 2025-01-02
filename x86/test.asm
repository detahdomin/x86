assume cs:codesg,ss:stack
data segment
	db 'welcome to masm!'
	db 00000010b,00100100b,00010111b
data ends
stack segment
	db 16 dup(0)
stack ends

codesg segment
start:
	mov ax,16
	mov sp,ax
	mov ax,0b860h
	mov ds,ax
	mov ax,data
	mov es,ax
	
	mov si,0
	mov di,0
	mov cx,3
s:
	mov bx,0
	push cx
	mov cx,16
	s1:
		mov al,es:[bx]
		mov ah,es:16[si]
		mov ds:[di],ax
		
		inc bx
		add di,2
	loop s1
	
	pop cx
	inc si
	add di,080h
	loop s
	
    mov ax,4c00h
    int 21h

codesg ends
end start
