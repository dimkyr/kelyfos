# Define the target FTP server URL
$ftpUrl = "http://your-ftp-server-url.com/"

# Make the HTTP request and get the content
$response = Invoke-WebRequest -Uri $ftpUrl

# Parse the response to get the file listings
$fileListings = $response.Content -split "`n" | Where-Object { $_ -match "(\d{4}-\d{2}-\d{2})" }

# Initialize an empty array to store file information
$files = @()

foreach ($listing in $fileListings) {
    $parts = $listing -split "\s+"
    $dateModified = $parts[0]
    $timeModified = $parts[1]
    $filename = $parts[-1]

    # Create a custom PowerShell object to store file information
    $file = New-Object -TypeName PSObject -Property @{
        Filename = $filename
        LastModified = [datetime]::ParseExact("$dateModified $timeModified", "yyyy-MM-dd HH:mm", $null)
    }

    # Add the file object to the files array
    $files += $file
}

# Sort the files by the last modified date, and get the most recent one
$latestFile = $files | Sort-Object LastModified -Descending | Select-Object -First 1

# Print the filename of the most recently modified file
Write-Output "The most recently modified file is: $($latestFile.Filename)"
