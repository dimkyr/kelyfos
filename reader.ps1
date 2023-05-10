# Define the path to the CSV file
$csvFilePath = "path\to\your\csvfile.csv"

# Import the contents of the CSV file
$csvData = Import-Csv -Path $csvFilePath

# Initialize the jagged array
$jaggedArray = New-Object 'System.Collections.ArrayList'

# Populate the jagged array with the CSV data
foreach ($row in $csvData) {
    $rowArray = New-Object 'System.Collections.ArrayList'
    
    foreach ($propertyName in $row.PSObject.Properties.Name) {
        $rowArray.Add($row.$propertyName) | Out-Null
    }

    $jaggedArray.Add($rowArray) | Out-Null
}

# Display the contents of the jagged array
foreach ($row in $jaggedArray) {
    $rowContent = ""
    foreach ($column in $row) {
        $rowContent += $column + " "
    }
    Write-Host $rowContent
}
