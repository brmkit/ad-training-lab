export LUDUSRANGENUMBER=$(ludus range list --json | jq '.rangeNumber')
sed -i "s/LUDUSRANGENUMBER/$LUDUSRANGENUMBER/g" hosts.yml
cp hosts.yml ../ansible/inventory/hosts.yml

cd ../ansible
ansible-playbook main.yml
