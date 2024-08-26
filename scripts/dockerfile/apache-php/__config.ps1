$global:softwareName = "apache-php"


if (-not $global:softwareName) {
    Throw "'softwareName' is not set."
}
