; =========================== LICENSE =====================================================
;/* MD5C.C - RSA Data Security, Inc., MD5 message-digest algorithm
;/* MD5.H - header file for MD5C.C
;/* MDDRIVER.C - test driver for MD2, MD4 and MD5
;/* Copyright (C) 1991-2, RSA Data Security, Inc. Created 1991. All rights reserved.
;License to copy and use this software is granted provided that it is identified as the "RSA Data Security, Inc. MD5 Message-Digest
;Algorithm" in all material mentioning or referencing this software or this function.
;License is also granted to make and use derivative works provided that such works are identified as "derived from the RSA Data
;Security, Inc. MD5 Message-Digest Algorithm" in all material mentioning or referencing the derived work.
;RSA Data Security, Inc. makes no representations concerning either the merchantability of this software or the suitability of this
;software for any particular purpose. It is provided "as is" without express or implied warranty of any kind.
;These notices must be retained in any copies of any part of this documentation and/or software.
; */
;https://www.ietf.org/rfc/rfc1321.txt
;# No "makefile" is provided in the RFC.
;# This one was written by Jim Ellis (jte@cert.org) for convenience.
; =========================================================================================
_MDPrint		dd 0
asc_40B058	db 0Ah,0
_PADDING        	db 80h, 3Fh dup(0)
Mode            	db 'rb',0
asCantBeOpened	db 'a%sCantBeOpened',0
aMdd		db 'aMdd',0
;########################################################################

_MDString	proc near
Str1		= dword	ptr -8Ch
var_88		= dword	ptr -88h
var_84		= dword	ptr -84h
var_74		= byte ptr -74h
var_64		= byte ptr -64h
		push	edi
		push	esi
		push	ebx
		add	esp, 0FFFFFF80h
		mov	ebx, eax
		mov	[esp+8Ch+Str1], eax
		call	_strlen
		mov	edi, eax
		lea	esi, [esp+8Ch+var_64]
		mov	[esp+8Ch+Str1], esi
		call	_MD5Init
		mov	[esp+8Ch+var_84], edi
		mov	[esp+8Ch+var_88], ebx
		mov	[esp+8Ch+Str1], esi
		call	_MD5Update
		mov	[esp+8Ch+var_88], esi
		lea	esi, [esp+8Ch+var_74]
		mov	[esp+8Ch+Str1], esi
		call	_MD5Final
		sub	esp, 0FFFFFF80h
		pop	ebx
		pop	esi
		pop	edi
		retn
_MDString	endp
;########################################################################
		public _MD5Init
_MD5Init	proc near
arg_0		= dword	ptr  4
		mov	eax, [esp+arg_0]
		mov	dword ptr [eax+14h], 0
		mov	dword ptr [eax+10h], 0
		mov	dword ptr [eax], 67452301h
		mov	dword ptr [eax+4], 0EFCDAB89h
		mov	dword ptr [eax+8], 98BADCFEh
		mov	dword ptr [eax+0Ch], 10325476h
		retn
_MD5Init	endp
;########################################################################
		public _MD5Update
_MD5Update	proc near
arg_0		= dword	ptr  4
arg_4		= dword	ptr  8
arg_8		= dword	ptr  0Ch
		push	ebp
		push	edi
		push	esi
		push	ebx
		mov	edi, [esp+10h+arg_0]
		mov	ebx, [esp+10h+arg_8]
		mov	eax, [edi+10h]
		mov	ebp, eax
		shr	ebp, 3
		and	ebp, 3Fh
		lea	edx, ds:0[ebx*8]
		add	eax, edx
		mov	[edi+10h], eax
		jnb	short loc_401D2B
		add	dword ptr [edi+14h], 1
loc_401D2B:
		mov	eax, ebx
		shr	eax, 1Dh
		add	[edi+14h], eax
		mov	esi, 40h
		sub	esi, ebp
		cmp	ebx, esi
		jnb	short loc_401D67
		mov	esi, 0
loc_401D43:
		lea	edx, [edi+ebp+18h]
		sub	ebx, esi
		jz	short loc_401D62
		mov	eax, esi
		add	eax, [esp+10h+arg_4]
		add	ebx, eax
