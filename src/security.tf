resource "yandex_vpc_security_group" "web-sg" {
  name        = "web-sg"
  description = "Security group for web server"
  network_id  = yandex_vpc_network.develop.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description    = "Allow port ${ingress.value}"
      protocol       = "TCP"
      v4_cidr_blocks = var.trusted_cidrs
      port           = ingress.value
    }
  }

  egress {
    description    = "Allow all outgoing"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}