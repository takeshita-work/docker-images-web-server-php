$global:version = "apache-php8.3"

if (-not $global:version) {
    Throw "'version' is not set."
}
