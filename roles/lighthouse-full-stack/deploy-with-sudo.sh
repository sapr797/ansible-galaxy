#!/bin/bash

set -e

echo "🔧 Ansible Stack Deployer with SUDO"
echo "==================================="

# Проверяем можем ли мы использовать sudo
if ! sudo -n true 2>/dev/null; then
    echo "🔐 Требуется пароль sudo для пользователя $(whoami)"
    read -s -p "Введите пароль sudo: " SUDO_PASS
    echo
    export ANSIBLE_BECOME_PASSWORD="$SUDO_PASS"
fi

# Плейбук для запуска
PLAYBOOK="test-full-fixed.yml"
if [ ! -f "$PLAYBOOK" ]; then
    PLAYBOOK="final-stack-deploy-fixed.yml"
fi

echo "📄 Используем плейбук: $PLAYBOOK"

# Проверка синтаксиса
echo "🔍 Проверка синтаксиса..."
ansible-playbook "$PLAYBOOK" --syntax-check

# Запуск
if [ -n "$ANSIBLE_BECOME_PASSWORD" ]; then
    echo "🚀 Запуск с паролем sudo..."
    ansible-playbook "$PLAYBOOK" \
        --become \
        --extra-vars "ansible_become_password=$ANSIBLE_BECOME_PASSWORD"
else
    echo "🚀 Запуск с кэшированным sudo..."
    ansible-playbook "$PLAYBOOK" --become
fi

echo "✅ Развертывание завершено!"
