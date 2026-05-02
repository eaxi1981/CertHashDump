    .686p
    .model flat, stdcall
    option casemap :none
    OPTION NOSCOPED
;------------------------------------------------------------------------------------------------------------------------------------------
include c:\masm32\include\windows.inc
include c:\masm32\m32lib\masm32.inc
includelib c:\masm32\m32lib\masm32.lib
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\comdlg32.inc
include c:\masm32\include\msvcrt.inc
include c:\masm32\include\libc.inc
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\comdlg32.lib
includelib c:\masm32\lib\msvcrt.lib
includelib c:\masm32\lib\libc.lib

_memset 		EQU _imp__memset
_memcpy		EQU _imp__memcpy
_malloc		EQU _imp__malloc
_malloc		EQU _imp___malloc
_free		EQU _imp__free
_strlen		EQU _imp__strlen
_fopen		EQU _imp__fopen
_printf		EQU _imp__printf
_fread		EQU _imp__fread
_fclose		EQU _imp__fclose
    .data
;------------------------------------------------------------------------------------------------------------------------------------------
nNumberOfBytesToWrite 	dd 0
nNumberOfBytesToRead 	dd 0
nNumberOfBytesWritten	dd 0
nNumberOfBytesRead	dd 0
lpNumberOfBytesWritten 	dd offset nNumberOfBytesWritten
lpNumberOfBytesRead 	dd offset nNumberOfBytesRead
;------------------------------------------------------------------------------------------------------------------------------------------
STRUCTURE_for_OPEN_FILE 	dd 04Ch
hwndOwner	dd 0
hInstance 	dd 400000h
lpstrFilter 		dd 0
lpstrCustomFilter	dd 0
nMaxCustFilter 	dd 0
nFilterIndex 	dd 1
off_FILENAME 	dd offset FILENAME_INPUT
nMaxFile 		dd 200h
lpstrFileTitle 	dd 0
nMaxFileTitle 	dd 0
lpstrInitialDir 	dd offset INITIAL_DIRECTORY
lpstrTitle 		dd 0
Flags 		dd 0
nFileOffset 	dd 0
nFileExtension 	dd 0
lpstrDefExt 	dd 0
lCustData 		dd 0
lpfnHook 		dd 0
lpTemplateName 	dd 0
;------------------------------------------------------------------------------------------------------------------------------------------
LOOKUP_TABLE_HEX		db '00'
db '0102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F202122232425262728292A2B2C2D2E2F303132333435363738393A3B3C3D3E3F40'
db '4142434445464748494A4B4C4D4E4F505152535455565758595A5B5C5D5E5F606162636465666768696A6B6C6D6E6F707172737475767778797A7B7C7D7E7F'
db '808182838485868788898A8B8C8D8E8F909192939495969798999A9B9C9D9E9FA0A1A2A3A4A5A6A7A8A9AAABACADAEAFB0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF'
db 'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECFD0D1D2D3D4D5D6D7D8D9DADBDCDDDEDFE0E1E2E3E4E5E6E7E8E9EAEBECEDEEEFF0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF',0
LOOKUP_TABLE_DEC		db '00010203040506070809'
db '1011121314151617181920212223242526272829303132333435363738394041424344454647484950'
db '51525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899',0
CURRENT_POS_in_LOOKUP_TABLE	dd offset LOOKUP_TABLE_HEX
;------------------------------------------------------------------------------------------------------------------------------------------
const_k		dd 428A2F98h
		dd 71374491h, 0B5C0FBCFh, 0E9B5DBA5h, 3956C25Bh, 59F111F1h
		dd 923F82A4h, 0AB1C5ED5h, 0D807AA98h, 12835B01h, 243185BEh
		dd 550C7DC3h, 72BE5D74h, 80DEB1FEh, 9BDC06A7h, 0C19BF174h
		dd 0E49B69C1h, 0EFBE4786h, 0FC19DC6h, 240CA1CCh, 2DE92C6Fh
		dd 4A7484AAh, 5CB0A9DCh, 76F988DAh, 983E5152h, 0A831C66Dh
		dd 0B00327C8h, 0BF597FC7h, 0C6E00BF3h, 0D5A79147h, 6CA6351h
		dd 14292967h, 27B70A85h, 2E1B2138h, 4D2C6DFCh, 53380D13h
		dd 650A7354h, 766A0ABBh, 81C2C92Eh, 92722C85h, 0A2BFE8A1h
		dd 0A81A664Bh, 0C24B8B70h, 0C76C51A3h, 0D192E819h, 0D6990624h
		dd 0F40E3585h, 106AA070h, 19A4C116h, 1E376C08h, 2748774Ch
		dd 34B0BCB5h, 391C0CB3h, 4ED8AA4Ah, 5B9CCA4Fh, 682E6FF3h
		dd 748F82EEh, 78A5636Fh, 84C87814h, 8CC70208h, 90BEFFFAh
		dd 0A4506CEBh, 0BEF9A3F7h, 0C67178F2h
SHA256_strucstart	dd 1Ch dup(0)
a		dd 0
b		dd 0
c_var		dd 0
d		dd 0
e		dd 0
f		dd 0
g		dd 0
h		dd 0
i		dd 0
j		dd 0
t1		dd 0
t2		dd 0
m		dd 0
		dd 3Fh dup(0)
