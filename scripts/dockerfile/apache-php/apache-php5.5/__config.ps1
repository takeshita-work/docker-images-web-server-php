$global:version = "apache-php5.5"

if (-not $global:version) {
    Throw "'version' is not set."
}
