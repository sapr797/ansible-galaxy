#!/bin/bash

set -e

echo "🔧 Ansible Stack Deployer"
echo "=========================="

# Проверка Ansible
if ! command -v ansible-playbook &> /dev/null; then
    echo "❌ Ansible не установлен!"
    exit 1
fi

echo "✅ Ansible доступен: $(ansible --version | head -1)"

# Проверка текущей директории
echo "📁 Текущая директория: $(pwd)"
echo "📁 Содержимое:"
ls -la

# Выбор плейбука
PLAYBOOK=""
if [ -f "deploy-stack.yml" ]; then
    PLAYBOOK="deploy-stack.yml"
elif [ -f "playbook.yml" ]; then
    PLAYBOOK="playbook.yml"
elif [ -f "run-full-stack.yml" ]; then
    PLAYBOOK="run-full-stack.yml"
else
    echo "❌ Не найден плейбук для запуска"
    echo "   Доступные плейбуки:"
    find . -name "*.yml" -type f | grep -v ".git" || true
    exit 1
fi

echo "📄 Используем плейбук: $PLAYBOOK"

# Проверка синтаксиса
echo "🔍 Проверка синтаксиса..."
ansible-playbook $PLAYBOOK --syntax-check

# Запуск
echo "🚀 Запуск развертывания..."
ansible-playbook $PLAYBOOK $@

echo "✅ Развертывание завершено!"
