output "vm_public_ip" {
  value       = yandex_compute_instance.platform.network_interface[0].nat_ip_address
  description = "Публичный IP ВМ"
}

output "vm_private_ip" {
  value       = yandex_compute_instance.platform.network_interface[0].ip_address
  description = "Внутренний IP ВМ"
}

output "db_fqdn" {
  value       = yandex_mdb_mysql_cluster.my_cluster.host[0].fqdn
  description = "FQDN хоста MySQL"
}

output "db_port" {
  value       = 3306
  description = "Порт MySQL"
}

output "registry_id" {
  value       = yandex_container_registry.my_registry.id
  description = "ID Container Registry"
}

output "repository_name" {
  value       = yandex_container_repository.my_repository.name
  description = "Полное имя репозитория"
}
output "db_name" {
  value       = yandex_mdb_mysql_database.my_db.name
  description = "Имя базы данных"
}
       