.data
#images: .incbin "court_resized.bmp"
SHOT_ORDER:
	.hword 0
	.hword 1
	.hword 0
	.hword 1
	.hword 0
	.hword 0
	.hword 1
	.hword 2
	

#set up variables and adresses
.equ ADDR_JP2, 0xFF200070     # address GPIO JP2
.equ ADDR_JP2_IRQ, 0x1000      # IRQ line for GPIO JP2 (IRQ12) 
.equ ADDR_JP2_EDGE, 0xFF20007C      # address Edge Capture register GPIO JP2 


.equ ADDR_VGA, 0x08000000
.equ ADDR_CHAR, 0x09000000



# r5 used for x coord, r6 used for y coord
# r7 used for hit (1)  or not hit (0)



.global _start

_start:
	

	# /*set up stack pointer*/
	movia sp, 0x03FFFFFC /* put stack at top of SDRAM */
	movia r11, 0
	
	movia  r8, 0
	wrctl  ctl0, r8            # disable global interrupts
	
	call DRAWCOURT
	
	
	movia r2, SHOT_ORDER
	movi r1, 1
	movi r3, 2

   movia  r8, ADDR_JP2         # load address GPIO JP2 into r8
   movia  r9, 0x07f557ff       # set motor,threshold and sensors bits to output, set state and sensor valid bits to inputs
   stwio  r9, 4(r8)

# set motors off enable threshold load sensor 3 and sensor 1
  movia  r9,  0xfabeefff
  stwio  r9,  0(r8)            # store value into threshold register

# disable threshold register and enable state mode

# keep threshold value same in case update occurs before state mode is enabled
   movia  r9,  0xfadfffff
   stwio  r9,  0(r8)

# enable interrupts

    movia  r12, 0x50000000       # enable interrupts on sensor 3
    stwio  r12, 8(r8)

    movia  r8, ADDR_JP2_IRQ    # enable interrupt for GPIO JP2 (IRQ12)
    wrctl  ctl3, r8

    movia  r8, 1
    wrctl  ctl0, r8            # enable global interrupts

	
DRAW_BALL_MOVING:
	ldh r17, 0(r2)
	addi r2, r2, 2
	beq r17, r3, YOU_WON
	beq r17, r1, DRAW_LEFT
	
	
	DRAW_RIGHT:
		#call audio
		movia r11, 0
		beq r3,r11, _start
		
		call audio
		
		call DRAW_R1
		beq r3,r11, _start
		call DRAW_R2
		beq r3,r11, _start
		call DRAW_R3
		beq r3,r11, _start
		call DRAW_R4
		beq r3,r11, _start
		movia r11, 1
		call DRAW_R5
		beq r3,r11, _start
		
	
	br DRAW_BALL_MOVING
	
	DRAW_LEFT:
		movia r11, 0
		beq r3,r11, _start
		
		call audio
		
		call DRAW_L1
		beq r3,r11, _start
		call DRAW_L2
		beq r3,r11, _start
		call DRAW_L3
		beq r3,r11, _start
		call DRAW_L4
		beq r3,r11, _start
		movia r11, 1
		call DRAW_L5
		beq r3,r11, _start
		
	br DRAW_BALL_MOVING
	
	YOU_WON:
		
		call WIN
		br _start




.section .exceptions, "ax"

handler:
	#addi sp, sp, -4
	#stw ea, 0(sp)
	movia  r8, 0
	wrctl  ctl0, r8

	rdctl et, ctl4                    # check the interrupt pending register (ctl4)
	movia r8, ADDR_JP2_IRQ
	and   r8, r8, et                  # check if the pending interrupt is from GPIO JP2
	beq   r8, r0, exit_handler

	movia r8, ADDR_JP2_EDGE           # check edge capture register from GPIO JP2
	ldwio et, 0(r8)
	andhi r8, et, 0x4000              # mask bit 30 (sensor 3)
	bne r8,r0, sensor_three
	andhi r8, et, 0x1000 
	bne   r8, r0, sensor_one        	# exit if sensor 1 did not interrupt
	br exit_handler


sensor_three:

	movia r8, 1
	#bne r17,r0,you_lose #hit sensor three but should have hit sensor 1
	bne r11, r8, exit_handler #continue if correct hit
	br you_lose
	# if miss game over
	
sensor_one:
	movia r8, 1
	#beq r17,r0,you_lose #hit sensor one (left is 1) but should have hit sensor 3 (right - 0)
	bne r11, r8, exit_handler #continue if correct hit
	
you_lose:
	call LOSE
	movia r11,2
	
exit_handler:

    movia r8,ADDR_JP2_EDGE
	movi r16, 0xFFFFFFFF
    stwio r16, 0(r8) # De-assert interrupt - write to edge capture reg

	movia  r8, 1
	wrctl  ctl0, r8

	#ldw ea, 0(sp)
	#addi sp, sp, 4
	subi  ea, ea, 4
	eret