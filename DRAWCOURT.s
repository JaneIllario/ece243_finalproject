IMAGE:
 .incbin "court_resized.bmp"
IMAGER1:
 .incbin "right_1.bmp"
IMAGER2:
 .incbin "right_2.bmp"
IMAGER3:
 .incbin "right_3.bmp"
IMAGER4:
 .incbin "right_4.bmp"
IMAGER5:
 .incbin "right_5.bmp"
IMAGEL1:
 .incbin "left_1.bmp"
IMAGEL2:
 .incbin "left_2.bmp"
IMAGEL3:
 .incbin "left_3.bmp"
IMAGEL4:
 .incbin "left_4.bmp"
IMAGEL5:
 .incbin "left_5.bmp"
YOUWIN:
 .incbin "win.bmp"
YOULOSE:
 .incbin "lose.bmp"
 
 
.equ VGA_ADDR, 0x08000000
.equ TIMER_ADDR, 0xFF202000
.equ  TIMER0_STATUS,    0
.equ  TIMER0_CONTROL,   4
.equ  TIMER0_PERIODL,   8
.equ  TIMER0_PERIODH,   12
.equ  TIMER0_SNAPL,     16
.equ  TIMER0_SNAPH,     20
.equ  TICKS,      100000000
.equ  TICKS_END,      500000000

 
.section .text
.global DRAWCOURT

DRAWCOURT:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGE
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP:

	beq r3, r18, TIMER_RUN
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP
	
XDONE:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP
	
TIMER_RUN:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret







.section .text
.global WIN

WIN:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, YOUWIN
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_WIN:

	beq r3, r18, TIMER_RUN_WIN
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_WIN
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_WIN
	
XDONE_WIN:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_WIN
	
TIMER_RUN_WIN:

	call audio_clap


DONE_WIN:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret






.section .text
.global LOSE

LOSE:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, YOULOSE
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_LOSE:

	beq r3, r18, TIMER_RUN_LOSE
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_LOSE
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_LOSE
	
XDONE_LOSE:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_LOSE
	
TIMER_RUN_LOSE:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS_END)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS_END)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_LOSE:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_LOSE
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_LOSE:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret
	
	
	
	
	
	
.global DRAW_R1
DRAW_R1:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGER1
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_R1:

	beq r3, r18, TIMER_RUN_R1
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_R1
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_R1
	
XDONE_R1:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_R1
	
TIMER_RUN_R1:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_R1:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_R1
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_R1:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret




.global DRAW_R2
DRAW_R2:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGER2
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_R2:

	beq r3, r18, TIMER_RUN
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_R2
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_R2
	
XDONE_R2:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_R2
	
TIMER_RUN_R2:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_R2:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_R2
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_R2:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret




.global DRAW_R3
DRAW_R3:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGER3
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_R3:

	beq r3, r18, TIMER_RUN_R3
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_R3
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_R3
	
XDONE_R3:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_R3
	
TIMER_RUN_R3:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_R3:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_R3
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_R3:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret




.global DRAW_R4
DRAW_R4:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGER4
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_R4:

	beq r3, r18, TIMER_RUN_R4
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_R4
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_R4
	
XDONE_R4:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_R4
	
TIMER_RUN_R4:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_R4:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_R4
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_R4:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret





.global DRAW_R5
DRAW_R5:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGER5
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_R5:

	beq r3, r18, TIMER_RUN_R5
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_R5
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_R5
	
XDONE_R5:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_R5
	
TIMER_RUN_R5:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_R5:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_R5
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_R5:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret





.global DRAW_L1
DRAW_L1:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGEL1
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_L1:

	beq r3, r18, TIMER_RUN_L1
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_L1
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_L1
	
XDONE_L1:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_L1
	
TIMER_RUN_L1:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_L1:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_L1
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_L1:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret





.global DRAW_L2
DRAW_L2:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGEL2
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_L2:

	beq r3, r18, TIMER_RUN_L2
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_L2
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_L2
	
XDONE_L2:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_L2
	
TIMER_RUN_L2:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_L2:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_L2
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_L2:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret






.global DRAW_L3
DRAW_L3:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGEL3
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_L3:

	beq r3, r18, TIMER_RUN_L3
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_L3
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_L3
	
XDONE_L3:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_L3
	
TIMER_RUN_L3:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_L3:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_L3
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_L3:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret








.global DRAW_L4
DRAW_L4:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGEL4
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_L4:

	beq r3, r18, TIMER_RUN_L4
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_L4
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_L4
	
XDONE_L4:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_L4
	
TIMER_RUN_L4:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_L4:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_L4
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_L4:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret





.global DRAW_L5
DRAW_L5:

	addi sp, sp, -40
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r7, 20(sp)
	stw r16, 24(sp)
	stw r17, 28(sp)
	stw r18, 32(sp)
	stw ra, 36(sp)
	
	movia r5, VGA_ADDR
	movia r16, IMAGEL5
    addi r16, r16, 66
	
	#x counter
	movi r2, 0
	#y counter
	movi r3, 0
	movi r4, 0
	#x lim
    movi r17, 319 
	#y lim
    movi r18, 239
	  
DRAW_LOOP_L5:

	beq r3, r18, TIMER_RUN_L5
	
	ldhio r4, (r16)
	
	call DRAWPIXEL
	
	beq r2, r17, XDONE_L5
	addi r2, r2, 1 #one in x traversed, add 1
	
	#each pixel in image is hw, move 2
	addi r16, r16, 2
	
	br DRAW_LOOP_L5
	
XDONE_L5:

	#finished one row
	#increment y
	addi r3, r3, 1
	#move one pixel
	addi r16, r16, 2
	#reset x
	movi r2, 0
	
	br DRAW_LOOP_L5
	
TIMER_RUN_L5:

	movia r6, TIMER_ADDR
    addi  r9, r0, 0x8
    stwio r9, TIMER0_CONTROL(r6)
	
	addi  r9, r0, %lo(TICKS)
	stwio r9, TIMER0_PERIODL(r6)
    addi  r9, r0, %hi(TICKS)
    stwio r9, TIMER0_PERIODH(r6)
	addi  r9, r0, 0x6                   # 0x6 = 0110 so we write 1 to START and to CONT
	stwio r9, TIMER0_CONTROL(r6)
 
TIMER_LOOP_L5:
	ldwio r9, TIMER0_STATUS(r6) # check if the TO bit of the status register is 1
	andi r9, r9, 0x1
	beq r9, r0, TIMER_LOOP_L5
	movi r9, 0x0  # clear the TO bit
	stwio r9, TIMER0_STATUS(r6)


DONE_L5:

	#retreive reg from stack
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r7, 20(sp)
	ldw r16, 24(sp)
	ldw r17, 28(sp)
	ldw r18, 32(sp)
	ldw ra, 36(sp)
	addi sp, sp, 40

ret