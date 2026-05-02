set PATH=C:\MASM32\bin;C:\MASM32\lib
ML.EXE /c /Cp /coff /Zf /Zi /Fm /FR /Sa /Sf /Sx /WX CertHashDump.asm 					>	result_MASM32.txt
RC.EXE 1.rc										>> 	result_MASM32.txt
LINK.EXE /subsystem:CONSOLE /MAP /LIBPATH:C:\MASM32\lib /OPT:REF /OPT:ICF CertHashDump 1.res	>> 	result_MASM32.txt