;------------------------------------------------------------------------------------------------------------------------------------------
SHA1_strucstart	dd 1Ch dup(0)
;------------------------------------------------------------------------------------------------------------------------------------------
MD5_context	db 80 dup (0)
;------------------------------------------------------------------------------------------------------------------------------------------
hFile_INPUT		dd 0
hFile_OUTPUT		dd 0
hFile_RESULT		dd 0
hFile_DATABASE		dd 0
;------------------------------------------------------------------------------------------------------------------------------------------
BUFOR_INPUT_size		dd 0
BUFOR_INPUT_handle	dd 0
BUFOR_INPUT_start		dd 0
BUFOR_INPUT_end		dd 0
BUFOR_OUTPUT_size	dd 0
BUFOR_OUTPUT_handle	dd 0
BUFOR_OUTPUT_start	dd 0
SECOND_BUFOR_size	dd 0
SECOND_BUFOR_handle	dd 0
SECOND_BUFOR_start	dd 0
BUFOR_TEMP		db 200h dup (0)
STATUS_FINAL_txt		db 100h dup (0)
;------------------------------------------------------------------------------------------------------------------------------------------
FILENAME_INPUT		db 200h dup (0)
FILENAME_INPUT_NO_PATH 	db 200h dup (0)
FILENAME_INPUT_BAD 	db 200h dup (0)
FILENAME_OUTPUT		db 200h dup (0)
FILENAME_RESULT		db 200h dup (0)
FILENAME_CERT		db 200h dup (0)
FILENAME_CERT_TBS	db 200h dup (0)
FILENAME_DATABASE	db '_DATABASE.CSV',0
;------------------------------------------------------------------------------------------------------------------------------------------
RESULT_MD5_16b		db 16 dup (0), 0
RESULT_MD5_16b_TXT	db 32 dup (0), 0
RESULT_SHA1_20b		db 20 dup (0), 0
RESULT_SHA1_20b_TXT	db 40 dup (0), 0
RESULT_SHA256_32b	db 32 dup (0), 0
RESULT_SHA256_32b_TXT	db 64 dup (0), 0
;------------------------------------------------------------------------------------------------------------------------------------------
INITIAL_DIRECTORY		db '.',0,0
Filter_OPEN_INPUT 		db 'All files',0,'*.*',0,'All files',0,'*.*',0,0
TYTUL_OPEN_INPUT	db 'SELECT INPUT. OUTPUT will be created in same directory.',0
;------------------------------------------------------------------------------------------------------------------------------------------
MODE			dd 0
;------------------------------------------------------------------------------------------------------------------------------------------
SUCCESSTitle_txt		db '                  :)',0
ErrorTitle      		db '                  :(',0
SUCCESS_txt		db 'EXTRACT CERTIFICATES SUCCESS',0
ERROR_CMDLINE_BAD_HEX	db 'bad cmd-line: remove space from name',0
ERROR_INPUT		db 'CreateFile: Access Violation',0
ERROR_OUTPUT		db 'CreateFile: output file error',0
ERROR_SEH		db 'Exception at:',0
ERROR_CERTS_ABOVE_256	db 'Above 256 certificates in file',0
;------------------------------------------------------------------------------------------------------------------------------------------
ERROR_PE_NR			dd 0
ERROR_0_offset			dd offset ERROR_0_STATUS_OK_txt
ERROR_1_offset			dd offset ERROR_1_file_not_PE_txt
ERROR_2_offset			dd offset ERROR_2_bad_OptionalHeader_txt
ERROR_3_offset			dd offset ERROR_3_NO_SECURITY_DIRECTORY_txt
ERROR_4_offset			dd offset ERROR_4_SecurityOutOfFile_txt
ERROR_5_offset			dd offset ERROR_5_No_RSRC_section_txt
ERROR_6_offset 			dd offset ERROR_6_no_VS_VERSION_INFO_txt
ERROR_0_STATUS_OK_txt		db 'Status OK',0
ERROR_1_file_not_PE_txt		db 'ERROR 1: PE: not MZ/PE file',0
ERROR_2_bad_OptionalHeader_txt 	db 'ERROR 2: PE: Optional Header non-10B non-20B',0
ERROR_3_NO_SECURITY_DIRECTORY_txt	db 'ERROR 3: PE: No SECURITY_DIRECTORY',0
ERROR_4_SecurityOutOfFile_txt	db 'ERROR 4: PE: SECURITY_DIRECTORY out of file', 0
ERROR_5_No_RSRC_section_txt	db 'ERROR 5: PE: no .RSRC section', 0
ERROR_6_no_VS_VERSION_INFO_txt	db 'ERROR 6: PE: no VS_VERSION_INFO', 0
;------------------------------------------------------------------------------------------------------------------------------------------
INTRO_header		db 'CertHashDump',0
INTRO_txt		db 'CertHashDump.exe',13,10,'[INPUT] [MODE]',0
ConsoleOut_handle		dd 0
NEXT_LINE_txt		db 13,10,0
COLON_txt		db ': ',0
TABULATOR_txt		db 9,0
;------------------------------------------------------------------------------------------------------------------------------------------
INPUT_BAD_txt		db '.BAD',0
ORIG_PE_EXE_txt		db '_ORIG_PE_EXE_______.bin',20h dup (0)
AUTHENTICODE_PE_EXE_txt	db '_AUTHENTICODE_PE__.bin',20h dup (0)
SECURITY_DIRECTORY_txt	db '_SECURITY_DIRECTORY.bin',20h dup (0)
CERTIFICATES_ALL____txt	db '_CERTIFICATES_ALL___.cer',20h dup (0)
CERTIFICATE_x_txt		db '_CERTIFICATE_00_FULL.cer',20h dup (0)
CERTIFICATE_x_TBS_txt	db '_CERTIFICATE_00_TBS_.cer',20h dup (0)
FINAL_RESULT_txt		db '_FINAL_RESULT.CSV', 20h dup (0)
;------------------------------------------------------------------------------------------------------------------------------------------
PE_OptionalHeader_VA			dd 0
PE_OptionalHeader_checksum_VA		dd 0
PE_DirectoryEntries_VA			dd 0
PE_DirectoryEntries_SecurityDirectory_VA	dd 0
PE_Sections_VA				dd 0
PE_Headers_End_VA			dd 0
SECURITY_CONTENT_start_VA			dd 0
SECURITY_CONTENT_current_VA		dd 0
SECURITY_CONTENT_end_VA			dd 0
Section_RSRC_start_VA			dd 0
Section_RSRC_end_VA			dd 0
Section_RSRC_VERSION_start_VA		dd 0
Section_RSRC_VERSION_end_VA		dd 0
Section_RSRC_VERSION_ANSI_end_VA		dd 0
PE_SECURITY_DIRECTORY_RawOffset		dd 0
Section_RSRC_RawOffset			dd 0
PE_SizeOfHeaders				dd 0
PE_SizeOfOptionalHeader			dd 0
SECURITY_CONTENT_size			dd 0
Section_RSRC_size				dd 0
Section_RSRC_VERSION_size			dd 0
Section_RSRC_VERSION_ANSI_size		dd 0
CompanyName				db 100h dup (0)
InternalName				db 100h dup (0)
OriginalFileName				db 100h dup (0)
EMPTY_CONTENT_txt			db 'empty', 0
;------------------------------------------------------------------------------------------------------------------------------------------
_Disasm STRUCT
    EIP            		DWORD ?
    VirtualAddr     		DQ    ?
    SecurityBlock   		DWORD ?
    CompleteInstr   		DB 64 DUP(?)
    Archi           		DWORD ?
    Options         		DWORD ?
    Reserved        		DB 400 DUP(?)
