
assume cs:code,ds:data,ss:stack
data segment
    db 'Welcome to masm!',0     ;要显示的字符串
data ends
 
stack segment
    dw 8 dup(0)        ;用于在调用子程序时存放寄存器值
stack ends
 
code segment
start:
    mov dh,8    ;指定行号（从0开始计数）
    mov dl,3    ;指定列号（从0开始计数）
    mov cl,2    ;指定颜色
 
    mov ax,data    ;设置ds
    mov ds,ax
    mov si,0    ;设置ds:[si]指向data段中当前要显示的字符
    mov ax,stack    ;设置栈顶
    mov ss,ax   
    mov sp,10H 
 
    call show_str    ;调用子程序，显示字符串
 
    mov ax,4c00H    ;程序返回
    int 21H
 
show_str:
    push ax
    push bx
    push dx
    push si

    mov ax,0B800H ;在汇编语言中使用这个符号0来显示未16进制
    mov es,ax

    mov ax,00A0H ;=160也就是一行的长度
    mul dh
    mov dh,0 ;dh为0 dx为3 因为dl为3
    add ax,dx
    add ax,dx
    mov bx,ax ;用来当es的偏移量

    mov al,cl 
    mov ch,0 ;防止cx中有东西
    mov si,0 ;用来给ds

    s:
    mov cl,ds:[si]
    jcxz ok ;cl读到了0 出现了奇怪的现象
    mov es:[bx],cl
    inc bx
    mov es:[bx],al
    inc bx
    inc si
    jmp short s

    ok:
        pop si
        pop dx
        pop bx
        pop ax
        ret    ;返回
code ends
end start