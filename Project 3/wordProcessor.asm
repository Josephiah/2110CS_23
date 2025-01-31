;; ============================================================================
;; CS 2110 - Fall 2023
;; Project 3 - wordProcessor
;; ============================================================================

;; ============================================================================


;; =============================== Part 0: main ===============================
;; This is the starting point of the assembly program.
;; It sets up the stack pointer, and then calls the wordProcess() subroutine.
;; This subroutine has been provided for you. Change which subroutine is called
;; to debug your solutions!

.orig x3000
;; Set Stack Pointer = xF000
LD R6, STACK_PTR
;; Call wordProcess(). Change the subroutine being called for your own debugging!
LD R5, SUBROUTINE_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LEA R0, TEST
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

JSRR R5
HALT
;; Use a different label above to test your subroutines. 
;; DO NOT CHANGE OR RENAME THESE!
STACK_PTR        .fill xF000
;; Change the value below to be the address you want to test! 
;; IMPORTANT: change it back to x7000 for the autograder to work!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SUBROUTINE_ADDR  .fill x7000
;TEST .stringz "ho DAD     "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.end


;; ============================ Part 1: wordLength ============================
;; DESCRIPTION:
;; This function calculates the length of a word, given the starting address of
;; the word.
;; The starting address of the word should be passed in via register R0.
;; The length of the word should be returned in register R0.
;; A word is terminated by either a space bar, a null terminator, or a newline
;; character.

;; SUGGESTED PSEUDOCODE:
;; def wordLength(R0):
;;     addr = R0
;;     length = 0
;;     while (true):
;;         if (mem[addr] == '\0'):
;;             break
;;         if (mem[addr] == '\n'):
;;             break
;;         if (mem[addr] == ' '):
;;             break
;;         addr += 1
;;         length += 1
;;     R0 = length
;;     return
.orig x3800
ADD R0, R0, 0   ;param: addr

AND R1,R1,0
AND R2,R2,0  ; length created
AND R3,R3,0  ; char created
AND R4,R4,0  ; neg-newline created
AND R5,R5,0  ; neg-space created

LEA R4, ASCII_NEWLINE_1
LDR R4, R4, 0
NOT R4, R4
ADD R4, R4, 1

LEA R5, ASCII_SPACE_1
LDR R5, R5, 0
NOT R5, R5
ADD R5, R5, 1

WHILE
LDR R3, R0, 0     ; char =  mem[addr]
ADD R3, R3, 0     ; char = char - '\0'
BRz END           ; if char == 0, end

LDR R3, R0, 0     ; char =  mem[addr]
ADD R3, R3, R4    ; char = char - '\n'
BRz END           ; if char == 0, end

LDR R3, R0, 0     ; char =  mem[addr]
ADD R3, R3, R5    ; char = char - ' '
BRz END           ; if char == 0, end

ADD R0,R0,1
ADD R2,R2,1
BR WHILE

END
AND R0, R0, 0
ADD R0, R0, R2


RET
ASCII_NEWLINE_1 .fill 10 
ASCII_SPACE_1   .fill 32 
.end 


;; ============================== Part 2: memcpy ==============================
;; DESCRIPTION: 
;; This function copies a block of memory from one location to another.
;; sourcePtr and destPtr are the starting addresses of the source and 
;; destination blocks of memory, respectively.
;; The length is the number of memory addresses to copy.
;; The sourcePtr, destPtr, and length should be passed in via registers R0, R1,
;; and R2 respectivley

;; SUGGESTED PSEUDOCODE:
;; def memcpy(R0, R1, R2):
;;     sourcePtr = R0
;;     destPtr = R1
;;     length = R2
;;     while (length > 0):
;;         mem[destPtr] = mem[sourcePtr]
;;         sourcePtr += 1
;;         destPtr += 1
;;         length -= 1
;;     return

.orig x4000
ADD R0, R0, 0 ;param: sourcePtr
ADD R1, R1, 0 ;param: destPtr
ADD R2, R2, 0 ;param: length

AND R3, R3, 0 ;sourcePtr_value is created
AND R4, R4, 0
AND R5, R5, 0

WHILE_2
ADD R2,R2,0  
BRnz END_2       ;if not length > 0, done

