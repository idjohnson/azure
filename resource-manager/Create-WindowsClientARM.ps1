### Define variables
$GroupName = 'pluralsight-lab'
$DeploymentName = 'windows-chef-node'
$AzureLocation = 'Australia Southeast'
$password = Read-Host -AsSecureString

$ChefValidationCertificatePath = $env:USERPROFILE + '\Documents\Git\pluralsight-cookbooks\.chef'
$ChefValidationCertificateName = 'pluralsight-validator.pem'
$ChefValidationCertificate = $ChefValidationCertificatePath + '\' + $ChefValidationCertificateName
$ChefValidationCertificateKey = Get-Content $ChefValidationCertificate -Raw | ConvertTo-SecureString -AsPlainText -Force

$ClientRbPath = $env:USERPROFILE + '\Documents\Git\pluralsight-cookbooks\.chef'
$ClientRb = $ClientRbPath + '\' + 'client.rb'
$ClientRbProperties = Get-Content $ClientRb -Raw

$additionalParameters = New-Object -TypeName Hashtable
$additionalParameters['adminPassword'] = $password
$additionalParameters['validation_key'] = $ChefValidationCertificateKey
$additionalParameters['client_rb'] = $ClientRbProperties

$AzureResourceGroup = New-AzureRmResourceGroup `
    -Name $GroupName `
    -Location $AzureLocation `
    -Verbose -Force

New-AzureRmResourceGroupDeployment `
    -Name $DeploymentName `
    -ResourceGroupName $AzureResourceGroup.ResourceGroupName `
    -TemplateFile WindowsChefNode.json `
    -TemplateParameterFile WindowsChefNode.parameters.json `
    @additionalParameters `
    -Verbose -Force
