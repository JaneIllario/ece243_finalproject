
CLAPPING:
	.incbin "49331__gregf__applause.wav"

SOUND_CLIP:
	.incbin "tennis_sound.wav"
	

.global audio
audio:
	
	addi sp, sp, -24
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r9, 20(sp)


    movia r6, 0xff203040	# Audio device base address: DE1-SoC
    movia r9, SOUND_CLIP
	addi r9, r9, 40
	ldw r4, 0(r9)
	addi r9, r9, 4

WaitForWriteSpace:
	
	ldh r5, 0(r9)
	
    ldwio r2, 4(r6)
    andhi r3, r2, 0xff00
    beq r3, r0, WaitForWriteSpace
    andhi r3, r2, 0xff
    beq r3, r0, WaitForWriteSpace
    
WriteTwoSamples:
    sthio r5, 8(r6)
    sthio r5, 12(r6)
	subi r4, r4, 2
	addi r9, r9, 2
    bne r4, r0, WaitForWriteSpace
    
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r9, 20(sp)
	addi sp, sp, 24
	
	ret
	
	
	
	
	
.global audio_clap
audio_clap:
	
	addi sp, sp, -24
	stw r2, (sp)
	stw r3, 4(sp)
	stw r4, 8(sp)
	stw r5, 12(sp)
	stw r6, 16(sp)
	stw r9, 20(sp)


    movia r6, 0xff203040	# Audio device base address: DE1-SoC
    movia r9, CLAPPING
	addi r9, r9, 40
	ldw r4, 0(r9)
	addi r9, r9, 4

WaitForWriteSpace_clap:
	
	ldh r5, 0(r9)
	
    ldwio r2, 4(r6)
    andhi r3, r2, 0xff00
    beq r3, r0, WaitForWriteSpace_clap
    andhi r3, r2, 0xff
    beq r3, r0, WaitForWriteSpace_clap
    
WriteTwoSamples_clap:
    sthio r5, 8(r6)
    sthio r5, 12(r6)
	subi r4, r4, 2
	addi r9, r9, 2
    bne r4, r0, WaitForWriteSpace_clap
    
	ldw r2, (sp)
	ldw r3, 4(sp)
	ldw r4, 8(sp)
	ldw r5, 12(sp)
	ldw r6, 16(sp)
	ldw r9, 20(sp)
	addi sp, sp, 24
	
	ret