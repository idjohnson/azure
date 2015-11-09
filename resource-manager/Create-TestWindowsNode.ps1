### Define variables
$GroupName = 'chef-demo'
$DeploymentName = 'windows-node-deployment'
$AzureLocation = 'West US'
$templateBaseUrl = 'https://raw.githubusercontent.com/jamesbannan/azure/master/azure-rm/templates'
$resourceTemplate = 'resourceVirtualMachine.json'
$templateUrl = $templateBaseUrl + '/' + $resourceTemplate
$password = Read-Host -AsSecureString
$AzureResourceGroup = Get-AzureRmResourceGroup -Name $GroupName

$ChefValidationCertificatePath = $env:USERPROFILE + '\Documents\Git\chef-demo\.chef'
$ChefValidationCertificateName = 'chefdemo-validator.pem'
$ChefValidationCertificate = $ChefValidationCertificatePath + '\' + $ChefValidationCertificateName
$ChefValidationCertificateKey = Get-Content $ChefValidationCertificate

$ClientRbPath = $env:USERPROFILE + '\Documents\Git\chef-demo\.chef'
$ClientRb = $ClientRbPath + '\' + 'client.rb'
$ClientRbProperties = Get-Content $ClientRb

$additionalParameters = New-Object -TypeName Hashtable
$additionalParameters['adminPassword'] = $password
$additionalParameters['templateBaseUrl'] = $templateBaseUrl
$additionalParameters['validation_key'] = $ChefValidationCertificateKey
$additionalParameters['client_rb'] = $ClientRbProperties

New-AzureRmResourceGroupDeployment `
    -Name $DeploymentName `
    -ResourceGroupName $AzureResourceGroup.ResourceGroupName `
    -TemplateUri $templateUrl `
    -TemplateParameterFile TestWindowsNode.parameters.json `
    @additionalParameters `
    -Verbose -Force
