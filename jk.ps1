# Start Job
$job = Start-Job -ScriptBlock {
    Start-Sleep -Seconds 5000
}

# Wait for job to complete with timeout (in seconds)
$job | Wait-Job -Timeout 10

# Check to see if any jobs are still running and stop them
$job | Where-Object {$_.State -ne "Completed"} | ForEach-Object {
    Stop-Job -Id $_.Id
    Write-Host "Job with ID $($_.Id) was stopped because it exceeded the timeout."
}
