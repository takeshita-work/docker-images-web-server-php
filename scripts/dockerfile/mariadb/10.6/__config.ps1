$global:version = "10.6"

if (-not $global:version) {
    Throw "'version' is not set."
}
