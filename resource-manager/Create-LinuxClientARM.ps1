function New-RandomString {
    $String = $null
    $r = New-Object System.Random
    1..6 | % { $String += [char]$r.next(97,122) }
    $string
}

### Define variables
$Location = 'West US' ### Use "Get-AzureLocation | Where-Object Name -eq 'ResourceGroup' | Format-Table Name, LocationsString -Wrap" in ARM mode to find locations which support Resource Groups
$GroupName = 'chef-demo'
$DeploymentName = 'linux-node-deployment'
$PublicDNSName = 'steamdriven-cheflab-linux'
$AdminUsername = 'chef'
$AzureStorageAccount = 'chefdemostorage' + (New-RandomString)
$AzureVirtualNetwork = 'chef-demo-vnet'

if((Test-AzureResourceGroup -ResourceGroupName $GroupName) -eq $false){
    New-AzureResourceGroup -Name $GroupName -Location $Location -Verbose
    $AzureResourceGroup = Get-AzureResourceGroup -Name $GroupName
    }
    else {$AzureResourceGroup = Get-AzureResourceGroup -Name $GroupName}

$parameters = @{
    'newStorageAccountName'="$AzureStorageAccount";
    'adminUsername'="$AdminUsername";
    'dnsNameForPublicIP'="$PublicDNSName";
    'virtualNetworkName'="$AzureVirtualNetwork"
    }

New-AzureResourceGroupDeployment `
    -Name $DeploymentName `
    -ResourceGroupName $AzureResourceGroup.ResourceGroupName `
    -TemplateFile LinuxChefNode.json `
    -TemplateParameterObject $parameters `
    -Verbose
