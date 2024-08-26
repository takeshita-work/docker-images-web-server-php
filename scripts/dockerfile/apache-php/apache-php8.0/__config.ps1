$global:version = "apache-php8.0"

if (-not $global:version) {
    Throw "'version' is not set."
}
