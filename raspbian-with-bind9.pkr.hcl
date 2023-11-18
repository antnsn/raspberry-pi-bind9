packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.10"
      source  = "github.com/hashicorp/qemu"
    }
  }
}


locals {
  iso_url = "https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64-lite.img.xz"
  iso_checksum_type = "sha256"
  iso_checksum = "26ef887212da53d31422b7e7ae3dbc3e21d09f996e69cbb44cc2edf9e8c3a5c9"
  target_image_size = 456130560
}

source "qemu" "raspberrypi_image" {
  iso_url           = local.iso_url
  iso_checksum      = local.iso_checksum
  ssh_username      = "pi"
  ssh_password      = "raspberry"
  qemu_binary       = " qemu"
}

build {
  name = "raspbian-bind9"  
  sources = ["source.qemu.raspberrypi_image"]


  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y bind9",
      "sudo systemctl enable bind9",
      "sudo systemctl start bind9",
      "sudo systemctl status bind9",
    ]
  }
  
  post-processor "manifest" {
    output = "raspbian-manifest.json"
  }
  

}


