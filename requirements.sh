#!/bin/bash
replace() {
        
    read -p "Proxmox API ID: " proxmox_api_id
    read -p "Proxmox API TOKEN: " proxmox_api_token
    read -p "Proxmox IP: " proxmox_node_ip
    read -p "Proxmox Node Name: " proxmox_node_name

    find . -type f ! -name "requirements.sh" -exec sed -i \
        -e "s/<proxmox_api_id>/$proxmox_api_id/g" \
        -e "s/<proxmox_api_token>/$proxmox_api_token/g" \
        -e "s/<proxmox_node_ip>/$proxmox_node_ip/g" \
        -e "s/<proxmox_node_name>/$proxmox_node_name/g" {} +

    find ./packer -type f -name "example.auto.pkrvars.hcl.txt" -exec bash -c \
        'mv "$0" "${0/example.auto.pkrvars.hcl.txt/value.auto.pkrvars.hcl}"' {} \;

    find ./terraform -type f -name "example-terraform.tfvars.txt" -exec bash -c \
        'mv "$0" "${0/example-terraform.tfvars.txt/terraform.tfvars}"' {} \;

}

requirements(){
    
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

    sudo apt update -qq
    sudo apt install -qq -y python3 python3-pip unzip mkisofs sshpass terraform packer

    # ansible 
    pip3 install ansible pywinrm jmespath
    ansible-galaxy collection install community.windows

    # terraform binary
    #wget https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip
    #unzip -q terraform_1.5.6_linux_amd64.zip -d binary/
    #sudo mv binary/terraform /usr/local/bin/
    #rm terraform_1.5.6_linux_amd64.zip

    # packer binary
    #wget https://releases.hashicorp.com/packer/1.9.4/packer_1.9.4_linux_amd64.zip
    #unzip -q packer_1.9.4_linux_amd64.zip -d binary/
    #sudo mv binary/packer /usr/local/bin/
    #rm packer_1.9.4_linux_amd64.zip

}

replace
requirements

echo "[+] run the task_templating.sh in packer/"