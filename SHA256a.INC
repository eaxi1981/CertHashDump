; =========================== LICENSE =====================================================
; Assemby x86 32-bit implementation of SHA256 algorithm
; written by Piotr Ulaszewski on the 15th of December 2016
; basing on a few C/c++ SHA256 implementations
; anti debug specific code modification included
; Source code is provided for learning purposes
; http://www.itprojects.wroclaw.pl/files/asm/sha256.zip
; ========================================================================================
;-------------------------------------------------------------------------------------------------------------------------------------------------------------
; Assembler implementation of the SHA 256 algorithm, written in 32-bit nasm assembly and can be used under any OS.
; Declare 32 byte buffer to hold calculated SHA256 value :	unsigned char shabuffer[32] = {0};
; Then execute function with 3 parameters:
; 1) pointer to result of SHA256 call (32 bytes), 	ecx = shabuffer
; 2) pointer to data source, 			edx = string
; 3) data length.				push = length -> eax = length
; sha256a (shabuffer, (unsigned char *)data_addr, data_size); czyli sha256a@12 - 3 DWORDY

; @sha256a@12: 	void sha256 (BYTE *shabuffer, char *string, int length);
; fastcall calling convention ecx = shabuffer, edx = string, push = length -> eax = length
;
; C declaration: void __fastcall MyFunc(int a, int b, int c);
; Arguments: ECX=a, EDX=b, [ESP+4]=c
; Stack cleanup: ret 4 (only 1 param on stack)
; mov ecx, 10       	; Arg 1	; 1) pointer to result of SHA256 call (32 bytes), 	ecx = shabuffer
; mov edx, 20       	; Arg 2	; 2) pointer to data source, 			edx = string
; push 30           	; Arg 3	; 3) data length.				push = length -> eax = length
; call @MyFunc@4

; sha256_final	proc near		; CODE XREF: sha256a+24p
;		push	esi
;		push	edi
;		mov	esi, ecx	argument w ECX
;		mov	edi, edx	argument w EDX
; ---------------------------------------------------------------------------
; if debug_mode not defined sha256 result will be false 
; %define debug_mode 1
;    %ifndef debug_mode	    ; make it wrong under debugger
;    mov eax, [fs:30h]
;    mov eax, [eax + 68h]
;    test eax, 70h
;    setnz al
;    add byte [ecx + SHA256_CTX.state], al
;    %endif
;------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------
_CH:
		and	edx, ecx
		not	ecx
		and	eax, ecx
		xor	edx, eax
		mov	eax, edx
		retn
MAJ:
		mov	ebx, ecx
		and	ebx, edx
		and	ecx, eax
		and	eax, edx
		xor	ebx, ecx
		xor	ebx, eax
		mov	eax, ebx
		retn
EP0:
		mov	eax, ecx
		mov	ebx, ecx
		ror	ecx, 16h
		ror	ebx, 0Dh
		ror	eax, 2
		xor	eax, ebx
		xor	eax, ecx
		retn
EP1:
		mov	eax, ecx
		mov	ebx, ecx
		ror	ecx, 19h
		ror	ebx, 0Bh
		ror	eax, 6
		xor	eax, ebx
		xor	eax, ecx
		retn
S0:
		mov	eax, ecx
		mov	ebx, ecx
		shr	ecx, 3
		ror	ebx, 12h
		ror	eax, 7
		xor	eax, ebx
		xor	eax, ecx
		retn
S1:
		mov	eax, ecx
		mov	ebx, ecx
		shr	ecx, 0Ah
		ror	ebx, 13h
		ror	eax, 11h
		xor	eax, ebx
		xor	eax, ecx
		retn
sha256_transform:
		push	esi
		push	edi
		mov	esi, ecx
		mov	edi, edx
		sub	ecx, ecx
sha256_transform_copy_chunk:
		sub	eax, eax
		sub	ebx, ebx
		mov	al, [edi+ecx*4+3]
		mov	bl, [edi+ecx*4+2]
		shl	ebx, 8
		or	eax, ebx
		sub	ebx, ebx
		mov	bl, [edi+ecx*4+1]
		shl	ebx, 10h
		or	eax, ebx
		sub	ebx, ebx
		mov	bl, [edi+ecx*4]
		shl	ebx, 18h
		or	eax, ebx
		mov	ds:m[ecx*4], eax
		inc	ecx
		cmp	ecx, 10h
		jb	short sha256_transform_copy_chunk
