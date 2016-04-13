
Configuration IISServer {

    Node $env:COMPUTERNAME {


        WindowsFeature WebServer {
            Name = 'Web-Server'
            Ensure = 'Present'
        }

        WindowsFeature WebAspNet45 {
            Name = 'Web-Asp-Net45'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]WebServer'
        }

        WindowsFeature WebMgmtConsole {
            Name = 'Web-Mgmt-Console'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]WebServer'
        }

        }

    }

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = "$env:COMPUTERNAME"
        }
    )
}

Write-Verbose -Message 'Compiling IIS DSC file.'
IISServer -OutputPath "$env:windir\Temp\$env:COMPUTERNAME" -VMName $env:COMPUTERNAME -ConfigurationData $ConfigurationData
Write-Verbose -Message 'Applying DSC config'
Start-DscConfiguration -Wait -Verbose -Path "$env:windir\Temp\$env:COMPUTERNAME" -Force


