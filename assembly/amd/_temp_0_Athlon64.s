	.file	"input.bc"
	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI0_0:
	.quad	4607182418800017408     # double 1.000000e+00
                                        #  (0x3ff0000000000000)
	.section	.rodata.cst4,"aM",@progbits,4
	.align	4
.LCPI0_1:
	.long	1048576000              # float 2.500000e-01
                                        #  (0x3e800000)
	.text
	.globl	__OpenCL_sor_kernel
	.align	16, 0x90
	.type	__OpenCL_sor_kernel,@function
__OpenCL_sor_kernel:                    # @__OpenCL_sor_kernel
# BB#0:                                 # %entry
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$72, %rsp
	movl	%r8d, 8(%rsp)           # 4-byte Spill
	movq	%rdx, %r14
	decl	%ecx
	movl	%ecx, 4(%rsp)           # 4-byte Spill
	cmpl	$2, %ecx
	jl	.LBB0_5
# BB#1:                                 # %for.cond5.preheader.preheader
	movq	8(%rsi), %rax
	movq	%rdi, 40(%rsp)          # 8-byte Spill
	movl	24(%rdi), %ecx
	addl	(%rsi), %ecx
	movl	%ecx, 36(%rsp)          # 4-byte Spill
	movq	32(%rdi), %rcx
	leal	(%rcx,%rax), %ebp
	movaps	%xmm0, %xmm1
	cvtss2sd	%xmm1, %xmm0
	movsd	.LCPI0_0(%rip), %xmm2
	addl	%eax, %ecx
	movq	%rcx, 24(%rsp)          # 8-byte Spill
	subsd	%xmm0, %xmm2
	movsd	%xmm2, 16(%rsp)         # 8-byte Spill
	mulss	.LCPI0_1(%rip), %xmm1
	movss	%xmm1, 52(%rsp)         # 4-byte Spill
	movl	8(%rsp), %eax           # 4-byte Reload
	leal	-1(%rax), %eax
	movl	%eax, 68(%rsp)          # 4-byte Spill
	movl	$1, %r13d
	.align	16, 0x90
.LBB0_2:                                # %for.cond5.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_7 Depth 2
	cmpl	$1, 68(%rsp)            # 4-byte Folded Reload
	jle	.LBB0_3
# BB#6:                                 # %for.body11.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	leal	-1(%r13), %ecx
	movl	8(%rsp), %eax           # 4-byte Reload
	imull	%eax, %ecx
	movl	%ecx, 64(%rsp)          # 4-byte Spill
	movl	%r13d, %r15d
	imull	%eax, %r15d
	leal	1(%r13), %ebx
	movl	%ebx, 12(%rsp)          # 4-byte Spill
	imull	%eax, %ebx
	leal	-1(%r15), %eax
	movl	%eax, 60(%rsp)          # 4-byte Spill
	leal	1(%r15), %eax
	movl	%eax, 56(%rsp)          # 4-byte Spill
	movl	$1, %r12d
	.align	16, 0x90
.LBB0_7:                                # %for.body11
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	cmpl	36(%rsp), %r13d         # 4-byte Folded Reload
	jne	.LBB0_9
# BB#8:                                 # %for.body11
                                        #   in Loop: Header=BB0_7 Depth=2
	movq	24(%rsp), %rax          # 8-byte Reload
	cmpl	%r12d, %eax
	jne	.LBB0_9
# BB#11:                                # %if.then
                                        #   in Loop: Header=BB0_7 Depth=2
	movl	56(%rsp), %eax          # 4-byte Reload
	leal	(%rax,%rbp), %eax
	movslq	%eax, %rax
	movss	(%r14,%rax,4), %xmm0
	movl	60(%rsp), %eax          # 4-byte Reload
	leal	(%rax,%rbp), %eax
	movslq	%eax, %rax
	addss	(%r14,%rax,4), %xmm0
	leal	(%rbp,%rbx), %eax
	movslq	%eax, %rax
	addss	(%r14,%rax,4), %xmm0
	movl	64(%rsp), %eax          # 4-byte Reload
	leal	(%rbp,%rax), %eax
	movslq	%eax, %rax
	addss	(%r14,%rax,4), %xmm0
	leal	(%rbp,%r15), %eax
	mulss	52(%rsp), %xmm0         # 4-byte Folded Reload
	cvtss2sd	%xmm0, %xmm0
	movslq	%eax, %rax
	movss	(%r14,%rax,4), %xmm1
	cvtss2sd	%xmm1, %xmm1
	mulsd	16(%rsp), %xmm1         # 8-byte Folded Reload
	addsd	%xmm0, %xmm1
	xorps	%xmm0, %xmm0
	cvtsd2ss	%xmm1, %xmm0
	movss	%xmm0, (%r14,%rax,4)
