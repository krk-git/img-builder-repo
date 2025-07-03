# Default ARM64-based Unix/Linux customization packer script.

variable project_id {
  type = string
  default = ""
}

variable source_image {
  type = string
  default = ""
}

variable zone {
  type = string
  default = ""
}

variable target_image_name {
  type = string
  default = ""
}

variable target_image_description {
  type = string
  default = ""
}

variable target_image_region {
  type = string
  default = ""
}

variable target_image_encryption_key {
  type = string
  default = ""
}

variable target_image_labels {
  type = map(string)
  default = {}
}

packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.6"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "imagebuilder" {
  project_id              = var.project_id
  source_image            = var.source_image
  zone                    = var.zone
  machine_type            = "c4a-standard-4"
  disk_type               = "hyperdisk-balanced"
  disk_size               = 50
  image_name              = var.target_image_name
  image_description       = var.target_image_description
  image_storage_locations = [var.target_image_region]
  image_labels            = var.target_image_labels
  use_iap                 = true
  image_encryption_key {
    kmsKeyName            = var.target_image_encryption_key
  }
  disk_encryption_key {
    kmsKeyName            = var.target_image_encryption_key
  }
  ssh_username            = "image-builder"
}

build {
  sources = ["sources.googlecompute.imagebuilder"]
}
