$global:repositoryName = "takeshitawork/web-server-php" #  "organization/repository" or "repository"
$global:date           = Get-Date -UFormat "%Y%m"


if (-not $global:repositoryName) {
    Throw "'repositoryName' is not set."
}
