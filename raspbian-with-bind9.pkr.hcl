locals {
  iso_url = "https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64-lite.img.xz"
  iso_checksum_type = "sha256"
  iso_checksum = "26ef887212da53d31422b7e7ae3dbc3e21d09f996e69cbb44cc2edf9e8c3a5c9"
  target_image_size = 456130560
}

build {
  name = "raspbian-bind9"  
  source "arm-image" {
    iso_url           = local.iso_url
    iso_checksum_type = local.iso_checksum_type
    iso_checksum      = local.iso_checksum
    target_image_size = local.target_image_size
  }

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


