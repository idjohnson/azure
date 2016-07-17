
$VerbosePreference = 'Continue'

### Retrieve the Azure AD credentials and authenticate against Azure Resource Manager

$cred = Get-AutomationPSCredential -Name 'Azure Automation'
Add-AzureRmAccount -Credential $cred

### Populate script variables from Azure Automation assets

$resourceGroupName = Get-AutomationVariable -Name 'virtualNetworkRGName'
$resourceLocation = Get-AutomationVariable -Name 'virtualNetworkRGLocation'
$vNetName = Get-AutomationVariable -Name 'virtualNetworkName'
$azureRegion = Get-AutomationVariable -Name 'azureDatacenterRegions'
$azureRegionSearch = '*' + $azureRegion + '*'

[array]$locations = Get-AzureRmLocation | Where-Object {$_.Location -like $azureRegionSearch}

### Retrieve the nominated virtual network and subnets (excluding the gateway subnet)

$vNet = Get-AzureRmVirtualNetwork `
    -ResourceGroupName $resourceGroupName `
    -Name $vNetName

[array]$subnets = $vnet.Subnets | Where-Object {$_.Name -ne 'GatewaySubnet'} | Select-Object Name

### Create and populate a new array with the IP ranges of each datacenter in the specified location

$ipRanges = @()

foreach($location in $locations){
   $ipRanges += Get-MicrosoftAzureDatacenterIPRange -AzureRegion $location.DisplayName
}

$ipRanges = $ipRanges | Sort-Object

### Iterate through each subnet in the virtual network

foreach($subnet in $subnets){

    $RouteTableName = 'route-' + $subnet.Name

    $vNet = Get-AzureRmVirtualNetwork `
        -ResourceGroupName $resourceGroupName `
        -Name $vNetName

    ### Create a new route table if one does not already exist
    
    if ((Get-AzureRmRouteTable -Name $RouteTableName -ResourceGroupName $resourceGroupName) -eq $null){
        $RouteTable = New-AzureRmRouteTable `
            -Name $RouteTableName `
            -ResourceGroupName $resourceGroupName `
            -Location $resourceLocation
    }

    ### If the route table exists, save as a variable and remove all routing configurations

    else {
        $RouteTable = Get-AzureRmRouteTable `
            -Name $RouteTableName `
            -ResourceGroupName $resourceGroupName
        $routeConfigs = Get-AzureRmRouteConfig -RouteTable $RouteTable
        foreach($config in $routeConfigs){
            Remove-AzureRmRouteConfig -RouteTable $RouteTable -Name $config.Name | Out-Null
        }
    }

    ### Create a routing configuration for each IP range and give each a descriptive name

    foreach($ipRange in $ipRanges){
        $routeName = ($ipRange.Region.Replace(' ','').ToLower()) + '-' + $ipRange.Subnet.Replace('/','-')
        Add-AzureRmRouteConfig `
            -Name $routeName `
            -AddressPrefix $ipRange.Subnet `
            -NextHopType Internet `
            -RouteTable $RouteTable | Out-Null
    }

    ### Include a routing configuration to give direct access to Microsoft's KMS servers for Windows activation

    Add-AzureRmRouteConfig `
        -Name 'AzureKMS' `
        -AddressPrefix 23.102.135.246/32 `
        -NextHopType Internet `
        -RouteTable $RouteTable

    ### Apply the route table to the subnet

    Set-AzureRmRouteTable -RouteTable $RouteTable

    $forcedTunnelVNet = $vNet.Subnets | Where-Object Name -eq $subnet.Name
    $forcedTunnelVNet.RouteTable = $RouteTable

    ### Update the virtual network with the new subnet configuration

    Set-AzureRmVirtualNetwork -VirtualNetwork $vnet -Verbose

}
