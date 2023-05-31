param (
    [switch]$flag = $false
)

if ($flag) {
    Write-Output "flag exists"
}
else
{
Write-Output "normal"
}
