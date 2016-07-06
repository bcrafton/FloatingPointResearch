mdef(16383)_out(1)_in(2)
mov r0, in0
mov r1, in1
div_zeroop(infinity) r0.x___, r0.x, r1.x
mov out0, r0
mend
il_cs_2_0
dcl_cb cb0[15] ; Constant buffer that holds ABI data
dcl_literal l0, 0x00000004, 0x00000001, 0x00000002, 0x00000003
dcl_literal l1, 0x00FFFFFF, 0xFFFFFFFF, 0xFFFFFFFE, 0xFFFFFFFD
dcl_literal l2, 0x0000FFFF, 0xFFFFFFFE, 0x000000FF, 0xFFFFFFFC
dcl_literal l3, 0x00000018, 0x00000010, 0x00000008, 0xFFFFFFFF
dcl_literal l4, 0xFFFFFF00, 0xFFFF0000, 0xFF00FFFF, 0xFFFF00FF
dcl_literal l5, 0x00000000, 0x00000004, 0x00000008, 0x0000000C
dcl_literal l6, 0x00000020, 0x00000020, 0x00000020, 0x00000020
dcl_literal l7, 0x00000018, 0x0000001F, 0x00000010, 0x0000001F
dcl_literal l8, 0x80000000, 0x80000000, 0x80000000, 0x80000000
call 1024;$
endmain
func 1024 ; __OpenCL_sor_kernel
mov r1013, cb0[8].x
mov r1019, l1.0000
dcl_max_thread_per_group 256
dcl_raw_uav_id(11)
dcl_arena_uav_id(8)
mov r0.__z_, vThreadGrpIdFlat0.x
mov r1022.xyz0, vTidInGrp0.xyz
mov r1023.xyz0, vThreadGrpId0.xyz
dcl_literal l9, 256, 1, 1, 0xFFFFFFFF
imad r1021.xyz0, r1023.xyzz, cb0[1].xyzz, r1022.xyzz
iadd r1021.xyz0, r1021.xyz0, cb0[6].xyz0
iadd r1023.xyz0, r1023.xyz0, cb0[7].xyz0
mov r1023.___w, r0.z
ishl r1023.___w, r1023.w, l0.z
mov r1018.x___, l0.0000
udiv r1024.xyz_, r1021.xyzz, cb0[10].xyzz
imad r1025.xyz0, r1023.xyzz, cb0[10].xyzz, r1022.xyzz
dcl_literal l17, 0x00000000, 0x00000000, 0x00000000, 0x00000000; f128:i128 00
dcl_literal l16, 0x00000001, 0x00000001, 0x00000001, 0x00000001; f128:i128 42949672974294967297
dcl_literal l13, 0x00000002, 0x00000002, 0x00000002, 0x00000002; f128:i128 85899345948589934594
dcl_literal l15, 0x3E800000, 0x3E800000, 0x3E800000, 0x3E800000; f128:i128 45035996284190720004503599628419072000
dcl_literal l14, 0x3F800000, 0x3F800000, 0x3F800000, 0x3F800000; f128:i128 45756572224737771524575657222473777152
dcl_literal l12, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF; f128:i128 1844674407370955161518446744073709551615
dcl_cb cb1[4]
dcl_indexed_temp_array x1[8]
dcl_literal l18, 0, 128, 16, 128
iadd r0.x, r1018.x, l18.w
mov r1028, l18.0
; Kernel arg setup: A
mov r1.x, cb1[0].x
; Kernel arg setup: M
mov r1.y, cb1[1].x
; Kernel arg setup: N
mov r1.z, cb1[2].x
; Kernel arg setup: w
mov r1.w, cb1[3].x
call 1029 ; sor
ret
endfunc ; __OpenCL_sor_kernel
;ARGSTART:__OpenCL_sor_kernel
;version:3:1:111
;device:redwood
;uniqueid:1024
;memory:hwprivate:0
;memory:hwlocal:0
;memory:hwregion:0
;pointer:A:float:1:1:0:uav:11:4:RW:0:0
;value:M:i32:1:1:16
;value:N:i32:1:1:32
;value:w:float:1:1:48
;function:1:1029
;uavid:11
;privateid:1
;reflection:0:float*
;reflection:1:int
;reflection:2:int
;reflection:3:float
;ARGEND:__OpenCL_sor_kernel
func 1029 ; sor                         ; @__OpenCL_sor_kernel
; BB#0:                                 ; %entry
	iadd r65.x___, r1.y, l12
	mov r66.x___, l13
	ilt r66.x___, r65.x, r66.x
	mov r67, r1021.xyz0
	if_logicalnz r66.x
	else
	mov r66.x___, r67.y
	mov r68.x___, l14
	sub r68.x___, r68.x, r1.w
	mul_ieee r69.x___, r1.w, l15
	iadd r70.x___, r1.z, l12
	mov r71.x___, l16
	whileloop
	ilt r72.x___, l16, r70.x
	if_logicalnz r72.x
	iadd r72.x___, r71.x, l12
	imul r73.x___, r72.x, r1.z
	iadd r72.x___, r71.x, l16
	imul r74.x___, r72.x, r1.z
	imul r75.x___, r71.x, r1.z
	iadd r76.x___, r75.x, l12
	iadd r77.x___, r75.x, l16
	mov r78.x___, l16
	whileloop
	ieq r79.x___, r66.x, r78.x
	ieq r80.x___, r71.x, r67.x
	iand r79.x___, r80.x, r79.x
	if_logicalnz r79.x
	iadd r79.x___, r76.x, r66.x
	ishl r79.x___, r79.x, l13
	iadd r79.x___, r1.x, r79.x
	uav_raw_load_id(11) r79.x___, r79.x
	iadd r80.x___, r77.x, r66.x
	ishl r80.x___, r80.x, l13
	iadd r80.x___, r1.x, r80.x
	uav_raw_load_id(11) r80.x___, r80.x
	add r79.x___, r80.x, r79.x
	iadd r80.x___, r66.x, r74.x
	ishl r80.x___, r80.x, l13
	iadd r80.x___, r1.x, r80.x
	uav_raw_load_id(11) r80.x___, r80.x
	add r79.x___, r79.x, r80.x
	iadd r80.x___, r66.x, r73.x
	ishl r80.x___, r80.x, l13
	iadd r80.x___, r1.x, r80.x
	uav_raw_load_id(11) r80.x___, r80.x
	add r79.x___, r79.x, r80.x
	mul_ieee r79.x___, r69.x, r79.x
	iadd r80.x___, r66.x, r75.x
	ishl r80.x___, r80.x, l13
	iadd r80.x___, r1.x, r80.x
	uav_raw_load_id(11) r81.x___, r80.x
	mul_ieee r81.x___, r68.x, r81.x
	add r79.x___, r79.x, r81.x
	uav_raw_store_id(11) mem0.x___, r80.x, r79.x
	else
	endif
	mov r79.x___, l13
	mov r80.x___, l17
	fence_threads_memory
	iadd r78.x___, r78.x, l16
	ilt r79.x___, r78.x, r70.x
	break_logicalz r79.x
	endloop
	mov r71.x___, r72.x
	else
	iadd r71.x___, r71.x, l16
	endif
	ilt r72.x___, r71.x, r65.x
	break_logicalz r72.x
	endloop
	endif
	ret_dyn
ret
endfunc ; sor
;ARGSTART:sor
;uniqueid:1029
;ARGEND:sor

end
