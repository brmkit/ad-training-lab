#!/bin/bash

replace() {
        
    source .env

    find . -type f ! -name "requirements.sh" -exec sed -i \
        -e "s/<proxmox_api_id>/$PROXMOX_API_ID/g" \
        -e "s/<proxmox_api_token>/$PROXMOX_API_TOKEN/g" \
        -e "s/<proxmox_node_ip>/$PROXMOX_NODE_IP/g" \
        -e "s/<proxmox_node_name>/$PROXMOX_NODE_NAME/g" {} +

    find ./packer -type f -name "example.auto.pkrvars.hcl.txt" -exec bash -c \
        'mv "$0" "${0/example.auto.pkrvars.hcl.txt/value.auto.pkrvars.hcl}"' {} \;

    find ./terraform -type f -name "example-terraform.tfvars.txt" -exec bash -c \
        'mv "$0" "${0/example-terraform.tfvars.txt/terraform.tfvars}"' {} \;

}

requirements(){
    
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update -qq
    sudo apt install -qq -y python3 python3-pip unzip mkisofs sshpass terraform packer mono-complete

    pip3 install ansible pywinrm jmespath
    ansible-galaxy collection install community.windows

}

replace
requirements
chmod +x packer/task_templating.sh
chmod +x terraform/task_terraforming.sh

echo "[+] run the task_templating.sh in packer/"