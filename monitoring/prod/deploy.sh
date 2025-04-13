#!/usr/bin/env bash

set -e

# 이미지 이름, 버전 및 배포 환경
export IMAGE_REPO="nexus.meatbox.co.kr:5001"
export IMAGE_VERSION="$(date +"%Y%m%d%H%M%S")"
export ENV=prod
export APP=telegraf-logging

echo ${IMAGE_VERSION}
# 도커 이미지 빌드 & 푸쉬
docker build -t ${IMAGE_REPO}/${ENV}/${APP}:${IMAGE_VERSION} .
docker tag ${IMAGE_REPO}/${ENV}/${APP}:${IMAGE_VERSION} ${IMAGE_REPO}/${ENV}/${APP}:latest
docker push ${IMAGE_REPO}/${ENV}/${APP}:${IMAGE_VERSION}
docker push ${IMAGE_REPO}/${ENV}/${APP}:latest

# docker compose yml에서 사용할 변수 설정
export TIMESTAMP=$(date +%s)
export CONFIG_NAME="telegraf-config"
export CONFIG_LOGGING_NAME="telegraf-logging-config"
export CONFIG_171_NAME="telegraf-171-config"
export CONFIG_161_NAME="telegraf-161-config"
export CONFIG_162_NAME="telegraf-162-config"

# docker stack 배포
docker stack deploy -c ./docker-compose.yml monitoring --with-registry-auth

# telegraf 관련 기존 Config 삭제
for config in $(docker config ls --format '{{.Name}}' | grep -E "${CONFIG_NAME}|${CONFIG_LOGGING_NAME}|${CONFIG_171_NAME}|${CONFIG_161_NAME}|${CONFIG_162_NAME}" | grep -v "${TIMESTAMP}"); do
    docker config rm "${config}"
done