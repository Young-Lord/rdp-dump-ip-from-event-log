# https://github.com/Young-Lord/rdp-dump-ip-from-event-log/blob/master/query_rdp_ip.ps1
# ref: https://powershell.org/2019/08/a-better-way-to-search-events/
# ref: https://stackoverflow.com/questions/68441505/powershell-how-to-read-eventdata-part-of-the-xml

$xml='<QueryList>
<Query Id="0" Path="Security">
  <Select Path="Security">*[System[(EventID=4624)]] and *[EventData[Data[@Name="IpAddress"]!="-"]] and *[EventData[Data[@Name="TargetUserName"]!="ANONYMOUS LOGON"]]</Select>
</Query>
</QueryList>'

$result=Get-WinEvent -FilterXml $xml -MaxEvents 100 | ForEach-Object {
    $eventXml = ([xml]$_.ToXml()).Event
    [PsCustomObject]@{
        Time=$_.TimeCreated
        TargetUserName = ($eventXml.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' }).'#text'
        IpAddress = ($eventXml.EventData.Data | Where-Object { $_.Name -eq 'IpAddress' }).'#text'
        WorkstationName = ($eventXml.EventData.Data | Where-Object { $_.Name -eq 'WorkstationName' }).'#text'
        LogonType = ($eventXml.EventData.Data | Where-Object { $_.Name -eq 'LogonType' }).'#text'
    }
}

$result | Sort-Object -Property Time | Format-Table
