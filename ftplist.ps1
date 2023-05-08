param (
    [string]$Url = "",
    [string]$LinkText = "",
    [string]$DownloadPath = ""
)

if (-not (Test-Path $DownloadPath)) {
    New-Item -Path $DownloadPath -ItemType Directory | Out-Null
}

function Download-File {
    param (
        [string]$Url,
        [string]$Destination
    )

    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($Url, $Destination)
}

$WebResponse = Invoke-WebRequest -Uri $Url -UseBasicParsing

$FoundLink = $null

foreach ($Link in $WebResponse.Links) {
    $LinkHTML = $Link.outerHTML
    if ($LinkHTML -match '<a[^>]*>(.*?)</a>') {
        $CurrentLinkText = $matches[1]
        if ($CurrentLinkText -eq $LinkText) {
            $FoundLink = $Link
            break
        }
    }
}

if ($FoundLink -eq $null) {
    Write-Host "Link with text '$LinkText' not found on the page."
    exit 1
}

$FileUrl = $FoundLink.href

$BaseUrl = New-Object System.Uri($Url)
$AbsoluteUrl = New-Object System.Uri($BaseUrl, $FileUrl)

if ([string]::IsNullOrEmpty($AbsoluteUrl)) {
    Write-Host "File URL not found for the link with text '$LinkText'."
    exit 1
}

$FileName = [System.IO.Path]::GetFileName($AbsoluteUrl.LocalPath)
$DestinationPath = Join-Path -Path $DownloadPath -ChildPath $FileName

Download-File -Url $AbsoluteUrl -Destination $DestinationPath

Write-Host "File '$FileName' downloaded to '$DownloadPath'."
