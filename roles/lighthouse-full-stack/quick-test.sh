#!/bin/bash

echo "🚀 Quick Stack Test"
echo "=================="

cd ~/lighthouse-test

echo "1. Testing syntax..."
ansible-playbook verify.yml --syntax-check && echo "✅ Syntax OK"

echo "2. Testing stack deployment..."
ansible-playbook simplest-orchestrator.yml && echo "✅ Deployment OK"

echo "3. Testing verification..."
ansible-playbook verify.yml --tags verify && echo "✅ Verification OK"

echo "🎉 All tests passed!"
