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
    move $s0, $sp           #save starting address of the array to $s0
    
# print input_msg
    li   $v0, 4            
    la   $a0, input_msg    
    syscall     
# initialize input count $t0         
    li   $t0, 0             
    
input_loop:
    beq  $t0, 5, end_input  # if input done
#take input
    li   $v0, 5             
    syscall               
    
#calculate address for current array position  
    sll  $t1, $t0, 2   #int(4 bits) 1 int= 4 (shift left for 2 bits)
    add  $t1, $s0, $t1      #add offset to s0, get current array address
    sw   $v0, 0($t1)   
    addi $t0, $t0, 1        # input count +1
    j    input_loop      
    
end_input:
    addi $sp, $sp, -8

# read first two element in array as parameter for the first iteration 
    move $s1, $sp           
    addi $s2, $sp, 4       
    
    move $a0, $s0           
    li   $a1, 5      #if count=$a1 end      
    move $a2, $s1          
    move $a3, $s2           
    jal  findMaxMin        
#print max
    lw   $a0, 0($s1)       # $a0 for max
    li   $v0, 1            
    syscall                
    
#print space
    li   $v0, 4            
    la   $a0, space        
    syscall                
    
#print min
    lw   $a0, 0($s2)       
    li   $v0, 1            
    syscall                
#print newline
    li   $v0, 4            
    la   $a0, newline       
    syscall              
#restore sp
    addi $sp, $sp, 28       
    
# exit
    li   $v0, 10            
    syscall                 

#------------------------- implement findMaxMin -----------------------------
findMaxMin:
    lw   $t0, 0($a0)        # $t0=arr[0]
    sw   $t0, 0($a2)        # max= first element of arr
    sw   $t0, 0($a3)        # min= first element of arr
    li   $t1, 1             # count of iteration
    
loop:
    beq  $t1, $a1, done   # if count=5, end
    sll  $t2, $t1, 2        # $t2= i * 4
    add  $t2, $a0, $t2      # $t2= &arr[i], t2 is address
    lw   $t3, 0($t2)        # $t3= arr[i], t3 is the value
    
    lw   $t4, 0($a2)        # $t4= *max (originally arr[0])
    lw   $t5, 0($a3)        # $t5= *min (originally arr[0])
    
    ble  $t3, $t4, check_min #t3<t4 then t3 not max, check if t3 min
    sw   $t3, 0($a2)      #if t3>t4 then new max is t3, save to $a2
    
check_min:
    bge  $t3, $t5, continue #if t3>t5, then t3 not min not max, next iteration
    sw   $t3, 0($a3)       #if t3<t5, then t3 is new min, save t3 to a3 and go to continue for next iteration
    
continue:
    addi $t1, $t1, 1       
    j    loop              
    
done:
    jr   $ra                