$global:version = "apache-php8.5"

if (-not $global:version) {
    Throw "'version' is not set."
}
