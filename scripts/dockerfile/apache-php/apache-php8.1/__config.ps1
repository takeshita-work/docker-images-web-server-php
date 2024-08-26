$global:version = "apache-php8.1"

if (-not $global:version) {
    Throw "'version' is not set."
}
