$global:version = "apache-php5.6"

if (-not $global:version) {
    Throw "'version' is not set."
}
