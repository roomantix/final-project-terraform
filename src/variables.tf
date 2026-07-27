variable "service_account_key_file" {
  description = "Путь к JSON-ключу сервисного аккаунта"
  type        = string
  default     = ""
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
}

variable "folder_id" {
  description = "ID каталога"
  type        = string
}

variable "vms_ssh_root_key" {
  description = "Публичный SSH-ключ"
  type        = string
  sensitive   = true
}

# VPC
variable "default_zone" {
  description = "Зона по умолчанию"
  type        = string
  default     = "ru-central1-a"
}

variable "vpc_name" {
  description = "Имя VPC"
  type        = string
  default     = "develop"
}

variable "vpc_cidr" {
  description = "CIDR подсети"
  type        = string
  default     = "10.0.1.0/24"
}

# Группа безопасности
variable "trusted_cidrs" {
  description = "Разрешённые CIDR для входящих правил"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ports" {
  description = "Открытые порты"
  type        = list(number)
  default     = [22, 80, 443]
}

# Виртуальная машина
variable "vm_name" {
  description = "Имя ВМ"
  type        = string
  default     = "web-server"
}

variable "vm_platform" {
  description = "Платформа (standard-v3, standard-v2)"
  type        = string
  default     = "standard-v3"
}

variable "vm_cores" {
  description = "Количество vCPU"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "RAM (ГБ)"
  type        = number
  default     = 2
}

variable "vm_core_fraction" {
  description = "Доля vCPU (20, 50, 100 для standard-v3)"
  type        = number
  default     = 20
}

variable "vm_disk_size" {
  description = "Размер загрузочного диска (ГБ)"
  type        = number
  default     = 20
}

variable "vm_disk_type" {
  description = "Тип диска (network-hdd, network-ssd)"
  type        = string
  default     = "network-hdd"
}

variable "vm_preemptible" {
  description = "Прерываемая ВМ"
  type        = bool
  default     = true
}

variable "vm_image_family" {
  description = "Семейство образа ОС"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "vm_labels" {
  description = "Метки для ВМ"
  type        = map(string)
  default = {
    environment = "development"
    project     = "terraform"
  }
}

# Cloud-init
variable "user_data_packages" {
  description = "Пакеты для установки"
  type        = list(string)
  default     = ["nginx"]
}

variable "user_data_runcmd" {
  description = "Команды после установки"
  type        = list(string)
  default     = [
    "systemctl enable nginx",
    "systemctl start nginx"
  ]
}

# Управляемая БД MySQL
variable "db_cluster_name" {
  description = "Имя кластера MySQL"
  type        = string
  default     = "mysql-cluster"
}

variable "db_environment" {
  description = "Окружение (PRESTABLE или PRODUCTION)"
  type        = string
  default     = "PRESTABLE"
}

variable "db_version" {
  description = "Версия MySQL"
  type        = string
  default     = "8.0"
}

variable "db_resource_preset" {
  description = "Тип хоста (например, s2.micro)"
  type        = string
  default     = "s2.micro"
}

variable "db_disk_type" {
  description = "Тип диска для БД (network-ssd)"
  type        = string
  default     = "network-ssd"
}

variable "db_disk_size" {
  description = "Размер диска БД (ГБ)"
  type        = number
  default     = 16
}

variable "db_name" {
  description = "Имя базы данных"
  type        = string
  default     = "mydb"
}

variable "db_user" {
  description = "Имя пользователя БД"
  type        = string
  default     = "myuser"
}

variable "db_password" {
  description = "Пароль пользователя БД"
  type        = string
  sensitive   = true
  default     = "CHANGE_ME_PASSWORD"
}

variable "db_high_availability" {
  description = "Включить второй хост в другой зоне"
  type        = bool
  default     = false
}

variable "db_second_zone" {
  description = "Вторая зона для HA"
  type        = string
  default     = "ru-central1-b"
}

# Container Registry
variable "registry_name" {
  description = "Имя реестра"
  type        = string
  default     = "my-registry"
}

variable "repository_name" {
  description = "Имя репозитория"
  type        = string
  default     = "my-app"
}



#deploy

variable "vm_ip" {
  description = "Публичный IP ВМ"
  type        = string
}

variable "registry_id" {
  description = "ID Container Registry"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Путь к приватному SSH-ключу"
  type        = string
  default     = ""
}

variable "db_port" {
  description = "Порт MySQL"
  type        = number
  default     = 3306
}

variable "db_host" {
  description = "FQDN хоста MySQL"
  type        = string
}