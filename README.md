# TF Unraid

## Description

Deploy VMs on your Unraid server using OpenTofu or Terraform.
This deployment will create a separate directory to deploy your tf vms to and [cloudinit](https://cloudinit.readthedocs.io/en/latest/index.html) to partially configure them. (I have manually deployed vms too so adding them to a separate directory)

Cloudinit configures a static IP and installed qemu-quest-agent too.

Thanks to [mcreekmore](https://github.com/mcreekmore/unraid-terraform) and [chrisreeves](https://github.com/chrisreeves-/scripts/blob/master/terraform/unraid) for the pointers.

Hope this helps someone...


## Requirements
1. Unraid server with VM enabled (Libvirt)
2. Libvirt listening on 0.0.0.0
3. Opentofu or Terraform. (I've tested with OpenTofu v1.11.1)
4. Libvirt provider [dmacvicar/libvirt](https://search.opentofu.org/provider/dmacvicar/libvirt/latest) (I've tested on version 0.9.1)
5. Hope I didn't miss anything

## Optional
1. Install [direnv](https://direnv.net/) to help with environment variables. See below for an example


## Change Libvirt Listen Address
1. Use your favorite command line editor to open `/etc/libvirt/libvirtd.conf` on the Unraid host
2. Search for `listen_addr = "127.0.0.1"`
3. Change to `listen_addr = "0.0.0.0"`
   
```bash
# Override the default configuration which binds to all network
# interfaces. This can be a numeric IPv4/6 address, or hostname
#
# This setting is not required or honoured if using systemd socket
# activation.
#
# If the libvirtd service is started in parallel with network
# startup (e.g. with systemd), binding to addresses other than
# the wildcards (0.0.0.0/::) might not be available yet.
#
#listen_addr = "127.0.0.1"
# limetech - uncommented
listen_addr = "0.0.0.0"
```

### direnv

[Direnv](https://direnv.net/) allows your to load environment variables when you `cd` to a directory which has a `.envrc` file in it. It then unloads the environment variables with you exit the directory. This allows you to manage your environment variables a lot easier with less typing.

1. Install direnv
2. Create a `.envrc` file in your project directory and populate it with your variables:
```bash
export LIBVIRT_DEFAULT_URI="qemu+sshcmd://admin-user@unraid.server/system"
export TF_VAR_user_pw="ChangeMe1!"
```
3. `cd` to your project directory and you should recieve an error stating direnv is blocked
4. Type `direnv allow` and your variables should load as seen below.

```bash
direnv: error /path/to/terraform/project/unraid-vm/.envrc is blocked. Run `direnv allow` to approve its content
me@mymac /path/to/terraform/project/unraid-vm $ direnv allow
direnv: loading /path/to/terraform/project/unraid-vm/.envrc
direnv: export +LIBVIRT_DEFAULT_URI +TF_VAR_user_pw
```

## Config

I've tried to keep all variable changes needed, in the `terraform.tfvars` file except for the libvirt connection uri and user password which I've added to the .envrc file.

Make necessary changes to your `terraform.tfvars` file.
The variable names are pretty self explanatory and a comment to add addtional information.


### Note
1. If your `cloud-init.tftpl` has a variable with sensitive data like
```bash
variable "user_pw" {
  type        = string
  sensitive   = true
}
```
You will see `+ user_data      = (sensitive value)` in your plan

2. I've had an issue with network config where having the interface name anything but what it will be on the caused it to not set the IP.
I've attemtped match rules but none worked. Will delve into that section at some point.
You may need to bring up a vm, check what the network interface name is and name it accordingly in your `cloud_network_config.tftpl`


## Deploying your VM
```bash
# cd to your tf directory

# initialize your td project state
tofu init

# prints the plan where you can see what about to be deloyed
# This plan outputs to a file named tfplan too
tofu plan -out tfplan

# apply the plan which avoids needing to type 'yes'
tofu apply tfplan
```

Depending on your Unraid server resource usage it will take few minutes to complete

To remove the VM you created with tf you will need to `destroy` it (or remove it manually) and type 'yes' to confirm.

```bash
# Make sure you are in the correct TF project
tofu destroy
```
## NB
Please **DO NOT** commit your `terraform.tfstate` or `terraform.tfstate.backup` file to a version control. Add them to your `.gitignore` along with the `terraform.tfvars` file if it has sensitive data. 