
$ResourceGroupName = 'chef-demo'
$VMName = 'win-client-2'
$ResourceVM = Get-AzureVM `
    -ResourceGroupName $ResourceGroupName `
    -Name $VMName
$AzureLocation = 'West US'


$ExtensionPublisher = 'Chef.Bootstrap.WindowsAzure'
$ExtensionName = 'ChefClient'
$ExtensionVersion = '1210.12'

$Settings = @{
    'client_rb' = 'chef_server_url  \"https://chef.steamdriven.net/organizations/steamdriven\"\nvalidation_client_name   \"steamdriven-validator\"\nvalidation_key    \"https://chefresources.blob.core.windows.net/bootstrap/steamdriven-validator.pem\"' 
    'runlist' = 'role[all-nodes]'
    }

$SettingsString = '
{
  "client_rb": "< your client.rb configuration >".
  "runlist":"< your run list >",
  "autoUpdateClient":"< true|false >",
  "deleteChefConfig":"< true|false >",
  "bootstrap_options": {
    "chef_node_name":"< your node name >",
    "chef_server_url":"< your chef server url >",
    "validation_client_name":"< your chef organization validation client name  >"
  }
}
'

Get-AzureVMAvailableExtension `
    -Publisher $ExtensionPublisher | `
    Select-Object ExtensionName,Publisher,Version,PublishedDate

Set-AzureVMExtension `
    -ResourceGroupName $ResourceGroupName `
    -VMName $ResourceVM.Name `
    -ExtensionType $ExtensionName `
    -ExtensionName $ExtensionName `
    -Publisher $ExtensionPublisher `
    -TypeHandlerVersion $ExtensionVersion `
    -Location $AzureLocation `
    -SettingString $SettingsString