#112550179

.data
    input_msg:  .asciiz "Enter five positive integers: "
    space:      .asciiz " "
    newline:    .asciiz "\n"

.text
.globl main

#------------------------- main -----------------------------
main:

    addi $sp, $sp, -20      #5 int arr
    move $s0, $sp           
    
# print input_msg
    li   $v0, 4            
    la   $a0, input_msg    
    syscall              
    

    li   $t0, 0             
    
input_loop:
    beq  $t0, 5, end_input  

    li   $v0, 5             
    syscall               
    
   
    sll  $t1, $t0, 2        
    add  $t1, $s0, $t1      
    sw   $v0, 0($t1)   
    
 
    addi $t0, $t0, 1        # i++
    j    input_loop      
    
end_input:
   
    addi $sp, $sp, -8      
    move $s1, $sp           
    addi $s2, $sp, 4       
    
   
    move $a0, $s0           
    li   $a1, 5            
    move $a2, $s1          
    move $a3, $s2           
    

    jal  findMaxMin        
    
 
    lw   $a0, 0($s1)       
    li   $v0, 1            
    syscall                
    

    li   $v0, 4            
    la   $a0, space        
    syscall                
    

    lw   $a0, 0($s2)       
    li   $v0, 1            
    syscall                
    
   
    li   $v0, 4            
    la   $a0, newline       
    syscall              
    

    addi $sp, $sp, 28       
    

    li   $v0, 10            
    syscall                 

#------------------------- procedure findMaxMin -----------------------------

findMaxMin:

    lw   $t0, 0($a0)        # $t0 = arr[0]
    sw   $t0, 0($a2)        # *max = arr[0]
    sw   $t0, 0($a3)        # *min = arr[0]

    li   $t1, 1             # i = 1
    
loop:

    beq  $t1, $a1, done   
    
   
    sll  $t2, $t1, 2        # $t2 = i * 4
    add  $t2, $a0, $t2      # $t2 = &arr[i]
    lw   $t3, 0($t2)        # $t3 = arr[i]
    

    lw   $t4, 0($a2)        # $t4 = *max
    lw   $t5, 0($a3)        # $t5 = *min
    

    ble  $t3, $t4, check_min 
    sw   $t3, 0($a2)      
    
check_min:

    bge  $t3, $t5, continue 
    sw   $t3, 0($a3)       
    
continue:
  
    addi $t1, $t1, 1        # i++
    j    loop              
    
done:
    jr   $ra                