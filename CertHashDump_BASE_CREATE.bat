del _DATABASE.CSV
for %%n in (*.vir,*.dll,*.bin,*.sys,*.hex,*.efi,*.exe) do CertHashDump.exe %%n BASE
pause
exit