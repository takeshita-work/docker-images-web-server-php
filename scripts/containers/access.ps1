<#
  containers/compose.yml に定義された任意のコンテナに exec でアクセスする。

  使い方:
    ./scripts/containers/access.ps1 <サービス名>
    <Tab> でサービス名を補完できる(containers/compose.yml から動的に取得するため、
    サービスが増減しても自動で追従する)。

  bash が入っていないイメージ(mailcatcher 等)では自動的に sh にフォールバックする。
  指定したコンテナが起動していない場合は自動的に起動する。
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ArgumentCompleter({
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
        try {
            docker compose -f "$PSScriptRoot/../../containers/compose.yml" config --services 2>$null |
                Sort-Object |
                Where-Object { $_ -like "$wordToComplete*" }
        } catch {
            @()
        }
    })]
    [string]$Service
)

try {
    . $PSScriptRoot/__config.ps1  # composeProjectName setting

    $composeArgs = @(
        "-p", "${global:composeProjectName}",
        "-f", "./containers/compose.yml"
    )

    docker-compose @composeArgs up -d $Service
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: $Service の起動に失敗しました。"
        exit 1
    }

    $shell = "bash"
    $probe = docker-compose @composeArgs exec -T $Service sh -c "command -v bash" 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $probe) {
        $shell = "sh"
    }

    Write-Host "$Service に $shell で接続します..."
    docker-compose @composeArgs exec $Service $shell
} catch {
    echo "Error: $_"
    exit 1
}
