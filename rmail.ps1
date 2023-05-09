# PowerShell Script to Read Latest Email from Specific Sender and Save Attachments to C:\Downloads

# Set the sender's email address
$senderEmail = "sender@example.com"

# Create an instance of Outlook
$outlook = New-Object -ComObject Outlook.Application
$namespace = $outlook.GetNamespace("MAPI")

# Access the default inbox
$inbox = $namespace.GetDefaultFolder(6)

# Filter messages from the specific sender
$messages = $inbox.Items
$filteredMessages = $messages.Restrict("[SenderEmailAddress] = '$senderEmail'")

# Sort messages by received time in descending order
$filteredMessages.Sort("[ReceivedTime]", $true)

# Get the latest email
$latestMessage = $filteredMessages.GetFirst()

if ($latestMessage -ne $null) {
    # Display email subject and date
    Write-Host "Latest email from $senderEmail:"
    Write-Host "Subject: $($latestMessage.Subject)"
    Write-Host "Received: $($latestMessage.ReceivedTime)"

    # Check for attachments
    if ($latestMessage.Attachments.Count -gt 0) {
        # Save attachments to the C:\Downloads folder
        $destinationPath = "C:\Downloads"

        foreach ($attachment in $latestMessage.Attachments) {
            $attachment.SaveAsFile((Join-Path $destinationPath $attachment.FileName))
            Write-Host "Saved attachment: $($attachment.FileName)"
        }
    } else {
        Write-Host "No attachments found in the latest email."
    }
} else {
    Write-Host "No emails found from $senderEmail"
}
