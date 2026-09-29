# ポート(80/443/1080/8080)が競合する他プロジェクトのコンテナを停止
. $PSScriptRoot/__stop_port_conflicts.ps1

$composeArgs = @(
    "--env-file=.docker/.env",
    "--project-directory=.",
    "-f", ".docker/compose.yml"
)
docker-compose @composeArgs down
