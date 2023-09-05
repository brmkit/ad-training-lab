#!/bin/bash
START_PATH=$(pwd)

create_templates(){

    for directory in $(ls -d */); do
        cd $directory
        packer init .
        echo "[+] building template in: $(pwd)"
        packer build .
        cd ..
    done;
    
}

create_templates

echo "[+] run the task_terraforming.sh in terraform/"