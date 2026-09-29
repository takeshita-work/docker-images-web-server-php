$global:version = "8.4"

if (-not $global:version) {
    Throw "'version' is not set."
}
