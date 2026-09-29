PY ?= 3.12
UV ?= uv

.DEFAULT_GOAL := help

.PHONY: help setup test train dev clean

help: ## Muestra comandos disponibles
	@echo Comandos disponibles:
	@echo   make setup  - Instala Python $(PY) y sincroniza dependencias con uv
	@echo   make test   - Ejecuta test de humo del entorno
	@echo   make train  - Entrena el modelo de referencia (DecisionTree en Iris)
	@echo   make dev    - Sincroniza dependencias incluyendo herramientas de desarrollo
	@echo   make clean  - Limpia la cache de uv

setup: ## Instala Python y sincroniza dependencias base
	$(UV) python install $(PY)
	$(UV) sync --python $(PY)

dev: ## Sincroniza dependencias con grupo de desarrollo
	$(UV) sync --all-groups

test: ## Test de humo de entorno y librerías
	$(UV) run python -c "import sklearn, yaml; print('Entorno OK - scikit-learn version:', sklearn.__version__)"

train: ## Entrena ejemplo Iris (arbol de decision)
	$(UV) run python -m src.app.train

clean: ## Limpia la cache de uv
	$(UV) cache clean
