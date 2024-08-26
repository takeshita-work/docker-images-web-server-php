$global:version = "apache-php7.2"

if (-not $global:version) {
    Throw "'version' is not set."
}
