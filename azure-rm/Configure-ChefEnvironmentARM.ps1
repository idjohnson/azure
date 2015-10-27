function New-RandomString {
    $String = $null
    $r = New-Object System.Random
    1..6 | % { $String += [char]$r.next(97,122) }
    $string
}

### Define variables

$azureLocation = 'westus'
$azureImagePublisher = 'chef-software'
$azureImageOffer = 'chef-server'
$azureImageSku = 'chefbyol'
$azureArmGroupName = 'chef-lab'
$azureResourceDeploymentName = 'chef-lab-deployment'
$azureResourceStorageName = 'cheflabstorage' + (New-RandomString)
$azureChefPublicDNSName = 'chef-lab-' + (New-RandomString)
$AdminUsername = 'chef'


### Create Resource Group ###

if((Test-AzureResourceGroup -ResourceGroupName $azureArmGroupName) -eq $false){
    New-AzureResourceGroup `
        -Name $azureArmGroupName `
        -Location $azureLocation `
        -Verbose
    $azureResourceGroup = Get-AzureResourceGroup -Name $azureArmGroupName
    }
    else {$azureResourceGroup = Get-AzureResourceGroup -Name $azureArmGroupName}

$parameters = @{
    'newStorageAccountName'="$azureResourceStorageName";
    'adminUsername'="$AdminUsername";
    'dnsNameForPublicIP'="$azureChefPublicDNSName";
    'chefServerSku'="$azureImageSku";
    'location'="$azureLocation";
    'imagePublisher'="$azureImagePublisher";
    'imageOffer'="$azureImageOffer"
    }

New-AzureResourceGroupDeployment `
    -Name $azureResourceDeploymentName `
    -ResourceGroupName $azureResourceGroup.ResourceGroupName `
    -TemplateFile .\templates\chef-environment.json `
    -TemplateParameterObject $parameters `
    -Verbose
