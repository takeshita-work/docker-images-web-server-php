$global:version = "11.4"

if (-not $global:version) {
    Throw "'version' is not set."
}
