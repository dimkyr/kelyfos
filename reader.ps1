# Define the path to the CSV file
$csvFilePath = "path\to\your\csvfile.csv"

# Import the contents of the CSV file
$csvData = Import-Csv -Path $csvFilePath

# Get the number of rows in the CSV file
$rowCount = $csvData.Count

# Initialize the jagged array
$jaggedArray = New-Object 'System.Collections.ArrayList'

# Populate the jagged array with the CSV data
for ($rowIndex = 0; $rowIndex -lt $rowCount; $rowIndex++) {
    $row = New-Object 'System.Collections.ArrayList'
    $columns = $csvData[$rowIndex].PSObject.Properties

    foreach ($column in $columns) {
        $row.Add($column.Value) | Out-Null
    }

    $jaggedArray.Add($row) | Out-Null
}

# Display the contents of the jagged array
foreach ($row in $jaggedArray) {
    $rowContent = ""
    foreach ($column in $row) {
        $rowContent += $column + " "
    }
    Write-Host $rowContent
}
