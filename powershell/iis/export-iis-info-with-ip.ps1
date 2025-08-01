Write-Host "Inicio - Script"
$Websites = Get-Website
$Hostname = hostname
$filename = "apps-"+$Hostname+".txt"
$IP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne '127.0.0.1' -and $_.PrefixOrigin -eq 'Dhcp' -or $_.PrefixOrigin -eq 'Manual' } | Select-Object -First 1 -ExpandProperty IPAddress)

'Hostname|IP|Type|Site|Webapp_Name|State|PhysicalPath|Bindings|AppPool_Name|AppPool_State|AppPool_ManagedRuntimeVersion' > $filename

foreach ($Website in $Websites) {

    $AppPool = Get-IISAppPool -Name $Website.ApplicationPool

    $customWeb = [PSCustomObject]@{
        Hostname = $Hostname
        IP = $IP
        Type = 'Site'
        Site = $Website.Name -join ';'
        Webapp_Name = ''
        State                 = $Website.State -join ';'
        PhysicalPath          = $Website.PhysicalPath
        Bindings              = $Website.Bindings.Collection -join ';'
        AppPool_Name                  = $AppPool.Name -join';'
        AppPool_State                 = $AppPool.State -join ';'
        AppPool_ManagedRuntimeVersion = $AppPool.ManagedRuntimeVersion -join ';'

    }

    $customWeb.Hostname + '|' + $customWeb.IP + '|' +$customWeb.Type + '|' + $customWeb.Site + '|' + $customWeb.Webapp_Name + '|' + $customWeb.State + '|' + $customWeb.PhysicalPath + '|' + $customWeb.Bindings + '|' + $customWeb.AppPool_Name + '|' + $customWeb.AppPool_State + '|' + $customWeb.AppPool_ManagedRuntimeVersion >> $filename
}

$Webapps = Get-WebApplication

foreach ($Webapp in $Webapps) {
    $name = ($Webapp.Path).Replace('/','')
    $site = $Webapp.GetParentElement().Attributes['name'].Value
    $AppPool = Get-IISAppPool -Name $Webapp.ApplicationPool

    $customApp = [PSCustomObject]@{
        Hostname = $Hostname
        Type = 'Application'
        Site = $site
        Webapp_Name  = $name
        State = ''
        PhysicalPath = $Webapp.PhysicalPath
        Bindings = ''
        AppPool_Name                  = $AppPool.Name -join';'
        AppPool_State                 = $AppPool.State -join ';'
        AppPool_ManagedRuntimeVersion = $AppPool.ManagedRuntimeVersion -join ';'
    }

    $customApp.Hostname + '|' +$customApp.Type + '|' + $customApp.Site + '|' + $customApp.Webapp_Name + '|' + $customApp.State + '|' + $customApp.PhysicalPath + '|' + $customApp.Bindings + '|' + $customApp.AppPool_Name + '|' + $customApp.AppPool_State + '|' + $customApp.AppPool_ManagedRuntimeVersion >> $filename
}  
Write-Host $filename
Write-Host "Fin - Script"