.LBB0_9:                                # %if.end
                                        #   in Loop: Header=BB0_7 Depth=2
	movq	40(%rsp), %rax          # 8-byte Reload
	movq	(%rax), %rax
	movq	(%rax), %rdi
	callq	barrier
	incl	%r12d
	cmpl	68(%rsp), %r12d         # 4-byte Folded Reload
	jl	.LBB0_7
# BB#10:                                #   in Loop: Header=BB0_2 Depth=1
	movl	12(%rsp), %r13d         # 4-byte Reload
	jmp	.LBB0_4
.LBB0_3:                                # %for.cond5.preheader.for.exit6_crit_edge
                                        #   in Loop: Header=BB0_2 Depth=1
	incl	%r13d
.LBB0_4:                                # %for.exit6
                                        #   in Loop: Header=BB0_2 Depth=1
	cmpl	4(%rsp), %r13d          # 4-byte Folded Reload
	jl	.LBB0_2
.LBB0_5:                                # %for.exit
	addq	$72, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
.Ltmp0:
	.size	__OpenCL_sor_kernel, .Ltmp0-__OpenCL_sor_kernel

	.section	.rodata.cst4,"aM",@progbits,4
	.align	4
.LCPI1_0:
	.long	1048576000              # float 2.500000e-01
                                        #  (0x3e800000)
	.section	.rodata.cst8,"aM",@progbits,8
	.align	8
.LCPI1_1:
	.quad	4607182418800017408     # double 1.000000e+00
                                        #  (0x3ff0000000000000)
	.text
	.globl	__OpenCL_sor_stub
	.align	16, 0x90
	.type	__OpenCL_sor_stub,@function
__OpenCL_sor_stub:                      # @__OpenCL_sor_stub
# BB#0:                                 # %entry
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	movl	40(%rdi), %r9d
	movq	32(%rdi), %rcx
	movq	24(%rdi), %rdx
	movq	(%rdi), %r15
	movl	8(%rdi), %r8d
	movl	12(%rdi), %r14d
	movss	16(%rdi), %xmm0
	cvtss2sd	%xmm0, %xmm2
	xorl	%edi, %edi
	mulss	.LCPI1_0(%rip), %xmm0
	movl	$1, %r11d
	movsd	.LCPI1_1(%rip), %xmm1
	subsd	%xmm2, %xmm1
	movl	$0, -4(%rsp)
	leal	-1(%r14), %r10d
	decl	%r8d
	jmp	.LBB1_2
	.align	16, 0x90
.LBB1_11:                               # %for.body11.i.i
                                        #   in Loop: Header=BB1_2 Depth=1
	movslq	%edi, %rsi
	shlq	$6, %rsi
	movl	%eax, 28(%rcx,%rsi)
	movslq	-4(%rsp), %rdi
	movq	%rdi, %rax
	shlq	$6, %rax
	movl	16(%rcx,%rax), %ebx
	cmpl	%ebx, 24(%rcx,%rax)
	jne	.LBB1_14
# BB#12:                                # %for.body11.i.i
                                        #   in Loop: Header=BB1_2 Depth=1
	movl	28(%rcx,%rax), %esi
	movl	20(%rcx,%rax), %eax
	cmpl	%eax, %esi
	jne	.LBB1_14
# BB#13:                                # %if.then.i.i
                                        #   in Loop: Header=BB1_2 Depth=1
	movl	%ebx, %ebp
	imull	%r14d, %ebp
	leal	1(%rax,%rbp), %esi
	movslq	%esi, %rsi
	movss	(%r15,%rsi,4), %xmm2
	leal	-1(%rax,%rbp), %esi
	movslq	%esi, %rsi
	addss	(%r15,%rsi,4), %xmm2
	leal	1(%rbx), %esi
	imull	%r14d, %esi
	addl	%eax, %esi
	movslq	%esi, %rsi
	addss	(%r15,%rsi,4), %xmm2
	decl	%ebx
	imull	%r14d, %ebx
	addl	%eax, %ebp
	addl	%eax, %ebx
	movslq	%ebx, %rax
	addss	(%r15,%rax,4), %xmm2
	mulss	%xmm0, %xmm2
	cvtss2sd	%xmm2, %xmm2
	movslq	%ebp, %rax
	movss	(%r15,%rax,4), %xmm3
	cvtss2sd	%xmm3, %xmm3
	mulsd	%xmm1, %xmm3
	addsd	%xmm2, %xmm3
	xorps	%xmm2, %xmm2
	cvtsd2ss	%xmm3, %xmm2
	movss	%xmm2, (%r15,%rax,4)
