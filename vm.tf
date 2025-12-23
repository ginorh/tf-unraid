resource "libvirt_domain" "domain-vm-tst" {
  name                = var.vm_name
  memory              = var.vm_memory
  memory_unit         = "MiB"
  vcpu                = var.vm_vcpu
  cpu                 = {
    mode              = "host-passthrough"
  }
  type                = "kvm"
  features            = {
    acpi              = true
  }
  running             = true
  metadata            = {
    xml               = "<vmtemplate xmlns='http://unraid' name='Ubuntu' iconold='ubuntu.png' icon='ubuntu.png' os='ubuntu' webui='' storage='default'/>"
  }
  os                  = {
    type              = "hvm"
    type_arch         = "x86_64"
    type_machine      = "q35"
  }
  depends_on = [ libvirt_volume.vm_disk ]

  devices             = {
    disks             = [
      {
        driver        = {
            type      = "qcow2"
          }
        source        = {

          volume      = {
            pool      = libvirt_volume.vm_disk.pool
            volume    = libvirt_volume.vm_disk.name
          }
        }
        target        = {
          dev         = "vda"
          bus         = "virtio" 
        }
      },
      {
        device        = "cdrom"
        source        = {
          volume      = {
            pool      = libvirt_volume.cloudinit.pool
            volume    = libvirt_volume.cloudinit.name
          }
        }
        target        = {
          dev         = "sdb"
          bus         = "sata" 
        }
      }
    ]
    interfaces = [
      {
        model           = {
          type          = "virtio-net"
        }
        source          = {
          bridge        = {
            bridge      = var.network_interface
          }
        }
        wait_for_ip     = {
         source        = "agent" # "lease" or "agent" or "any"
         #  timeout       = 300  # seconds
        }
      }
    ]
    graphics            = [
      {
        spice           = {
          auto_port     = true
        }
      }
    ]
    videos              = [
      {
        model           = {
          heads         = 1
          primary       = "yes"
          ram           = 65536
          type          = "qxl"
          vram          = 16384
          vga_mem       = 16384
        }
      }
    ]
    # IMPORTANT: this is a known bug on cloud images, since they expect a console
    # we need to pass it
    # https://bugs.launchpad.net/cloud-images/+bug/1573095
    consoles            = [{}]

    # enabled the channel for the qemu-guest-agent systemd service.
    channels            = [
      {
        source          = {
          unix          = {
            mode        = "bind"
          }
        }
        target          = {
            virt_io     = {
              name      = "org.qemu.guest_agent.0"
            }
          }
        }
    ]
  }
}
