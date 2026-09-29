$global:softwareName = "mariadb"


if (-not $global:softwareName) {
    Throw "'softwareName' is not set."
}
