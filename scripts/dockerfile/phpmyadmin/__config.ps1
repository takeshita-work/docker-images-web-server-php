$global:softwareName = "phpmyadmin"


if (-not $global:softwareName) {
    Throw "'softwareName' is not set."
}