loc_401D53:
		movzx	ecx, byte ptr [eax]
		mov	[edx], cl
		add	eax, 1
		add	edx, 1
		cmp	eax, ebx
		jnz	short loc_401D53
loc_401D62:
		pop	ebx
		pop	esi
		pop	edi
		pop	ebp
		retn
loc_401D67:
		lea	edx, [edi+ebp+18h]
		mov	ecx, esi
		add	ecx, [esp+10h+arg_4]
		mov	eax, [esp+10h+arg_4]
		mov	[esp+10h+arg_8], ebx
loc_401D79:
		movzx	ebx, byte ptr [eax]
		mov	[edx], bl
		add	eax, 1
		add	edx, 1
		cmp	eax, ecx
		jnz	short loc_401D79
		mov	ebx, [esp+10h+arg_8]
		lea	edx, [edi+18h]
		mov	eax, edi
		call	_MD5Transform
		mov	eax, 7Fh
		sub	eax, ebp
		cmp	eax, ebx
		jnb	short loc_401DC3
		mov	ebp, [esp+10h+arg_4]
loc_401DA5:
		lea	edx, [ebp+esi+0]
		mov	eax, edi
		call	_MD5Transform
		mov	eax, esi
		add	esi, 40h
		add	eax, 7Fh
		cmp	eax, ebx
		jb	short loc_401DA5
		mov	ebp, 0
		jmp	short loc_401D43
loc_401DC3:
		mov	ebp, 0
		jmp	loc_401D43
_MD5Update	endp

;########################################################################
		public _MD5Final
_MD5Final	proc near
var_20		= dword	ptr -20h
var_1C		= dword	ptr -1Ch
var_18		= dword	ptr -18h
var_C		= byte ptr -0Ch
arg_0		= dword	ptr  4
arg_4		= dword	ptr  8
		push	ebx
		sub	esp, 1Ch
		mov	ebx, [esp+20h+arg_4]
		lea	edx, [ebx+10h]
		mov	ecx, 8
		lea	eax, [esp+20h+var_C]
		call	_Encode
		mov	eax, [ebx+10h]
		shr	eax, 3
		and	eax, 3Fh
		cmp	eax, 37h
		ja	short loc_401E4B
		mov	edx, 38h
		sub	edx, eax
loc_401DFB:
		mov	[esp+20h+var_18], edx
		mov	[esp+20h+var_1C], offset _PADDING
		mov	[esp+20h+var_20], ebx
		call	_MD5Update
		mov	[esp+20h+var_18], 8
		lea	eax, [esp+20h+var_C]
		mov	[esp+20h+var_1C], eax
		mov	[esp+20h+var_20], ebx
		call	_MD5Update
		mov	ecx, 10h
		mov	edx, ebx
		mov	eax, [esp+20h+arg_0]
		call	_Encode
		mov	eax, ebx
		lea	edx, [ebx+58h]
loc_401E3C:
		mov	byte ptr [eax],	0
		add	eax, 1
		cmp	eax, edx
		jnz	short loc_401E3C
		add	esp, 1Ch
		pop	ebx
		retn
loc_401E4B:
		mov	edx, 78h
		sub	edx, eax
		jmp	short loc_401DFB
_MD5Final	endp

;########################################################################
_Encode		proc near
		test	ecx, ecx
		jz	short locret_4015CA
		push	esi
		push	ebx
		mov	ebx, eax
		mov	esi, ecx
		mov	eax, 0
loc_40159F:
		mov	ecx, [edx+eax]
		mov	[ebx+eax], cl
		mov	ecx, [edx+eax]
		mov	[ebx+eax+1], ch
		mov	ecx, [edx+eax]
		shr	ecx, 10h
		mov	[ebx+eax+2], cl
		mov	ecx, [edx+eax]
		shr	ecx, 18h
		mov	[ebx+eax+3], cl
		add	eax, 4
		cmp	eax, esi
		jb	short loc_40159F
		pop	ebx
		pop	esi
		retn
locret_4015CA:
		retn
