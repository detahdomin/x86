assume cs:codesg

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983','1984','1985'
    db '1986','1987','1988','1989','1990','1991','1992','1993','1994','1995'
 
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514,345980
    dd 590827,803530,1183000,1843000,2758000,3753000,4649000,5937000
 
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
data ends

table segment
    db 21 dup ('year summ ne ?? ')
table ends

codesg segment
    start:
        mov ax,data
        mov ds,ax

        mov ax,table
        mov es,ax

        mov cx,21
        mov bx,0
        mov di,0

        s:mov si,0 ;控制table
        ;年份记录
        mov ax,ds:[di]
        mov es:[bx+si],ax
        add di,2
        add si,2
        mov ax,ds:[di]
        mov es:[bx+si],ax

        sub di,2
        add si,3 ;跳过空格

        ;收入记录
        add di,168
        mov ax,ds:[di]
        mov es:[bx+si],ax
        add di,2
        add si,2
        mov ax,ds:[di]
        mov es:[bx+si],ax

        sub di,2
        add si,3 ;跳过空格

        ;雇员数
        add di,168
        mov ax,ds:[di]
        mov es:[bx+si],ax

        add si,3 ;跳过空格
        sub si,8
        mov ax,es:[bx+si]
        add si,2
        mov dx,es:[bx+si]
        add si,3
        div sword ptr es:[bx+si]
        add si,3
        mov es:[bx+si],ax
        add si,1 ;跳过空格

        sub di,336
        add di,2
        add bx,16
        loop s

        mov ax,4c00h
        int 21h
    codesg ends
end start