_Disasm ENDS
;------------------------------------------------------
dasm _Disasm 		<0>
szDasm 			db 64 dup(0)
DUMMY			db 1000 dup (0)
;------------------------------------------------------------------------------------------------------------------------------------------
BeaEngine_DLL_txt		db 'BeaEngine.DLL',0
BeaEngine_Disasm_txt	db 'Disasm',0
BeaEngine_handle		dd 0
BeaEngine_LOADED		dd 0
Disasm			dd 0
;------------------------------------------------------------------------------------------------------------------------------------------
SEH_EIP_RVA_address	dd 0
SEH_EIP_Raw_address	dd 0
SEH_EIP_Raw_address_txt	db 10 dup (0)
SEH_EIP_raw_bytes		db 100 dup (0)
SEH_CONTEXT_RECORD	dd 0
;#########################################################################################################################################
.code
start:
;#########################################################################################################################################
jmp REAL_START
include SHA256a.INC
include SHA1.INC
include MD5.INC

REAL_START:
call SET_CONSOLE
call TRY_LOAD_BeaEngine
call CREATE_DATABASE_FILE

push offset SEH_HANDLER
call SetUnhandledExceptionFilter

call PARSE_CMDLINE
call GET_MODE_from_ARG2

cmp MODE, 0
jne omit_copy_file_as_bad
call CREATE_NAME_INPUT_BAD
invoke CopyFileA, offset FILENAME_INPUT, offset FILENAME_INPUT_BAD, 0

omit_copy_file_as_bad:
call OPEN_INPUT_and_SET_BUFORS
call DISPLAY_FILENAME_INPUT_NO_PATH

cmp MODE, 0
je OMIT_CREATE_RESULT_FILE
call CREATE_RESULT_FILE

OMIT_CREATE_RESULT_FILE:
call PARSE_PE
call SET_STATUS_from_ERROR_PE
call CALC_HASHES_for_FULL_FILE

cmp ERROR_PE_NR, 0
jne BAD_PE
call CREATE_AUTHENTICODE_PE_FILE
call EXTRACT_SECURITY_DIRECTORY
call EXTRACT_CERTIFICATES_ALL
mov ESI, SECURITY_CONTENT_start_VA
mov SECURITY_CONTENT_current_VA, ESI
jmp SEARCH_FIRST_3082
;#########################################################################################################################################
ERROR_on_CREATE_INPUT:
invoke GetLastError
call SET_STATUS_from_EBX
call DISPLAY_FILENAME_INPUT_NO_PATH
mov ESI, offset FILENAME_INPUT_NO_PATH
call WRITE_ESI_and_TAB_to_RESULT_and_BASE
mov EBX, offset STATUS_FINAL_txt

cmp MODE, 0
jne FINITO_ERROR_text_in_EBX
call WRITE_EBX_to_CONSOLE
mov ESI, offset STATUS_FINAL_txt
call WRITE_ESI_and_NEXTLINE_to_RESULT_and_BASE
call CLOSE_ALL
jmp EXITPROCESS
;#########################################################################################################################################
SET_STATUS_from_EBX:
mov ECX, 100h
mov ESI, EBX
mov EDI, offset STATUS_FINAL_txt
rep movsb
ret
;#########################################################################################################################################
SET_STATUS_from_ERROR_PE:
mov EAX, ERROR_PE_NR
shl EAX, 2
mov ESI, offset ERROR_PE_NR
add ESI, 4
mov EBX, [ESI+EAX]
call SET_STATUS_from_EBX
ret
;#########################################################################################################################################
WRITE_EBX_to_CONSOLE:
invoke _strlen, EBX
invoke WriteConsole, ConsoleOut_handle,EBX, EAX, offset nNumberOfBytesWritten,0
invoke WriteConsole, ConsoleOut_handle,offset TABULATOR_txt , 2, offset nNumberOfBytesWritten,0
ret
;#########################################################################################################################################
FINITO_SUCCESS_PROC:
call CLOSE_ALL
cmp MODE, 0
je DELETE_INPUT_BAD
invoke MessageBoxA,NULL,offset SUCCESS_txt,offset SUCCESSTitle_txt,MB_ICONEXCLAMATION
jmp EXITPROCESS

DELETE_INPUT_BAD:
invoke DeleteFileA, offset FILENAME_INPUT_BAD
EXITPROCESS:
invoke ExitProcess,NULL
;------------------------------------------------------------------------------------------------------------------------------------------
FINITO_ERROR_text_in_EBX:
call CLOSE_ALL
invoke MessageBoxA, NULL, EBX, offset ErrorTitle, MB_ICONEXCLAMATION
jmp EXITPROCESS
;------------------------------------------------------------------------------------------------------------------------------------------
GET_MODE_from_ARG2:
mov ESI, offset FILENAME_OUTPUT
mov EAX, [ESI]
cmp EAX, 'esab'
je BASE
cmp EAX, 'ESAB'
je BASE
SAVE:
mov MODE, 1
ret
BASE:
mov MODE, 0
ret
;------------------------------------------------------------------------------------------------------------------------------------------
BAD_PE:
call SET_STATUS_from_ERROR_PE
call WRITE_EBX_to_CONSOLE
cmp ERROR_PE_NR, 3
jb NOT_PE
call CREATE_AUTHENTICODE_PE_FILE

NOT_PE:
mov ESI, BUFOR_INPUT_start
mov SECURITY_CONTENT_start_VA, ESI
mov SECURITY_CONTENT_current_VA, ESI
add ESI, BUFOR_INPUT_size
mov SECURITY_CONTENT_end_VA, ESI
mov ESI, SECURITY_CONTENT_start_VA
jmp SEARCH_FIRST_3082
;#######################################################################################
FRAGG__WRITE_as_FILE_and_CALC_HASH:
cmp MODE, 0
je OMIJA_in_FRAGG
call CREATE_file_FILENAME_OUTPUT
invoke WriteFile, hFile_OUTPUT, ESI, BUFOR_OUTPUT_size, lpNumberOfBytesWritten,0
invoke CloseHandle, hFile_OUTPUT
OMIJA_in_FRAGG:
call CALC_SHA256
call CALC_SHA1
call CALC_MD5
call CONVERT_HASHES_to_ASCII

mov ESI, offset FILENAME_OUTPUT
call WRITE_ESI_and_TAB_to_RESULT_and_BASE

