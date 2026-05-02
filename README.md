This program dumps certificates and TBS-certificates from PE file and calculates MD5, SHA1, SHA256 hashes of: full PE, Authenticode PE and all found certificates and TBS-certificates.
The main purpose of the program is to create a hash database for large numbers of PE files - for malware detection purposes.
It works in two modes:
- single file mode - dumps all certificates and TBS-certificates, create a database of hashes for a single file: %1_FINAL_RESULT.CSV
- multi file mode - create a common single database of hashes of all processed files - _DATABASE.CSV. Doesnt' dump certificates.

*.CSV databases can be easily viewed and processed by e.g. CSVFileViewer https://www.nirsoft.net/utils/csv_file_view.html or exported to Excel
The format of single-file and multi-file databases is the same, so they can be combined.
In addition to hashes, database also contains CompanyName, InternalName, OriginalFilename retrieved from VS_VERSION_INFO - so we can see which companies use a given TBS-certificate.

Single file mode launches by cmd-line: CertDumpHash.exe [PE file], by drag-and-drop, by launching in GUI and selecting file.
Multi file mode launches by cmd-line with option BASE: CertDumpHash.exe [PE file] BASE
So in folder with many files to process you should create BAT file like these:
for %%n in (*.*) do CertDumpHash.exe %%n BASE	or
for %%n in (*.exe, *.dll, *.ocx, *.sys, *.bin, *.vir ) do CertDumpHash.exe %%n BASE

"Errors" displayed during PE file parsing are mostly not real errors: correct PE file does not have to contain SECURITY_DIRECTORY, .RSRC section, VS_VERSION_INFO etc. -
but if they are not there, the appropriate values will not be retrieved. 
For PE files with SECURITY_DIRECTORY the program extracts certificates from it - these are certificates the presence of which can be seen in the "digital signatures" tab in the PE file properties.
For any files without SECURITY_DIRECTORY - both PE and non-PE - the program try to extract certificates from the entire file, so you can use it to extract certificates from e.g. memory dump.

Since the program is designed to process large numbers of PE files, often including files with incorrect structure, e.g. malware, certain measures have been taken to handle errors.
1) SEH handler is installed: when SEH occurs, the message "Exception at:" is displayed, followed by the byte string from the EIP where the error occurred. Disassembly library BeaEngine.dll is also attached, if you keep it next to the program the library will be loaded and you can see disassembly of failed instruction after the byte string of SEH EIP. But even without disassembly the place of error can be easily identified in debugger a) by mentioned "byte string" - just look for this byte string, b) by the address of SEH EIP - it is raw address, so you have to add imagebase to it to obtain virtual address.
So most people dont' need BeaEngine.dll, it is loaded optionally and the program works without it. 
2) before processing each file a copy of it is created - as [filename].BAD. This *.BAD file is deleted after successful processing, but it remains if processing is interrupted unexpectedly due to e.g. SEH or CreateFile's Access Violation. So after processing folder with thousands of files you can simply look for *.BAD files to identify which have not been processed. Such errors are written to database of course also - after sorting by STATUS = column 2 look for "Create File: Access Violation" [file is opened by someone else] or "Exception at:" [SEH].
3) for debugging purposes, in single-file mode, except certificates, other processed fraggs of PE file are dumped: full file, Authenticode PE part of file, SECURITY_DIRECTORY, CERTIFICATES_ALL.
So you can check yourself the calculated hashes of certificates and all these fraggs  - in e.g. WinHex

Limitations:
You need to remove spaces from names of processing files.
Up to 256 certificates can be extracted from one file
Single file size limit about 900MB... I have to replace GlobalAlloc

Compilation
The program is entirely written in MS Macro Assembler. To compile:
1) The simplest way is to download free MASM32 package: https://masm32.com/download/masm32v11r.zip, after installing compile as follows:
set PATH=C:\MASM32\bin;C:\MASM32\lib
ML.EXE /c /Cp /coff /Zf /Zi /Fm /FR /Sa /Sf /Sx /WX CertHashDump.asm 					> 	result_MASM32.txt
RC.EXE 1.rc										>> 	result_MASM32.txt
LINK.EXE /subsystem:CONSOLE /MAP /LIBPATH:C:\MASM32\lib /OPT:REF /OPT:ICF CertHashDump 1.res 	>> 	result_MASM32.txt
This very old MASM32 package contain \bin files from 1998, but it compiles and works OK in Windows 10.
By the way, this is an instructive example of Microsoft's backward compatibility - binaries from 1998 produce application working in OS functioning 20 years later...

2) You can use of course \bin files from your own installation of VisualStudio
3) You can get free \bin files from MS this way: https://gist.github.com/mmozeiko/7f3162ec2988e81e56d5c4e22cde9977
py.exe portable-msvc.py --msvc-version 14.31 --accept-license=store_true --target=x86 --host-x86

I have tested compilation with \bin files from VisualStudio 2012 and VisualStudio 14.31.31103, then:
set PATH=C:\MASM32_14.31.31103\bin;C:\MASM32_14.31.31103\lib
For 14.31 a little correction in C:\MASM32\include\winextra.inc was necessary:
alrt_eventname WCHAR  [EVLEN + 1] dup(?)	-> alrt_eventname WCHAR  100 dup(0)
alrt_servicename WCHAR [SNLEN + 1] dup(?)	-> alrt_servicename WCHAR 100 dup(0)
