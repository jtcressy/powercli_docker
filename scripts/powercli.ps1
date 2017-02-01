Get-Module -ListAvailable PowerCLI* | Import-Module
Connect-VIServer -Server $args[0] -User $args[1] -Password $args[2]