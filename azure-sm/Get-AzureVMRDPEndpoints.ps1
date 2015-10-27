$ServiceName = 'axieoaueclients'
$VMNames = '*'

$VMs = Get-AzureVM -ServiceName $ServiceName | Where-Object {$_.Name -like $VMNames}

$a = @()

foreach ($VM in $VMs){
    $RDPEndpoint = (Get-AzureEndpoint -VM $VM | Where-Object {$_.Name -eq 'RemoteDesktop'}).Port
    $URL = ($VM.ServiceName).ToLower() + '.cloudapp.net' + ':' + $RDPEndpoint
    $item = New-Object PSObject
    $item | Add-Member -type NoteProperty -Name 'Name' -Value $vm.Name
    $item | Add-Member -type NoteProperty -Name 'RDP Endpoint' -Value $URL
    $a += $item
    $item = $null
}

$a