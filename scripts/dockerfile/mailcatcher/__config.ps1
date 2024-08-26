$global:softwareName = "mailcatcher"


if (-not $global:softwareName) {
    Throw "'softwareName' is not set."
}
