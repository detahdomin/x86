assume cs:code,ds:data,ss:stack
 
data segment  ;定义数据段
  db 0
data ends
 
stack segment ;定义栈段
  db 0
stack ends
 
code segment  ;定义代码段
start:
 
  mov ax,stack    ;设置栈顶
  mov ss,ax
  mov sp,10H
 
  mov ax,4240H    ;被除数的低16位
  mov dx,000FH    ;被除数的高16位
  mov cx,0AH    ;除数
  call divdw    ;调用子程序
 
  mov ax,4c00H          ;程序返回
  int 21H
 
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
  
code ends
end start
; assume cs:code,ss:stack

; stack segment
;     db 0
; stack ends

; code segment
; start:

;     mov ax,stack
;     mov ss,ax
;     mov sp,10H

;     mov ax,4240H
;     mov dx,000FH
;     mov cx,0AH
;     call divdw

; divdw:;功能：改进后的不会溢出的div指令
;           ;参数：  ax=被除数低16位，dx=被除数高16位，cx = 除数
;           ;返回：  ax=商的低16位，dx=商的高16位，cx = 余数
 
;   ;计算公式： X/N = int( H/N ) * 65536 + [rem( H/N) * 65536 + L]/N  
;   ;其中X为被除数，N为除数，H为被除数的高16位，L为被除数的低16位，
;   ;int()表示结果的商，rem()表示结果的余数。
;     push bx
;     mov bx,ax ;bx=L
;     mov ax,dx

;     div cx

;     push ax        ;将int(H/N)*65536结果的高16位，即int(H/N)，压入栈
;     mov ax,0
;     push ax        ;将int(H/N)*65536结果的低16位，即0000H，压入栈

;     mov ax,bx

;     div cx

;     mov cx,dx
;     pop bx
;     pop dx

;     pop bx

;     ret

; code ends
; end start
