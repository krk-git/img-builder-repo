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
  project_id              = "ramakrishna-test"
  source_image            = "debian-11-bullseye-v20250610"
  zone                    = "us-central1-a"
  machine_type            = "e2-standard-4" # Or any other x86-64 machine type
  disk_type               = "pd-balanced"
  disk_size               = 50
  image_name              = "debian11"
  image_description       = "Custom Debian 11 image for image builder" # Or var.target_image_description
  image_storage_locations = [var.target_image_region]
  image_labels            = {
    owner = "ramakrishna"
  } # Or var.target_image_labels
  use_iap                 = true
  image_encryption_key {
    kmsKeyName            = var.target_image_encryption_key
  }
  disk_encryption_key {
    kmsKeyName            = var.target_image_encryption_key
  }
  ssh_username            = "imagebuilder"
}

build {
  sources = ["sources.googlecompute.imagebuilder"]
}