_Encode		endp
;########################################################################
_MD5Transform	proc near
var_64		= dword	ptr -64h
var_60		= dword	ptr -60h
var_5C		= dword	ptr -5Ch
var_58		= dword	ptr -58h
var_54		= dword	ptr -54h
var_50		= dword	ptr -50h
var_4C		= dword	ptr -4Ch
var_48		= dword	ptr -48h
var_44		= dword	ptr -44h
var_40		= dword	ptr -40h
var_3C		= dword	ptr -3Ch
var_38		= dword	ptr -38h
var_34		= dword	ptr -34h
var_30		= dword	ptr -30h
var_2C		= dword	ptr -2Ch
var_28		= dword	ptr -28h
var_24		= dword	ptr -24h
var_20		= dword	ptr -20h
var_1C		= dword	ptr -1Ch
var_18		= dword	ptr -18h
var_14		= dword	ptr -14h
		push	ebp
		push	edi
		push	esi
		push	ebx
		sub	esp, 54h
		mov	ebp, eax
		mov	ecx, edx
		mov	eax, [eax]
		mov	[esp+64h+var_54], eax
		mov	eax, [ebp+4]
		mov	[esp+64h+var_60], eax
		mov	eax, [ebp+8]
		mov	[esp+64h+var_5C], eax
		mov	eax, [ebp+0Ch]
		mov	[esp+64h+var_58], eax
		mov	[esp+64h+var_64], 0
		mov	eax, 0
