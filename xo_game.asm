.model small
.data          

    new_line db 13, 10, "$"
    game_draw db "_|_|_", 13, 10
    db "_|_|_", 13, 10
    db "_|_|_", 13, 10, "$"    
    game_pointer db 9 DUP(?)  
    win_flag db 0 
    player db "0$" 
    line_fence db "--------------------------------------------------------------------------------$" 
    game_start_message db "WELCOME IN XO GAME", 13, 10, "$"
    player_message db "PLAYER $"   
    win_message db " WIN!$"   
    type_message db "ENTER A NUMBER OF POSITION: $"

.code

main proc far
    mov ax, @data
    mov ds, ax


xogame proc near  
    mov ax, 0b800H
    mov es, ax
    
    mov ax, 0003H
    int 10H   
    call set_game_pointer   
main_loop:  
    call clear_screen   
    
    lea dx, game_start_message 
    call print
    lea dx, line_fence 
    call print
    
    lea dx, new_line
    call print  
    lea dx, new_line
    call print      
    
    lea dx, player_message
    call print
    lea dx, player
    call print  
    
    lea dx, new_line
    call print    
    
    lea dx, game_draw
    call print    
    
    lea dx, new_line
    call print    
    
    lea dx, type_message    
    call print            
                                   
    call read_keyboard                                
    sub al, 49             
    mov bh, 0
    mov bl, al                                  
                                  
    call update_draw                                  
    call check  
         
    cmp win_flag, 1  
    jne skip
    jmp game_xoover
skip:
    call change_player    
    jmp main_loop   
change_player:   
    lea si, player    
    xor byte ptr ds:[si], 1    
    
    ret
update_draw:
    mov bl, game_pointer[bx]
    mov bh, 0
    
    lea si, player
    cmp byte ptr ds:[si], "0"  ; Compare byte at [si] with the character '0'
    je draw_x                 
    cmp byte ptr ds:[si], "1"  ; Compare byte at [si] with the character '1'
    je draw_o                 
draw_x:
    mov cl, "X"
    jmp update
draw_o:          
    mov cl, "O"  
    jmp update    
update:         
    mov ds:[bx], cl
    ret        
check:
    call check_line
    ret     
check_line:
    mov cx, 0
    
    check_line_loop:     
    cmp cx, 0
    je first_line
    
    cmp cx, 1
    je second_line
    
    cmp cx, 2
    je third_line  
    
    call check_column
    ret        
first_line:    
    mov si, 0   
    jmp do_check_line   
second_line:    
    mov si, 3
    jmp do_check_line    
third_line:    
    mov si, 6
    jmp do_check_line        
do_check_line:
    inc cx
    mov bh, 0
    mov bl, game_pointer[si]
    mov al, ds:[bx]
    cmp al, "_"
    je check_line_loop
    
    inc si
    mov bl, game_pointer[si]    
    cmp al, ds:[bx]
    jne check_line_loop 
    
    inc si
    mov bl, game_pointer[si]  
    cmp al, ds:[bx]
    jne check_line_loop
    
    mov win_flag, 1
    ret         
check_column:
    mov cx, 0
    
    check_column_loop:     
    cmp cx, 0
    je first_column
    
    cmp cx, 1
    je second_column
    
    cmp cx, 2
    je third_column  
    
    call check_diagonal
    ret        
first_column:    
    mov si, 0   
    jmp do_check_column   

second_column:    
    mov si, 1
    jmp do_check_column
    
third_column:    
    mov si, 2
    jmp do_check_column        
do_check_column:
    inc cx
    mov bh, 0
    mov bl, game_pointer[si]
    mov al, ds:[bx]
    cmp al, "_"
    je check_column_loop
    
    add si, 3
    mov bl, game_pointer[si]    
    cmp al, ds:[bx]
    jne check_column_loop 
    
    add si, 3
    mov bl, game_pointer[si]  
    cmp al, ds:[bx]
    jne check_column_loop
    
    mov win_flag, 1
    ret
check_diagonal:
    mov cx, 0
    
    check_diagonal_loop:     
    cmp cx, 0
    je first_diagonal
    
    cmp cx, 1
    je second_diagonal                            
    ret       
first_diagonal:    
    mov si, 0                
    mov dx, 4
    jmp do_check_diagonal   
second_diagonal:    
    mov si, 2
    mov dx, 2
    jmp do_check_diagonal       
do_check_diagonal:
    inc cx
    mov bh, 0
    mov bl, game_pointer[si]
    mov al, ds:[bx]
    cmp al, "_"
    je check_diagonal_loop
    
    add si, dx
    mov bl, game_pointer[si]    
    cmp al, ds:[bx]
    jne check_diagonal_loop 
    
    add si, dx
    mov bl, game_pointer[si]  
    cmp al, ds:[bx]
    jne check_diagonal_loop
    
    mov win_flag, 1
    ret  
game_xoover:        
    call clear_screen   
    
    lea dx, new_line
    call print                          
    
    lea dx, player_message
    call print
    
    lea dx, player
    call print
    
    lea dx, win_message
    call print 

    jmp fim    
set_game_pointer:
    lea si, game_draw
    lea bx, game_pointer          
    mov cx, 9      
loop_1:
    cmp cx, 6
    je add_1                
    
    cmp cx, 3
    je add_1
    
    jmp add_2     
add_1:
    add si, 1
    jmp add_2           
add_2:                                 
    mov ds:[bx], si 
    add si, 2
    inc bx
    loop loop_1 
    ret      
print:      ; print dx content 
    mov ah, 9
    int 21h   
    ret 
clear_screen:       ; get and set video mode
    mov ah, 0fh
    int 10h   
    mov ah, 0
    int 10h
    ret
read_keyboard:  ; read keyboard and return content in ah
    mov ah, 1       
    int 21h  
    ret      
fim:
    mov ax, 4c00h
    int 21h
     ret
    xogame endp
main endp         
end main
