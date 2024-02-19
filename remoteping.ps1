param(
    [string]$hostName,
    [string]$ip,
    [int]$pingCount
)

function Test-IsValidIpAddress {
    param([string]$ip)
    [System.Net.IPAddress]$address = $null
    return [System.Net.IPAddress]::TryParse($ip, [ref]$address)
}

function Send-ZabbixData {
    param(
        [string]$key,
        [string]$value
    )
    $ZabbixInstallPath = "$Env:Programfiles\Zabbix Agent 2"
    $ZSender = "$ZabbixInstallPath\zabbix_sender.exe"
    $configPath = "$ZabbixInstallPath\zabbix_agent2.conf"
    $tempFile = New-TemporaryFile
    "- $key  $value" | Set-Content -Path $tempFile
    & "$ZSender"  -c $configPath  -i $tempFile
}

function Ping-Host {
    param(
        [string]$hostIp,
        [int]$count
    )

    $pingResult = Test-Connection -ComputerName $hostIp -Count $count -Delay 1 -ErrorAction SilentlyContinue
    $pingResultCount = $pingResult.Count 
    if ( ! $pingResult.Count ){
        $pingResultCount = 0
    }
    $loss = [Math]::Round(((1 - ($pingResultCount / $count)) * 100), 3)
    $response = [Math]::Round(($pingResult.ResponseTime | Measure-Object -Average).Average / 1000, 3)
    $pingStatus = 0
    if ( $pingResultCount -ne 0) {
        $pingStatus = 1
    }

    return @{
        loss = $loss
        ping = $pingStatus
        response = $response
    }
}

if ( -not (Test-IsValidIpAddress -ip $ip)){
    Write-Host "$ip is not a valid IP address. Exiting with error code 3."
    exit 3
}

$pingData = Ping-Host -hostIp $ip -count $pingCount
$jsonOutput = $pingData | ConvertTo-Json -Compress
Write-Output $jsonOutput
Send-ZabbixData -key "remote.ping[$hostName]" -value $jsonOutput