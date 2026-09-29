$composeArgs = @(
    "--env-file=.docker/.env",
    "--project-directory=.",
    "-f", ".docker/compose.yml"
)
docker-compose @composeArgs exec apache-php /bin/bash
