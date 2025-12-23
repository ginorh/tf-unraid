#
resource "libvirt_pool" "tf_pool" {
  name        = "tf_pool"
  type        = "dir"
  target      = {
    type      = "dir"
    path      = var.tf_pool_path
    permissions     = {
        mode        = "0755"
    }
  }
}

resource "libvirt_volume" "base_image_disk" {
  name            = "base_image.qcow2"
  pool            = libvirt_pool.tf_pool.name
  depends_on      = [ libvirt_pool.tf_pool ]
  target          = {
    format        = {
      type        = "qcow2"
    }
  }
  create          = {
    content       = {
        url       = var.img_url_path
        target    = {
          format  = {
            type  = "qcow2"
          }
        }
    }
  }
}

resource "libvirt_volume" "vm_disk" {
  name            = "${var.vm_name}.qcow2"
  pool            = libvirt_pool.tf_pool.name
  capacity        = var.vm_disk_size
  depends_on      = [ libvirt_volume.base_image_disk ]
  target          = {
    format        = {
      type        = "qcow2"
    }
  }
  backing_store   = {
    path          = libvirt_volume.base_image_disk.path
      format      = {
        type      = "qcow2"
      }
  }
}
