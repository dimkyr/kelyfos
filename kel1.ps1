New-Item -Path HKCR:\ -Name ".tar.gz" -Force | Out-Null
New-ItemProperty -Path HKCR:\.tar.gz -Name "" -Value "CompressedTarFile" -PropertyType String -Force | Out-Null

New-Item -Path HKCR:\ -Name ".bmp.gz" -Force | Out-Null
New-ItemProperty -Path HKCR:\.bmp.gz -Name "" -Value "CompressedBitmapFile" -PropertyType String -Force | Out-Null

New-Item -Path HKCR:\CompressedTarFile -Force | Out-Null
New-ItemProperty -Path HKCR:\CompressedTarFile -Name "" -Value "Compressed Tar File" -PropertyType String -Force | Out-Null
New-ItemProperty -Path HKCR:\CompressedTarFile\DefaultIcon -Name "" -Value "C:\Program Files\TarProgram\tar.exe,0" -PropertyType String -Force | Out-Null
New-ItemProperty -Path HKCR:\CompressedTarFile\shell -Name "" -Value "open" -PropertyType String -Force | Out-Null
New-ItemProperty -Path HKCR:\CompressedTarFile\shell\open\command -Name "" -Value '"C:\Program Files\TarProgram\tar.exe" "%1"' -PropertyType String -Force | Out-Null

New-Item -Path HKCR:\CompressedBitmapFile -Force | Out-Null
New-ItemProperty -Path HKCR:\CompressedBitmapFile -Name "" -Value "Compressed Bitmap File" -PropertyType String -Force | Out-Null
New-ItemProperty -Path HKCR:\CompressedBitmapFile\DefaultIcon -Name "" -Value "C:\Program Files\BmpProgram\bmp.exe,0" -PropertyType String -Force | Out-Null
New-ItemProperty -Path HKCR:\CompressedBitmapFile\shell -Name "" -Value "open" -PropertyType String -Force | Out-Null
New-ItemProperty -Path HKCR:\CompressedBitmapFile\shell\open\command -Name "" -Value '"C:\Program Files\BmpProgram\bmp.exe" "%1"' -PropertyType String -Force | Out-Null
