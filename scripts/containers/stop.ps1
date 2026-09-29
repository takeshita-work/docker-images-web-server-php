<#
  containers/compose.yml のコンテナを停止する。

  使い方:
    ./scripts/containers/stop.ps1              ... 全サービスを停止
    ./scripts/containers/stop.ps1 <サービス名>  ... 指定したサービスのみ停止(<Tab>で補完)
#>

param(
    [Parameter(Position = 0)]
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

    $target = @()
    if ($Service) { $target = @($Service) }

    docker-compose @composeArgs stop @target
} catch {
    echo "Error: $_"
    exit 1
}
