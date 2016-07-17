# Update-AzureDatacenterRoutes

This script makes use of the AzurePublicIPAddresses PowerShell module written by Kieran Jacobsen (<https://www.poshsecurity.com/blog/working-with-azures-public-ip-addresses>), and is designed to automatically create a route table on one or more Azure virtual network subnets, creating a direct route to the Azure datacenters in the nominated geo-political zone (e.g. Australia = Australia Southeast & Australia East). This allows IaaS instances to directly access Azure services (e.g. Azure Storage, Azure Recovery Vault) when they are also connected to an on-premises network via VPN or ExpressRoute.

This script is designed to be run as an Azure Automation runbook which allows it to run on a schedule, although with some modification it can also be run as a standalone PowerShell script.

To run the script within Azure Automation, the latest versions of the following modules are required:

1. AzurePublicIPAddresses (<https://www.powershellgallery.com/packages/AzurePublicIPAddresses/0.5.1>)
2. AzureRM.profile
3. AzureRM.Network
4. AzureRM.Resources

The script also makes use of the following Azure Automation Assets:

1. virtualNetworkRGName (variable/string/unencrypted) - this is the name of the Resource Group within which the virtual network resides
2. virtuaNetworkRGLocation (variable/string/unencrypted) - this is the Azure location of the Resource Group (e.g. Australia Southeast)
3. virtualNetworkName (variable/string/unencrypted) - this is the name of the Virtual Network resource
4. azureDatacenterRegions (variable/string/unencrypted) - this is the name of the primary geo-political zone (e.g. australia)

The script takes the azureDatacenterRegions value (e.g. australia) and returns all public IP ranges for each datacenter within that region (e.g. Australia Southeast, Australia East). Then, for each range, a new route configuration is created within a route table, along with a route for the public IP range of the Azure KMS service. Each subnet receives a route table with the same content, except the GatewaySubnet.

Because it is designed to be run on a schedule, each time the script is run it will remove all the routing configurations and will replace them with the latest values returned by the AzurePublicIPAddresses module.