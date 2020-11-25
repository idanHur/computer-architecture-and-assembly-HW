# Title:HW4      	id:318247822
# Author: idan hur      	

################# Data segment #####################
.data

str:  .space    33
msg1: .asciiz  "\n please enter a string (max 32 chars):\n"
msg2: .asciiz  "\n The max sequence of abc in the string is:"
msg3: .asciiz  "\n Please enter a char to look for in the string: \n"
msg4: .asciiz  "\n The number of occurrences of the char in the string is:"
msg5: .asciiz  "\n Please enter X (1-9)\n"
msg6: .asciiz  "\n The string after reduction in reverse is:\n "



################# Code segment #####################
.text
.globl main
main:	li $v0,4
	la $a0,msg1     #"please enter a string"
	syscall
	
	li $a1,32
	la $a0,str
	li $v0,8
	syscall
	la $a0,str
	li $v0,0
	jal count_abc
        li $v0,4
        la $a0,msg3
        syscall
        li $v0,12
        syscall
        la $a0,str
	jal count_char
        li $v0,4
        la $a0,msg5
        syscall 
	li $v0,5
	syscall
	la $a0,str
	add $a1,$zero,$v0
	jal delet
	la $a1,str
        li $v0,4
        la $a0 msg6
        syscall
        jal reverse
        
     
        
	
	j exit
	
read:      li $t0, 0
loop:      li $v0, 12
           syscall
           sb $v0,0($a0)
           addi $a0,$a0,1
           addi $t0,$t0,1
           blt $t0,32,loop
           jr $ra
           
            	
	
	
count_abc:            li $t0,0
loop_count_agine:     li $t3,1
loop_abc:             bge $t0,31,print_num_sequ
                      lb $t1,0($a0)
                      blt $t1,'a',break_count #if char in t1 is smaller save number of small char sequense to $v0 
                      bgt $t1 ,'z',break_count #if char in t1 is greater save number of sequence to $v0 and start count agine
                      addi $a0,$a0,1
                      addi $t0,$t0,1 #char counter
                      lb $t2,0($a0)
                      ble $t2,$t1,break_count#if next char isnt bigger stop count and 
                      addi $t3,$t3,1 #temp counter
                      j loop_abc

break_count:  addi $a0,$a0,1
              addi $t0,$t0,1 #char counter
              blt $t3,$v0,loop_count_agine
              add $v0,$zero,$t3
              j loop_count_agine
       
print_num_sequ:  add $t0,$zero,$v0
                 li $v0,4
	         la $a0,msg2
	         syscall
	         add $a0,$zero,$t0
	         li $v0,1
	         syscall 
                 jr $ra
              
count_char:      li $t1,0#equal char counter
                 li $t2,1#postion counter
count_loop:      lb $t0,0($a0)
                 bne $v0,$t0,skip_equal#if not equal skips counter pramote
                 addi $t1,$t1,1 #if equal pramote char counter
skip_equal:      addi $a0,$a0,1 #pramote to next char
                 addi $t2,$t2,1#pramote position counter
                 blt $t2,32,count_loop
                 li $v0,4
	         la $a0,msg4
	         syscall
	         add $a0,$zero,$t1
	         li $v0,1
	         syscall
                 jr $ra
 
         
                 
                         
                                 
                                                 
                                                 
delet:           li $t0,0
                 add $t1,$zero,$a0#to save original address
                 add $t3,$zero,$a0
                 addi $t0,$a1,-1#first time index need to be reduced by 1 to represent position
                 addi $a1,$a1,-1
first:           add $a0,$a0,$t0
                 add $t3,$t3,$t0#first undex address
                 addi $t4,$t0,1#next delet index
                 add $t2,$t0,$zero#curent position caunter
                 add $t4,$t4,$a1#next delet index
                 addi $t0,$t0,1#pramote currant index counter
                 addi $t3,$t3,1#pramote next index address
loop_delet:      lb $t5,0($t3)
                 sb $t5,0($a0)
                 addi $t3,$t3,1 #$t3 byte to move
                 addi $a0,$a0,1 #where to store
                 addi $t0,$t0,1 #current index counter pramote
                 addi $t2,$t2,1
                 beq $t0,32,remove
                 beqz $a1,loop_delet
                 beq $t0,$t4,pramote
                 j loop_delet
                 
pramote:        addi $t3,$t3,1#pramote to next char addres becouse reached next delet
                add $t4,$t4,$a1 #pramote counter to next position
                beq $t0,32,remove
                j loop_delet

remove:         li $t3,32
                addi $a1,$a1,1#number of which position to delet from user
                divu $t3,$a1#cheack to know how many numbers got deletet
                mflo $t3
                li $t2,32
                sub $t2,$t2,$t3#from where need to delet is end minus how many numbers got delet
                add $t1,$t1,$t2#addres of where to start
                li $t0, ' '
loop_remove:    sb $t0,0($t1)
                addi $t1,$t1,1#pramote to next address
                addi $t2,$t2,1#pramote position counter
                blt $t2,32 loop_remove
                jr $ra


reverse:        li $t0, ' '
                li $v0,11
                li $t1,32#char counter from max to min
                addi $a1,$a1,31#initalize to end of string
loop_reverse:   lb $a0,0,($a1)
                subi $a1,$a1,1#pramote to next char from end to start
                subi $t1,$t1,1#reduce counter to new position
                beq $a0,$t0,loop_reverse#if char at position is not a char load next char
                syscall
                bgt $t1,$zero,loop_reverse#if not reach to start of string from end dont stop
                jr $ra
                
                
               






exit:   li $v0,10
	syscall
