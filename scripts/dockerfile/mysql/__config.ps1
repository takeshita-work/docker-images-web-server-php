$global:softwareName = "mysql"


if (-not $global:softwareName) {
    Throw "'softwareName' is not set."
}
