docker-compose `
  --env-file=.docker/.env `
  --project-directory=. `
  -f .docker/compose.yml `
  exec apache-php /bin/bash