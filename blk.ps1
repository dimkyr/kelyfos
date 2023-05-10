# Create a non-blocking task (job)
$job = Start-Job -ScriptBlock {
    # Your task code here
    Start-Sleep -Seconds 5
    Write-Output "Task completed"
}

# Wait for the job to complete (making it blocking)
Wait-Job -Job $job

# Get the results from the completed job
$result = Receive-Job -Job $job

# Display the result
Write-Output $result

# Clean up the job
Remove-Job -Job $job

# Replace 'installer.exe' with the actual installer file name
# Replace '/S' with the silent installation switch for your installer, if different
$installerPath = "C:\path\to\installer.exe"
$installerArgs = "/S"

# Run the silent installer and wait for it to complete
Start-Process -FilePath $installerPath -ArgumentList $installerArgs -NoNewWindow -Wait

