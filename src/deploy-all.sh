#!/bin/bash
set -e

# --- Загрузка переменных из .env (если файл существует) ---
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# --- Проверка обязательных переменных ---
required_vars=("REGISTRY_ID" "VM_IP" "SSH_PRIVATE_KEY_PATH" "SERVICE_ACCOUNT_KEY_FILE")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Ошибка: переменная $var не задана. Укажите её в .env или экспортируйте."
        exit 1
    fi
done

echo ">>> Registry ID: $REGISTRY_ID"
echo ">>> VM IP: $VM_IP"
echo ">>> Путь к ключу: $SERVICE_ACCOUNT_KEY_FILE"

# --- Проверка наличия необходимых утилит ---
for cmd in git docker; do
    if ! command -v $cmd &> /dev/null; then
        echo "Ошибка: $cmd не установлен. Установите и повторите."
        exit 1
    fi
done

# --- Клонирование / обновление репозитория с приложением ---
REPO_URL="https://github.com/roomantix/shvirtd-example-python.git"
REPO_DIR="shvirtd-example-python"

if [ -d "$REPO_DIR" ]; then
    echo ">>> Репозиторий уже существует, обновляем..."
    cd "$REPO_DIR"
    git pull
    cd ..
else
    echo ">>> Клонируем репозиторий $REPO_URL"
    git clone "$REPO_URL" "$REPO_DIR"
fi

# Переходим в папку с проектом
cd "$REPO_DIR"

# --- Аутентификация в Container Registry (локально) ---
if [ ! -f "$SERVICE_ACCOUNT_KEY_FILE" ]; then
    echo "Ошибка: файл ключа $SERVICE_ACCOUNT_KEY_FILE не найден локально"
    exit 1
fi
cat "$SERVICE_ACCOUNT_KEY_FILE" | docker login --username json_key --password-stdin cr.yandex

# --- Сборка и загрузка образа (используем Dockerfile.python из репозитория) ---
IMAGE="cr.yandex/${REGISTRY_ID}/my-app:latest"
echo ">>> Сборка образа $IMAGE ..."
docker build -f Dockerfile.python -t "$IMAGE" .

echo ">>> Загрузка образа в реестр..."
docker push "$IMAGE"

# Возвращаемся в корневую папку
cd ..

# --- Запуск Terraform для развёртывания на ВМ ---
echo ">>> Развёртывание на ВМ через Terraform..."
terraform apply -auto-approve \
    -var="vm_ip=$VM_IP" \
    -var="registry_id=$REGISTRY_ID" \
    -var="ssh_private_key_path=$SSH_PRIVATE_KEY_PATH" \
    -var="service_account_key_file=$SERVICE_ACCOUNT_KEY_FILE" \
    -var="db_host=$DB_HOST" \
    -var="db_port=$DB_PORT" \
    -var="db_name=$DB_NAME" \
    -var="db_user=$DB_USER" \
    -var="db_password=$DB_PASSWORD"

# --- Вывод информации ---
echo ">>> Готово! Приложение должно быть доступно по адресу: http://${VM_IP}:5000"