mov ESI, offset STATUS_FINAL_txt
call WRITE_ESI_and_TAB_to_RESULT_and_BASE

mov ESI, offset RESULT_MD5_16b_TXT
call WRITE_ESI_and_TAB_to_RESULT_and_BASE

mov ESI, offset RESULT_SHA1_20b_TXT
call WRITE_ESI_and_TAB_to_RESULT_and_BASE

mov ESI, offset RESULT_SHA256_32b_TXT
call WRITE_ESI_and_TAB_to_RESULT_and_BASE

mov ESI, offset CompanyName
call WRITE_ESI_and_TAB_to_RESULT_and_BASE

mov ESI, offset InternalName
call WRITE_ESI_and_TAB_to_RESULT_and_BASE

mov ESI, offset OriginalFileName
call WRITE_ESI_and_NEXTLINE_to_RESULT_and_BASE

ret
;#######################################################################################
WRITE_ESI_and_TAB_to_RESULT_and_BASE:
call WRITE_to_RESULT_and_BASE
mov ESI, offset TABULATOR_txt
call WRITE_to_RESULT_and_BASE
ret
;-----------------------------------------------------------------
WRITE_ESI_and_NEXTLINE_to_RESULT_and_BASE:
call WRITE_to_RESULT_and_BASE
mov ESI, offset NEXT_LINE_txt
call WRITE_to_RESULT_and_BASE
ret
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
WRITE_to_RESULT_and_BASE:
invoke _strlen, ESI
mov BUFOR_OUTPUT_size, EAX
cmp EAX, 0
je WRITE_to_BASE
cmp MODE, 0
je WRITE_to_BASE
WRITE_to_RESULT:
invoke WriteFile, hFile_RESULT, ESI, BUFOR_OUTPUT_size, lpNumberOfBytesWritten,0
WRITE_to_BASE:
invoke WriteFile, hFile_DATABASE, ESI, BUFOR_OUTPUT_size, lpNumberOfBytesWritten,0
ret
;#######################################################################################
CALC_HASHES_for_FULL_FILE:
mov EBX, offset ORIG_PE_EXE_txt
call CREATE_NAME_FILENAME_OUTPUT
mov EAX, BUFOR_INPUT_size
mov BUFOR_OUTPUT_size, EAX
mov ESI, BUFOR_INPUT_start
call FRAGG__WRITE_as_FILE_and_CALC_HASH
ret
;#######################################################################################
PARSE_PE:
;--------------------------------------------------------------------
cmp BUFOR_INPUT_size, 300h
jb ERROR_1_file_not_PE
mov ESI, BUFOR_INPUT_start
mov AX, [ESI]
cmp AX, 'ZM'
jne ERROR_1_file_not_PE
mov EAX, [ESI + 3Ch]
add ESI, EAX
cmp ESI, BUFOR_INPUT_end
ja ERROR_1_file_not_PE
;--------------------------------------------------------------------
mov AX, [ESI]
cmp AX, 'EP'
jne ERROR_1_file_not_PE
xor EAX, EAX
mov AX, [ESI + 14h]
mov PE_SizeOfOptionalHeader, EAX
add ESI, 6*4
;--------------------------------------------------------------------
mov PE_OptionalHeader_VA, ESI
mov EAX, [ESI+3Ch]
mov PE_SizeOfHeaders, EAX
add EAX, BUFOR_INPUT_start
mov PE_Headers_End_VA, EAX
mov PE_OptionalHeader_checksum_VA, ESI
add PE_OptionalHeader_checksum_VA, 40h
cmp word ptr [ESI], 20Bh
jne check_10B
add ESI, 112
jmp ESI_na_DIRECTORY_ENTRIES
check_10B:
cmp word ptr [ESI], 10Bh
jne ERROR_2_bad_OptionalHeader
add ESI, 96
;-------------------------------------------------------------------
ESI_na_DIRECTORY_ENTRIES:
mov PE_DirectoryEntries_VA, ESI
add ESI, 4*8
;-------------------------------------------------------------------
mov PE_DirectoryEntries_SecurityDirectory_VA, ESI
mov EAX, [ESI]
mov PE_SECURITY_DIRECTORY_RawOffset, EAX
cmp EAX, 0
je ERROR_3_NO_SECURITY_DIRECTORY
cmp EAX, BUFOR_INPUT_size
jae ERROR_4_SecurityDirectory_out_of_file
mov EAX, [ESI+4]
cmp EAX, 0
je ERROR_3_NO_SECURITY_DIRECTORY
cmp EAX, 10000h
jae ERROR_3_NO_SECURITY_DIRECTORY
mov SECURITY_CONTENT_size, EAX
mov BUFOR_OUTPUT_size, EAX
add EAX, PE_SECURITY_DIRECTORY_RawOffset
cmp EAX, BUFOR_INPUT_size
ja ERROR_4_SecurityDirectory_out_of_file
AFTER_ERROR_PE_NR_3_and_4:
mov ESI, BUFOR_INPUT_start
add ESI, PE_SECURITY_DIRECTORY_RawOffset
;-------------------------------------------------------------------
mov SECURITY_CONTENT_start_VA, ESI
add ESI, SECURITY_CONTENT_size
mov SECURITY_CONTENT_end_VA, ESI
mov ESI, PE_OptionalHeader_VA
add ESI, PE_SizeOfOptionalHeader
;-------------------------------------------------------------------
mov PE_Sections_VA, ESI
RSRC_SECTION_ENTRY_SEARCH:
mov EAX, [ESI]
cmp EAX, 'rsr.'
je RSRC_SECTION_ENTRY_FOUND
cmp ESI, PE_Headers_End_VA
jae ERROR_5_No_RSRC_section
add ESI, 40
jmp RSRC_SECTION_ENTRY_SEARCH
;-------------------------------------------------------------------
RSRC_SECTION_ENTRY_FOUND:
mov EAX, [ESI+5*4]
mov Section_RSRC_RawOffset, EAX
add EAX, BUFOR_INPUT_start
mov Section_RSRC_start_VA, EAX
mov EAX, [ESI+4*4]
mov Section_RSRC_size, EAX
add EAX, Section_RSRC_RawOffset
cmp EAX, BUFOR_INPUT_size
ja ERROR_5_No_RSRC_section
mov EAX, Section_RSRC_start_VA
add EAX, Section_RSRC_size
mov Section_RSRC_end_VA, EAX
call PARSE_RSRC
ret
;#######################################################################################
ERROR_1_file_not_PE:
mov ERROR_PE_NR, 1
ret
;-------------------------------------------------------------------
ERROR_2_bad_OptionalHeader:
mov ERROR_PE_NR, 2
ret
;-------------------------------------------------------------------
ERROR_3_NO_SECURITY_DIRECTORY:
mov ERROR_PE_NR, 3
jmp AFTER_ERROR_PE_NR_3_and_4
;-------------------------------------------------------------------
ERROR_4_SecurityDirectory_out_of_file:
mov ERROR_PE_NR, 4
jmp AFTER_ERROR_PE_NR_3_and_4
;-------------------------------------------------------------------
ERROR_5_No_RSRC_section:
cmp ERROR_PE_NR, 0
jne error_already_set
mov ERROR_PE_NR, 5
error_already_set:
ret
;--------------------------------------------
ERROR_6_no_VS_VERSION_INFO:
cmp ERROR_PE_NR, 0
jne error_already_set
mov ERROR_PE_NR, 6
jmp PARSE_RSRC_ends
;#######################################################################################
PARSE_RSRC:
mov ESI, Section_RSRC_start_VA
SEARCH_34000000:
cmp ESI, Section_RSRC_end_VA
jae ERROR_6_no_VS_VERSION_INFO
mov EAX, [ESI+2]
cmp EAX, 00000034h
je SEARCH_VS_VERSION_INFO
SEARCH_34000000_loop:
inc ESI
jmp SEARCH_34000000
SEARCH_VS_VERSION_INFO:
mov EAX, [ESI+6]
cmp EAX, 00530056h
jne SEARCH_34000000_loop
mov EAX, [ESI+10]
cmp EAX, 0056005Fh
jne SEARCH_34000000_loop
;-------------------------------------------------------------------
mov Section_RSRC_VERSION_start_VA, ESI
xor EAX, EAX
mov AX, [ESI]
mov Section_RSRC_VERSION_size, EAX
add EAX, Section_RSRC_VERSION_start_VA
mov Section_RSRC_VERSION_end_VA, EAX
mov ESI, Section_RSRC_VERSION_start_VA
mov EDI, SECOND_BUFOR_start
mov ECX, Section_RSRC_VERSION_size
shr ECX, 1
mov Section_RSRC_VERSION_ANSI_size, ECX
deUNICODE:
lodsw
stosb
loop deUNICODE
mov ESI, SECOND_BUFOR_start
;-------------------------------------------------------------------
mov EAX, ESI
add EAX, Section_RSRC_VERSION_ANSI_size
mov Section_RSRC_VERSION_ANSI_end_VA, EAX
;--------------------------------------------
SEARCH_CompanyName_loop:
mov EAX, [ESI]
cmp EAX, 'pmoC'
je FOUND_Comp
SEARCH_CompanyName_loop2:
inc ESI
cmp ESI, Section_RSRC_VERSION_ANSI_end_VA
jae SEARCH_InternalName
jmp SEARCH_CompanyName_loop
FOUND_Comp:
mov EAX, [ESI+4]
cmp EAX, 'Nyna'
jne SEARCH_CompanyName_loop2
mov EAX, [ESI+7]
cmp EAX, 'emaN'
jne SEARCH_CompanyName_loop2
FOUND_CompanyName:
mov AL, [ESI-2]
mov EDX, offset CompanyName_write_content
cmp AL, 0
je EMPTY_CONTENT
call FOUND_LABEL
CompanyName_write_content:
mov EDI, offset CompanyName
call COPY_CONTENT_to_OWN_BUFOR
;--------------------------------------------
SEARCH_InternalName:
mov ESI, SECOND_BUFOR_start
SEARCH_InternalName_loop:
mov EAX, [ESI]
cmp EAX, 'etnI'
je FOUND_Inte
SEARCH_InternalName_loop2:
inc ESI
cmp ESI, Section_RSRC_VERSION_ANSI_end_VA
jae SEARCH_OriginalFileName
jmp SEARCH_InternalName_loop
FOUND_Inte:
mov EAX, [ESI+4]
cmp EAX, 'lanr'
jne SEARCH_InternalName_loop2
mov EAX, [ESI+8]
cmp EAX, 'emaN'
jne SEARCH_InternalName_loop2
FOUND_InternalName:
mov AL, [ESI-2]
mov EDX, offset InternalName_write_content
cmp AL, 0
je EMPTY_CONTENT
call FOUND_LABEL
InternalName_write_content:
mov EDI, offset InternalName
call COPY_CONTENT_to_OWN_BUFOR
;--------------------------------------------
SEARCH_OriginalFileName:
mov ESI, SECOND_BUFOR_start
SEARCH_OriginalFileName_loop:
mov EAX, [ESI]
cmp EAX, 'girO'
je FOUND_Orig
SEARCH_OriginalFileName_loop2:
inc ESI
cmp ESI, Section_RSRC_VERSION_ANSI_end_VA
jae PARSE_RSRC_ends
jmp SEARCH_OriginalFileName_loop
FOUND_Orig:
mov EAX, [ESI+4]
cmp EAX, 'lani'
jne SEARCH_OriginalFileName_loop2
mov EAX, [ESI+8]
cmp EAX, 'eliF'
jne SEARCH_OriginalFileName_loop2
mov EAX, [ESI+12]
cmp EAX, 'eman'
jne SEARCH_OriginalFileName_loop2
FOUND_OriginalFileName:
mov AL, [ESI-2]
mov EDX, offset OriginalFileName_write_content
cmp AL, 0
je EMPTY_CONTENT
call FOUND_LABEL
OriginalFileName_write_content:
mov EDI, offset OriginalFileName
call COPY_CONTENT_to_OWN_BUFOR
;--------------------------------------------
PARSE_RSRC_ends:
ret
;--------------------------------------------
EMPTY_CONTENT:
mov ECX, 10
mov ESI, offset EMPTY_CONTENT_txt
mov EDI, offset BUFOR_TEMP
rep movsb
mov ESI, offset BUFOR_TEMP
mov EBX, 10
jmp EDX
;--------------------------------------------------------------------
FOUND_LABEL:
xor EBX, EBX
mov ECX, 20
search_content_loop:
inc ESI
cmp byte ptr [ESI], 0
je SEARCH_CONTENT_START
loop search_content_loop
ret
SEARCH_CONTENT_START:
mov ECX, 3
SEARCH_CONTENT_START_loop:
cmp byte ptr [ESI], 0
jne FOUND_CONTENT_START
inc ESI
loop SEARCH_CONTENT_START_loop
ret
FOUND_CONTENT_START:
mov ECX, 0
push ESI
CALCULATE_CONTENT_LENGTH_loop:
mov AL, byte ptr [ESI]
cmp AL, 20h
jb END_of_ASCII_CONTENT
cmp AL, 7Eh
ja END_of_ASCII_CONTENT
inc ESI
inc ECX
cmp ECX, 40
ja COPY_CONTENT
jmp CALCULATE_CONTENT_LENGTH_loop
COPY_CONTENT:
pop ESI
invoke _strlen, ESI
mov ECX, EAX
inc ECX
mov EBX, ECX
mov EDI, offset BUFOR_TEMP
rep movsb
ret
;--------------------------------------------
END_of_ASCII_CONTENT:
mov byte ptr [ESI], 20h
mov byte ptr [ESI+1], 0
jmp COPY_CONTENT
;--------------------------------------------------------------------
COPY_CONTENT_to_OWN_BUFOR:
mov ESI, offset BUFOR_TEMP
mov ECX, EBX
rep movsb
ret
;#######################################################################################
CREATE_AUTHENTICODE_PE_FILE:
mov ESI, BUFOR_INPUT_start
mov EDI, SECOND_BUFOR_start
mov ECX, PE_OptionalHeader_checksum_VA
sub ECX, BUFOR_INPUT_start
rep movsb
add ESI, 4
mov ECX, PE_DirectoryEntries_SecurityDirectory_VA
sub ECX, ESI
rep movsb
add ESI, 8
mov ECX, BUFOR_INPUT_start
add ECX, BUFOR_INPUT_size
sub ECX, ESI
sub ECX, SECURITY_CONTENT_size
rep movsb
mov EAX, EDI
sub EAX, SECOND_BUFOR_start
mov BUFOR_OUTPUT_size, EAX
;--------------------------------------------------------------------
CALCULATE_AUTHENTICODE:
mov EBX, offset AUTHENTICODE_PE_EXE_txt
call CREATE_NAME_FILENAME_OUTPUT
mov ESI, SECOND_BUFOR_start
call FRAGG__WRITE_as_FILE_and_CALC_HASH
ret
;#######################################################################################
EXTRACT_SECURITY_DIRECTORY:
mov EBX, offset SECURITY_DIRECTORY_txt
call CREATE_NAME_FILENAME_OUTPUT
mov ESI, SECURITY_CONTENT_start_VA
mov SECURITY_CONTENT_current_VA, ESI
mov EAX, SECURITY_CONTENT_size
mov BUFOR_OUTPUT_size, EAX
call FRAGG__WRITE_as_FILE_and_CALC_HASH
ret
;#######################################################################################
EXTRACT_CERTIFICATES_ALL:
mov EBX, offset CERTIFICATES_ALL____txt
call CREATE_NAME_FILENAME_OUTPUT
mov ESI, SECURITY_CONTENT_start_VA
add ESI, 8
mov SECURITY_CONTENT_current_VA, ESI
xor EAX, EAX
mov AX, [ESI+2]
xchg AH, AL
add EAX, 4
mov BUFOR_OUTPUT_size, EAX
call FRAGG__WRITE_as_FILE_and_CALC_HASH
ret
;#######################################################################################

