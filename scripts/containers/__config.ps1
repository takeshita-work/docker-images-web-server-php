$global:composeProjectName = "takeshita-work_web-server-php"


if (-not $global:composeProjectName) {
    Throw "'composeProjectName' is not set."
}