loc_4015FD:
		movzx	edx, byte ptr [ecx+eax+1]
		shl	edx, 8
		movzx	ebx, byte ptr [ecx+eax+2]
		shl	ebx, 10h
		or	edx, ebx
		movzx	ebx, byte ptr [ecx+eax]
		or	edx, ebx
		movzx	ebx, byte ptr [ecx+eax+3]
		shl	ebx, 18h
		or	edx, ebx
		mov	[esp+eax+64h+var_50], edx
		add	eax, 4
		cmp	eax, 40h
		jnz	short loc_4015FD
		mov	[esp+64h+var_64], eax
		mov	esi, [esp+64h+var_50]
		mov	edi, [esp+64h+var_54]
		lea	ecx, [esi+edi-28955B88h]
		mov	esi, [esp+64h+var_5C]
		mov	edx, esi
		mov	ebx, [esp+64h+var_58]
		xor	edx, ebx
		mov	edi, [esp+64h+var_60]
		and	edx, edi
		xor	edx, ebx
		add	edx, ecx
		rol	edx, 7
		add	edx, edi
		mov	ecx, [esp+64h+var_4C]
		lea	ebx, [ecx+ebx-173848AAh]
		mov	ecx, esi
		xor	ecx, edi
		and	ecx, edx
		xor	ecx, esi
		add	ecx, ebx
		rol	ecx, 0Ch
		add	ecx, edx
		mov	ebx, [esp+64h+var_48]
		lea	esi, [ebx+esi+242070DBh]
		mov	ebx, edi
		xor	ebx, edx
		and	ebx, ecx
		xor	ebx, edi
		add	ebx, esi
		ror	ebx, 0Fh
		add	ebx, ecx
		mov	esi, [esp+64h+var_44]
		lea	edi, [esi+edi-3E423112h]
		mov	esi, edx
		xor	esi, ecx
		and	esi, ebx
		xor	esi, edx
		add	esi, edi
		ror	esi, 0Ah
		add	esi, ebx
		mov	edi, [esp+64h+var_40]
		lea	edi, [edi+edx-0A83F051h]
		mov	edx, ecx
		xor	edx, ebx
		and	edx, esi
		xor	edx, ecx
		add	edx, edi
		rol	edx, 7
		add	edx, esi
		mov	edi, [esp+64h+var_3C]
		lea	edi, [edi+ecx+4787C62Ah]
		mov	ecx, ebx
		xor	ecx, esi
		and	ecx, edx
		xor	ecx, ebx
		add	ecx, edi
		rol	ecx, 0Ch
		add	ecx, edx
		mov	edi, [esp+64h+var_38]
		lea	edi, [edi+ebx-57CFB9EDh]
		mov	ebx, esi
		xor	ebx, edx
		and	ebx, ecx
		xor	ebx, esi
		add	ebx, edi
		ror	ebx, 0Fh
		add	ebx, ecx
		mov	edi, [esp+64h+var_34]
		lea	edi, [edi+esi-2B96AFFh]
		mov	esi, edx
		xor	esi, ecx
		and	esi, ebx
		xor	esi, edx
		add	esi, edi
		ror	esi, 0Ah
		add	esi, ebx
		mov	edi, [esp+64h+var_30]
		lea	edi, [edi+edx+698098D8h]
		mov	edx, ecx
		xor	edx, ebx
		and	edx, esi
		xor	edx, ecx
		add	edx, edi
		rol	edx, 7
		add	edx, esi
		mov	edi, [esp+64h+var_2C]
		lea	edi, [edi+ecx-74BB0851h]
		mov	ecx, ebx
		xor	ecx, esi
		and	ecx, edx
		xor	ecx, ebx
		add	ecx, edi
		rol	ecx, 0Ch
		add	ecx, edx
		mov	edi, [esp+64h+var_28]
		lea	edi, [edi+ebx-0A44Fh]
		mov	ebx, esi
		xor	ebx, edx
		and	ebx, ecx
		xor	ebx, esi
		add	ebx, edi
		ror	ebx, 0Fh
		add	ebx, ecx
		mov	edi, [esp+64h+var_24]
		lea	edi, [edi+esi-76A32842h]
		mov	esi, edx
		xor	esi, ecx
		and	esi, ebx
		xor	esi, edx
		add	esi, edi
		ror	esi, 0Ah
		add	esi, ebx
		mov	edi, [esp+64h+var_20]
		lea	edi, [edi+edx+6B901122h]
		mov	edx, ecx
		xor	edx, ebx
		and	edx, esi
		xor	edx, ecx
		add	edx, edi
		rol	edx, 7
		add	edx, esi
		mov	edi, [esp+64h+var_1C]
		lea	edi, [edi+ecx-2678E6Dh]
		mov	ecx, ebx
		xor	ecx, esi
		and	ecx, edx
		xor	ecx, ebx
		add	ecx, edi
		rol	ecx, 0Ch
		add	ecx, edx
		mov	edi, [esp+64h+var_18]
		lea	edi, [edi+ebx-5986BC72h]
		mov	ebx, esi
		xor	ebx, edx
		and	ebx, ecx
		xor	ebx, esi
		add	ebx, edi
		ror	ebx, 0Fh
		add	ebx, ecx
		mov	edi, [esp+64h+var_14]
		lea	edi, [edi+esi+49B40821h]
		mov	esi, edx
		xor	esi, ecx
		and	esi, ebx
		xor	esi, edx
		add	esi, edi
		ror	esi, 0Ah
		add	esi, ebx
		mov	edi, [esp+64h+var_4C]
		lea	edi, [edi+edx-9E1DA9Eh]
		mov	edx, ebx
		xor	edx, esi
		and	edx, ecx
		xor	edx, ebx
		add	edx, edi
		rol	edx, 5
		add	edx, esi
		mov	edi, [esp+64h+var_38]
		lea	edi, [edi+ecx-3FBF4CC0h]
		mov	ecx, esi
		xor	ecx, edx
		and	ecx, ebx
		xor	ecx, esi
		add	ecx, edi
		rol	ecx, 9
		add	ecx, edx
		mov	edi, [esp+64h+var_24]
		lea	edi, [edi+ebx+265E5A51h]
		mov	ebx, edx
		xor	ebx, ecx
		and	ebx, esi
		xor	ebx, edx
		add	ebx, edi
		rol	ebx, 0Eh
		add	ebx, ecx
		mov	edi, [esp+64h+var_50]
		lea	edi, [edi+esi-16493856h]
		mov	esi, ecx
		xor	esi, ebx
		and	esi, edx
		xor	esi, ecx
		add	esi, edi
		ror	esi, 0Ch
		add	esi, ebx
		mov	edi, [esp+64h+var_3C]
		lea	edi, [edi+edx-29D0EFA3h]
		mov	edx, ebx
		xor	edx, esi
		and	edx, ecx
		xor	edx, ebx
		add	edx, edi
		rol	edx, 5
		add	edx, esi
		mov	edi, [esp+64h+var_28]
		lea	edi, [edi+ecx+2441453h]
		mov	ecx, esi
		xor	ecx, edx
		and	ecx, ebx
		xor	ecx, esi
		add	ecx, edi
		rol	ecx, 9
		add	ecx, edx
		mov	edi, [esp+64h+var_14]
		lea	edi, [edi+ebx-275E197Fh]
		mov	ebx, edx
		xor	ebx, ecx
		and	ebx, esi
		xor	ebx, edx
		add	ebx, edi
		rol	ebx, 0Eh
		add	ebx, ecx
		mov	edi, [esp+64h+var_40]
		lea	edi, [edi+esi-182C0438h]
		mov	esi, ecx
		xor	esi, ebx
		and	esi, edx
		xor	esi, ecx
		add	esi, edi
		ror	esi, 0Ch
		add	esi, ebx
		mov	edi, [esp+64h+var_2C]
		lea	edi, [edi+edx+21E1CDE6h]
		mov	edx, ebx
		xor	edx, esi
		and	edx, ecx
		xor	edx, ebx
		add	edx, edi
		rol	edx, 5
		add	edx, esi
		mov	edi, [esp+64h+var_18]
		lea	edi, [edi+ecx-3CC8F82Ah]
		mov	ecx, esi
		xor	ecx, edx
		and	ecx, ebx
		xor	ecx, esi
		add	ecx, edi
		rol	ecx, 9
		add	ecx, edx
		mov	edi, [esp+64h+var_44]
		lea	edi, [edi+ebx-0B2AF279h]
		mov	ebx, edx
		xor	ebx, ecx
		and	ebx, esi
		xor	ebx, edx
		add	ebx, edi
		rol	ebx, 0Eh
		add	ebx, ecx
		mov	edi, [esp+64h+var_30]
		lea	esi, [edi+esi+455A14EDh]
		mov	edi, ecx
		xor	edi, ebx
		and	edi, edx
		xor	edi, ecx
		add	edi, esi
		ror	edi, 0Ch
		add	edi, ebx
		mov	esi, [esp+64h+var_1C]
		lea	esi, [esi+edx-561C16FBh]
		mov	edx, ebx
		xor	edx, edi
		and	edx, ecx
		xor	edx, ebx
		add	edx, esi
		rol	edx, 5
		add	edx, edi
		mov	esi, [esp+64h+var_48]
		lea	esi, [esi+ecx-3105C08h]
		mov	ecx, edi
		xor	ecx, edx
		and	ecx, ebx
		xor	ecx, edi
		add	ecx, esi
		rol	ecx, 9
		add	ecx, edx
		mov	esi, [esp+64h+var_34]
		lea	ebx, [esi+ebx+676F02D9h]
		mov	esi, edx
		xor	esi, ecx
		and	esi, edi
		xor	esi, edx
		add	esi, ebx
		rol	esi, 0Eh
		add	esi, ecx
		mov	ebx, ecx
		xor	ebx, esi
		mov	eax, [esp+64h+var_20]
		lea	eax, [eax+edi-72D5B376h]
		mov	edi, edx
		and	edi, ebx
		xor	edi, ecx
		add	edi, eax
		ror	edi, 0Ch
		add	edi, esi
		mov	eax, [esp+64h+var_3C]
		lea	edx, [eax+edx-5C6BEh]
		xor	ebx, edi
		add	ebx, edx
		rol	ebx, 4
		lea	edx, [edi+ebx]
		mov	eax, [esp+64h+var_30]
		lea	ebx, [eax+ecx-788E097Fh]
		mov	ecx, esi
		xor	ecx, edi
		xor	ecx, edx
		add	ecx, ebx
		rol	ecx, 0Bh
		add	ecx, edx
		mov	eax, [esp+64h+var_24]
		lea	esi, [eax+esi+6D9D6122h]
		mov	ebx, edi
		xor	ebx, edx
		xor	ebx, ecx
		add	ebx, esi
		rol	ebx, 10h
		add	ebx, ecx
		mov	eax, [esp+64h+var_18]
		lea	edi, [eax+edi-21AC7F4h]
		mov	esi, edx
		xor	esi, ecx
		xor	esi, ebx
		add	esi, edi
		ror	esi, 9
		add	esi, ebx
		mov	eax, [esp+64h+var_4C]
		lea	edi, [eax+edx-5B4115BCh]
		mov	edx, ecx
		xor	edx, ebx
		xor	edx, esi
		add	edx, edi
		rol	edx, 4
		add	edx, esi
		mov	eax, [esp+64h+var_40]
		lea	ecx, [eax+ecx+4BDECFA9h]
		mov	edi, ebx
		xor	edi, esi
		xor	edi, edx
		add	edi, ecx
		rol	edi, 0Bh
		add	edi, edx
		mov	eax, [esp+64h+var_34]
		lea	ecx, [eax+ebx-944B4A0h]
		mov	ebx, esi
		xor	ebx, edx
		xor	ebx, edi
		add	ebx, ecx
		rol	ebx, 10h
		add	ebx, edi
		mov	eax, [esp+64h+var_28]
		lea	esi, [eax+esi-41404390h]
		mov	ecx, edx
		xor	ecx, edi
		xor	ecx, ebx
		add	ecx, esi
		ror	ecx, 9
		add	ecx, ebx
		mov	eax, [esp+64h+var_1C]
		lea	edx, [eax+edx+289B7EC6h]
		mov	esi, edi
		xor	esi, ebx
		xor	esi, ecx
		add	esi, edx
		rol	esi, 4
		add	esi, ecx
		mov	eax, [esp+64h+var_50]
		lea	edx, [eax+edi-155ED806h]
		mov	edi, ebx
		xor	edi, ecx
		xor	edi, esi
		add	edi, edx
		rol	edi, 0Bh
		add	edi, esi
		mov	eax, [esp+64h+var_44]
		lea	ebx, [eax+ebx-2B10CF7Bh]
		mov	edx, ecx
		xor	edx, esi
		xor	edx, edi
		add	edx, ebx
		rol	edx, 10h
		add	edx, edi
		mov	eax, [esp+64h+var_38]
		lea	ecx, [eax+ecx+4881D05h]
		mov	ebx, esi
		xor	ebx, edi
		xor	ebx, edx
		add	ebx, ecx
		ror	ebx, 9
		add	ebx, edx
		mov	eax, [esp+64h+var_2C]
		lea	ecx, [eax+esi-262B2FC7h]
		mov	esi, edi
		xor	esi, edx
		xor	esi, ebx
		add	esi, ecx
		rol	esi, 4
		add	esi, ebx
		mov	eax, [esp+64h+var_20]
		lea	edi, [eax+edi-1924661Bh]
		mov	ecx, edx
		xor	ecx, ebx
		xor	ecx, esi
		add	ecx, edi
		rol	ecx, 0Bh
		add	ecx, esi
		mov	eax, [esp+64h+var_14]
		lea	edx, [eax+edx+1FA27CF8h]
		mov	edi, ebx
		xor	edi, esi
		xor	edi, ecx
		add	edi, edx
		rol	edi, 10h
		add	edi, ecx
		mov	eax, [esp+64h+var_48]
		lea	edx, [eax+ebx-3B53A99Bh]
		mov	ebx, esi
		xor	ebx, ecx
		xor	ebx, edi
		add	ebx, edx
		ror	ebx, 9
		add	ebx, edi
		mov	eax, [esp+64h+var_50]
		lea	esi, [eax+esi-0BD6DDBCh]
		mov	edx, ecx
		not	edx
		or	edx, ebx
		xor	edx, edi
		add	edx, esi
		rol	edx, 6
		add	edx, ebx
		mov	eax, [esp+64h+var_34]
		lea	ecx, [eax+ecx+432AFF97h]
		mov	esi, edi
		not	esi
		or	esi, edx
		xor	esi, ebx
		add	esi, ecx
		rol	esi, 0Ah
		add	esi, edx
		mov	eax, [esp+64h+var_18]
		lea	ecx, [eax+edi-546BDC59h]
		mov	edi, ebx
		not	edi
		or	edi, esi
		xor	edi, edx
		add	edi, ecx
		rol	edi, 0Fh
		add	edi, esi
		mov	eax, [esp+64h+var_3C]
		lea	ebx, [eax+ebx-36C5FC7h]
		mov	ecx, edx
		not	ecx
		or	ecx, edi
		xor	ecx, esi
		add	ecx, ebx
		ror	ecx, 0Bh
		add	ecx, edi
		mov	eax, [esp+64h+var_20]
		lea	edx, [eax+edx+655B59C3h]
		mov	ebx, esi
		not	ebx
		or	ebx, ecx
		xor	ebx, edi
		add	ebx, edx
		rol	ebx, 6
		add	ebx, ecx
		mov	eax, [esp+64h+var_44]
		lea	edx, [eax+esi-70F3336Eh]
		mov	esi, edi
		not	esi
		or	esi, ebx
		xor	esi, ecx
		add	esi, edx
		rol	esi, 0Ah
		add	esi, ebx
		mov	eax, [esp+64h+var_28]
		lea	edi, [eax+edi-100B83h]
		mov	edx, ecx
		not	edx
		or	edx, esi
		xor	edx, ebx
		add	edx, edi
		rol	edx, 0Fh
		add	edx, esi
		mov	eax, [esp+64h+var_4C]
		lea	ecx, [eax+ecx-7A7BA22Fh]
		mov	edi, ebx
		not	edi
		or	edi, edx
		xor	edi, esi
		add	edi, ecx
		ror	edi, 0Bh
		add	edi, edx
		mov	eax, [esp+64h+var_30]
		lea	ecx, [eax+ebx+6FA87E4Fh]
		mov	ebx, esi
		not	ebx
		or	ebx, edi
		xor	ebx, edx
		add	ebx, ecx
		rol	ebx, 6
		add	ebx, edi
		mov	eax, [esp+64h+var_14]
		lea	esi, [eax+esi-1D31920h]
		mov	ecx, edx
		not	ecx
		or	ecx, ebx
		xor	ecx, edi
		add	ecx, esi
		rol	ecx, 0Ah
		add	ecx, ebx
		mov	eax, [esp+64h+var_38]
		lea	edx, [eax+edx-5CFEBCECh]
		mov	esi, edi
		not	esi
		or	esi, ecx
		xor	esi, ebx
		add	esi, edx
		rol	esi, 0Fh
		add	esi, ecx
		mov	eax, [esp+64h+var_1C]
		lea	edx, [eax+edi+4E0811A1h]
		mov	edi, ebx
		not	edi
		or	edi, esi
		xor	edi, ecx
		add	edi, edx
		ror	edi, 0Bh
		add	edi, esi
		mov	eax, [esp+64h+var_40]
		lea	ebx, [eax+ebx-8AC817Eh]
		mov	edx, ecx
		not	edx
		or	edx, edi
		xor	edx, esi
		add	edx, ebx
		rol	edx, 6
		add	edx, edi
		mov	eax, [esp+64h+var_24]
		lea	ebx, [eax+ecx-42C50DCBh]
		mov	ecx, esi
		not	ecx
		or	ecx, edx
		xor	ecx, edi
		add	ecx, ebx
		rol	ecx, 0Ah
		add	ecx, edx
		mov	eax, [esp+64h+var_48]
		lea	esi, [eax+esi+2AD7D2BBh]
		mov	ebx, edi
		not	ebx
		or	ebx, ecx
		xor	ebx, edx
		add	ebx, esi
		rol	ebx, 0Fh
		add	ebx, ecx
		mov	eax, [esp+64h+var_2C]
		lea	edi, [eax+edi-14792C6Fh]
		mov	esi, edx
		not	esi
		or	esi, ebx
		xor	esi, ecx
		add	esi, edi
		mov	edi, [esp+64h+var_54]
		add	edx, edi
		mov	[ebp+0], edx
		ror	esi, 0Bh
		mov	edi, [esp+64h+var_60]
		lea	edx, [edi+ebx]
		add	esi, edx
		mov	[ebp+4], esi
		mov	esi, [esp+64h+var_5C]
		lea	edx, [esi+ebx]
		mov	[ebp+8], edx
		mov	ebx, [esp+64h+var_58]
		lea	edx, [ebx+ecx]
		mov	[ebp+0Ch], edx
		mov	eax, [esp+64h+var_64]
loc_401CC7:
		sub	eax, 1
		jnz	short loc_401CC7
		add	esp, 54h
		pop	ebx
		pop	esi
		pop	edi
		pop	ebp
		retn
_MD5Transform	endp
