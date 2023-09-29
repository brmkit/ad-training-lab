#!/bin/bash
START_PATH=$(pwd)
update_ansible_ips() {
    
    OUTPUT=$(terraform output)

    DC=$(echo "$OUTPUT" | grep "DC =" | cut -d '"' -f 2)
    FS=$(echo "$OUTPUT" | grep "FS =" | cut -d '"' -f 2)
    WS1=$(echo "$OUTPUT" | grep "WS1 =" | cut -d '"' -f 2)
    WS2=$(echo "$OUTPUT" | grep "WS2 =" | cut -d '"' -f 2)
    MONITORING=$(echo "$OUTPUT" | grep "MONITORING =" | cut -d '"' -f 2)

    cd ../ansible
    cp inventory.bak inventory.ini
    
    find . -type f ! -name "inventory.bak" -name "inventory.ini" -exec sed -i \
        -e "s/<domain_controller>/$DC/g" \
        -e "s/<workstation1>/$WS1/g" \
        -e "s/<workstation2>/$WS2/g" \
        -e "s/<monitoring_server>/$MONITORING/g" \
        -e "s/<fileserver>/$FS/g" {} +
    
    cd $START_PATH

}

terraforming(){

    terraform init
    terraform apply -auto-approve
    update_ansible_ips
}

terraforming

echo "[+] run ansible-playbook main.yml inside the ansible folder!"