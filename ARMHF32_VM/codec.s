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
	.file	"codec.c"
	.text
	.align	1
	.p2align 2,,3
	.global	get_sign
	.arch armv7-a
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	get_sign, %function
get_sign:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mvns	r0, r0
	lsrs	r0, r0, #31
	bx	lr
	.size	get_sign, .-get_sign
	.align	1
	.p2align 2,,3
	.global	get_magnitude
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	get_magnitude, %function
get_magnitude:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	cmp	r0, #0
	it	lt
	rsblt	r0, r0, #0
	bx	lr
	.size	get_magnitude, .-get_magnitude
	.align	1
	.p2align 2,,3
	.global	ulaw_compress
	.syntax unified
	.thumb
	.thumb_func
	.fpu vfpv3-d16
	.type	ulaw_compress, %function
ulaw_compress:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	eor	r3, r0, r0, asr #31
	movw	r2, #8159
	sub	r3, r3, r0, asr #31
	mvns	r0, r0
	cmp	r3, r2
	it	cs
	movcs	r3, r2
	adds	r3, r3, #33
	cmp	r3, #63
	lsr	r2, r0, #31
	itt	ls
	ubfxls	r3, r3, #1, #4
	movls	r0, #0
	bls	.L6
	clz	r1, r3
	rsb	r0, r1, #26
	rsb	r1, r1, #27
	lsrs	r3, r3, r1
	lsls	r0, r0, #4
	and	r3, r3, #15
	sxtb	r0, r0
.L6:
	orr	r0, r0, r2, lsl #7
	orrs	r3, r3, r0
	mvns	r0, r3
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
	.ascii	"output_tone.wav\000"
	.align	2
.LC4:
	.ascii	"Error: Could not open file.\000"
	.align	2
.LC5:
	.ascii	"Processing complete! %d samples compressed and deco"
	.ascii	"mpressed.\012\000"
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
	ldr	r2, .L21
	ldr	r3, .L21+4
.LPIC7:
	add	r2, pc
	ldr	r1, .L21+8
	ldr	r0, .L21+12
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
	ldr	r1, .L21+16
.LPIC2:
	add	r1, pc
	mov	r5, r0
	ldr	r0, .L21+20
.LPIC3:
	add	r0, pc
	bl	fopen(PLT)
	clz	r4, r0
	lsrs	r4, r4, #5
	cmp	r5, #0
	it	eq
	moveq	r4, #1
	cmp	r4, #0
	bne	.L19
	add	r7, sp, #8
	mov	r6, r0
	mov	r3, r5
	movs	r2, #44
	movs	r1, #1
	mov	r0, r7
	bl	fread(PLT)
	mov	r0, r7
	mov	r3, r6
	movs	r2, #44
	movs	r1, #1
	add	r7, sp, #4
	bl	fwrite(PLT)
	add	r8, sp, #6
	b	.L13
.L16:
	ldrsh	r0, [sp, #4]
	adds	r4, r4, #1
	bl	ulaw_compress(PLT)
	movs	r1, #2
	mvns	r0, r0
	and	r3, r0, #15
	ubfx	ip, r0, #4, #3
	lsls	r2, r0, #24
	lsl	r3, r3, #1
	mov	r2, #1
	add	r3, r3, #33
	mov	r0, r8
	lsl	r3, r3, ip
	ite	mi
	submi	ip, r3, #33
	rsbpl	ip, r3, #33
	mov	r3, r6
	strh	ip, [sp, #6]	@ movhi
	bl	fwrite(PLT)
.L13:
	mov	r3, r5
	movs	r2, #1
	movs	r1, #2
	mov	r0, r7
	bl	fread(PLT)
	cmp	r0, #1
	beq	.L16
	mov	r0, r5
	bl	fclose(PLT)
	mov	r0, r6
	bl	fclose(PLT)
	ldr	r1, .L21+24
	mov	r2, r4
	movs	r0, #1
.LPIC5:
	add	r1, pc
	bl	__printf_chk(PLT)
	movs	r0, #0
.L10:
	ldr	r2, .L21+28
	ldr	r3, .L21+4
.LPIC6:
	add	r2, pc
	ldr	r3, [r2, r3]
	ldr	r2, [r3]
	ldr	r3, [sp, #52]
	eors	r2, r3, r2
	mov	r3, #0
	bne	.L20
	add	sp, sp, #56
	@ sp needed
	pop	{r4, r5, r6, r7, r8, pc}
.L19:
	ldr	r0, .L21+32
.LPIC4:
	add	r0, pc
	bl	puts(PLT)
	movs	r0, #1
	b	.L10
.L20:
	bl	__stack_chk_fail(PLT)
.L22:
	.align	2
.L21:
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC7+4)
	.word	__stack_chk_guard(GOT)
	.word	.LC0-(.LPIC0+4)
	.word	.LC1-(.LPIC1+4)
	.word	.LC2-(.LPIC2+4)
	.word	.LC3-(.LPIC3+4)
	.word	.LC5-(.LPIC5+4)
	.word	_GLOBAL_OFFSET_TABLE_-(.LPIC6+4)
	.word	.LC4-(.LPIC4+4)
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0"
	.section	.note.GNU-stack,"",%progbits
