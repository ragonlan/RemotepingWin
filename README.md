# zabbix-remoteping

## Getting started
 
Put remoteping.ps1 in 'C:\Program Files\Zabbix Agent 2\script\'.

Edit zabbix_agent2.conf in 'C:\Program Files\Zabbix Agent 2\' and add this line:
```
AllowKey=system.run[*,nowait]
```

> **Note:** Some zabbix agent 2 configuración has a bug inside config file about relative paths. To solve it you have to edit config fiel and transform relative path to abosolute path:
> From this:
>```
>Include=.\zabbix_agent2.d\plugins.d\*.conf
>```
> Into this:
>```
>Include=C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\plugins.d\*.conf
>```

## MACROS

Macros control the behavior of scripts.

|Name|Description|Default|
|--------------|--------------|--------------|
|{$REMOTE.PING.NAME1}|Name to show in every item discobery|None
||IP to ping|None|
|{$ICMP.PING.LOSS}|ICMP ping loss in percent.|40|
|{$ICMP.PING.LATENCY}|Time in seconds it takes to respond to an ICMP ping.|0.1|

Each pair of MACROS (\{$REMOTE.PING.NAME*\} and \{$REMOTE.PING.IP*\}) defines the name and IP of the hosts to ping. You can put up to 12 diferents host.
