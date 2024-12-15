.model small
.stack 128
.data   
    design0 db "    *****    *******  *******  *******   ***   ***   ******   ***      **   **  $"        
    design1 db "   *******   **       **       **        **** ****   **   **  ***      *** ***  $"            
    design2 db "  ***   ***  *******  *******  *******   *********   ******   ***       *****   $"             
    design3 db "  *********  *******  *******  *******   *** * ***   ******   ***        ***    $"             
    design4 db "  ***   ***       **       **  **        ***   ***   **   **  *******    ***    $"             
    design5 db "  ***   ***  *******  *******  *******   ***   ***   ******   *******    ***    $"             
   
    design6 db "        ******   ******       ** *******     *****     ******     *****         $"        
    design7 db "        **   **  **   **     **  **         *******    **   **   *******        $"            
    design8 db "        **   **  ******     **   *******   ***   ***   ******   ***   ***       $"             
    design9 db "        **   **  *******   **    *******   *********   *******  *********       $"             
   design10 db "        **   **  **   **  **          **   ***   ***   **   **  ***   ***       $"             
   design11 db "        ******   **   ** **      *******   ***   ***   **   **  ***   ***       $"
   
   menu db   "*SELECT GAME", 0Dh, 0Ah, "1.  Guessing Game", 0Dh, 0Ah, "2.  Guessing letter game", 0Dh, 0Ah, "3.  Encreption Game", 0Dh, 0Ah, "4.  EXIT ",0Dh, 0Ah,"Enter your choice: $"
    invalid_choice db "Invalid choice. Please try again.$"

    

    prompt db "Guess a number between 1 and 10: $"
    wrong_guess db "Wrong guess, try again.$" 
    greater db "Your guess is greater than the target. Try a smaller number.$"
    smaller db "Your guess is smaller than the target. Try a greater number.$"
    correct db "Correct! You guessed it! Congratulations!$"
    gameOver db "Game Over! You've exceeded the maximum attempts.$"
    guess db 0        
    target db 5       
    newline db 0Dh, 0Ah, "$"
    header db "--------------------- Welcome to the Number Guessing Game! ---------------------$"
    game_started db 0 
    attempts db 0     
  
    
    game_name db "--------------------- Welcome to the Letter Guessing Game! ---------------------$" 
    line_fence db "--------------------------------------------------------------------------------$" 
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
    
    Enc_name db "----------------------- Welcome to the Encryption Game! ------------------------$" 
    buffer db 255 dup(0)
    answer db 255 dup(0)
    encrypted db 255 dup(0) 
    prompt2 db "Enter a string: ", "$"
    prompt3 db "Enter your solution: ", "$"
    encrypted_msg db 13, 10, 'Encrypted string: $'
    msg_equal db "Strings are equal.$"      
    msg_not_equal db "Strings are not equal.$" 
    
    goodbye db "         GOODBYE :(","$"

.code

main proc far
    mov ax, @data
    mov ds, ax
    
    lea dx, design0
    mov ah, 09h
    int 21h
    
    lea dx, design1
    mov ah, 09h
    int 21h
    
    lea dx, design2
    mov ah, 09h
    int 21h
    
    lea dx, design3
    mov ah, 09h
    int 21h
    
    lea dx, design4
    mov ah, 09h
    int 21h
    
    lea dx, design5
    mov ah, 09h
    int 21h
    
    lea dx, newline
    mov ah, 09h
    int 21h
    
    lea dx, design6
    mov ah, 09h
    int 21h
    
    lea dx, design7
    mov ah, 09h
    int 21h
    
    lea dx, design8
    mov ah, 09h
    int 21h
    
    lea dx, design9
    mov ah, 09h
    int 21h
    
    lea dx, design10
    mov ah, 09h
    int 21h
    
    lea dx, design11
    mov ah, 09h
    int 21h
        
  
main_menu:
    lea dx, newline
    mov ah, 09h
    int 21h

  
    lea dx, menu
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'  ;convert the ASCII code of the numeric character into its actual numerical value

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
    jne exit_check
    jmp encrypt_game
exit_check:
    cmp al, 4
    jne invalid_choice_label
    jmp exit_prog

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
    
exit_prog:
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, goodbye   
    mov ah, 09h
    int 21h
    
    mov ah, 4ch
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
    
    
    lea dx, prompt     ; Load address of the prompt message
    mov ah, 09h
    int 21h
    
    lea dx, newline    ; Load address of newline
    mov ah, 09h
    int 21h

    mov byte ptr [game_started], 1

guess_number:
    mov al, [attempts]  ; Load number of attempts
    cmp al, 2           ; Compare attempts with 3
    ja gameOver_display ; If greater than 3, go to game over

    mov ah, 01h        ; Read a character from the keyboard
    int 21h
    sub al, '0'        ; Convert ASCII to integer
    mov guess, al      ; Store the guess
    mov al, [target]   ; Load target into AL
    cmp guess, al      ; Compare guess with target
    je correct_guess   ; If equal, jump to correct guess
    jl smaller_guess   ; If less, jump to "Smaller"
    jmp greater_guess  ; Otherwise, it's "Greater"

smaller_guess:
    inc byte ptr [attempts]

    lea dx, newline    
    mov ah, 09h
    int 21h

    lea dx, smaller    ; Load "Smaller!" message
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
    
    lea dx, greater    ; Load "Greater!" message
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
    
    lea dx, correct    ; Load "Correct!" message
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
    lea dx, newline    ; Print newline for spacing
    mov ah, 09h
    int 21h

    lea dx, gameOver  ; Load "Game Over!" message
    mov ah, 09h
    int 21h

    lea dx, newline    ; Print newline after game over
    mov ah, 09h
    int 21h

    jmp exit_program
wrong_guess_display:
    lea dx, wrong_guess ; Print "Wrong guess, try again"
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    jmp exit_program

;----------------------------------------------------------------------------------
;----------------------------- Letter Guessing Game -------------------------------
Letter_Guessing_Game:
    mov ax, @data
    mov ds, ax   
    
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

game_start:
    lea dx, masked_word
    mov ah, 09h
    int 21h

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

    mov ax, @data
    mov ds, ax

    
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
    
    
    ; Display the prompt
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
 ; Display the prompt
    lea dx, prompt3
    mov ah, 09h
    int 21h
      ; Read input
    lea di, answer          ; Point SI to the buffer
    mov cx, 0               ; Reset character count

read_answer_loop:
    mov ah, 01h            
    int 21h
    cmp al, 13              ; Check for Enter key (ASCII 13)
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
    mov al, [si]                ; Load character from 'answer'
    mov bl, [di]                ; Load character from 'encrypted'

    cmp al, bl                  ; Compare the characters
    jne not_equal               ; If not equal, jump to 'not_equal'

    cmp al, 0                   ; Check if end of string (null character)
    je strings_equal            ; If both strings end, they are equal

    ; Advance pointers to next character
    inc si
    inc di
    jmp compare_loop            ; Repeat the comparison

not_equal:
    lea dx, msg_not_equal       ; Load address of "not equal" message
    jmp print_message           ; Jump to print the message

strings_equal:
    lea dx, msg_equal           ; Load address of "equal" message

print_message:
    ; Print the message using DOS interrupt 21h function 09h
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
main endp         
end main
