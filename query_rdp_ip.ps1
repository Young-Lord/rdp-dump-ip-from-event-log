$xml='<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4624)]]</Select>
  </Query>
</QueryList>'
#Write-Host '登录时间','登录类型','登录账号','登录IP地址'
foreach ($event in Get-WinEvent -FilterXml $xml) {
    try { $time=$event.TimeCreated
    $type= [regex]::matches($event.Message, '登录类型:(.+)')   | %{$_.Groups[1].Value.Trim()}
    $user=([regex]::matches($event.Message, '帐户名称?:(.+)')  | %{$_.Groups[1].Value.Trim()})[1]
    $IP=  [regex]::matches($event.Message, '源网络地址:(.+)') | %{$_.Groups[1].Value.Trim()}
    if ($IP -ne "-"){ Write-Host $time,$user,$type,$IP }
    }
    catch { }
}