
$applications = @(
    'Office365ProPlus',
    '7zip',
    'adobereader',
    'GoogleChrome',
    'vlc',
    'Silverlight',
    'javaruntime'
    )

Get-PackageProvider -Name chocolatey -Force

foreach ($application in $applications){
    Install-Package -Name $application -Force
}

