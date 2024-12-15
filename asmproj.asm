.model small
.data          
    menu db "Select a game:", 0Dh, 0Ah, "1.  Guessing Game", 0Dh, 0Ah, "2.  Guessing letter game", 0Dh, 0Ah,"3.  XO GAME",0dh,0Ah, "4.  encreption game", 0Dh, 0Ah, "Enter your choice: $"
    invalid_choice db "Invalid choice. Please try again.$"    
    
    prompt db "Guess a number between 0 and 9: $"
    wrong_guess db "Wrong guess, try again.$" 
    greater db "Your guess is greater than the target. Try a smaller number.$"
    smaller db "Your guess is smaller than the target. Try a greater number.$"
    correct db "Correct! You guessed it! Congratulations!$"
    gameOver db "Game Over! You've exceeded the maximum attempts.$"
    guess db 0        
    target db 5       
    newline db 0Dh, 0Ah, "$"
    header db "---------- Welcome to the Number Guessing Game! ----------$"
    game_started db 0 
    attempts db 0   
  
    game_name db "---------- Welcome to the Letter Guessing Game! ----------$" 
    line_fence db "---------------------------------------------------------$" 
    word db "ASSEMBLY", 0        
    msg_prompt db "Guess the missing letter: $"
    msg_correct db "Correct! The missing letter was: $"
    msg_wrong db "Wrong! Try again.$"
    msg_win db "You win! Congratulations!$"  
    msg_lose db "You lose! Game Over.$"   
    input db 0                 
    masked_word db "AS_EMBLY$"     
    max_attempts db 3          
    attemptss db 0
    
    new_line db 13, 10, "$"
    game_draw db "_|_|_", 13, 10
    db "_|_|_", 13, 10
    db "_|_|_", 13, 10, "$"    
    game_pointer db 9 DUP(?)  
    win_flag db 0 
    player db "0$" 
    game_start_message db "WELCOME IN XO GAME", 13, 10, "$"
    player_message db "PLAYER $"   
    win_message db " WIN!$"   
    type_message db "ENTER A NUMBER OF POSITION: $"
       
    Enc_name db "---------- Welcome to the Encryption Game! ----------$" 
    buffer db 255 dup(0)
    answer db 255 dup(0)
    encrypted db 255 dup(0) 
    prompt2 db "Enter your message: ", "$"
    prompt3 db "Enter your solution: ", "$"
    encrypted_msg db 13, 10, 'Encrypted string: $'
    msg_equal db "you WIN:)$"      
    msg_not_equal db "You LOSE !!!!$" 

.code

main proc far
    mov ax, @data
    mov ds, ax

main_menu:
    lea dx, menu
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'  
    ; Check choice and call game
    cmp al, 1
    jne skip_guessing_game
    jmp guessing_game
skip_guessing_game:
    cmp al, 2
    jne  skip_Letter_Guessing_Game
    jmp Letter_Guessing_Game
skip_Letter_Guessing_Game:
    cmp al, 3
    jne skip_xogame
    jmp xogame
skip_xogame:
    cmp al, 4
    jne invalid_choice_label
    jmp encrypt_game

invalid_choice_label:
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, invalid_choice
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    jmp main_menu
        
    lea dx, header     
    mov ah, 09h
    int 21h
    
    lea dx, newline    
    mov ah, 09h
    int 21h
;----------------------------------------------------------------------------------  
;----------------------------  Number Guessing Game -------------------------------
guessing_game:
    mov ax, 0b800H  ; b800h is used for the video memory of text mode on color displays. This is where text and attributes for the screen are stored.
    mov es, ax
    
    mov ax, 0003H   ; AX is being prepared for a BIOS interrupt call to set the video mode.
    int 10H
    
    
    lea dx, header
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, line_fence
    mov ah, 09h
    int 21h  
    
    lea dx, newline
    mov ah, 09h
    int 21h
    
    
    lea dx, prompt     
    mov ah, 09h
    int 21h
    
    lea dx, newline    
    mov ah, 09h
    int 21h

    mov byte ptr [game_started], 1

guess_number:
    mov al, [attempts]  
    cmp al, 2           
    ja gameOver_display

    mov ah, 01h     
    int 21h
    sub al, '0'        
    mov guess, al     
    mov al, [target]  
    cmp guess, al     
    je correct_guess  
    jl smaller_guess  
    jmp greater_guess  

smaller_guess:
    inc byte ptr [attempts]

    lea dx, newline    
    mov ah, 09h
    int 21h

    lea dx, smaller    
    mov ah, 09h
    int 21h

    lea dx, newline    
    mov ah, 09h
    int 21h

    jmp guess_number     ; Continue the game

greater_guess:
    inc byte ptr [attempts]

    lea dx, newline    
    mov ah, 09h
    int 21h
    
    lea dx, greater   
    mov ah, 09h
    int 21h
    
    lea dx, newline  
    mov ah, 09h
    int 21h

    jmp guess_number     ; Continue the game

correct_guess:
    lea dx, newline  
    mov ah, 09h
    int 21h
    
    lea dx, correct    
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, newline    
    mov ah, 09h
    int 21h

exit_program:
    jmp main_menu

