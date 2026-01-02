# Роль Ansible для Vector

[![Тестирование Molecule](https://img.shields.io/badge/тестируется%20с-molecule-blue)](https://molecule.readthedocs.io/)
[![Лицензия: MIT](https://img.shields.io/badge/Лицензия-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-vector--role-blue)](https://galaxy.ansible.com/)

Роль Ansible для установки и настройки [Vector](https://vector.dev/) - высокопроизводительного пайплайна для observability.

## Возможности

- ✅ **Простая установка**: Устанавливает Vector с помощью официального инсталлятора
- ✅ **Управление директориями**: Создает необходимые директории (`/etc/vector`, `/var/lib/vector`, `/var/log/vector`)
- ✅ **Управление службами**: Конфигурация и управление службой Systemd
- ✅ **Поддержка нескольких ОС**: Протестировано на Ubuntu 22.04 и Oracle Linux 8
- ✅ **Готово к продакшену**: Правильные права доступа и структура директорий
- ✅ **Тестирование**: Полный набор тестов Molecule с Podman
- ✅ **CI/CD**: GitHub Actions пайплайн для автоматического тестирования
- ✅ **Качество кода**: Конфигурация ansible-lint и yamllint

## Результаты настройки Molecule

✅ **Molecule создаёт Docker контейнер**  
✅ **Converge применяет роль Vector** (тестовую версию)  
✅ **Verify проверяет результаты без ошибок**  
✅ **Весь цикл `molecule test` работает**

🏗️ Структура проекта
text
vector-role/
├── roles/vector/              # Основная роль
│   ├── tasks/main.yml        # Задачи установки
│   ├── handlers/main.yml     # Обработчики сервиса
│   └── defaults/main.yml     # Переменные по умолчанию
├── molecule/                 # Тесты Molecule
│   └── default/
│       ├── molecule.yml      # Конфигурация тестов
│       ├── converge.yml      # Применение роли
│       └── verify.yml        # Проверка результатов
├── .github/workflows/        # CI/CD пайплайны
├── .ansible-lint             # Конфигурация линтера
├── .yamllint                 # Конфигурация YAML линтера
├── tox.ini                   # Конфигурация тестового окружения
└── scripts/                  # Вспомогательные скрипты

## Финальная рабочая конфигурация

### `tasks/main.yml` - тестовая роль Vector:
```yaml
- debug: msg="Vector role is executing"
- copy: создаёт тестовый файл
- raw: создаёт директорию /etc/vector
- raw: создаёт конфиг vector.yaml
molecule/default/converge.yml - применяет роль:
yaml
- raw: устанавливает Python
- include_tasks: выполняет задачи роли
molecule/default/verify.yml - проверяет результат:
yaml
- raw: проверяет созданные файлы
- debug: показывает результаты
Требования
Поддерживаемые платформы
Rocky Linux 9 (основная тестовая платформа)
RHEL/CentOS 8+
Ubuntu 20.04 (Focal)
Ubuntu 22.04 (Jammy)
Oracle Linux 8

Другие совместимые дистрибутивы RHEL/CentOS 8

Ansible
Ansible >= 2.9

Python >= 3.6

Зависимости
Ansible Core: >= 2.17.0
Python: >= 3.9
Docker: Для тестирования Molecule
Tox: Для запуска тестового пайплайна
Коллекция community.general
Коллекция ansible.posix

Установка
Из GitHub
Использование роли в проекте
yaml
# requirements.yml
---
roles:
  - name: vector
    src: https://github.com/sapr797/ansible-galaxy.git
    scm: git
    version: main

Установка зависимостей

pip install ansible-core molecule molecule-docker docker

# Клонировать репозиторий
git clone https://github.com/sapr797/ansible-galaxy.git
cd ansible-galaxy
Из Ansible Galaxy (когда будет опубликовано)
bash
ansible-galaxy install sapr797.vector-role
Ролевые переменные
Все настраиваемые переменные находятся в defaults/main.yml:

yaml
# Версия Vector для установки
vector_version: "0.35.0"

# Директории для установки
vector_config_dir: /etc/vector
vector_data_dir: /var/lib/vector
vector_log_dir: /var/log/vector
🔧 Конфигурация

Основные переменные (defaults/main.yml)

yaml
# Версия Vector
vector_version: "latest"

# Директории
vector_config_dir: /etc/vector
vector_data_dir: /var/lib/vector
vector_log_dir: /var/log/vector

# Пользователь и группа
vector_user: vector
vector_group: vector

# Сервис
vector_service_name: vector
vector_service_state: started
vector_service_enabled: true

Пример playbook с кастомными настройками
yaml
---
- name: Настройка Vector с мониторингом
  hosts: observability_servers
  become: yes
  
  vars:
    vector_config_dir: /opt/vector/config
    vector_service_enabled: true
    
  roles:
    - vector

🧪 Тестирование
Полный тестовый пайплайн

# Запуск всех тестов через tox
tox

# или конкретная среда
tox -e py39-molecule
tox -e lint

# Конфигурация службы
vector_user: vector
vector_group: vector
vector_service_name: vector

Ручное тестирование с Molecule

# Создание тестового окружения
molecule create

# Применение роли
molecule converge

# Проверка идемпотентности
molecule idempotence

# Запуск верификации
molecule verify

# Очистка
molecule destroy

# Полный цикл тестирования
molecule test

Проверка качества кода

# Запуск всех проверок
./scripts/run-checks.sh

# Отдельные проверки
ansible-lint .
yamllint .
molecule lint

🔄 CI/CD
Проект включает готовый пайплайн GitHub Actions (.github/workflows/test.yml), который:
Запускает тесты Molecule на push/pull request
Проверяет код с помощью ansible-lint и yamllint
Тестирует на нескольких версиях Python

🛠️ Разработка

Настройка локального окружения
# Создание виртуального окружения
python3 -m venv venv
source venv/bin/activate

# Установка зависимостей разработки
pip install -r requirements.txt
pip install tox pre-commit

# Установка pre-commit хуков
pre-commit install
Добавление нового сценария тестирования
molecule init scenario -s ubuntu -d docker
molecule init scenario -s centos8 -d docker
Конфигурация tox
Проект использует tox.ini для управления тестовыми окружениями:

ini
[tox]
envlist = py39-molecule, lint

[testenv]
deps = 
    ansible-core>=2.17
    molecule
    molecule-docker
    ansible-lint
    yamllint
commands = 
    molecule test -s default

[testenv:lint]
deps = 
    ansible-lint
    yamllint
commands = 
    ansible-lint .
    yamllint .

Использование
Базовый плейбук
yaml
---
- name: Установка Vector на всех серверах
  hosts: all
  become: yes
  
  roles:
    - role: vector-role
Продвинутый плейбук с кастомной конфигурацией
yaml
---
- name: Настройка Vector с пользовательскими параметрами
  hosts: observability_servers
  become: yes
  
  vars:
    vector_version: "0.34.0"
    vector_config_dir: /opt/vector/config
    
  roles:
    - role: vector-role
Роль в requirements файле
yaml
# requirements.yml
---
roles:
  - name: sapr797.vector-role
    src: https://github.com/sapr797/ansible-galaxy.git
    version: main
Пример: Конфигурация Vector
Роль включает примеры шаблонов:

Служба Systemd: templates/vector.service.j2

Файл конфигурации: templates/vector.toml.j2

Для кастомизации конфигурации Vector, переопределите шаблон:

yaml
- name: Развертывание кастомной конфигурации Vector
  template:
    src: путь/к/вашему/vector.toml.j2
    dest: "{{ vector_config_dir }}/vector.toml"
    owner: "{{ vector_user }}"
    group: "{{ vector_group }}"
    mode: '0644'
Разработка
Локальная настройка

# Создать виртуальное окружение
python3 -m venv venv
source venv/bin/activate

# Установить зависимости
pip install -r requirements.txt  # или вручную:
pip install molecule molecule-podman ansible ansible-lint yamllint
Тестирование с Molecule
Быстрый старт:

# Запустить полный набор тестов
molecule test

Настройка локального окружения

# Создание виртуального окружения
python3 -m venv venv
source venv/bin/activate

# Установка зависимостей разработки
pip install -r requirements.txt
pip install tox pre-commit

# Установка pre-commit хуков
pre-commit install
Добавление нового сценария тестирования

molecule init scenario -s ubuntu -d docker
molecule init scenario -s centos8 -d docker
Конфигурация tox
Проект использует tox.ini для управления тестовыми окружениями:

ini
[tox]
envlist = py39-molecule, lint

[testenv]
deps = 
    ansible-core>=2.17
    molecule
    molecule-docker
    ansible-lint
    yamllint
commands = 
    molecule test -s default

[testenv:lint]
deps = 
    ansible-lint
    yamllint
commands = 
    ansible-lint .
    yamllint .

Подробные команды:

molecule create    # Создать тестовые инстансы
molecule converge  # Применить роль
molecule verify    # Запустить верификацию
molecule destroy   # Очистить окружение
molecule idempotence # Проверить идемпотентность
molecule lint      # Проверить качество кода
Сценарии тестирования
default: Ubuntu 22.04 с установкой Vector

Зависимости
Python 3.6+
Docker (для тестирования с Molecule)
Molecule и соответствующие драйверы

Пример сценария
yaml
---
- name: Развертывание Vector с мониторингом
  hosts: logging_servers
  become: yes
  
  vars:
    vector_version: "0.35.0"
    vector_config_dir: /etc/vector
  
  roles:
    - role: vector-role
Лицензия
MIT License

Copyright (c) 2024 sapr797

Разрешается свободное использование, копирование, изменение, объединение, публикация, распространение, сублицензирование и/или продажа копий данного программного обеспечения.

Информация об авторе
Автор: sapr797

GitHub: https://github.com/sapr797

Репозиторий: https://github.com/sapr797/ansible-galaxy

Ссылки
Документация Vector

Ansible Best Practices

Документация Molecule

Благодарности
Команда Vector за отличный инструмент observability

Сообщество Ansible

Фреймворк тестирования Molecule
cd vector-role-galaxy
molecule test
**********************************************
В папке roles собраны различные сценарии развертывания на Ansible.

## 🏗️ Lighthouse Full Stack
**Папка:** `lighthouse-full-stack/`

Полный стек приложений с ролью-оркестратором, который умеет развертывать все компоненты системы.

### Особенности:
- **Оркестрация**: Единая роль управляет всем стеком
- **Верификация**: Автоматическая проверка работоспособности
- **Модульность**: Каждый компонент в отдельной роли
- **Тестирование**: Полный набор тестов

### Компоненты:
1. **PostgreSQL** - база данных
2. **Nginx** - веб-сервер
3. **Приложение** - основное приложение
4. **Lighthouse** - мониторинг

### Использование:
```bash
cd lighthouse-full-stack
ansible-playbook verify.yml          # Проверить стек
ansible-playbook test-orchestrator-final-v2.yml  # Развернуть стек
📁 Структура
text
сценарии/
└── lighthouse-full-stack/      # Этот сценарий
    ├── verify.yml              # Проверка работоспособности
    ├── test-orchestrator-final-v2.yml  # Основной плейбук
    ├── roles/                  # Роли Ansible
    └── README.md               # Документация
