### Define variables
$AzureLocation = 'West US' ### Use "Get-AzureLocation | Where-Object Name -eq 'ResourceGroup' | Format-Table Name, LocationsString -Wrap" in ARM mode to find locations which support Resource Groups
$GroupName = 'chef-demo'
$DeploymentName = 'linux-node-deployment'
$templateBaseUrl = 'https://raw.githubusercontent.com/jamesbannan/azure/master/azure-rm/templates'
$resourceTemplate = 'resourceVirtualMachine.json'
$templateUrl = $templateBaseUrl + '/' + $resourceTemplate
$password = Read-Host -AsSecureString
$AzureResourceGroup = Get-AzureRmResourceGroup -Name $GroupName

### Get Chef organization validation key
$ChefValidationCertificatePath = $env:USERPROFILE + '\Documents\Git\chef-demo\.chef'
$ChefValidationCertificateName = 'chefdemo-validator.pem'
$ChefValidationCertificate = $ChefValidationCertificatePath + '\' + $ChefValidationCertificateName
$ChefValidationCertificateKey = Get-Content $ChefValidationCertificate -Raw

### Get client.rb bootstrap settings
$ClientRbPath = $env:USERPROFILE + '\Documents\Git\chef-demo\.chef'
$ClientRb = $ClientRbPath + '\' + 'client.rb'
$ClientRbProperties = Get-Content $ClientRb -Raw

### Define additional template parameters
$additionalParameters = New-Object -TypeName Hashtable
$additionalParameters['adminPassword'] = $password
$additionalParameters['validation_key'] = $ChefValidationCertificateKey
$additionalParameters['client_rb'] = $ClientRbProperties

New-AzureResourceGroupDeployment `
    -Name $DeploymentName `
    -ResourceGroupName $AzureResourceGroup.ResourceGroupName `
    -TemplateFile LinuxChefNode.json `
    -TemplateParameterFile LinuxChefNode.parameters.json `
    @additionalParameters `
    -Verbose -Force
