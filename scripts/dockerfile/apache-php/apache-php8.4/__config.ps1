$global:version = "apache-php8.4"

if (-not $global:version) {
    Throw "'version' is not set."
}