.LBB1_14:                               # %if.end.i.i
                                        #   in Loop: Header=BB1_2 Depth=1
	incl	%edi
	movl	%edi, -4(%rsp)
	cmpl	%r9d, %edi
	jb	.LBB1_1
# BB#15:                                #   in Loop: Header=BB1_2 Depth=1
	movl	$0, -4(%rsp)
	xorl	%edi, %edi
	.align	16, 0x90
.LBB1_16:                               #   in Loop: Header=BB1_2 Depth=1
	movslq	%edi, %rbx
	shlq	$6, %rbx
	movl	28(%rcx,%rbx), %eax
	incl	%eax
	movl	%eax, 44(%rcx,%rbx)
	xorl	%r11d, %r11d
	cmpl	36(%rcx,%rbx), %eax
	jl	.LBB1_11
	jmp	.LBB1_8
	.align	16, 0x90
.LBB1_2:                                # =>This Inner Loop Header: Depth=1
	movq	120(%rdx), %rax
	movslq	%edi, %rdi
	shlq	$6, %rdi
	movq	%rax, (%rcx,%rdi)
	movq	128(%rdx), %rax
	movq	%rax, 8(%rcx,%rdi)
	movq	120(%rdx), %rax
	incq	%rax
	movq	%rax, 120(%rdx)
	cmpq	88(%rdx), %rax
	jb	.LBB1_6
# BB#3:                                 #   in Loop: Header=BB1_2 Depth=1
	movq	$0, 120(%rdx)
	movq	128(%rdx), %rax
	incq	%rax
	movq	%rax, 128(%rdx)
	cmpq	96(%rdx), %rax
	jb	.LBB1_6
# BB#4:                                 #   in Loop: Header=BB1_2 Depth=1
	movq	$0, 128(%rdx)
	movq	136(%rdx), %rax
	incq	%rax
	movq	%rax, 136(%rdx)
	cmpq	104(%rdx), %rax
	jb	.LBB1_6
# BB#5:                                 #   in Loop: Header=BB1_2 Depth=1
	movq	$0, 136(%rdx)
.LBB1_6:                                # %.exit.i
                                        #   in Loop: Header=BB1_2 Depth=1
	leaq	(%rcx,%rdi), %rax
	movl	(%rax), %eax
	addl	24(%rdx), %eax
	movl	%eax, 16(%rcx,%rdi)
	movslq	-4(%rsp), %rax
	shlq	$6, %rax
	movl	8(%rcx,%rax), %esi
	addl	32(%rdx), %esi
	movl	%esi, 20(%rcx,%rax)
	movslq	-4(%rsp), %rax
	shlq	$6, %rax
	movl	%r8d, 32(%rcx,%rax)
	movslq	-4(%rsp), %rdi
	movq	%rdi, %rax
	shlq	$6, %rax
	cmpl	$2, 32(%rcx,%rax)
	movl	$1, %eax
	jl	.LBB1_9
	jmp	.LBB1_7
	.align	16, 0x90
.LBB1_1:                                # %switch.barriers.ithread-pre-split
                                        #   in Loop: Header=BB1_2 Depth=1
	testl	%r11d, %r11d
	je	.LBB1_16
	jmp	.LBB1_2
	.align	16, 0x90
.LBB1_7:                                # %for.cond5.preheader.i.i
                                        #   in Loop: Header=BB1_2 Depth=1
	movslq	%edi, %rsi
	shlq	$6, %rsi
	movl	%eax, 24(%rcx,%rsi)
	movslq	-4(%rsp), %rax
	shlq	$6, %rax
	movl	%r10d, 36(%rcx,%rax)
	movslq	-4(%rsp), %rdi
	movq	%rdi, %rax
	shlq	$6, %rax
	cmpl	$1, 36(%rcx,%rax)
	movl	$1, %eax
	jg	.LBB1_11
