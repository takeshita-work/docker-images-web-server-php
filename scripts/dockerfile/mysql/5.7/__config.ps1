$global:version = "5.7"

if (-not $global:version) {
    Throw "'version' is not set."
}
