Import-Module ServerManager -Force
Add-WindowsFeature -Name Web-Server,Web-Asp-Net,Web-Mgmt-Service -IncludeAllSubFeature -Verbose