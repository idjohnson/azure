### Define variables
$AzureLocation = 'West US' ### Use "Get-AzureLocation | Where-Object Name -eq 'ResourceGroup' | Format-Table Name, LocationsString -Wrap" in ARM mode to find locations which support Resource Groups
$GroupName = 'chef-demo'
$DeploymentName = 'linux-node-deployment'

if((Test-AzureResourceGroup -ResourceGroupName $GroupName) -eq $false){
    New-AzureResourceGroup -Name $GroupName -Location $Location -Verbose
    $AzureResourceGroup = Get-AzureResourceGroup -Name $GroupName
    }
    else {$AzureResourceGroup = Get-AzureResourceGroup -Name $GroupName}

New-AzureResourceGroupDeployment `
    -Name $DeploymentName `
    -ResourceGroupName $AzureResourceGroup.ResourceGroupName `
    -TemplateFile LinuxChefNode.json `
    -TemplateParameterFile LinuxChefNode.parameters.json `
    -Verbose