sha256_transform_extend:
		mov	edx, ecx
		sub	edx, 10h
		mov	eax, ds:m[edx*4]
		mov	edx, ecx
		sub	edx, 0Fh
		mov	ebx, ds:m[edx*4]
		push	ecx
		push	edx
		push	eax
		mov	ecx, ebx
		call	S0
		mov	ebx, eax
		pop	eax
		pop	edx
		pop	ecx
		add	eax, ebx
		mov	edx, ecx
		sub	edx, 7
		mov	ebx, ds:m[edx*4]
		add	eax, ebx
		mov	edx, ecx
		sub	edx, 2
		mov	ebx, ds:m[edx*4]
		push	ecx
		push	edx
		push	eax
		mov	ecx, ebx
		call	S1
		mov	ebx, eax
		pop	eax
		pop	edx
		pop	ecx
		add	eax, ebx
		mov	ds:m[ecx*4], eax
		inc	ecx
		cmp	ecx, 40h
		jb	short sha256_transform_extend
		mov	eax, [esi+50h]
		mov	ds:a, eax
		mov	eax, [esi+54h]
		mov	ds:b, eax
		mov	eax, [esi+58h]
		mov	ds:c_var, eax
		mov	eax, [esi+5Ch]
		mov	ds:d, eax
		mov	eax, [esi+60h]
		mov	ds:e, eax
		mov	eax, [esi+64h]
		mov	ds:f, eax
		mov	eax, [esi+68h]
		mov	ds:g, eax
		mov	eax, [esi+6Ch]
		mov	ds:h, eax
		sub	ecx, ecx
sha256_transform_compression:
		mov	eax, ds:m[ecx*4]
		add	eax, ds:const_k[ecx*4]
		push	ecx
		push	edx
		push	eax
		mov	ecx, ds:e
		mov	edx, ds:f
		mov	eax, ds:g
		call	_CH
		mov	ebx, eax
		pop	eax
		pop	edx
		pop	ecx
		add	eax, ebx
		push	ecx
		push	edx
		push	eax
		mov	ecx, ds:e
		call	EP1
		mov	ebx, eax
		pop	eax
		pop	edx
		pop	ecx
		add	eax, ebx
		add	eax, ds:h
		mov	ds:t1, eax
		push	ecx
		push	edx
		push	eax
		mov	ecx, ds:a
		mov	edx, ds:b
		mov	eax, ds:c_var
		call	MAJ
		mov	ebx, eax
		pop	eax
		pop	edx
		pop	ecx
		mov	eax, ebx
		push	ecx
		push	edx
		push	eax
		mov	ecx, ds:a
		call	EP0
		mov	ebx, eax
		pop	eax
		pop	edx
		pop	ecx
		add	eax, ebx
		mov	ds:t2, eax
		mov	eax, ds:g
		mov	ds:h, eax
		mov	eax, ds:f
		mov	ds:g, eax
		mov	eax, ds:e
		mov	ds:f, eax
		mov	eax, ds:d
		add	eax, ds:t1
		mov	ds:e, eax
		mov	eax, ds:c_var
		mov	ds:d, eax
		mov	eax, ds:b
		mov	ds:c_var, eax
		mov	eax, ds:a
		mov	ds:b, eax
		mov	eax, ds:t2
		add	eax, ds:t1
		mov	ds:a, eax
		inc	ecx
		cmp	ecx, 40h
		jb	sha256_transform_compression
		mov	eax, ds:a
		add	[esi+50h], eax
		mov	eax, ds:b
		add	[esi+54h], eax
		mov	eax, ds:c_var
		add	[esi+58h], eax
		mov	eax, ds:d
		add	[esi+5Ch], eax
		mov	eax, ds:e
		add	[esi+60h], eax
		mov	eax, ds:f
		add	[esi+64h], eax
		mov	eax, ds:g
		add	[esi+68h], eax
		mov	eax, ds:h
		add	[esi+6Ch], eax
		pop	edi
		pop	esi
		retn
sha256_init:
		mov	dword ptr [ecx+40h], 0
		mov	dword ptr [ecx+48h], 0
		mov	dword ptr [ecx+4Ch], 0
		mov	dword ptr [ecx+50h], 6A09E667h
		mov	dword ptr [ecx+54h], 0BB67AE85h
		mov	dword ptr [ecx+58h], 3C6EF372h
		mov	dword ptr [ecx+5Ch], 0A54FF53Ah
		mov	dword ptr [ecx+60h], 510E527Fh
		mov	dword ptr [ecx+64h], 9B05688Ch
		mov	dword ptr [ecx+68h], 1F83D9ABh
		mov	dword ptr [ecx+6Ch], 5BE0CD19h
		xor	eax, eax
		add	[ecx+50h], al
		retn
sha256_update:
		push	esi
		push	edi
		push	ebp
		mov	esi, ecx
		mov	edi, edx
		mov	ebp, eax
		sub	ecx, ecx
