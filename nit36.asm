# Nicholas Tillmann
# NIT36
.eqv INPUT_SIZE 3
.data
display: .word 0
input: .space INPUT_SIZE
.text
# THIS MACRO WILL OVERWRITE WHATEVER IS IN THE a0 AND v0 REGISTERS.
.macro print_str %str
	.data
	print_str_message: .asciiz %str
	.text
	la	a0, print_str_message
	li	v0, 4
	syscall
.end_macro

.globl main
main:
	print_str "Hello! Welcome!\n"

	_main_loop:
		# Load display value into register and print
		lw a0, display
		li v0, 1
		syscall
		# Calls the print
		print_str "\nOperation (=,+,-,*,/,c,q): "
		
		# Take input from user
		li v0, 8
		la a0, input
		li a1, INPUT_SIZE
		syscall

		# load the input from user into register
		lb t0, input
		#check for quit
		beq t0, 'q', _quit
		#check for clear
		beq t0, 'c', _clear
		#check for operations
		beq t0, '=', _get_operand
		beq t0, '+', _get_operand
		beq t0, '-', _get_operand
		beq t0, '*', _get_operand
		beq t0, '/', _get_operand
		print_str "Huh?\n "
		j _main_loop
		
		_get_operand:
		#getting the operand from the user
		print_str "Value: "
		li v0, 5
		syscall
		beq t0, '+', _add
		beq t0, '-', _sub
		beq t0, '*', _mul
		beq t0, '/', _div
		beq t0, '=', _equal

		j _main_loop
		
		_equal:
		sw v0, display
		j _main_loop

		_add:
		lw t2, display
		add t2, t2, v0
		sw t2, display
		j _main_loop

		_sub:
		lw t2, display
		sub t2, t2, v0
		sw t2, display
		j _main_loop

		_mul:
		lw t2, display
		mul t2, t2, v0
		sw t2, display
		j _main_loop

		_div:
		beq v0, 0, _div_by_zero
		lw t2, display
		div t2, t2, v0
		sw t2, display
		j _main_loop

		_div_by_zero:
		print_str "Attempting to divide by zero\n"
		j _main_loop
		
		_quit:
		li v0, 10
		syscall

		_clear:
		li t2, 0
		sw t2, display
		j _main_loop