gameOver_display:
    lea dx, newline    
    mov ah, 09h
    int 21h

    lea dx, gameOver  
    mov ah, 09h
    int 21h

    lea dx, newline    
    mov ah, 09h
    int 21h

    jmp exit_program
wrong_guess_display:
    lea dx, wrong_guess
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    jmp exit_program

;----------------------------------------------------------------------------------
;----------------------------- Letter Guessing Game -------------------------------
Letter_Guessing_Game:    
    mov ax, 0b800H
    mov es, ax
    
    mov ax, 0003H
    int 10H
    
    lea dx, game_name
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, line_fence
    mov ah, 09h
    int 21h
   
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, masked_word
    mov ah, 09h
    int 21h
    
    lea dx, newline
    mov ah, 09h
    int 21h
game_start:
    
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, msg_prompt
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    mov input, al              

    lea dx, newline
    mov ah, 09h
    int 21h

    cmp input, 'S'             
    je correct_Guess           

wrong_Guess:
    inc attemptss

    mov al, [max_attempts]     
    cmp attemptss, al           

    je game_Over               

    lea dx, msg_wrong
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    jmp game_start             

correct_Guess:
    lea dx, msg_correct
    mov ah, 09h
    int 21h
    
    lea dx, newline
    mov ah, 09h
    int 21h

    mov dl, input
    mov ah, 02h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, msg_win
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    jmp main_menu

game_Over:
    lea dx, msg_lose
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    jmp main_menu

exit_game:

    jmp main_menu 
;----------------------------------------------------------------------------
;---------------------------- Encryption Game -------------------------------
encrypt_game:
    mov ax, 0b800H
    mov es, ax
    
    mov ax, 0003H
    int 10H
    
    lea dx, Enc_name
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, line_fence
    mov ah, 09h
    int 21h  
    
     lea dx, newline
    mov ah, 09h
    int 21h
    
    
    lea dx, prompt2
    mov ah, 09h
    int 21h
    
    ; Read input
    lea si, buffer          ; Point SI to the buffer
    mov cx, 0               ; Reset character count

read_loop:
    mov ah, 01h            
    int 21h
    cmp al, 13              ; Check for Enter key (ASCII 13)
    je done_reading         
    mov [si], al            
    inc si                  
    inc cx                  
    cmp cx, 255             
    je done_reading
    jmp read_loop   

done_reading:
    mov byte ptr [si], "$"   ; Null-terminate the string
 
    
;----------------------------------------------------------> reading answer 
 ; Display the prompt3
    lea dx, prompt3
    mov ah, 09h
    int 21h
    
    lea di, answer         
    mov cx, 0              

read_answer_loop:
    mov ah, 01h            
    int 21h
    cmp al, 13              
    je done_reading_answer         
    mov [di], al            
    inc di                  
    inc cx                  
    cmp cx, 255             
    je done_reading_answer
    jmp read_answer_loop   



done_reading_answer:
    mov byte ptr [di], "$"   ; Null-terminate the string
;-----------------------------------------------------------------> done reading answer   


    
    ; Encrypt the string
    lea si, buffer          
    lea di, encrypted     

encrypt_loop:
    mov al, [si]            
    cmp al, "$"               
    je done_encrypt         

    ; Encrypt only alphabetic characters
    cmp al, 'A'
    jl skip_encrypt
    cmp al, 'Z'
    jle upper_case
    cmp al, 'a'
    jl skip_encrypt
    cmp al, 'z'
    jg skip_encrypt

lower_case:
    add al, 3               ; Shift lowercase character by 3
    cmp al, 'z'             ; Wrap around if necessary
    jle store_char
    sub al, 26              ; Wrap around if past 'z'
    jmp store_char

upper_case:
    add al, 3               
    cmp al, 'Z'            
    jle store_char
    sub al, 26              

store_char:
    mov [di], al           
    inc si                  
    inc di                  
    jmp encrypt_loop        

skip_encrypt:
    mov [di], al            ; Non-alphabetic characters remain unchanged
    inc si                  
    inc di                  
    jmp encrypt_loop       

done_encrypt:
    mov byte ptr [di], "$"    ; Null-terminate the encrypted string

    ; Print a newline
    lea dx, newline
    mov ah, 09h
    int 21h
    
    
;-------------------------------------------> compare 

    lea si, answer
    lea di, encrypted
compare_loop:
    mov al, [si]                
    mov bl, [di]                

    cmp al, bl                  
    jne not_equal               

    cmp al, 0                   
    je strings_equal            
    
    
    inc si
    inc di
    jmp compare_loop            

not_equal:
    lea dx, msg_not_equal       
    jmp print_message           

strings_equal:
    lea dx, msg_equal          

print_message:
    
    mov ah, 09h
    int 21h
    
    
    ; Print another newline
    lea dx, newline
    mov ah, 09h
    int 21h

;--------------------------------------------> done compare 

    ; Display "Encrypted string:" message
    lea dx, encrypted_msg
    mov ah, 09h
    int 21h

    ; Print the encrypted string
    lea dx, encrypted
    mov ah, 09h
    int 21h

    ; Print another newline
    lea dx, newline
    mov ah, 09h
    int 21h
    
    ; Print another newline
    lea dx, newline
    mov ah, 09h
    int 21h

    ; Back to the main menu
    jmp main_menu
;--------------------------------------------------------------------------------
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