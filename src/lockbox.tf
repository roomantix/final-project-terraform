# Создание секрета в Lockbox
resource "yandex_lockbox_secret" "db_password_secret" {
  name        = "db-password-secret"
  description = "Секрет для хранения пароля от базы данных"
  folder_id   = var.folder_id
}

# Создание версии секрета с самим паролем
resource "yandex_lockbox_secret_version" "db_password_version" {
  secret_id = yandex_lockbox_secret.db_password_secret.id

  entries {
    key        = "DB_PASSWORD"
    text_value = var.db_password
  }
}

data "yandex_lockbox_secret" "db_password_secret_data" {
  secret_id = yandex_lockbox_secret.db_password_secret.id
}


data "yandex_lockbox_secret_version" "db_password_version_data" {
  secret_id = yandex_lockbox_secret.db_password_secret.id
}
