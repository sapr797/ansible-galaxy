#!/bin/bash
echo "Testing Ansible inventory..."
echo ""

echo "1. All hosts in production:"
ansible-inventory -i inventory/production/hosts --list

echo ""
echo "2. Testing connectivity:"
ansible all -i inventory/production/hosts -m ping

echo ""
echo "3. Checking host facts:"
ansible all -i inventory/production/hosts -m setup -a 'gather_subset=min'
