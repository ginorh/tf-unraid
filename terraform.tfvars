#
vm_name           = "vm-tst" # the name of your vm as it will be displayed in your Unraid server too
vm_memory         = "2048" # memory alloacation
vm_vcpu           = 1 # vCPUs  
vm_disk_size      = 10737418240 # 10GB
user_name         = "changeme-user" # The userame for your deployed VM
img_url_path      = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img" 
tf_pool_path      = "/mnt/user/domains/tf_deployments/tst_vm" # directory location on your unraid server 
ssh_public_key    = "~/.ssh/id_ed25519.pub" # path to your preferred public key
network_interface = "br0" # network interface
ipv4_net_address  = "10.0.0.20/16" # needs to be in CIDR notation e.g. 10.0.10.2/16
tf_ns_search_domain  = "your.domain" # name server search domain
tf_ns_addresses      = "10.0.0.1" # nameserver address
tf_ipv4_via_route    = "10.0.0.1" # default gateway
