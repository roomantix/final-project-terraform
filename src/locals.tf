locals {
  db_password_from_lockbox = one([
    for entry in data.yandex_lockbox_secret_version.db_password_version_data.entries : entry.text_value
    if entry.key == "DB_PASSWORD"
  ])
}