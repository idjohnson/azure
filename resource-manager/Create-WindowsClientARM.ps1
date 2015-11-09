### Define variables
$GroupName = 'chef-demo'
$DeploymentName = 'windows-node-deployment'
$AzureLocation = 'West US'

if((Test-AzureRmResourceGroup -ResourceGroupName $GroupName) -eq $false){
    New-AzureRmResourceGroup -Name $GroupName -Location $AzureLocation -Verbose
    $AzureResourceGroup = Get-AzureRmResourceGroup -Name $GroupName
    }
    else {$AzureResourceGroup = Get-AzureRmResourceGroup -Name $GroupName}

$additionalParameters = New-Object -TypeName Hashtable

$password = Read-Host -AsSecureString

$additionalParameters['adminPassword'] = $password

New-AzureRmResourceGroupDeployment `
    -Name $DeploymentName `
    -ResourceGroupName $AzureResourceGroup.ResourceGroupName `
    -TemplateFile WindowsChefNode.json `
    -TemplateParameterFile WindowsChefNode.parameters.json `
    @additionalParameters `
    -Verbose -Force
