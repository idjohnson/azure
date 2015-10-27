$users = (
    'Sandra Pienaar',
    'Katie Hodgson',
    'Jodie Munro',
    'Clare Neeson',
    'Melinda Bruce',
    'Kai Chua',
    'Mike Kleviansky',
    'Donna Currid',
    'Karen Ingram',
    'Brad Adler',
    'Morris Smith',
    'Simon Peach',
    'Dubravko Vucic'
)

Import-Module ActiveDirectory

$a = @()

foreach ($user in $users){
    $FirstName = $user.Split(' ')[0]
    $Surname = $user.Split(' ')[1]
    $SamAccountName = $FirstName + '.' + $Surname
    $ADUser = Get-ADUser -Filter * | Where-Object {$_.Surname -eq $Surname}
    Set-ADUser $ADUser `
        -Replace @{SamAccountName=$SamAccountName} `
        -ChangePasswordAtLogon $true `
        -Verbose
    $a += $SamAccountName
}

foreach ($user in $users){
    $FirstName = $user.Split(' ')[0]
    $Surname = $user.Split(' ')[1]
    $ADUser = Get-ADUser -Filter * | Where-Object {$_.Surname -eq $Surname}
    Set-ADAccountPassword $ADUser.DistinguishedName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText 'P@ssw0rd' -Force) -Verbose
}

$Path = 'OU=AxieoUsers,OU=Accounts,OU=Axieo,DC=corp,DC=axieo,DC=com'

foreach ($user in $users){
    $Surname = $user.Split(' ')[1]
    $ADUser = Get-ADUser -Filter * -SearchBase $Path | Where-Object {$_.Surname -eq $Surname}
    $a += $ADUser.SamAccountName
}

$a | Sort-Object