LDR R3, R0, 0  ;sourcePtr_value = mem[sourcePtr]
STR R3, R1, 0   ;mem[destPtr] = sourcePtr_value

ADD R0, R0, 1 ;sourcePtr++
ADD R1, R1, 1 ;destPtr++
ADD R2, R2, -1 ;lengt--
BR WHILE_2

END_2
RET
.end


;; ========================== Part 3: capitalizeLine ==========================
;; DESCRIPTION:
;; This subroutine capitalizes all the letters in a line of text. A line is 
;; terminated by either the null terminator or the newline character.
;; The starting address of the line should be passed in via register R0.
;; Keep in mind that ASCII characters that are not lowercase letters (i.e. 
;; symbols, number, etc) should not be modified!

;; SUGGESTED PSUEDOCODE:
;; def capitalizeLine(R0):
;;     addr = R0
;;     while (mem[addr] != '\0' and mem[addr] != '\n'):
;;         if (mem[addr] >= 'a' and mem[addr] <= 'z'): 
;;             mem[addr] = mem[addr] - 32 
;;         addr += 1
;;     return

.orig x4800
ADD R0, R0, 0            ;param: addr 

ADD R1, R1, 0            ;mem[addr] created
ADD R2, R2, 0            ;negative_newline created
ADD R3, R3, 0            ;negative_lowerA created 
ADD R4, R4, 0            ;negative_lowerZ created 
ADD R5, R5, 0            ;minus_32 created

LD R2, ASCII_NEWLINE_2   ;\/
NOT R2, R2               ;\/
ADD R2, R2, 1            ;negative_newline = -32

LD R3, LOWER_A           ;\/
NOT R3, R3               ;\/
ADD R3, R3, 1            ;negative_lowercaseA = -97

LD R4, LOWER_Z           ;\/
NOT R4, R4               ;\/
ADD R4, R4, 1            ;negative_lowercaseZ = -122

LD R5, MINUS_32          ;minus_32 = -32

WHILE_3
    LDR R1, R0, 0            ;\/
    ADD R1, R1, 0            ;check mem[addr]
    BRz END_3                ;if mem[addr] == 0, done
    
    LDR R1, R0, 0            ;\/
    ADD R1, R1, R2           ;check mem[addr] == '\n'
    BRz END_3                ;if mem[addr]== '\n', done
    
    IF_3
        LDR R1, R0, 0            ;\/
        ADD R1, R1, R3           ;check mem[addr] >= 'a'
        BRn THEN_3               ;if (not mem[addr] >= 'a') or (not ZP), go to then
        
        LDR R1, R0, 0            ;\/
        ADD R1, R1, R4           ;check mem[addr] == 'z'
        BRp THEN_3               ;if (not mem[addr] >= 'z') or (not NZ), go to then
    
        LDR R1, R0, 0
        ADD R1, R1, R5            ;mem[addr] - 32
        STR R1, R0, 0              ;mem[addr] = mem[addr]*
    
    THEN_3
    ADD R0, R0, 1            ;addr++
    LDR R1, R0, 0            ;mem[addr] updated
    BR WHILE_3

END_3
RET
LOWER_A         .fill 97
LOWER_Z         .fill 122
MINUS_32        .fill -32
ASCII_NEWLINE_2 .fill 10 
.end




;; =========================== Part 4: reverseWords ===========================
;; DESCRIPTION:
;; This subroutine reverses each individual word in a line of text.
;; For example, the line "Hello World" would become "olleH dlroW".
;; A line is terminated by either the null terminator or the newline character.
;; The starting address of the line should be passed in via register R0.

;; SUGGESTED PSEUDOCODE:
;; def reverseWords(R0):
;;     i = R0
;;     while (true):
;;          if (mem[i] == '\0' or mem[i] == '\n'):
;;              break
;;          if (mem[i] == ' '):
;;              i++
;;              continue
;;          start = i
;;          count = 0
;;          while (mem[i] != ' ' and mem[i] != '\0' and mem[i] != '\n'):
;;              stack.push(mem[i])
;;              i++
;;              count++
;;          i = start
;;          while (count > 0):
;;              mem[i] = stack.pop()
;;              i++
;;              count--
;;     return

.orig x5000

ADD R0, R0, 0       ;param: i

