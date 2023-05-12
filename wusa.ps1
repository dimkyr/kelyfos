# Replace 'WindowsTH-KB2693643-x64.msu' with the actual MSU file name
$installerPath = "C:\Windows\System32\wusa.exe"
$updatePackagePath = ".\WindowsTH-KB2693643-x64.msu"  # Modify this path to your .msu file

$installerArgs = @($updatePackagePath, "/quiet", "/norestart")

# Run the silent installer and wait for it to complete
Start-Process -FilePath $installerPath -ArgumentList $installerArgs -NoNewWindow -Wait
