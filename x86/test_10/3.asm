assume cs:code,ds:data,ss:stack

data segment
    db 10 dup(0)
data ends

stack segment
    dw 16 dup(0)
stack ends

code segment
    start:
        mov ax,data
        mov ds,ax
        mov si,0
        mov bx,stack    ;设置栈顶
        mov ss,bx
        mov sp,20H

        mov ax,12666
        call shuzhi
        mov dh,8    ;在屏幕第几行开始显示
        mov dl,3    ;在屏幕第几列开始显示
        mov cl,2    ;显示的字符的颜色
        call show_str
 
        mov ax,4c00H    ;程序返回
        int 21H
    
    shuzhi:
        push cx;    
        push dx;
        push si;
        push bx;
        mov dx,0
        mov bx,0
    pushshuzi:
        mov cx,000AH
        call divdw
        push cx
        inc bx
        mov cx,ax    ;cx = ax = 结果的商的低16位
        add cx,dx    ;dx是结果的商的高16位，ax和dx一定都是非负数 最后一位得商0
        jcxz popshuzi
        jmp short pushshuzi
    popshuzi:
        mov cx,bx
        s1:
        pop ax
        add ax,30H
        mov ds:[si],ax
        inc si
        loop s1

        pop bx
        pop si    ;子程序结束，将寄存器的值pop出来
        pop dx;    
        pop cx;

        

    divdw:    ;功能：改进后的不会溢出的div指令
                ;参数：  ax=被除数低16位，dx=被除数高16位，cx = 除数
                ;返回：  ax=商的低16位，dx=商的高16位，cx = 余数
        
        ;计算公式： X/N = int( H/N ) * 65536 + [rem( H/N) * 65536 + L]/N  
        ;其中X为被除数，N为除数，H为被除数的高16位，L为被除数的低16位，
        ;int()表示结果的商，rem()表示结果的余数。
        
        push bx    ;bx是额外用到的寄存器，要压入栈
        
        mov bx,ax    ;bx=L
        mov ax,dx    ;ax=H
        mov dx,0    ;dx=0
        div cx        ;计算H/N，结果的商即int(H/N)保存在ax，余数即rem(H/N)保存在dx
        
                        ;接下来要计算int(H/N)*65536，思考一下，65536就是0001 0000 H，
                        ;因此计算结果就是，高16位=int(H/N)，低16位为0000H。
        
        push ax        ;将int(H/N)*65536结果的高16位，即int(H/N)，压入栈
        mov ax,0
        push ax        ;将int(H/N)*65536结果的低16位，即0000H，压入栈
        
                        ;接下来要计算 rem(H/N)*65536 ，同理可得，
                        ;计算结果为 高16位=  rem(H/N)*65536 ，即此时dx的值，
                        ;低16位为 0000H。
        
        mov ax,bx    ;ax = bx = L ，即 [rem(H/N)*65536 + L]的低16位
                        ;此时dx=rem(H/N)，可以看做 [rem(H/N)*65536 + L] 的高16位
        div cx        ;计算 [rem( H/N) * 65536 + L]/N ，结果的商保存在ax，余数保存在dx
        
                        ;接下来要将两项求和。  左边项的高、低16位都在栈中，
                        ;其中高16位就是最终结果的高16位，低16位是0000H。
                        ;右边项的商为16位，在ax中，也就是最终结果的低16位，
                        ;余数在dx中，也就是最终结果的余数。
        
        mov cx,dx    ;cx = 最终结果的余数
        pop bx        ;cx = int(H/N)*65536结果的低16位，即0000H。
        pop dx        ;bx = int(H/N)*65536结果的高16位，即最终结果的高16位
        
        pop bx    ;还原bx的值
        
        ret
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
        jcxz ok ;cl读到了0 出现了奇怪的现象
        mov cl,ds:[si]
        ; jcxz ok ;cl读到了0 出现了奇怪的现象
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