AND R1, R1, 0       ;mem[i] created
AND R2, R2, 0       ;start created
AND R3, R3, 0       ;count created
AND R4, R4, 0       ;negative_newline created
AND R5, R5, 0       ;negative_space created

LD R4, ASCII_NEWLINE_3   ;\/
NOT R4, R4               ;\/
ADD R4, R4, 1            ;negative_newline = -32

LD R5, ASCII_SPACE_2     ;\/
NOT R5, R5               ;\/
ADD R5, R5, 1            ;negative_space = -10

WHILE1_4
    LDR R1, R0, 0            ;\/
    ADD R1, R1, 0            ;check mem[addr] == 0
    BRz END_4                ;if mem[addr] == 0, done
    
    LDR R1, R0, 0            ;\/
    ADD R1, R1, R4           ;check mem[addr] == '\n'
    BRz END_4                ;if mem[addr]== '\n', done
    
    LDR R1, R0, 0            ;\/
    ADD R1, R1, R5           ;check mem[addr] == ' '
    BRnp HERE_4              ;if mem[addr] == ' ', continue\
    ADD R0, R0, 1            ;else i++
    BR WHILE1_4
    
    HERE_4
    AND R2, R2, 0            ;\/
    ADD R2, R0, 0            ;start = i
    AND R3, R3, 0            ;count = 0
    
    WHILE2_4
        LDR R1, R0, 0            ;\/
        ADD R1, R1, 0            ;check mem[addr] == 0
        BRz STOP1_4                ;if mem[addr] == 0, stop
        
        LDR R1, R0, 0            ;\/
        ADD R1, R1, R4           ;check mem[addr] == '\n'
        BRz STOP1_4                ;if mem[addr]== '\n', stop
        
        LDR R1, R0, 0            ;\/
        ADD R1, R1, R5           ;check mem[addr] == ' '
        BRz STOP1_4              ;if mem[addr] == ' ', stop
        
        LDR R1, R0, 0
        ADD R6, R6, -1           ;\/
        STR R1, R6, 0           ;stack.push(mem[i])
        ADD R0, R0, 1           ;i++
        ADD R3, R3, 1           ;count++
        BR WHILE2_4
    
    STOP1_4
    AND R0, R0, 0
    ADD R0, R2, 0               ;i = start
    
    WHILE3_4
        ADD R3, R3, 0           ;check count
        BRnz WHILE1_4           ;if not count > 0, done
        
        LDR R2, R6, 0           ;\/
        ADD R6, R6, 1           ;start = stack.pop()
        STR R2, R0, 0           ;mem[i] = start
        
        ADD R0, R0, 1           ;i++
        ADD R3, R3, -1          ;count--
        
        BR WHILE3_4
    
    BR WHILE1_4
        
    
END_4
RET
ASCII_NEWLINE_3 .fill 10 
ASCII_SPACE_2   .fill 32 
.end


;; =========================== Part 5: rightJustify ===========================
;; DESCRIPTION: 
;; This subroutine right justifies a line of text by padding with space bars.
;; For example, the line "CS2110   " would become "   CS2110". A line is 
;; terminated by either the null terminator or the newline character.
;; The starting address of the line should be passed in via register R0.

;; SUGGESTED PSEUDOCODE:
;; def rightJustify(R0):
;;    start = R0
;;    curr = start
;;    while (mem[curr] != '\n' and mem[curr] != '\0'):
;;        curr++
;;    curr--
;;    end = curr
;;    // This loop shifts over the entire string one spacebar at a time,
;;    // until it is no longer terminated by a spacebar!
;;    while (mem[end] == ' '):
;;        while (curr != start):
;;            mem[curr] = mem[curr - 1]
;;            curr--
;;        mem[curr] = ' '
;;        curr = end
;;    return

.orig x5800

ADD R0, R0, 0            ;param: start

AND R1, R1, 0            ;curr created
AND R2, R2, 0            ;mem[curr] created
AND R3, R3, 0            ;end_ created
AND R4, R4, 0            ;negative_space created
AND R5, R5, 0            ;negative_newline created

ADD R1, R0, 0            ;curr = start

LD R4, ASCII_SPACE_3     ;\/
NOT R4, R4               ;\/
ADD R4, R4, 1            ;negative_space = -32

