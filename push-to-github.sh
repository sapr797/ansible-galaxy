#!/bin/bash
# Скрипт для отправки изменений на GitHub по SSH

set -e

echo "=== Настройка SSH и отправка на GitHub ==="

# Проверка SSH ключа
if [ ! -f ~/.ssh/id_ed25519 ] && [ ! -f ~/.ssh/id_rsa ]; then
    echo "❌ SSH ключ не найден!"
    echo "Создайте ключ: ssh-keygen -t ed25519 -C 'your_email@example.com'"
    exit 1
fi

# Запуск SSH агента
eval "$(ssh-agent -s)" > /dev/null 2>&1

# Добавление ключа
if [ -f ~/.ssh/id_ed25519 ]; then
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
elif [ -f ~/.ssh/id_rsa ]; then
    ssh-add ~/.ssh/id_rsa 2>/dev/null
fi

# Проверка подключения к GitHub
echo "Проверка подключения к GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH подключение к GitHub работает"
else
    echo "❌ Проблема с SSH подключением"
    echo "Добавьте публичный ключ в GitHub:"
    cat ~/.ssh/id_ed25519.pub 2>/dev/null || cat ~/.ssh/id_rsa.pub
    exit 1
fi

# Переход в директорию проекта
cd ~/lighthouse-automation/vector-role-galaxy

# Проверка изменений
if [ -n "$(git status --porcelain)" ]; then
    echo "Обнаружены изменения, коммитим..."
    git add .
    read -p "Введите сообщение коммита: " commit_message
    git commit -m "${commit_message:-Auto commit}"
fi

# Отправка изменений
echo "Отправка изменений на GitHub..."
git push origin main

# Отправка тегов
echo "Отправка тегов..."
git push origin --tags

echo "✅ Отправка завершена успешно!"
echo "📦 Репозиторий: https://github.com/sapr797/ansible-galaxy"
