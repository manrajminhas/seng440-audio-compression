	.arch armv7-a
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"codec_hw.c"
	.text
	.align	1
	.p2align 2,,3
	.global	ulaw_compress
	.arch armv7-a
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	ulaw_compress, %function
ulaw_compress:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	.syntax unified
@ 14 "codec_hw.c" 1
	mulaw r0, r0
@ 0 "" 2
	.thumb
	.syntax unified
	uxtb	r0, r0
	bx	lr
	.size	ulaw_compress, .-ulaw_compress
	.align	1
	.p2align 2,,3
	.global	ulaw_expand
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	ulaw_expand, %function
ulaw_expand:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mvns	r0, r0
	and	r3, r0, #15
	ubfx	r2, r0, #4, #3
	lsls	r3, r3, #1
	adds	r3, r3, #33
	lsls	r3, r3, r2
	lsls	r2, r0, #24
	ite	mi
	submi	r0, r3, #33
	rsbpl	r0, r3, #33
	bx	lr
	.size	ulaw_expand, .-ulaw_expand
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"rb\000"
	.align	2
.LC1:
	.ascii	"voice.wav\000"
	.align	2
.LC2:
	.ascii	"wb\000"
	.align	2
.LC3:
	.ascii	"output_tone_hw.wav\000"
	.align	2
.LC4:
	.ascii	"Error: Could not open file.\000"
	.section	.text.startup,"ax",%progbits
	.align	1
	.p2align 2,,3
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 56
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r2, .L17
	ldr	r3, .L17+4
.LPIC6:
	add	r2, pc
	ldr	r1, .L17+8
	ldr	r0, .L17+12
	push	{r4, r5, r6, r7, r8, lr}
.LPIC0:
	add	r1, pc
	ldr	r3, [r2, r3]
	sub	sp, sp, #56
.LPIC1:
	add	r0, pc
	ldr	r3, [r3]
	str	r3, [sp, #52]
	mov	r3,#0
	bl	fopen(PLT)
	ldr	r1, .L17+16
.LPIC2:
	add	r1, pc
	mov	r5, r0
	ldr	r0, .L17+20
.LPIC3:
	add	r0, pc
	bl	fopen(PLT)
	cmp	r0, #0
	it	ne
	cmpne	r5, #0
	beq	.L15
	add	r4, sp, #8
	mov	r6, r0
	mov	r3, r5
	movs	r2, #44
	movs	r1, #1
	mov	r0, r4
	bl	fread(PLT)
	mov	r3, r6
	mov	r0, r4
	movs	r2, #44
	movs	r1, #1
	add	r7, sp, #4
	add	r8, sp, #6
	bl	fwrite(PLT)
	b	.L9
.L12:
	ldrh	r2, [sp, #4]
	.syntax unified
@ 14 "codec_hw.c" 1
	mulaw r2, r2
@ 0 "" 2
	.thumb
	.syntax unified
	mvns	r2, r2
	and	r3, r2, #15
	ubfx	r4, r2, #4, #3
	lsls	r2, r2, #24
	lsl	r3, r3, #1
	mov	r2, #1
	add	r3, r3, #33
	mov	r1, #2
	mov	r0, r8
	lsl	r3, r3, r4
	ite	mi
	submi	r4, r3, #33
	rsbpl	r4, r3, #33
	mov	r3, r6
	strh	r4, [sp, #6]	@ movhi
	bl	fwrite(PLT)
.L9:
	mov	r3, r5
	movs	r2, #1
	movs	r1, #2
	mov	r0, r7
	bl	fread(PLT)
	cmp	r0, #1
	beq	.L12
	mov	r0, r5
	bl	fclose(PLT)
	mov	r0, r6
	bl	fclose(PLT)
	movs	r0, #0
.L6:
	ldr	r2, .L17+24
	ldr	r3, .L17+4
.LPIC5:
	add	r2, pc
	ldr	r3, [r2, r3]
	ldr	r2, [r3]
	ldr	r3, [sp, #52]
	eors	r2, r3, r2
	mov	r3, #0
	bne	.L16
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L15:
	ldr	r0, .L17+28
.LPIC4:
	add	r0, pc
	bl	puts(PLT)
	movs	r0, #1
	b	.L6
.L16:
	bl	__stack_chk_fail(PLT)
.L18:
	.align	2
.L17:
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC6+4)
	.word	__stack_chk_guard(GOT)
	.word	.LC0-(.LPIC0+4)
	.word	.LC1-(.LPIC1+4)
	.word	.LC2-(.LPIC2+4)
	.word	.LC3-(.LPIC3+4)
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC5+4)
	.word	.LC4-(.LPIC4+4)
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",%progbits
