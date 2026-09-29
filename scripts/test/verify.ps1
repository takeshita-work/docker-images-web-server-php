<#
  containers/compose.yml の全サービスを起動し、それぞれが正常に動作するかを自動で確認する。
  - apache-php : HTTPでアクセスし、200かつ "Fatal error" を含まないことを確認
  - mysql/mariadb : mysqladmin(mariadb-admin) ping で応答を確認
  - phpMyAdmin : HTTPでアクセスし、200かつページ内に "phpMyAdmin" を含むことを確認
  - MailCatcher : HTTPでアクセスし、200であることを確認
  最後に必ず containers/compose.yml のコンテナを削除する(成功・失敗にかかわらず)。
#>

. $PSScriptRoot/../containers/__config.ps1  # composeProjectName setting

$composeArgs = @(
    "-p", "${global:composeProjectName}",
    "-f", "./containers/compose.yml"
)

$results = New-Object System.Collections.Generic.List[object]

function Add-Result {
    param([string]$Target, [bool]$Ok, [string]$Detail)
    $results.Add([PSCustomObject]@{
        Target = $Target
        Result = if ($Ok) { "OK" } else { "NG" }
        Detail = $Detail
    })
}

function Wait-Until {
    param(
        [scriptblock]$Check,
        [int]$TimeoutSec = 30,
        [int]$IntervalSec = 2
    )
    $elapsed = 0
    while ($elapsed -lt $TimeoutSec) {
        $r = & $Check
        if ($r.Ok) { return $r }
        Start-Sleep -Seconds $IntervalSec
        $elapsed += $IntervalSec
    }
    return $r
}

function Test-Http {
    param([string]$Url, [string]$MustContain = $null, [string]$MustNotContain = $null)
    try {
        $res = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 10
        if ($res.StatusCode -ne 200) {
            return @{ Ok = $false; Detail = "HTTP $($res.StatusCode)" }
        }
        if ($MustContain -and $res.Content -notmatch [regex]::Escape($MustContain)) {
            return @{ Ok = $false; Detail = "HTTP 200だが '$MustContain' が見つからない" }
        }
        if ($MustNotContain -and $res.Content -match [regex]::Escape($MustNotContain)) {
            return @{ Ok = $false; Detail = "HTTP 200だが '$MustNotContain' を含む" }
        }
        return @{ Ok = $true; Detail = "HTTP 200" }
    } catch {
        return @{ Ok = $false; Detail = $_.Exception.Message }
    }
}

function Test-DbPing {
    param([string]$Service, [string]$Binary)
    try {
        $out = docker-compose @composeArgs exec -T $Service $Binary ping -uroot -pmysql_root_password 2>&1 | Out-String
        if ($LASTEXITCODE -eq 0 -and $out -match "mysqld is alive") {
            return @{ Ok = $true; Detail = "$Binary ping OK" }
        }
        return @{ Ok = $false; Detail = ($out.Trim() -replace "`r?`n", " / ") }
    } catch {
        return @{ Ok = $false; Detail = $_.Exception.Message }
    }
}

try {
    Write-Host "containers/compose.yml の全コンテナを起動しています..."
    docker-compose @composeArgs up -d | Out-Null

    # apache-php: サービス名 -> ホスト側ポート
    $apachePorts = [ordered]@{
        "apache-php5.5" = 11080
        "apache-php5.6" = 12080
        "apache-php7.0" = 13080
        "apache-php7.1" = 14080
        "apache-php7.2" = 15080
        "apache-php7.3" = 16080
        "apache-php7.4" = 17080
        "apache-php8.0" = 18080
        "apache-php8.1" = 19080
        "apache-php8.2" = 20080
        "apache-php8.3" = 21080
        "apache-php8.4" = 22080
        "apache-php8.5" = 23080
    }
    foreach ($name in $apachePorts.Keys) {
        $port = $apachePorts[$name]
        Write-Host "確認中: $name (http://127.0.0.1:$port/)"
        $r = Wait-Until -Check { Test-Http -Url "http://127.0.0.1:$port/" -MustNotContain "Fatal error" }
        Add-Result $name $r.Ok $r.Detail
    }

    # mysql / mariadb: サービス名 -> 使用するpingコマンド
    $dbServices = [ordered]@{
        "mysql5.7"      = "mysqladmin"
        "mysql8.0"      = "mysqladmin"
        "mysql8.4"      = "mysqladmin"
        "mariadb10.6"   = "mariadb-admin"
        "mariadb10.11"  = "mariadb-admin"
        "mariadb11.4"   = "mariadb-admin"
    }
    foreach ($name in $dbServices.Keys) {
        $bin = $dbServices[$name]
        Write-Host "確認中: $name ($bin ping)"
        $r = Wait-Until -Check { Test-DbPing -Service $name -Binary $bin }
        Add-Result $name $r.Ok $r.Detail
    }

    # phpMyAdmin: サービス名 -> ホスト側ポート
    $pmaPorts = [ordered]@{
        "phpmyadmin-mysql5.7"      = 30080
        "phpmyadmin-mysql8.0"      = 31080
        "phpmyadmin-mysql8.4"      = 32080
        "phpmyadmin-mariadb10.6"   = 33080
        "phpmyadmin-mariadb10.11"  = 34080
        "phpmyadmin-mariadb11.4"   = 35080
    }
    foreach ($name in $pmaPorts.Keys) {
        $port = $pmaPorts[$name]
        Write-Host "確認中: $name (http://127.0.0.1:$port/)"
        $r = Wait-Until -Check { Test-Http -Url "http://127.0.0.1:$port/" -MustContain "phpMyAdmin" }
        Add-Result $name $r.Ok $r.Detail
    }

    # MailCatcher
    Write-Host "確認中: smtp(mailcatcher) (http://127.0.0.1:1080/)"
    $r = Wait-Until -Check { Test-Http -Url "http://127.0.0.1:1080/" }
    Add-Result "smtp(mailcatcher)" $r.Ok $r.Detail

} finally {
    Write-Host "後片付け: containers/compose.yml のコンテナを削除しています..."
    docker-compose @composeArgs down | Out-Null
}

Write-Host ""
$results | Format-Table -AutoSize -Wrap

$failed = $results | Where-Object { $_.Result -eq "NG" }
if ($failed) {
    Write-Host "$($failed.Count) / $($results.Count) 件 失敗しました。" -ForegroundColor Red
    exit 1
} else {
    Write-Host "全 $($results.Count) 件 成功しました。" -ForegroundColor Green
    exit 0
}