SEARCH_FIRST_3082:
inc ESI
cmp ESI, SECURITY_CONTENT_end_VA
jae FINITO_SUCCESS_PROC
cmp word ptr [ESI], 8230h
je SEARCH_SECOND_3082
jmp SEARCH_FIRST_3082
;--------------------------------------------------------------------
SEARCH_SECOND_3082:
cmp word ptr [ESI+4], 8230h
je SEARCH_A003020102
jmp SEARCH_FIRST_3082
;--------------------------------------------------------------------
SEARCH_A003020102:
cmp dword ptr [ESI+8], 010203A0h
jne SEARCH_FIRST_3082
cmp byte ptr [ESI+12], 02h
jne SEARCH_FIRST_3082
;--------------------------------------------------------------------
FOUND_CERT:
mov SECURITY_CONTENT_current_VA, ESI
mov EBX, offset CERTIFICATE_x_txt
call INCREASE_NUMBER_in_NAME
call CREATE_NAME_FILENAME_OUTPUT
mov ESI, SECURITY_CONTENT_current_VA
call SET_BUFOR_OUTPUT_size_to_CERT_SIZE
call FRAGG__WRITE_as_FILE_and_CALC_HASH
mov EBX, offset CERTIFICATE_x_TBS_txt
call INCREASE_NUMBER_in_NAME
call CREATE_NAME_FILENAME_OUTPUT
mov ESI, SECURITY_CONTENT_current_VA
add ESI, 4
mov SECURITY_CONTENT_current_VA, ESI
call SET_BUFOR_OUTPUT_size_to_CERT_SIZE
call FRAGG__WRITE_as_FILE_and_CALC_HASH
mov ESI, SECURITY_CONTENT_current_VA
inc ESI
jmp SEARCH_FIRST_3082
;--------------------------------------------------------------------
SET_BUFOR_OUTPUT_size_to_CERT_SIZE:
xor EAX, EAX
mov AX, [ESI+2]
xchg AH, AL
add EAX, 4
mov BUFOR_OUTPUT_size, EAX
ret
;#######################################################################################
DISPLAY_FILENAME_INPUT_NO_PATH:
mov ESI, offset FILENAME_INPUT
mov EDI, offset FILENAME_INPUT_NO_PATH
call REMOVE_PATH_from_ESI_to_EDI
mov EDI, offset FILENAME_INPUT_NO_PATH
invoke WriteConsole, ConsoleOut_handle,offset NEXT_LINE_txt, 2, offset nNumberOfBytesWritten,0
invoke WriteConsole, ConsoleOut_handle,EDI, 40, offset nNumberOfBytesWritten,0
invoke WriteConsole, ConsoleOut_handle, offset TABULATOR_txt, 1, offset nNumberOfBytesWritten,0
ret
;#######################################################################################
CREATE_NAME_INPUT_BAD:
mov EDI, offset FILENAME_INPUT_BAD
mov ESI, offset FILENAME_INPUT
invoke _strlen, ESI
mov ECX, EAX
rep movsb
mov ESI, offset INPUT_BAD_txt
mov ECX, 5
rep movsb
ret
;#######################################################################################
CREATE_RESULT_FILE:
mov EBX, offset FINAL_RESULT_txt
call CREATE_NAME_FILENAME_OUTPUT
mov ECX, 200h
mov ESI, offset FILENAME_OUTPUT
mov EDI, offset FILENAME_RESULT
rep movsb
invoke CreateFileA, offset FILENAME_RESULT,0F0000000h,3,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
cmp EAX, 0FFFFFFFFh
mov EBX, offset ERROR_OUTPUT
jz FINITO_ERROR_text_in_EBX
mov hFile_RESULT, EAX
ret
;#######################################################################################
CREATE_DATABASE_FILE:
invoke CreateFileA, offset FILENAME_DATABASE,0F0000000h,3,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
cmp EAX, 0FFFFFFFFh
mov EBX, offset ERROR_OUTPUT
jz FINITO_ERROR_text_in_EBX
mov hFile_DATABASE, EAX
invoke SetFilePointer, hFile_DATABASE, 0,0,FILE_END
ret
;#######################################################################################
CALC_SHA256:
mov ECX, 	offset RESULT_SHA256_32b
mov EDX, ESI
push BUFOR_OUTPUT_size
call sha256a
ret
;#######################################################################################
CALC_SHA1:
mov EBP, ESP
push BUFOR_OUTPUT_size
push ESI
push offset RESULT_SHA1_20b
call _SHA1
mov ESP, EBP
ret
;#######################################################################################
CALC_MD5:
mov EBP, ESP
push offset MD5_context
call    _MD5Init

