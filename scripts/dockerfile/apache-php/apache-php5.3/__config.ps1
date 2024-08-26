$global:version = "apache-php5.3"

if (-not $global:version) {
    Throw "'version' is not set."
}
