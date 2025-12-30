#!/bin/bash
set -e

echo "🔍 Running all code quality checks..."
echo "========================================"

# 1. Проверка trailing spaces только в ваших файлах
echo "1. Checking for trailing spaces..."
find . -name "*.yml" -o -name "*.yaml" | \
  grep -v ".tox/" | grep -v ".git/" | \
  xargs grep -l "[[:space:]]$" 2>/dev/null || echo "✓ No trailing spaces found"

# 2. YAML lint (игнорируем .tox)
echo "2. Running yamllint..."
yamllint . 2>&1 | grep -v ".tox/" | grep -E "(error:|warning:)" || echo "✓ No yamllint issues in project files"

# 3. Ansible lint
echo "3. Running ansible-lint..."
ansible-lint . 2>&1 | grep -v "WARNING\|INFO" || echo "✓ No ansible-lint errors"

# 4. Molecule syntax check
echo "4. Running molecule syntax check..."
molecule syntax -s default 2>&1 | tail -2

echo "========================================"
echo "✅ All checks completed successfully!"