sha256_update_update:
		sub	eax, eax
		mov	al, [edi+ecx]
		mov	ebx, [esi+40h]
		mov	[esi+ebx], al
		inc	dword ptr [esi+40h]
		cmp	dword ptr [esi+40h], 40h
		jnz	short sha256_update_dont_update
		push	eax
		push	ebx
		push	ecx
		push	edx
		mov	ecx, esi
		lea	edx, [esi]
		call	sha256_transform
		pop	edx
		pop	ecx
		pop	ebx
		pop	eax
		mov	dword ptr [esi+40h], 0
		push	ecx
		mov	eax, [esi+48h]
		mov	edx, [esi+4Ch]
		sub	ecx, ecx
		mov	ebx, 200h
		add	eax, ebx
		adc	edx, ecx
		mov	[esi+48h], eax
		mov	[esi+4Ch], edx
		pop	ecx
sha256_update_dont_update:
		inc	ecx
		cmp	ecx, ebp
		jb	short sha256_update_update
		pop	ebp
		pop	edi
		pop	esi
		retn
sha256_final:
		push	esi
		push	edi
		mov	esi, ecx
		mov	edi, edx
		mov	ecx, [esi+40h]
		cmp	ecx, 38h
		jnb	short sha256_final_above
		mov	byte ptr [esi+ecx], 80h
		inc	ecx
sha256_final_fill:
		mov	byte ptr [esi+ecx], 0
		inc	ecx
		cmp	ecx, 38h
		jb	short sha256_final_fill
		jmp	short sha256_final_append
sha256_final_above:
		mov	byte ptr [esi+ecx], 80h
		inc	ecx
sha256_final_fill2:
		mov	byte ptr [esi+ecx], 0
		inc	ecx
		cmp	ecx, 40h
		jb	short sha256_final_fill2
		pusha
		mov	ecx, esi
		lea	edx, [esi]
		call	sha256_transform
		mov	ecx, 38h
		sub	eax, eax
		lea	edi, [esi]
		rep stosb
		popa
sha256_final_append:
		mov	eax, [esi+40h]
		sub	edx, edx
		mov	ecx, edx
		mov	ebx, eax
		add	eax, ebx
		adc	edx, ecx
		add	eax, ebx
		adc	edx, ecx
		add	eax, ebx
		adc	edx, ecx
		add	eax, ebx
		adc	edx, ecx
		add	eax, ebx
		adc	edx, ecx
		add	eax, ebx
		adc	edx, ecx
		add	eax, ebx
		adc	edx, ecx
		add	[esi+48h], eax
		adc	[esi+4Ch], edx
		mov	al, [esi+48h]
		mov	[esi+3Fh], al
		mov	al, [esi+49h]
		mov	[esi+3Eh], al
		mov	al, [esi+4Ah]
		mov	[esi+3Dh], al
		mov	al, [esi+4Bh]
		mov	[esi+3Ch], al
		mov	al, [esi+4Ch]
		mov	[esi+3Bh], al
		mov	al, [esi+4Dh]
		mov	[esi+3Ah], al
		mov	al, [esi+4Eh]
		mov	[esi+39h], al
		mov	al, [esi+4Fh]
		mov	[esi+38h], al
		mov	ecx, esi
		lea	edx, [esi]
		call	sha256_transform
		sub	edx, edx
sha256_final_hash:
		mov	ecx, 18h
		mov	eax, edx
		shl	eax, 3
		sub	ecx, eax
		mov	eax, [esi+50h]
		shr	eax, cl
		and	eax, 0FFh
		mov	[edi+edx], al
		mov	eax, [esi+54h]
		shr	eax, cl
		and	eax, 0FFh
		mov	[edi+edx+4], al
		mov	eax, [esi+58h]
		shr	eax, cl
		and	eax, 0FFh
		mov	[edi+edx+8], al
		mov	eax, [esi+5Ch]
		shr	eax, cl
		and	eax, 0FFh
		mov	[edi+edx+0Ch], al
		mov	eax, [esi+60h]
		shr	eax, cl
		and	eax, 0FFh
		mov	[edi+edx+10h], al
		mov	eax, [esi+64h]
		shr	eax, cl
		and	eax, 0FFh
		mov	[edi+edx+14h], al
		mov	eax, [esi+68h]
		shr	eax, cl
		and	eax, 0FFh
		mov	[edi+edx+18h], al
		mov	eax, [esi+6Ch]
		shr	eax, cl
		and	eax, 0FFh
		mov	[edi+edx+1Ch], al
		inc	edx
		cmp	edx, 4
		jb	sha256_final_hash
		pop	edi
		pop	esi
		retn
		db 1Eh dup(90h)
		public sha256a
sha256a:
arg_0		= dword	ptr  4
		mov	eax, [esp+arg_0]
		pusha
		mov	ecx, offset SHA256_strucstart
		call	sha256_init
		popa
		pusha
		mov	ecx, offset SHA256_strucstart
		call	sha256_update
		popa
		pusha
		mov	edx, ecx
		mov	ecx, offset SHA256_strucstart
		call	sha256_final
		popa
		retn	4
