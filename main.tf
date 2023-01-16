terraform {
  required_providers {
    fly = {
      source = "fly-apps/fly"
      version = "0.0.16"
    }
  }
}

variable "project-name" {
    type    = string
    default = "flyiac-test-kitsune"
}

resource "fly_app" "exampleApp" {
  name = var.project-name
  org  = "personal"
}

resource "fly_ip" "exampleIp" {
  app        = var.project-name
  type       = "v4"
  depends_on = [fly_app.exampleApp]
}

resource "fly_ip" "exampleIpv6" {
  app        = var.project-name
  type       = "v6"
  depends_on = [fly_app.exampleApp]
}

resource "fly_machine" "exampleMachine" {
  for_each = toset(["ewr", "lax"])
  app    = var.project-name
  region = each.value
  name   = "flyiac-${each.value}"

  image  = "flyio/iac-tutorial:latest"
  services = [
    {
      ports = [
        {
          port     = 443
          handlers = ["tls", "http"]
        },
        {
          port     = 80
          handlers = ["http"]
        }
      ]
      "protocol" : "tcp",
      "internal_port" : 80
    },
  ]

  cpus = 1
  memorymb = 256

  depends_on = [fly_app.exampleApp]
}