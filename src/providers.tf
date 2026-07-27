terraform {
  required_version = ">= 1.12.0, < 2.0.0"
 required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
    local = {
      source  = "hashicorp/local"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
  service_account_key_file = file(var.service_account_key_file)

}

provider "local" {}
