# VPC
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}

# Подсеть
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = [var.vpc_cidr]
}

# Образ ОС
data "yandex_compute_image" "os" {
  family = var.vm_image_family
}

# Виртуальная машина
resource "yandex_compute_instance" "platform" {
  name        = var.vm_name
  platform_id = var.vm_platform
  zone        = var.default_zone

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.image_id
      size     = var.vm_disk_size
      type     = var.vm_disk_type
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web-sg.id]
  }

  metadata = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
    user-data          = templatefile("${path.module}/cloud-init.tpl", {
      packages = var.user_data_packages
      runcmd   = var.user_data_runcmd
    })
  }

  labels = var.vm_labels
}

# Управляемый кластер MySQL
resource "yandex_mdb_mysql_cluster" "my_cluster" {
  name        = var.db_cluster_name
  environment = var.db_environment
  network_id  = yandex_vpc_network.develop.id
  version     = var.db_version

  resources {
    resource_preset_id = var.db_resource_preset
    disk_type_id       = var.db_disk_type
    disk_size          = var.db_disk_size
  }

  mysql_config = {
    max_connections = 100
    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
  }

  # Первый хост (обязательный)
  host {
    zone      = var.default_zone
    subnet_id = yandex_vpc_subnet.develop.id
  }

  # Второй хост (опционально, если включена высокая доступность)
  dynamic "host" {
    for_each = var.db_high_availability ? [1] : []
    content {
      zone      = var.db_second_zone
      subnet_id = yandex_vpc_subnet.develop.id
    }
  }


  lifecycle {
    ignore_changes = all 

  }
}

# База данных
resource "yandex_mdb_mysql_database" "my_db" {
  cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = var.db_name
}

# Пользователь БД
resource "yandex_mdb_mysql_user" "my_user" {
  cluster_id = yandex_mdb_mysql_cluster.my_cluster.id
  name       = var.db_user
  password   = var.db_password

  permission {
    database_name = yandex_mdb_mysql_database.my_db.name
    roles         = ["ALL"]
  }
}

# Container Registry
resource "yandex_container_registry" "my_registry" {
  name = var.registry_name
}

resource "yandex_container_repository" "my_repository" {
  name = "${yandex_container_registry.my_registry.id}/${var.repository_name}"
}


resource "local_file" "outputs" {
  content = jsonencode({
    vm_public_ip   = yandex_compute_instance.platform.network_interface[0].nat_ip_address
    vm_private_ip  = yandex_compute_instance.platform.network_interface[0].ip_address
    db_fqdn        = yandex_mdb_mysql_cluster.my_cluster.host[0].fqdn
    db_port        = 3306
    registry_id    = yandex_container_registry.my_registry.id
    repository_name = yandex_container_repository.my_repository.name
  })
  filename = "${path.module}/terraform_outputs.json"
}