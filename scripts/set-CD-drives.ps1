#Script by Joel Cressy (http://github.com/jtcressy)
if(!(Get-Module PowerCLI*)){
    Get-Module -ListAvailable PowerCLI* | Import-Module
}
#If the user does not provide exactly 5 arguments, we'll have to ask them interactively
if (!($args.Count -eq 5)) {
    #inform the user of proper syntax
    Write-Host "Usage: set-CD-drives.ps1 <server> <username> <vm(s)> <datastore> <isopath>"
    
    if(($VIServer = Read-Host -Prompt 'VM Server') -eq '') {
        Write-Host "ERR: Hostname or IP Required for vmware server"
        break
    }
    if(($VIUser = Read-Host -Prompt 'Username') -eq '') {
        Write-Host "ERR: Username required"
        break
    }
    
    if(($VMname = Read-Host -Prompt 'VM Name') -eq '') {
        Write-Host "ERR: Type a name to search for VM(s) to use. Can use wildcards (e.g. vm* to select all vm's starting with 'vm')"
        break
    }
    if(($VIDS = Read-Host -Prompt 'Datastore name') -eq '') {
        Write-Host "ERR: Specify the name of the datastore to mount the iso"
        break
    }
    if(($ISOpath = Read-Host -Prompt "Path to ISO in datastore $VIDS") -eq '') {
        Write-Host "ERR: Specify the path to the ISO file on datastore $VIDS"
        break
    }
} else {
    $VIServer = $args[0]
    $VIUser = $args[1]
    #Read password interactively every time and store it cryptographically with securestring
    if(($VIPass = Read-Host -AsSecureString -Prompt 'Password') -eq '') {
        Write-Host "ERR: Password Required"
        break
    }
    $VMname = $args[2]
    $VIDS = $args[3]
    $ISOpath = $args[4]
}
#Use PSCredential to extract the encrypted password for PowerCLI to connect to the server
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $VIUser, $VIPass
$connection = Connect-VIServer -Server $VIServer -User $Cred.GetNetworkCredential().UserName -Password $Cred.GetNetworkCredential().Password
Write-Host "Connected to $connection"
$VMS = get-VM $VMname
foreach ($VM in $VMS) {
    $cd = Get-CDDrive -VM $VM
    Set-CDDrive -CD $cd -IsoPath "[$VIDS] $ISOpath" -StartConnected:$true -Connected:$true -Confirm:$false
    Write-Host "Set CD Drive to '[$VIDS] $ISOpath' for VM $VM"
}
Start-Sleep -Seconds 10
foreach ($VM in $VMS) {
    if ($VM.PowerState -eq 'PoweredOn') {
        #vSphere WILL ask to override the CD-ROM lock if it's powered on. Otherwise we're fine.
        Get-VMQuestion -VM $VM | Set-VMQuestion -Option "button.yes" -Confirm:$false
        Write-Host "Answered Question for $VM to override CD-ROM door lock"
    }
}