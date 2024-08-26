try {
  . $PSScriptRoot/__config.ps1  # composeProjectName setting

  docker-compose `
    -p "${global:composeProjectName}" `
    -f ./docker-compose/compose.yml `
    down
} catch {
    echo "Error: $_"
    exit 1
}
