#!/usr/bin/env bash

set -e

ENV=prod

git pull


# docker compose yml에서 사용할 변수 설정
export TIMESTAMP=$(date +%s)
export CONFIG_NAME="telegraf-config"
export CONFIG_LOGGING_NAME="telegraf-logging-config"
export CONFIG_161_NAME="telegraf-161-config"
export CONFIG_162_NAME="telegraf-162-config"

# docker stack 배포
docker stack deploy -c ./docker-compose.yml monitoring

# telegraf 관련 기존 Config 삭제
for config in $(docker config ls --format '{{.Name}}' | grep -E "${CONFIG_NAME}|${CONFIG_LOGGING_NAME}|${CONFIG_161_NAME}|${CONFIG_162_NAME}" | grep -v "${TIMESTAMP}"); do
    docker config rm "${config}"
done