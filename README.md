# Automated AD Training Lab
This is a simple way to deploy a ~~minimal active directory lab~~ vulnerable active directory environment on Proxmox.

*just another automated Active Directory lab and a little bit more*

### Why another automated lab?

- I am always looking for new technologies to learn, and this one has caught my attention and satisfied my curiosity the most. The possibilities that this technology offers are endless, so... *why not?*

- Usually I spend time developing active directory lab environment to test, understand and evaluate actions related to red teaming stuff (or whatever). Since I like automating everything I decided to focus more on creating a fully automated and potentially scalable solution... ready to welcome your implants and log your actions.

*seriously, I just want to learn packer + terraform + ansible stuff*

### A word before you begin
I've discovered that creating a lab like this is more useful to others than just to myself. This consideration inspired me to spend time defining some basic attack paths to help beginners understand how to use a C2 and their functionalities while playing with some Active Directory stuff... without spending money.

I'm not aiming to emulate the perfection of the Prolabs by Hack The Box or all the beatifull scenario out there in this magic world. Instead, this lab is meant to be straightforward and accessible **for newcomers**.

If you want something like this but **way much better**:

- [GOAD](https://github.com/Orange-Cyberdefense/GOAD)

or... use your money :sweat_smile:

- [All the HackTheBox Prolabs!](https://www.hackthebox.com/hacker/pro-labs)
- [SlayerLab](https://slayerlabs.com/)
- [VulnLab](https://www.vulnlab.com/)

## Getting started
### Prerequisite
1. a Proxmox server
2. sufficient space on `local-lvm` (~200GB)
3. define privileges and create API token
```bash
# run on proxmox server shell
pveum role add provisioner -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Pool.Audit SDN.Use Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Console VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
pveum user add userprovisioner@pve
pveum aclmod / -user userprovisioner@pve -role provisioner
pveum user token add userprovisioner@pve provisioner-token --privsep=0
pveum aclmod /storage/local --user userprovisioner@pve --role PVEDatastoreAdmin --token userprovisioner@pve\!provisioner-token
```
**you have to save the output somewhere, you need this!**

### Deploy
1. Create a VM (ubuntu-desktop) inside your Proxmox hosts and ssh into it
2. `git clone <repo>` 
3. `cd ad-training-lab`
4. `cp env.example .env && nano .env` fill with apitoken and proxmox ip!
5. `chmod +x requirements.sh packer/task_templating.sh terraform/task_terraforming.sh && sudo ./requirements.sh`
6. then run the `task_templating.sh` script inside `packer/`
7. and `task_terraforming.sh` script in `terraform/`
8. finally, inside `ansible/` run `ansible-playbook main.yml`
9. Enjoy :crossed_fingers:

*BONUS: check the files and modify network or storage name if needed.
The lab is currently deployed on storage **local-lvm** and network bridge **vmbr1**.*

## Lab Overview

### Infrastructure
The infrastructure is designed to be simple and use few resources, you can add as many VMs per "type" as you like, or increase the complexity of the environment by duplicating VMs and trusting DCs (?).

- **Monitoring Server:** Ubuntu-based server with docker, docker-compose and **wazuh-docker** deployed.

- **DC**: Windows Server 2019 with AD roles installed.

- **ADCS:** Windows Server 2019 server with ADCS role installed.

- **FS:** Windows Server 2019 server with FS-FileServer role installed.

- **WEB:** Windows Server 2019 server with IIS Installed

- **WS1 & WS2:** Windows 10 Enterprise LTSC workstations.

***Obviously it's not intended to be a SAFE environment.***

### Credentials
Below are the credentials used in the environment:

| Resources            | Username      | Password              | Note                  |
|----------------------|---------------|-----------------------|-----------------------|
| Monitoring Server    | ubuntu        | ubuntu                |                       |
| Wazuh Web Interface  | admin         | SecretPassword        |                       |
| Domain Administrator | Administrator | DomainAdminPassword.  |                       |
| Provision User       | provision     | ProvisionPassword.    |                       |

**You can start your journey logging in with: RED\jacktest -> Password1!**

*you can also change domain_name variable in ansible/inventory/group_vars/all.yml*

## TODO
- [x] remove the manually-iso-uploads part.
- [x] i know, the ansible part needs some improvement, i'm working on it.
- [x] let packer do the iso downloading with the iso_url option
- [x] convert ansible tasks using *microsoft.ad* ansible collection
- [x] add ADCS template and basic ansible configuration
- [ ] implement some basic ESCx
- [ ] move monitoring on elk + elastic_agent (?)
- [x] add user simulation ([GHOSTS](https://github.com/cmu-sei/GHOSTS) or similar).

## Acknowledgments
- [Packer Plugin for Windows Update](https://github.com/rgl/packer-plugin-windows-update): An indispensable plugin for managing the operating system update before creating the template.
- [SecLab by mttaggart](https://github.com/mttaggart/seclab): An impressive repository and a person absolutely worth following. It inspired me to create something of my own.
- [packer-windows by StefanScherer](https://github.com/StefanScherer/packer-windows): packer + windows = StefanScherer repo.
- [vulnerable-AD by WazeHell](https://github.com/WazeHell/vulnerable-AD): This script defines vulnerabilities and misconfigurations in an Active Directory environment, just perfect.

Thank you to the creators and contributors of these projects for their invaluable resources and inspiration.
