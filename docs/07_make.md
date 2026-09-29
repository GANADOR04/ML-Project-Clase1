[Back to `README.md`](../README.md)

# 📜 7) Automatización de Tareas con `Make`

En proyectos de Machine Learning colaborativos y profesionales es esencial contar con un **punto de entrada único y estandarizado** para las tareas recurrentes (configuración de entorno, comprobaciones de salud, ejecución de pipelines de entrenamiento y limpieza).

En el MUIA utilizamos un [`Makefile`](../Makefile) multiplataforma diseñado para funcionar de manera idéntica en **Windows nativo** y **macOS**.

---

## 🛠️ 1. Comandos disponibles en el `Makefile`

Al ejecutar simplemente `make` sin argumentos, se invoca el objetivo predeterminado `help`:

```bash
make
```

Salida esperada:
```text
Comandos disponibles:
  make setup  - Instala Python 3.12 y sincroniza dependencias con uv
  make test   - Ejecuta test de humo del entorno
  make train  - Entrena el modelo de referencia (DecisionTree en Iris)
  make dev    - Sincroniza dependencias incluyendo herramientas de desarrollo
  make clean  - Limpia la cache de uv
```

---

## 🔍 2. Detalle de objetivos (*targets*)

### `make setup`
Prepara el entorno de ejecución desde cero:
```makefile
setup:
	$(UV) python install $(PY)
	$(UV) sync --python $(PY)
```
1. Comprueba si Python 3.12 está instalado; si no, `uv` lo descarga automáticamente.
2. Crea el entorno virtual hermético `.venv` y sincroniza las dependencias fijadas en [`uv.lock`](../uv.lock).

### `make test`
Realiza una prueba rápida (*smoke test*) para validar que el entorno de ejecución puede importar las librerías científicas sin errores de DLL ni conflictos de versiones:
```makefile
test:
	$(UV) run python -c "import sklearn, yaml; print('Entorno OK - scikit-learn version:', sklearn.__version__)"
```

### `make train`
Lanza el pipeline de entrenamiento de referencia ([`src/app/train.py`](../src/app/train.py)):
```makefile
train:
	$(UV) run python -m src.app.train
```
Entrena un árbol de decisión sobre el conjunto de datos Iris, calcula la métrica de precisión (*accuracy*) y serializa el modelo entrenado y los metadatos en un subdirectorio fechado dentro de `runs/`.

### `make dev`
Sincroniza el entorno incluyendo las librerías del grupo de desarrollo declaradas en [`pyproject.toml`](../pyproject.toml) (como `pytest`, `ruff` o `jupyterlab`):
```makefile
dev:
	$(UV) sync --all-groups
```

---

## 🔄 3. Tabla de Equivalencias Directas (`make` vs `uv run`)

Si estás en un equipo con Windows donde aún no has instalado `make` (vía `winget install ezwinports.make`), puedes ejecutar exactamente los mismos comandos directos con `uv`:

| Acción | Con `Makefile` | Equivalente directo con `uv` |
| :--- | :--- | :--- |
| **Configurar entorno** | `make setup` | `uv python install 3.12` && `uv sync` |
| **Instalar dev tools** | `make dev` | `uv sync --all-groups` |
| **Smoke test** | `make test` | `uv run python -c "import sklearn; print(sklearn.__version__)"` |
| **Entrenamiento** | `make train` | `uv run python -m src.app.train` |
| **Limpiar caché** | `make clean` | `uv cache clean` |

Ambas vías son 100% compatibles y producen exactamente los mismos resultados reproducibles.