LD R5, ASCII_NEWLINE_4   ;\/
NOT R5, R5               ;\/
ADD R5, R5, 1            ;negative_newline = -10

WHILE1_5
    LDR R2, R1, 0            ;\/
    ADD R2, R2, 0            ;check mem[addr] == 0
    BRz SKIP1_5              ;if mem[addr] == 0, skip
    
    LDR R2, R1, 0            ;\/
    ADD R2, R2, R5           ;check mem[addr] == '\n'
    BRz SKIP1_5              ;if mem[addr] == 0, skip
    
    ADD R1, R1, 1            ;curr++
    BR WHILE1_5

SKIP1_5
ADD R1, R1, -1               ;curr--

AND R3, R3, 0                ;\/
ADD R3, R1, 0                ;end_ = curr


WHILE2_5
    LDR R2, R3, 0             ;
    ADD R2, R2, R4            ;check mem[end] == ' '
    BRnp STOP2_5              ;if mem[curr] != ' ', stop
    
    WHILE3_5
        NOT R1, R1
        ADD R1, R1, 1
        ADD R1, R1, R0        ;check curr == start
        BRz STOP1_5           ;if curr == start, stop
        
        NOT R1, R1
        ADD R1, R1, 1
        ADD R1, R1, R0
        LDR R2, R1, -1        ;\/
        STR R2, R1, 0         ;mem[curr] = mem[curr-1]
        
        ADD R1, R1, -1        ;curr--
        BR WHILE3_5
    
    STOP1_5
    NOT R1, R1
    ADD R1, R1, 1
    ADD R1, R1, R0
    NOT R4, R4
    ADD R4, R4, 1
    STR R4, R1, 0             ; mem[curr] = ' '
    NOT R4, R4
    ADD R4, R4, 1
    AND R1, R1, 0             ;\/
    ADD R1, R1, R3            ;curr = end_
    
    BR WHILE2_5             

STOP2_5
RET
ASCII_SPACE_3   .fill 32
ASCII_NEWLINE_4 .fill 10
.end


;; ============================= Part 6: getInput =============================
;; DESCRIPTION: 
;; This function should read a string of characters from the keyboard and place
;; them in a buffer.
;; The address of the buffer should be passed in via register R0.
;; The string should be terminated by two consecutive '$' characters.
;; The '$' characters should not be placed in the buffer.
;; Remember to properly null-terminate your string, and to print out each 
;; character as it is typed!
;; You may assume that the user will always enter a valid input.

;; SUGGESTED PSEUDOCODE:
;; def getInput(R0):
;;      bufferPointer = R0
;;      while (true):
;;          input = GETC() 
;;          OUT(input)
;;          mem[bufferPointer] = input 
;;          if input == '$':
;;              if mem[bufferPointer - 1] == '$':
;;                  mem[bufferPointer - 1] = '\0'
;;                  break
;;          bufferPointer += 1

.orig x6000

ADD R0, R0, 0       ;param: bufferPoint

AND R1, R1, 0       ;bufferPoint is created
AND R2, R2, 0       ;mem[bufferPointer] is created
AND R3, R3, 0       ;input is created
AND R4, R4, 0       ;neg_dollarsign is created
AND R5, R5, 0

ADD R1, R0, 0       ;bufferPoint = param

LD R4, ASCII_DOLLAR_SIGN    ;\/
NOT R4, R4                  ;\/
ADD R4, R4, 1               ;neg_dollarsign = -36

WHILE_6                     ;while true
    TRAP x20                ;\/
    AND R3, R3, 0           ;\/
    ADD R3, R0, 0           ;input = GET()
    
    TRAP x21                ;OUT(input)
    
    STR R3, R1, 0            ;mem[bufferPointer] = input
    
    IF1_6
        ADD R3, R3, R4          ;check input == $
        BRnp NEXT_6             ;if input!=$, then done
    
        IF2_6
            LDR R2, R1, -1          ;mem[bufferPoint - 1] created
            ADD R2, R2, R4          ;check mem[bufferPointer - 1] == $
            BRnp NEXT_6             ;if mem[bufferPointer - 1] != $, then done
            
            AND R3, R3, 0            ;
            STR R3, R1, -1           ;mem[bufferPoint - 1] = 0
            BR END_6
    
    NEXT_6
    ADD R1, R1, 1           ;bufferPointer++
    BR WHILE_6
    
