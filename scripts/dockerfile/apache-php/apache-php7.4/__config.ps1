$global:version = "apache-php7.4"

if (-not $global:version) {
    Throw "'version' is not set."
}
