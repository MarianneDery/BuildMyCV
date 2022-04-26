Get-Content config.txt | Where-Object {$_.length -gt 0} | Where-Object {!$_.StartsWith("#")} | ForEach-Object {
    $var = $_.Split('=',2).Trim()
    New-Variable -Scope Script -Name $var[0] -Value $var[1]
}

$dburl="postgresql://$($User):$($Password)@$($Server):$($Port)/$($Database)"

psql -f schema.sql $dburl
psql -f seed.sql $dburl
