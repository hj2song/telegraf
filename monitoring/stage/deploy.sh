#!/usr/bin/env bash

set -e
ENV=stage

git pull

# docker compose yml에서 사용할 변수 설정
export TIMESTAMP=$(date +%s)
export CONFIG_NAME="telegraf-config"
export CONFIG_01_NAME="telegraf-01-config"

# docker stack 배포
docker stack deploy -c ./docker-compose.yml monitoring 

# telegraf 관련 기존 Config 삭제
for config in $(docker config ls --format '{{.Name}}' | grep -E "${CONFIG_NAME}|${CONFIG_01_NAME}" | grep -v "${TIMESTAMP}"); do
    docker config rm "${config}"
done