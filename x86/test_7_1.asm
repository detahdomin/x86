assume cs:codesg,ss:stacksg,ds:datasg

stacksg segment
    dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
    db '1. sisplay      '
    db '2. brows        '
    db '3. replace      '
    db '4. modify'
datasg ends

codesg segment
    start:mov ax,datasg
    mov ds,ax
    
    mov ax,stacksg
    mov ss,ax
    mov sp,16           ;栈地址是从高到底存储,容量空间为16,设置为16

    mov bx,0
    mov cx,4

s0: push cx
    mov si,0
    mov cx,4

s:  mov al,[bx+3+si]
    and al,11011111B
    mov [bx+3+si],al
    inc si
    loop s

    add bx,16
    pop cx
    loop s0

    mov ax,4c00H
    int 21H

codesg ends

end start