AND R3, R3, 0            ;
STR R3, R1, -3           ;mem[bufferPoint] = 0
END_6
RET
ASCII_DOLLAR_SIGN .fill 36
.end


;; ============================ Part 7: parseLines ============================
;; IMPORTANT: This method has already been implemented for you. It will help 
;; you when implementing wordProcessor!

;; Description: This subroutine parses a string of characters from an 
;; initial buffer and places the parsed string in a new buffer. 
;; This subroutine divides each line into 8 characters or less. If a word
;; cannot fully fit on the current line, trailing spaces will be added and it
;; will be placed on the next line instead.

;; The address of the buffer containing the unparsed string, as well as the 
;; address of the destination buffer should be passed in via registers R0 and
;; R1 respectively.

;; An example of what memory looks like before and after parsing:
;;  x3000 │ 'A' │               x6000 │ 'A' │  ───┐
;;  x3001 │ ' ' │               x6001 │ ' ' │     │
;;  x3002 │ 'q' │               x6002 │ 'q' │     │
;;  x3003 │ 'u' │               x6003 │ 'u' │     │ 8 characters
;;  x3004 │ 'i' │               x6004 │ 'i' │     │ (not including \n!)
;;  x3005 │ 'c' │               x6005 │ 'c' │     │
;;  x3006 │ 'k' │               x6006 │ 'k' │     │
;;  x3007 │ ' ' │               x6007 │ ' ' │  ───┘
;;  x3008 │ 'r' │               x6008 │ \n  │
;;  x3009 │ 'e' │               x6009 │ 'r' │  ───┐
;;  x300A │ 'd' │               x600A │ 'e' │     │
;;  x300B │ ' ' │               x600B │ 'd' │     │
;;  x300C │ 'k' │     ───>      x600C │ ' ' │     │ 8 characters
;;  x300D │ 'i' │               x600D │ ' ' │     │ (not including \n!)
;;  x300E │ 't' │               x600E │ ' ' │     │
;;  x300F │ 't' │               x600F │ ' ' │     │
;;  x3010 │ 'y' │               x6010 │ ' ' │  ───┘
;;  x3011 │ \0  │               x6011 │ \n  │
;;  x3012 │ \0  │               x6012 │ 'k' │  ───┐
;;  x3013 │ \0  │               x6013 │ 'i' │     │
;;  x3014 │ \0  │               x6014 │ 't' │     │
;;  x3015 │ \0  │               x6015 │ 't' │     │ 8 characters
;;  x3016 │ \0  │               x6016 │ 'y' │     │ (not including \0!)
;;  x3017 │ \0  │               x6017 │ ' ' │     │
;;  x3018 │ \0  │               x6018 │ ' ' │     │
;;  x3019 │ \0  │               x6019 │ ' ' │  ───┘
;;  x301A │ \0  │               x601A │ \0  │

