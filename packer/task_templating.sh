#!/bin/bash
START_PATH=$(pwd)

autounattend_iso(){

    for directory in $(ls | grep win); do
        cd $directory
        mkisofs -J -l -R -V "Autounattend" \
                -iso-level 4 \
                -o "Autounattend-$directory.iso" \
                autounattend.xml
        cd ..
    done
    
    read -p "--- [!] need to upload all the win*/Autounattend-*.iso file inside proxmox ISO storage. [press enter to continue]" rsp
}

create_templates(){

    for directory in $(ls -d */); do
        cd $directory
        packer init .
        echo "[+] building template in: $(pwd)"
        packer build .
        cd ..
    done;
    
}

autounattend_iso
create_templates

echo "[+] run the task_terraforming.sh in terraform/"