.LBB1_8:                                # %for.exit6.i.i
                                        #   in Loop: Header=BB1_2 Depth=1
	movslq	%edi, %rbx
	shlq	$6, %rbx
	movl	24(%rcx,%rbx), %eax
	incl	%eax
	movl	%eax, 40(%rcx,%rbx)
	cmpl	32(%rcx,%rbx), %eax
	jl	.LBB1_7
.LBB1_9:                                # %__OpenCL_sor_kernel.exit.i
                                        #   in Loop: Header=BB1_2 Depth=1
	incl	%edi
	movl	%edi, -4(%rsp)
	cmpl	%r9d, %edi
	jb	.LBB1_1
# BB#10:                                # %delegate@__OpenCL_sor_stub.exit
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	ret
.Ltmp1:
	.size	__OpenCL_sor_stub, .Ltmp1-__OpenCL_sor_stub

	.align	16, 0x90
	.type	barrier,@function
barrier:                                # @barrier
# BB#0:
	movq	%rdi, %rax
	movl	$2, %edi
	jmpq	*%rax  # TAILCALL
.Ltmp2:
	.size	barrier, .Ltmp2-barrier

	.type	.str,@object            # @.str
	.section	.rodata,"a",@progbits
.str:
	.asciz	 "A"
	.size	.str, 2

	.type	.str1,@object           # @.str1
.str1:
	.asciz	 "float*"
	.size	.str1, 7

	.type	.str2,@object           # @.str2
.str2:
	.asciz	 "M"
	.size	.str2, 2

	.type	.str3,@object           # @.str3
.str3:
	.asciz	 "int"
	.size	.str3, 4

	.type	.str4,@object           # @.str4
.str4:
	.asciz	 "N"
	.size	.str4, 2

	.type	.str5,@object           # @.str5
.str5:
	.asciz	 "int"
	.size	.str5, 4

	.type	.str6,@object           # @.str6
.str6:
	.asciz	 "w"
	.size	.str6, 2

	.type	.str7,@object           # @.str7
.str7:
	.asciz	 "float"
	.size	.str7, 6

	.type	__OpenCL_sor_metadata,@object # @__OpenCL_sor_metadata
	.section	.data.rel.local,"aw",@progbits
	.globl	__OpenCL_sor_metadata
	.align	8
__OpenCL_sor_metadata:
	.quad	208                     # 0xd0
	.quad	0                       # 0x0
	.zero	24
	.zero	24
	.long	7                       # 0x7
	.long	3                       # 0x3
	.long	0                       # 0x0
	.quad	.str
	.long	0                       # 0x0
	.long	0                       # 0x0
	.long	0                       # 0x0
	.quad	.str1
	.long	3                       # 0x3
	.long	0                       # 0x0
	.long	0                       # 0x0
	.quad	.str2
	.long	0                       # 0x0
	.long	0                       # 0x0
	.long	0                       # 0x0
	.quad	.str3
	.long	3                       # 0x3
	.long	0                       # 0x0
	.long	0                       # 0x0
	.quad	.str4
	.long	0                       # 0x0
	.long	0                       # 0x0
	.long	0                       # 0x0
	.quad	.str5
	.long	5                       # 0x5
	.long	0                       # 0x0
	.long	0                       # 0x0
	.quad	.str6
	.long	0                       # 0x0
	.long	0                       # 0x0
	.long	0                       # 0x0
	.quad	.str7
	.zero	20
	.size	__OpenCL_sor_metadata, 244

	.type	sgv,@object             # @sgv
	.section	.rodata,"a",@progbits
sgv:
	.zero	1
	.size	sgv, 1

	.type	fgv,@object             # @fgv
fgv:
	.zero	1
	.size	fgv, 1

	.type	lvgv,@object            # @lvgv
	.align	8
lvgv:
	.size	lvgv, 0

	.type	rvgv,@object            # @rvgv
	.align	8
rvgv:
	.size	rvgv, 0

	.type	__OpenCL_sor_nature,@object # @__OpenCL_sor_nature
	.data
	.globl	__OpenCL_sor_nature
	.align	8
__OpenCL_sor_nature:
	.long	3                       # 0x3
	.long	64                      # 0x40
	.size	__OpenCL_sor_nature, 8


	.section	".note.GNU-stack","",@progbits
