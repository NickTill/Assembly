# Nicholas Tillmann
# NIT36
# preserves a0, v0
.macro print_str %str
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
.data
    display: .word 0
    operation: .word 0
.text

.globl main
main:
     # while(true) {
     print_str "Welcome to Calcy Calculator\n"
 _loop:
 		#load
		lw a0, display
		li v0, 1
		syscall
		# Calls the print
		print_str "\nOperation (=,+,-,*,/,c,q): "
		
		#take input
    		li v0, 12  
    		syscall    
    	 	sb v0, operation
    	 	
   		# load the input from user into register
		lb t0, operation
		
		#check for quit
		beq t0, 'q', _quit
		
		#check for clear
		beq t0, 'c', _clear
		
		#check for operations
		beq t0, '*', _get_operand
		beq t0, '/', _get_operand
		beq t0, '=', _get_operand
		beq t0, '+', _get_operand
		beq t0, '-', _get_operand
		print_str "\nInvalid Input\n"
		print_str "Please enter in a valid operation\n"
		j _loop
		
		_get_operand:
		print_str "Value: "
		li v0, 5
		syscall
		beq t0, '+', _add
		beq t0, '-', _sub
		beq t0, '*', _mul
		beq t0, '/', _div
		beq t0, '=', _equal
		j _loop
		
		#case =
		_equal:
		sw v0, display
		j _loop
		#case +
		_add:
		lw t1, display
		add t1, t1, v0
		sw t1, display
		j _loop
		#case -
		_sub:
		lw t1, display
		sub t1, t1, v0
		sw t1, display
		j _loop
		#case *
		_mul:
		lw t1, display
		mul t1, t1, v0
		sw t1, display
		j _loop
		#case /
		_div:
		beq v0, 0, _div_error_zero
		lw t1, display
		div t1, t1, v0
		sw t1, display
		j _loop
		
		_div_error_zero:
		print_str "Cannot divide by zero\n"
		print_str "Please enter in a valid operation\n"
		j _loop
		#case q
		_quit:
		li v0, 10
		syscall
		#case  c
		_clear:
		sw zero, display
		j _loop
		
_break:
	# }
	j _loop

