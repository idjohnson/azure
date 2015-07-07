$serviceName = 'sccmlabcloud-01'
$vmName = 'WINDEMO-01'
$winRMCert = (Get-AzureVM -ServiceName $serviceName -Name $vmName | Select-Object -ExpandProperty vm).DefaultWinRMCertificateThumbprint
 
$AzureX509cert = Get-AzureCertificate -ServiceName $serviceName -Thumbprint $winRMCert -ThumbprintAlgorithm sha1
 
$certTempFile = [IO.Path]::GetTempFileName()
$AzureX509cert.Data | Out-File $certTempFile
 
$CertToImport = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $certTempFile
 
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store 'Root', 'LocalMachine'
$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$store.Add($CertToImport)
$store.Close()
 
Remove-Item $certTempFile


#################


$username = 'azureuser'
$pwd = ConvertTo-SecureString –String 'P@ssw0rd' –AsPlainText -Force
$credential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $username, $pwd

$uri = Get-AzureWinRMUri -ServiceName $serviceName -Name $VMName 

Invoke-Command -ConnectionUri $uri -Credential $credential -ScriptBlock {
    winrm quickconfig -q
}

#################

