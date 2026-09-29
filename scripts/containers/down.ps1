<#
  containers/compose.yml のコンテナを削除する。

  使い方:
    ./scripts/containers/down.ps1              ... 全サービスを削除(ネットワークも削除)
    ./scripts/containers/down.ps1 <サービス名>  ... 指定したサービスのみ削除(<Tab>で補完。
    他のサービスが起動中の場合、ネットワークは使用中のため削除されない)
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

    docker-compose @composeArgs down @target
} catch {
    echo "Error: $_"
    exit 1
}
