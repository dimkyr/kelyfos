# Get the current working directory
$currentDirectory = Get-Location

$job = Start-Job -ScriptBlock {
    param($dir)
    
    # Set the location to the current working directory
    Set-Location $dir

    # Insert your command here
    Start-Sleep -Seconds 15   # This is just a placeholder command
} -ArgumentList $currentDirectory

# Wait for the specified amount of time (in seconds)
Start-Sleep -Seconds 10

# Check if job is still running
if ($job.JobStateInfo.State -eq 'Running') {
    # Stop the job if it is still running
    Stop-Job -Job $job
}

# Always clean up the job, whether it completed or was stopped
Remove-Job -Job $job
