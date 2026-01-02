#!/bin/bash

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_step() {
    echo -e "\n${GREEN}=== $1 ===${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Проверка аргументов
ENV=${1:-"staging"}
ACTION=${2:-"deploy"}
COMPONENT=${3:-"all"}

case $ACTION in
    deploy)
        PLAYBOOK="deploy-full-stack.yml"
        ;;
    validate)
        PLAYBOOK="validate-stack.yml"
        ;;
    destroy)
        PLAYBOOK="destroy-stack.yml"
        ;;
    rollback)
        PLAYBOOK="rollback-stack.yml"
        ;;
    *)
        print_error "Unknown action: $ACTION"
        exit 1
        ;;
esac

print_step "Starting stack $ACTION for environment: $ENV"

# Проверка наличия Ansible
if ! command -v ansible-playbook &> /dev/null; then
    print_error "Ansible is not installed!"
    exit 1
fi

# Экспорт переменных
export ANSIBLE_CONFIG="$(pwd)/ansible.cfg"
export ANSIBLE_FORCE_COLOR=true

# Параметры запуска
ANSIBLE_ARGS=""
ANSIBLE_ARGS+=" -e stack_name=myapp-$ENV"
ANSIBLE_ARGS+=" -e deploy_env=$ENV"
ANSIBLE_ARGS+=" -i inventory/$ENV"

# Если есть Vault
if [ -f "vault-password.txt" ]; then
    ANSIBLE_ARGS+=" --vault-password-file vault-password.txt"
fi

# Если указан конкретный компонент
if [ "$COMPONENT" != "all" ]; then
    ANSIBLE_ARGS+=" --tags $COMPONENT"
    print_warning "Deploying only component: $COMPONENT"
fi

# Запуск Ansible
print_step "Executing: ansible-playbook $PLAYBOOK $ANSIBLE_ARGS"
ansible-playbook $PLAYBOOK $ANSIBLE_ARGS

if [ $? -eq 0 ]; then
    print_success "Stack $ACTION completed successfully!"
    
    # Дополнительные проверки
    if [ "$ACTION" == "deploy" ]; then
        print_step "Running post-deployment checks..."
        ansible $ANSIBLE_ARGS -m ping all
    fi
else
    print_error "Stack $ACTION failed!"
    exit 1
fi
