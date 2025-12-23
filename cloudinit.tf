resource "libvirt_cloudinit_disk" "init" {
  name                  = "vm-init"
  user_data             = templatefile("${path.module}/cloud_init.tftpl", {
      hostname          = var.vm_name
      user_name         = var.user_name
      password          = var.user_pw
      ssh_key           = file("${var.ssh_public_key}")
    })
  meta_data             = yamlencode({
    local-hostname      = var.vm_name
  })
  network_config        = templatefile("${path.module}/cloud_network_config.tftpl", {
      ipv4              = var.ipv4_net_address
      ns_search_domain  = var.tf_ns_search_domain
      ns_addresses      = var.tf_ns_addresses
      ipv4_via_route    = var.tf_ipv4_via_route
    }) 
}

resource "libvirt_volume" "cloudinit" {
  name              = "vm-cloudinit.iso"
  pool              = libvirt_pool.tf_pool.name
  create            = {
    content         = {
      url           = libvirt_cloudinit_disk.init.path
      format        = "raw"
    }
  }
}