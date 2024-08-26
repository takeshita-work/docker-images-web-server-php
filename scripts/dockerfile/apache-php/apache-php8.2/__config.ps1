$global:version = "apache-php8.2"

if (-not $global:version) {
    Throw "'version' is not set."
}