mov EAX, BUFOR_OUTPUT_size
push EAX
push ESI
push offset MD5_context
call    _MD5Update

push offset MD5_context
push offset RESULT_MD5_16b
call    _MD5Final
mov ESP, EBP
ret
;#######################################################################################
CONVERT_HASHES_to_ASCII:
mov ECX, 32
mov ESI, offset RESULT_SHA256_32b
mov EDI, offset RESULT_SHA256_32b_TXT
call HEX2TXT
mov ECX, 20
mov ESI, offset RESULT_SHA1_20b
mov EDI, offset RESULT_SHA1_20b_TXT
call HEX2TXT
mov ECX, 16
mov ESI, offset RESULT_MD5_16b
mov EDI, offset RESULT_MD5_16b_TXT
call HEX2TXT
ret
;#######################################################################################
OPEN_INPUT_and_SET_BUFORS:
mov lpstrFilter, offset Filter_OPEN_INPUT
mov lpstrTitle, offset TYTUL_OPEN_INPUT
call OPEN_FILE
mov hFile_INPUT, EAX
invoke GetFileSize,hFile_INPUT,0
mov BUFOR_INPUT_size, EAX
cmp EAX, 200h
jb ALLOC_200h
add EAX, EAX
ALLOC_BUFORS:
mov BUFOR_OUTPUT_size, EAX
mov SECOND_BUFOR_size, EAX
call SET_BUFOR_INPUT_size_EAX
call SET_BUFOR_OUTPUT
call SET_SECOND_BUFOR
invoke ReadFile, hFile_INPUT, BUFOR_INPUT_start, BUFOR_INPUT_size, lpNumberOfBytesRead, 0
ret
ALLOC_200h:
mov EAX, 200h
jmp ALLOC_BUFORS
;#######################################################################################
INCREASE_NUMBER_in_NAME:
mov EDX, CURRENT_POS_in_LOOKUP_TABLE
mov AX, [EDX]
mov [EBX+13], AX
cmp dword ptr [EBX+16], "LLUF"
je DONT_INCREASE_NUMBER
mov EAX, CURRENT_POS_in_LOOKUP_TABLE
sub EAX, offset LOOKUP_TABLE_HEX
cmp EAX, 512
jae ERROR_CERTS_ABOVE_256_proc
add CURRENT_POS_in_LOOKUP_TABLE, 2
DONT_INCREASE_NUMBER:
ret
;--------------------------------------------------------------------
ERROR_CERTS_ABOVE_256_proc:
mov EBX, offset ERROR_CERTS_ABOVE_256
jmp FINITO_ERROR_text_in_EBX
;#######################################################################################
CREATE_NAME_FILENAME_OUTPUT:
mov ECX, 200h
mov ESI, offset FILENAME_INPUT
mov EDI, offset FILENAME_OUTPUT
rep movsb
xor ECX, ECX
mov EDI, offset FILENAME_OUTPUT
SEARCH_END_of_NAME:
cmp byte ptr [EDI], 0
je ADD_APPENDIX
inc EDI
inc ECX
jmp SEARCH_END_of_NAME
;-------------------------------------------------------------------
ADD_APPENDIX:
mov ECX, 40
mov ESI, EBX
rep movsb
mov ESI, offset FILENAME_OUTPUT
mov EDI, offset FILENAME_OUTPUT
call REMOVE_PATH_from_ESI_to_EDI
ret
;#######################################################################################
CREATE_file_FILENAME_OUTPUT:
invoke CreateFileA, offset FILENAME_OUTPUT,0F0000000h,3,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
cmp EAX, 0FFFFFFFFh
mov EBX, offset FILENAME_OUTPUT
jz FINITO_ERROR_text_in_EBX
mov hFile_OUTPUT, EAX
ret
;#######################################################################################
SET_CONSOLE:
INVOKE GetStdHandle, STD_OUTPUT_HANDLE
mov ConsoleOut_handle, EAX
mov EAX, 0A0000c0h
invoke SetConsoleScreenBufferSize, ConsoleOut_handle, EAX
invoke GetLastError
ret
;#######################################################################################
SEH_HANDLER:

