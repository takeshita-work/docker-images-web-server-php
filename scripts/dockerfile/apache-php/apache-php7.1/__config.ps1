$global:version = "apache-php7.1"

if (-not $global:version) {
    Throw "'version' is not set."
}
