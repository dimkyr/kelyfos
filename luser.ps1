# Get the current user's SID
$UserSID = (New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).Identity.User.Value

# Retrieve the current user's profile from the registry
$UserProfile = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$UserSID"

# Get the current user's display name from the registry
$DisplayName = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$UserSID" -Name 'ProfileImagePath').ProfileImagePath.Split('\')[-1]

# Split the display name into first and last name
$NameParts = $DisplayName.Split(" ")

# Display the first and last name of the current user
$FirstName = $NameParts[0]
$LastName = $NameParts[1
###############
# Import the Active Directory module
Import-Module ActiveDirectory

# Get the current user's username
$UserName = $env:USERNAME

# Get the current user's domain
$Domain = (Get-WmiObject -Class Win32_ComputerSystem).Domain

# Retrieve the current user's Active Directory account
$ADUser = Get-ADUser -Identity $UserName -Server $Domain -Properties GivenName, Surname

# Display the first and last name of the current user
$FirstName = $ADUser.GivenName
$LastName = $ADUser.Surname
Write-Host "First Name: $FirstName"
Write-Host "Last Name: $LastName"