;; PSEUDOCODE:
;; def parseLines(R0, R1):
;;      source = R0
;;      destination = R1
;;      currLineLen = 0
;;      while (mem[source] != '\0'):
;;          wordLen = wordLength(source)
;;          if (currLineLen + wordLen - 8 <= 0):
;;              memcpy(source, destination + currLineLen, wordLen)
;;              lineLen += wordLen
;;              if (mem[source + wordLen] == '\0'):
;;                  break 
;;              source += wordLen + 1 
;;              if (lineLen < 8):
;;                  mem[destination + lineLen] = ' '
;;                  lineLen += 1
;;          else:
;;              while (lineLen - 8 < 0):
;;                  mem[destination + lineLen] = ' '
;;                  lineLen += 1
;;              mem[destination + lineLen] = '\n'
;;              destination += lineLen + 1
;;              lineLen = 0
;;      while (lineLen - 8 < 0):
;;          mem[destination + lineLen] = ' '   
;;      mem[destination + lineLen] = '\0'
.orig x6800
;; Save RA on the stack
ADD R6, R6, -1
STR R7, R6, 0
AND R2, R2, 0 ; currLineLen = 0
PARSE_LINES_WHILE
    LDR R3, R0, 0 
    BRz EXIT_PARSE_LINES_WHILE ; mem[source] == '\0'
    ; make a wordLength(source) call
    ; Save R0-R5 on the stack
    ADD R6, R6, -1
    STR R0, R6, 0
    ADD R6, R6, -1
    STR R1, R6, 0
    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R4, R6, 0
    ADD R6, R6, -1
    STR R5, R6, 0

    LD R3, WORDLENGTH_ADDR
    JSRR R3            
    ADD R3, R0, 0 ; wordLen (R3) = wordLength(source)

    ; Restore R0-R5 from the stack!
    LDR R5, R6, 0
    ADD R6, R6, 1
    LDR R4, R6, 0
    ADD R6, R6, 1
    LDR R2, R6, 0
    ADD R6, R6, 1
    LDR R1, R6, 0
    ADD R6, R6, 1
    LDR R0, R6, 0
    ADD R6, R6, 1

    ADD R4, R2, R3 ;; R4 = currLineLen + wordLen
    ADD R4, R4, -8
    BRp PARSE_LINES_ELSE
        ;; Save R0-R5 on the stack
        ADD R6, R6, -1
        STR R0, R6, 0
        ADD R6, R6, -1
        STR R1, R6, 0
        ADD R6, R6, -1
        STR R2, R6, 0
        ADD R6, R6, -1
        STR R3, R6, 0
        ADD R6, R6, -1
        STR R4, R6, 0
        ADD R6, R6, -1
        STR R5, R6, 0

        ADD R1, R1, R2 ;; destination + currLineLen
        ADD R2, R3, 0  ;; wordLen is in R3
        LD R5, MEMCPY_ADDR
        JSRR R5 ;; memcpy(source, destination + currLineLen, wordLen)

        ;; Restore R0-R5 from the stack
        LDR R5, R6, 0
        ADD R6, R6, 1
        LDR R4, R6, 0
        ADD R6, R6, 1
        LDR R3, R6, 0
        ADD R6, R6, 1
        LDR R2, R6, 0
        ADD R6, R6, 1
        LDR R1, R6, 0
        ADD R6, R6, 1
        LDR R0, R6, 0
        ADD R6, R6, 1

        ADD R2, R2, R3 ;; lineLen += wordLen

        ; if (mem[source + wordLen] == '\0'), 
        ADD R5, R0, R3 ;; R5 = source + wordLen
        LDR R5, R5, 0 ;; R5 = mem[source + wordLen]
        BRnp LINE_HASNT_ENDED
        BR FILL_WITH_SPACES
        LINE_HASNT_ENDED

        ADD R0, R0, R3 ;; source += wordLen
        ADD R0, R0, 1 ;; source += 1

        ADD R4, R2, -8 ; if (linelen < 8):
        BRzp DONT_ADD_SPACE
            ;; Add the spacebar
            ADD R5, R1, R2 ;; R5 = destination + lineLen
            LD R4, ASCII_SPACE_4
            STR R4, R5, 0 ;; mem[destination + lineLen] = ' '
            ADD R2, R2, 1 ;; lineLen += 1
        DONT_ADD_SPACE
        BRnzp PARSE_LINES_WHILE
    PARSE_LINES_ELSE
        ;; Else clause
        PARSE_LINES_WHILE2
            ADD R4, R2, -8
            BRzp EXIT_PARSE_LINES_WHILE2
            LD R4, ASCII_SPACE_4
            ADD R5, R1, R2 ;; R5 = destination + lineLen
            STR R4, R5, 0 ;; mem[destination + lineLen] = ' '
            ADD R2, R2, 1 ;; lineLen += 1
            BRnzp PARSE_LINES_WHILE2
        EXIT_PARSE_LINES_WHILE2
        LD R4, ASCII_NEWLINE_5
        ADD R5, R1, R2 ;; R5 = destination + lineLen
        STR R4, R5, 0 ;; mem[destination + lineLen] = '\n'
        ADD R1, R1, R2 ;; destination += lineLen
        ADD R1, R1, 1 ;; destination += 1
        AND R2, R2, 0 ;; lineLen = 0
        BRnzp PARSE_LINES_WHILE
EXIT_PARSE_LINES_WHILE

