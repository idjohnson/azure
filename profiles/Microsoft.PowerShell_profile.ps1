function prompt{
  $currentLocaction = $executionContext.SessionState.Path.CurrentLocation.ToString()
  $host.UI.RawUI.WindowTitle = ($currentLocaction -Replace '^[^:]+::', '')
  Write-Host '[' -NoNewLine

  if($IsAdmin){
    Write-Host $env:COMPUTERNAME -NoNewLine -ForegroundColor 'Red'
  }

  else{
    Write-Host $env:COMPUTERNAME -NoNewLine -ForegroundColor 'DarkGray'
  }

  Write-Host "] $(Invoke-ShortenPath $currentLocaction)>" -NoNewLine
  return ' '
}

function Invoke-ShortenPath {
    param (
        [string] $Path
    )

    $dirSeparator = [System.IO.Path]::DirectorySeparatorChar

    $newPath = $Path -Replace '^[^:]+::', ''
    $pathParts = $newPath.Split('\',[System.StringSplitOptions]::RemoveEmptyEntries)
    $outPath = ''

    if ($pathParts.Length -gt 3) {

        if(-not($pathParts[0].EndsWith(':'))){
            $outPath += '\\'
        }

        $outPath += "$($pathParts[0])$($dirSeparator)$($pathParts[1])$($dirSeparator)...$($dirSeparator)$($pathParts[-1])"
    }

    else{
        $outPath += "$($newPath)"
    }

    Write-Output $outPath
}

function Invoke-GetLocationEx { (Get-Location).ToString() }
Set-Alias -Name 'pwd' -Value 'Invoke-GetLocationEx' -Option 'AllScope' -Force

$windowsIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$windowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($windowsIdentity)
$adm=[System.Security.Principal.WindowsBuiltInRole]::Administrator
$global:IsAdmin=$windowsPrincipal.IsInRole($adm)

# Load posh-git example profile
. ("$env:LOCALAPPDATA\GitHub\shell.ps1")
. ("$env:github_posh_git\profile.example.ps1")

Set-Location $env:USERPROFILE\Documents
cls