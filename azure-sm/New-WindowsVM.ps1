
$winvm = New-AzureVMConfig `
    -Name WINDEMO-01 `
    -InstanceSize Basic_A1 `
    -ImageName a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201505.01-en.us-127GB.vhd `

$winvm | Add-AzureProvisioningConfig -Windows -AdminUsername 'azureuser' -Password 'P@ssw0rd' -EnableWinRMHttp

$winvm | Set-AzureSubnet -SubnetNames 'Subnet-1'

New-AzureVM -ServiceName sccmlabcloud-01 -VMs $winvm -VNetName 'Steamdriven-vNet001' -WaitForBoot -Verbose