;; while (lineLen - 5 < 0):
;;    mem[destination + lineLen] = ' ' 
FILL_WITH_SPACES
    ADD R4, R2, -8
    BRzp EXIT_FILL_WITH_SPACES
    LD R4, ASCII_SPACE_4
    ADD R5, R1, R2 ;; R5 = destination + lineLen
    STR R4, R5, 0 ;; mem[destination + lineLen] = ' '
    ADD R2, R2, 1 ;; lineLen += 1
BRnzp FILL_WITH_SPACES
EXIT_FILL_WITH_SPACES

AND R4, R4, 0 ;; '\0'
ADD R5, R1, R2 ;; R5 = destination + lineLen
STR R4, R5, 0 ;; mem[destination + lineLen] = '\0'

; Pop RA from the stack
LDR R7, R6, 0
ADD R6, R6, 1

RET

WORDLENGTH_ADDR .fill x3800
MEMCPY_ADDR     .fill x4000
ASCII_SPACE_4   .fill 32
ASCII_NEWLINE_5 .fill 10
.end


;; ========================== Part 8: wordProcessor ===========================
;; Implement this subroutine LAST! It will use all the other subroutines.
;; This subroutine should read in a string of characters from the keyboard and
;; write it into the buffer provided at x8000. It should then parse the string
;; into lines of 8 characters or less, and write the parsed string to the 
;; buffer provided at x8500. Finally, for each line, the user should be able to
;; select between leaving the line as is, capitalizing the line, reversing the 
;; words in the line, or right justifying the line. The final parsed string 
;; should be written to the buffer at x8500 and printed out to the console.

;; You may assume that the input will always be valid - it will not exceed the 
;; length of the buffer, no word will be longer than 8 characters, and there 
;; will not be any leading / trailing spaces!

;; An example of what correct console output looks like if the sentence typed
;; is "The quick brown fox jumps over the lazy dog", and the options entered
;; are 0, 1, 2, 3, 0, 1, 2, 3
;; Note that any characters that are not 0, 1, 2, or 3 should be ignored!

;; Expected console output:

;; The quick brown fox jumps over the lazy dog$$
;; Enter modifier options:
;; The 
;; QUICK
;; nworb
;;     fox
;; jumps
;; OVER THE
;; yzal god

;; SUGGESTED PSEUDOCODE:
;; def WordProcess():
;;      GetInput(x8000)
;;      OUT(\n)
;;      ParseLines(x8000, x8500)
;;      startOfCurrLine = x8500
;;      PUTS("Enter modifier options.\n")
;;      while (true):
;;          option = GETC()
;;          if (option == '0'):
;;              pass
;;          elif (option == '1'):
;;              CapitalizeLine(startOfCurrLine)
;;          elif (option == '2'):
;;              ReverseWords(startOfCurrLine)
;;          elif (option == '3'):
;;              RightJustify(startOfCurrLine)
;;          else:
;;              // Input is not valid, just try again:
;;              continue
;;          // Print the line after it is modified
;;          i = 0
;;          while (i < 9):
;;              OUT(mem[startOfCurrLine])
;;              startOfCurrLine++
;;              i++
;;          if (mem[startOfCurrLine - 1] == '\0'):
;;              break
;;      return
.orig x7000

AND R0, R0, 0               ;R0 
AND R1, R1, 0               ;R1 or ASCII*
AND R2, R2, 0               ;R2 or mem[startOfCurrLine]
AND R3, R3, 0               ;function
AND R4, R4, 0               ;startOfCurrLine
AND R5, R5, 0               ;option and i

LEA R5, SAVER
STR R7, R5, 7

LD R0, BUFFER_1             ;\/
LD R3, GETINPUT_ADDR        ;\/
JSRR R3                     ;getInput(x8000)

LD R0, ASCII_NEWLINE_6      ;\/
TRAP x21                    ;OUT(\n)

LD R0, BUFFER_1             ;\/ 
LD R1, BUFFER_2             ;\/
LD R3, PARSELINES_ADDR      ;\/
JSRR R3                     ;ParseLines(x8000, x8500)

LD R4, BUFFER_2             ;startOfCurrLine = x8500

LEA R0, OPTIONS_MSG         ;\/
TRAP x22                    ;PUTS("Enter modifier options.\n")

