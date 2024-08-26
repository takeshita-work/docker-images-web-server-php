$global:version = "apache-php7.3"

if (-not $global:version) {
    Throw "'version' is not set."
}
