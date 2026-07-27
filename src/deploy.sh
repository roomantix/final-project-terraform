#!/bin/bash
set -e

# Проверка количества аргументов
if [ $# -ne 7 ]; then
    echo "Ошибка: требуется 7 аргументов, передано $#"
    echo "Использование: $0 <registry_id> <key_path> <db_host> <db_port> <db_name> <db_user> <db_password>"
    exit 1
fi

REGISTRY_ID="$1"
KEY_PATH="$2"
DB_HOST="$3"
DB_PORT="$4"
DB_NAME="$5"
DB_USER="$6"
DB_PASSWORD="$7"

echo ">>> Переданные параметры:"
echo "REGISTRY_ID=$REGISTRY_ID"
echo "KEY_PATH=$KEY_PATH"
echo "DB_HOST=$DB_HOST"
echo "DB_PORT=$DB_PORT"
echo "DB_NAME=$DB_NAME"
echo "DB_USER=$DB_USER"

IMAGE_NAME="cr.yandex/${REGISTRY_ID}/my-app:latest"
CONTAINER_NAME="my-app"
HOST_PORT=5000

# Проверка Docker
if ! command -v docker &> /dev/null; then
    echo "Ошибка: Docker не установлен"
    exit 1
fi

# Аутентификация
if [ -f "$KEY_PATH" ]; then
    cat "$KEY_PATH" | docker login --username json_key --password-stdin cr.yandex
fi

# Скачивание образа
docker pull $IMAGE_NAME || { echo "Не удалось скачать образ"; exit 1; }

# Остановка и удаление
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Запуск с переменными
docker run -d --name $CONTAINER_NAME \
  -p $HOST_PORT:5000 \
  -e DB_HOST="$DB_HOST" \
  -e DB_PORT="$DB_PORT" \
  -e DB_NAME="$DB_NAME" \
  -e DB_USER="$DB_USER" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  $IMAGE_NAME || {
    echo "Ошибка запуска контейнера"
    docker logs $CONTAINER_NAME --tail 20
    exit 1
  }

echo ">>> Ожидание запуска приложения..."
for i in $(seq 1 12); do
    if curl -s http://localhost:$HOST_PORT > /dev/null; then
        echo ">>> Приложение отвечает на порту $HOST_PORT"
        exit 0
    fi
    echo "Попытка $i из 12... (ждем 5 сек)"
    sleep 5
done

echo "Ошибка: приложение не запустилось за 60 секунд"
docker logs $CONTAINER_NAME --tail 30
exit 1