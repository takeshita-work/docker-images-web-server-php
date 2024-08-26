$global:version = "apache-php7.0"

if (-not $global:version) {
    Throw "'version' is not set."
}
