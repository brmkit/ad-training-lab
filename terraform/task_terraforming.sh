#!/bin/bash

terraform init
terraform apply -auto-approve
terraform output -raw ansible_inventory > ../ansible/inventory/hosts.yml
echo "[+] run -> ansible-playbook main.yml <- inside the ansible folder!"