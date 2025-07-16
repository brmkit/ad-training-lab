export LUDUSRANGENUMBER=$(ludus range list --json | jq '.LUDUSRANGE')
sed -i "s/LUDUSRANGENUMBER/$LUDUSRANGENUMBER/g" inventory.yml
cp hosts.yml ../ansible/invventory/hosts.yml

cd ../ansible
ansible-playbook main.yml