mov EAX, [ESP+4]
mov ECX, [EAX+4]
mov EDX, [ECX+0B8h]
mov SEH_EIP_RVA_address, EDX
mov SEH_CONTEXT_RECORD, ECX
invoke GetModuleHandle, NULL
sub EDX, EAX
mov SEH_EIP_Raw_address, EDX
invoke dw2hex, EDX, offset SEH_EIP_Raw_address_txt
mov ESI, SEH_EIP_RVA_address
mov EDI, offset SEH_EIP_raw_bytes
mov ECX, 7
call HEX2TXT
cmp BeaEngine_LOADED, 1
jne BUILDING_STATUS_FINAL_txt
;-------------------------------------------------------
mov EDX, SEH_EIP_RVA_address
mov dasm.EIP,  EDX
mov dasm.Archi, 1
mov dasm.Options, 0
push offset dasm
call Disasm
add ESP, 4
;-------------------------------------------------------
BUILDING_STATUS_FINAL_txt:
mov EDI, offset STATUS_FINAL_txt
mov ESI, offset ERROR_SEH
mov ECX, 13
rep movsb
mov ESI, offset SEH_EIP_Raw_address_txt
mov ECX, 8
rep movsb
call PRINT_COLON
mov ESI, offset SEH_EIP_raw_bytes
mov ECX, 14
rep movsb
call PRINT_COLON
mov ESI, offset dasm.CompleteInstr
invoke _strlen, ESI
mov ECX, EAX
rep movsb
;-------------------------------------------------------
mov EDI, offset STATUS_FINAL_txt
invoke _strlen, EDI
invoke WriteConsole, ConsoleOut_handle,EDI, EAX, offset nNumberOfBytesWritten,0
mov ESI, offset FILENAME_INPUT_NO_PATH
call WRITE_ESI_and_TAB_to_RESULT_and_BASE
mov ESI, offset STATUS_FINAL_txt
call WRITE_ESI_and_NEXTLINE_to_RESULT_and_BASE
FINITO:
mov EAX, 1
ret 4
;------------------------------------------------------
PRINT_COLON:
mov ESI, offset COLON_txt
mov ECX, 1
rep movsb
ret
;---------------------------------------------------------------------------
TRY_LOAD_BeaEngine:
;--------------------------------------------------------------------------
invoke LoadLibrary, offset BeaEngine_DLL_txt
test EAX, EAX
jz BeaEngine_load_failed
mov BeaEngine_handle, EAX
invoke GetProcAddress, BeaEngine_handle, offset BeaEngine_Disasm_txt
test EAX, EAX
jz BeaEngine_load_failed
mov Disasm, EAX
mov BeaEngine_LOADED, 1
BeaEngine_load_failed:
ret
;#######################################################################################
HEX2TXT:
mov EDX, offset LOOKUP_TABLE_HEX
HEX2TXT_loop:
xor EAX, EAX
mov AL, [ESI]
mov AX, [EDX+EAX*2]
mov [EDI], AX
dec ECX
cmp ECX, 0
je HEX2TXT_end
inc ESI
add EDI, 2
jmp HEX2TXT_loop
HEX2TXT_end:
ret
;#######################################################################################
REMOVE_PATH_from_ESI_to_EDI:
mov EBX, EDI
mov AX, [ESI+1]
cmp AX, '\:'
jne COPY_no_CHANGE
REMOVE_FULL_PATH_loop:
inc ESI
mov AL, [ESI]
cmp AL, '\'
je write_ESI_for_last_slash
cmp AL, 0
je end_of_string
jmp REMOVE_FULL_PATH_loop
write_ESI_for_last_slash:
mov EDX, ESI
jmp REMOVE_FULL_PATH_loop
end_of_string:
mov ECX, 200h
mov ESI, EDX
inc ESI
mov EDI, offset BUFOR_TEMP
rep movsb
mov ECX, 200h
mov ESI, offset BUFOR_TEMP
mov EDI, EBX
rep movsb
ret
;-------------------------------------------------------------------
COPY_no_CHANGE:
mov ECX, 200h
rep movsb
ret
;#######################################################################################
OPEN_FILE:
cmp FILENAME_INPUT, 0
jne OMIJA_OPEN_DLG
push offset STRUCTURE_for_OPEN_FILE
call GetOpenFileNameA
OMIJA_OPEN_DLG:
invoke CreateFileA,offset FILENAME_INPUT,GENERIC_READ,0,0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL,0
mov EBX, offset ERROR_INPUT
cmp EAX, 0FFFFFFFFh
je ERROR_on_CREATE_INPUT
ret
;#######################################################################################
CLOSE_ALL:
invoke CloseHandle, hFile_INPUT
invoke CloseHandle, hFile_OUTPUT
invoke CloseHandle, hFile_RESULT
invoke CloseHandle, hFile_DATABASE
invoke GlobalUnlock, BUFOR_INPUT_start
invoke GlobalUnlock, BUFOR_OUTPUT_start
invoke GlobalUnlock, SECOND_BUFOR_start
invoke GlobalFree, BUFOR_INPUT_handle
invoke GlobalFree, BUFOR_OUTPUT_handle
invoke GlobalFree, SECOND_BUFOR_handle
ret
;#######################################################################################
SET_BUFOR_INPUT_size_EAX:
invoke GlobalAlloc, 42h, EAX
mov BUFOR_INPUT_handle, eax
invoke GlobalLock, eax
mov BUFOR_INPUT_start, eax
add EAX, BUFOR_INPUT_size
mov BUFOR_INPUT_end, EAX
ret
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET_BUFOR_OUTPUT:
invoke GlobalAlloc, 42h, BUFOR_OUTPUT_size
mov BUFOR_OUTPUT_handle, eax
invoke GlobalLock, eax
mov BUFOR_OUTPUT_start, eax
ret
;--------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET_SECOND_BUFOR:
invoke GlobalAlloc, 42h, SECOND_BUFOR_size
mov SECOND_BUFOR_handle, eax
invoke GlobalLock, eax
mov SECOND_BUFOR_start, eax
ret
;#######################################################################################
PARSE_CMDLINE:
invoke GetCommandLineA
mov esi, eax
xor EAX, EAX
OMIT_the_EXE_PATH:
call FIND_SPACE
call FIND_NONSPACE
mov AL, byte ptr [ESI]
cmp AL, 0
je CMD_LINE_ENDS
mov EDI, offset FILENAME_INPUT
call GET_STRING_ARG
cmp byte ptr [ESI], 0
je CMD_LINE_ENDS
mov EDI, offset FILENAME_OUTPUT
call GET_STRING_ARG
CMD_LINE_ENDS:
ret
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------
GET_STRING_ARG:
call FIND_NONSPACE
GET_STRING_ARG_loop:
movsb
mov byte ptr [EDI+1], 0
cmp byte ptr [ESI], 20h
ja GET_STRING_ARG_loop
ret
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------
FIND_NONSPACE:
mov AL, byte ptr [ESI]
cmp AL, 0
je CMD_LINE_ENDS
cmp AL, 20h
je INC_ESI
ret
;--------------------------------------
INC_ESI:
inc ESI
jmp FIND_NONSPACE
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------
FIND_SPACE:
mov AL, byte ptr [ESI]
cmp AL, 0
je CMD_LINE_ENDS
cmp AL, 20h
jne INC_ESI2
ret
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------
INC_ESI2:
inc ESI
jmp FIND_SPACE
;#############################################################################################
End start
