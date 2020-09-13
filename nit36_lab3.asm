# Nicholas Tillmann
# NIT36

# preserves a0, v0
.macro print_str %str
	# DON'T PUT ANYTHING BETWEEN .macro AND .end_macro!!
	.data
	print_str_message: .asciiz %str
	.text
	push a0
	push v0
	la a0, print_str_message
	li v0, 4
	syscall
	pop v0
	pop a0
.end_macro

# -------------------------------------------
.eqv ARR_LENGTH 5
.data
	arr: .word 100, 200, 300, 400, 500
	message: .asciiz "testing!"
.text
# -------------------------------------------
.globl main
main:
	jal input_arr
	jal print_arr
	la a0, message #called before (print chars)
	jal print_chars
	
	
	#quit
	li v0,10
	syscall
	
#print chars
 print_chars:      
      move t0, a0
      li t4, 0
      
      print_char:
      	lb t5, (t0)
      	beq t5, 0, end #branch to target 'end' if  t5 = 0
      	move a0, t5
      	li v0, 11
      	syscall
      	
      	
      	addi t4, t4, 1 #t4 = t4+1
      	addi t0, t0, 1 #t0 = t0+1
      	print_str "\n"
      	j print_char
      
      	#end target (if t5 == 0)
      	end:
      	jr ra

#print arr
  print_arr:
  li t1, 0
  
      _loop:
      	la t3, arr
      	mul t2, t1, 4
      	add t3, t3, t2
      	lw t2, (t3)
      	
      	print_str "arr[" #arr =
      	
      	li v0, 1  #value of index of array
      	move a0, t1
      	syscall
      		
      	print_str "] = 
      	
      	li v0, 1 #" #actual value of array
      	move a0, t2
      	syscall
      	
      	print_str "\n" #return new line
      	
      	add t1, t1, 1
      	blt t1, ARR_LENGTH, _loop #loop
      	
      jr ra


#input arr
input_arr: #input arr method
	_loop:
	
	print_str  "Enter Value: "
	
		li v0, 5 #read the first integer
		syscall
		la	t3, arr 
		mul	t2, t1, 4
		add	t3, t3, t2
		sw	v0, (t3)
		
		print_str"\n"
		add t1, t1,  1
		blt t1, 5, _loop
	jr ra
	
