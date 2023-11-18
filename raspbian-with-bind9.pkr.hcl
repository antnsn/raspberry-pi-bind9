
variable "raspberry_pi_version" {
    default = "64bit"
  }
  
  variable "bind9_install" {
    default = true
  }


build {
  name = "raspbian-bind9"  
  source "arm" "raspberry_pi_image" {
    file_urls = [
      "https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64-lite.img.xz",
    ]
  
    file_checksum_url     = "https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2023-10-10/2023-10-10-raspios-bookworm-arm64-lite.img.xz.sha256"
    file_checksum_type    = "sha256"
    file_target_extension = "xz"
  
    image_build_method = "reuse"
    image_path         = "raspberry-pi.img"
    image_size         = "2G"
    image_type         = "dos"
  
    image_partitions = [
      {
        name        = "boot"
        type        = "c"
        start_sector = 8192
        filesystem  = "vfat"
        size        = "256M"
        mountpoint  = "/boot"
      },
      {
        name        = "root"
        type        = "83"
        start_sector = 532480
        filesystem  = "ext4"
        size        = "0"
        mountpoint  = "/"
      },
    ]
  
    image_chroot_env = [
      "PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin",
    ]
  
    qemu_binary_source_path      = "/usr/bin/qemu-arm-static"
    qemu_binary_destination_path = "/usr/bin/qemu-arm-static"
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
