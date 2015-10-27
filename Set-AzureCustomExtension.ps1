Get-AzureVMImage -Verbose:$false | Where-Object {$_.label -like 'Windows 10*'} | Format-Table Label, PublishedDate -AutoSize

$ImageFamily = 'Windows 10 Enterprise (x64)'
$VMImage = Get-AzureVMImage | Where-Object { $_.ImageFamily -eq $ImageFamily } | Sort-Object PublishedDate -Descending | Select-Object -ExpandProperty ImageName -First 1

Set-AzureVMCustomScriptExtension

Set-AzureVMExtension `
    -ExtensionName CustomScriptExtension `
    -VM $vm `
    -Publisher Microsoft.Compute | Update-AzureVM -Verbose

$context = Get-AzureVM -ServiceName mycloudservice -Name myvm

Set-AzureVMCustomScriptExtension `
    -VM $VM.VM `
    -FileUri 'http://sccmlabstorage001.blob.core.windows.net/scripts/New-Folder.ps1' `
    -Run 'New-Folder.ps1' `
    -Argument 'c:\hello_from_customscriptextension'

Set-AzureVMCustomScriptExtension `
    -VM $VM.VM `
    -FileUri 'http://sccmlabstorage001.blob.core.windows.net/scripts/Install-SOEApplications.ps1' `
    -Run 'Install-SOEApplications.ps1'

Update-AzureVM -VM $VM.VM -ServiceName $VM.ServiceName -Name $VM.InstanceName -Verbose

Publish-AzureVMDscConfiguration -ConfigurationPath .\AzureVMConfiguration.ps1

$vm = Get-AzureVM -ServiceName psdsc -Name CSETest

Set-AzureVMDscExtension `
    -VM $vm `
    -ConfigurationArchive Win10SOEApplications.ps1.zip `
    -ConfigurationName Win10SOEApplications `
    -Version '2.4' `
    -StorageContext $StorageContext `
    -ContainerName $StorageContainer `
    -Verbose | Update-AzureVM -Verbose


$StorageAccount = 'win10teststor1mprlyf'
$StorageKey = 'UvsknfIvX8vFOjr5E1Z5AFzZA2OdJQaElGaDJvh9ptRiuztS7i0fd74qs9uenQ8SE7M4s0E377wReaioOm8/fw=='
$StorageContainer = 'windows-powershell-dsc'
 
$StorageContext = New-AzureStorageContext `
    -StorageAccountName $StorageAccount `
    -StorageAccountKey $StorageKey

Publish-AzureVMDscConfiguration `
    -ConfigurationPath .\Win10SOEApplications.ps1 `
    -ContainerName $StorageContainer `
    -StorageContext $StorageContext

$vm = Get-AzureVM -ServiceName psdsc -Name CSETest

Set-AzureVMDscExtension `
    -VM $vm `
    -ConfigurationArchive AzureVMConfiguration.ps1.zip `
    -ConfigurationName AzureDscDemo `
    -Verbose `
    -StorageContext $StorageContext `
    -ContainerName $StorageContainer | Update-AzureVM