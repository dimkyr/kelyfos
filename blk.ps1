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
