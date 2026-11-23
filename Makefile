SHELL := /bin/bash

.PHONY: setup verify test report lint clean all

help:
	@echo "================================================================================"
	@echo " Kaggle Kaggriculture Solution Reproduction & Verification"
	@echo "================================================================================"
	@echo "  make setup     - Install dependencies"
	@echo "  make verify    - Run 1-command verification suite (bash run.sh)"
	@echo "  make test      - Verify Python AST syntax of agent and configs"
	@echo "  make report    - Open interactive HTML solution preview"
	@echo "  make clean     - Remove temporary pycache and build artifacts"
	@echo "  make all       - Complete verification pipeline (verify -> test)"
	@echo "================================================================================"

setup:
	python3 -m pip install -r requirements.txt || pip install -r requirements.txt

verify:
	bash run.sh

test:
	@echo "==> Testing submission agent syntax..."
	python3 -c "import ast; ast.parse(open('main.py').read()); print('✓ main.py AST verified successfully.')"
	python3 -c "import json; json.load(open('configs/model_config.json')); print('✓ configs/model_config.json verified successfully.')"

report:
	open reports/solution_preview.html || xdg-open reports/solution_preview.html || echo "Preview located at reports/solution_preview.html"

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	rm -rf .pytest_cache .ruff_cache

all: verify test
	@echo "==> Full Kaggriculture verification passed cleanly!"
