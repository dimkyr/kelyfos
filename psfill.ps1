function Create-Browser {
    param(
        [Parameter(mandatory=$true)][ValidateSet('Chrome','Edge','Firefox')][string]$browser,
        [Parameter(mandatory=$false)][bool]$HideCommandPrompt = $true,
        [Parameter(mandatory=$false)][string]$driverversion = ''
    )
    $driver = $null
    
    function Load-NugetAssembly {
        [CmdletBinding()]
        param(
            [string]$url,
            [string]$name,
            [string]$zipinternalpath,
            [switch]$downloadonly
        )
        if($psscriptroot -ne ''){
            $localpath = join-path $psscriptroot $name
        }else{
            $localpath = join-path $env:TEMP $name
        }
        $tmp = "$env:TEMP\$([IO.Path]::GetRandomFileName())"
        $zip = $null
        try{
            if(!(Test-Path $localpath)){
                Add-Type -A System.IO.Compression.FileSystem
                write-host "Downloading and extracting required library '$name' ... " -F Green -NoNewline
                (New-Object System.Net.WebClient).DownloadFile($url, $tmp)
                $zip = [System.IO.Compression.ZipFile]::OpenRead($tmp)
                $zip.Entries | ?{$_.Fullname -eq $zipinternalpath} | %{
                    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_,$localpath)
                }
	            Unblock-File -Path $localpath
                write-host "OK" -F Green
            }
            if(!$downloadonly.IsPresent){
                Add-Type -LiteralPath $localpath -EA Stop
            }
        
        }catch{
            throw "Error: $($_.Exception.Message)"
        }finally{
            if ($zip){$zip.Dispose()}
            if(Test-Path $tmp){del $tmp -Force -EA 0}
        }  
    }

    # Load Selenium Webdriver .NET Assembly
    Load-NugetAssembly 'https://www.nuget.org/api/v2/package/Selenium.WebDriver' -name 'WebDriver.dll' -zipinternalpath 'lib/net45/WebDriver.dll' -EA Stop

    if($psscriptroot -ne ''){
        $driverpath = $psscriptroot
    }else{
        $driverpath = $env:TEMP
    }
    switch($browser){
        'Chrome' {
            $chrome = Get-Package -Name 'Google Chrome' -EA SilentlyContinue | select -F 1
            if (!$chrome){
                throw "Google Chrome Browser not installed."
                return
            }
            Load-NugetAssembly "https://www.nuget.org/api/v2/package/Selenium.WebDriver.ChromeDriver/$driverversion" -name 'chromedriver.exe' -zipinternalpath 'driver/win32/chromedriver.exe' -downloadonly -EA Stop
            # create driver service
            $dService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($driverpath)
            # hide command prompt window
            $dService.HideCommandPromptWindow = $HideCommandPrompt
            # create driver object
            $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver $dService
        }
        'Edge' {
            $edge = Get-Package -Name 'Microsoft Edge' -EA SilentlyContinue | select -F 1
            if (!$edge){
                throw "Microsoft Edge Browser not installed."
                return
            }
            Load-NugetAssembly "https://www.nuget.org/api/v2/package/Selenium.WebDriver.MSEdgeDriver/$driverversion" -name 'msedgedriver.exe' -zipinternalpath 'driver/win64/msedgedriver.exe' -downloadonly -EA Stop
            # create driver service
            $dService = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService($driverpath)
            # hide command prompt window
            $dService.HideCommandPromptWindow = $HideCommandPrompt
            # create driver object
            $driver = New-Object OpenQA.Selenium.Edge.EdgeDriver $dService
        }
        'Firefox' {
            $ff = Get-Package -Name "Mozilla Firefox*" -EA SilentlyContinue | select -F 1
            if (!$ff){
                throw "Mozilla Firefox Browser not installed."
                return
            }
            Load-NugetAssembly "https://www.nuget.org/api/v2/package/Selenium.WebDriver.GeckoDriver/$driverversion" -name 'geckodriver.exe' -zipinternalpath 'driver/win64/geckodriver.exe' -downloadonly -EA Stop
            # create driver service
            $dService = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService($driverpath)
            # hide command prompt window
            $dService.HideCommandPromptWindow = $HideCommandPrompt
            # create driver object
            $driver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver $dService
        }
    }
    return $driver
}

$browser = Create-Browser -browser Edge

$browser.Navigate().GoToUrl("https://ecommerce-playground.lambdatest.io/index.php?route=account/register")

#filling in the form
$first_name = $browser.FindElement([OpenQA.Selenium.By]::Id("input-firstname"))
$first_name.SendKeys("FirstName")

$last_name = $browser.FindElement([OpenQA.Selenium.By]::Id("input-lastname"))
$last_name.SendKeys("LastName")

$random_email = (Get-Random -Minimum 0 -Maximum 99999).ToString() + "@example.com"

$email = $browser.FindElement([OpenQA.Selenium.By]::Id("input-email"))
$email.SendKeys("your-email4@example.com")

$telephone = $browser.FindElement([OpenQA.Selenium.By]::Id("input-telephone"))
$telephone.SendKeys("+351999888777")

$password = $browser.FindElement([OpenQA.Selenium.By]::Id("input-password"))
$password.SendKeys("123456")

$password_confirm = $browser.FindElement([OpenQA.Selenium.By]::Id("input-confirm"))
$password_confirm.SendKeys("123456")

$newsletter = $browser.FindElement([OpenQA.Selenium.By]::XPath("//label[@for='input-newsletter-yes']"))
$newsletter.Click()

$terms = $browser.FindElement([OpenQA.Selenium.By]::XPath("//label[@for='input-agree']"))
$terms.Click()

$continue_button = $browser.FindElement([OpenQA.Selenium.By]::XPath("//input[@value='Continue']"))
$continue_button.Click()

#asserting that the browser title is correct
if ($browser.Title -ne "Your Account Has Been Created!") {
    throw "Browser title is not correct."
}

#closing the browser
$browser.Quit()
