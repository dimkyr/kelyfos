# Define the path to the CSV file
$csvFilePath = "path\to\your\csvfile.csv"

# Import the contents of the CSV file
$csvData = Import-Csv -Path $csvFilePath

# Get the number of rows and columns in the CSV file
$rowCount = $csvData.Count
$columnCount = $csvData[0].PSObject.Properties.Count

# Initialize the two-dimensional array
$twoDimensionalArray = New-Object 'System.String[,]'($rowCount, $columnCount)

# Populate the two-dimensional array with the CSV data
for ($rowIndex = 0; $rowIndex -lt $rowCount; $rowIndex++) {
    $columns = $csvData[$rowIndex].PSObject.Properties

    for ($columnIndex = 0; $columnIndex -lt $columnCount; $columnIndex++) {
        $twoDimensionalArray[$rowIndex, $columnIndex] = $columns[$columnIndex].Value
    }
}

# Display the contents of the two-dimensional array
for ($rowIndex = 0; $rowIndex -lt $rowCount; $rowIndex++) {
    for ($columnIndex = 0; $columnIndex -lt $columnCount; $columnIndex++) {
        Write-Host -NoNewline $twoDimensionalArray[$rowIndex, $columnIndex] " "
    }
    Write-Host
}