WHILE1_8                    ;\/
    TRAP x20                ;GETC()
    
    LEA R5, SAVER
    STR R0, R5, 0
    STR R1, R5, 1
    STR R2, R5, 2
    STR R3, R5, 3
    STR R4, R5, 4
    IFZERO_8
        AND R5, R5, 0           ;\/   
        ADD R5, R0, 0           ;option = GETC()
        
        LD R1, ASCII_ZERO       ;\/
        NOT R1, R1              ;\/
        ADD R1, R1, 1           ;\/
        ADD R5, R5, R1          ;\/
        BRnp ELIFONE_8          ;if option != '0', then next
    BR PASS
    
    ELIFONE_8
        AND R5, R5, 0           ;\/   
        ADD R5, R0, 0           ;option = GETC()
        
        LD R1, ASCII_ONE        ;\/
        NOT R1, R1              ;\/
        ADD R1, R1, 1           ;\/
        ADD R5, R5, R1          ;\/
        BRnp ELIFTWO_8          ;if option != '1', then next  
        
        AND R0, R0, 0
        ADD R0, R4, 0           ;\/                              
        LD R3, CAPITALIZE_ADDR  ;\/     
        JSRR R3                 ;CapitalizeLine(startOfCurrLine)
    BR PASS
    
    ELIFTWO_8
        AND R5, R5, 0           ;\/   
        ADD R5, R0, 0           ;option = GETC()
        
        LD R1, ASCII_TWO        ;\/
        NOT R1, R1              ;\/
        ADD R1, R1, 1           ;\/
        ADD R5, R5, R1          ;\/
        BRnp ELIFTHREE_8        ;if option != '2', then next
        
        AND R0, R0, 0
        ADD R0, R4, 0           ;\/                                   
        LD R3, REVERSE_ADDR     ;\/                              
        JSRR R3                 ;ReverseWords(startOfCurrLine)
    BR PASS
    
    ELIFTHREE_8
        AND R5, R5, 0                 ;\/   
        ADD R5, R0, 0                 ;option = GETC()
        
        LD R1, ASCII_THREE            ;\/
        NOT R1, R1                    ;\/
        ADD R1, R1, 1                 ;\/
        ADD R5, R5, R1                ;\/
        BRnp ELSE_8                   ;if option != '3', then next
        
        AND R0, R0, 0
        ADD R0, R4, 0           ;\/                                   
        LD R3, RIGHT_JUSTIFY_ADDR     ;\/                              
        JSRR R3                       ;RightJustify(startOfCurrLine)
    BR PASS
    
    ELSE_8
        BR WHILE1_8                    ;continue
    
    PASS
    
    
    LEA R5, SAVER
    LDR R0, R5, 0
    LDR R1, R5, 1
    LDR R2, R5, 2
    LDR R3, R5, 3
    LDR R4, R5, 4
    LDR R7, R5, 7
    
    AND R5, R5, 0                   ;i = 0

    WHILE2_8      
        ADD R5, R5, -9      ;check if i<9            
        BRzp IF_8           ;if i>=9, then done  
        ADD R5, R5, 9
        
        LDR R0, R4, 0       ;\/                      
        TRAP x21            ;OUT(mem[startofCurrLine])
        
        ADD R4, R4, 1       ;startOfCurrLine++
        ADD R5, R5, 1       ;i++
        BR WHILE2_8 
        
    IF_8
    LDR R2, R4, -1          ;\/
    ADD R2, R2, 0           ;check mem[startOfCurrLine - 1] == ’\0’
    BRz END_8               ;if mem[startOfCurrLine - 1] == ’\0’, done
    
    BR WHILE1_8
    
END_8
RET
BUFFER_1           .fill x8000
BUFFER_2           .fill x8500
GETINPUT_ADDR      .fill x6000
PARSELINES_ADDR    .fill x6800
CAPITALIZE_ADDR    .fill x4800
REVERSE_ADDR       .fill x5000
RIGHT_JUSTIFY_ADDR .fill x5800
ASCII_ZERO         .fill 48
ASCII_ONE          .fill 49
ASCII_TWO          .fill 50
ASCII_THREE        .fill 51
ASCII_NEWLINE_6    .fill 10
OPTIONS_MSG        .stringz "Enter modifier options:\n"
SAVER              .blkw 8
.end


;; x8000 Buffer
.orig x8000
.blkw 100
.end


;; x8500 Buffer
.orig x8500
.blkw 100
.end
