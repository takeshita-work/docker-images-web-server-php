$global:version = "10.11"

if (-not $global:version) {
    Throw "'version' is not set."
}
