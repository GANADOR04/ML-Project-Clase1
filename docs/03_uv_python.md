[Back to `README.md`](../README.md)

# ⚡ 3) Gestión de Python y Dependencias con `uv`

En el MUIA estandarizamos el ecosistema Python sobre **[`uv`](https://docs.astral.sh/uv/)** (desarrollado por Astral en Rust). `uv` unifica y reemplaza de forma extremadamente rápida a herramientas tradicionales como `pip`, `pip-tools`, `virtualenv`, `pyenv`, `poetry` y `conda`.

***

## 🌟 Ventajas clave de `uv`

1. **10 a 100 veces más rápido** que pip o conda instalando dependencias.
2. **Descarga e instala versiones de Python** de forma transparente y aislada sin ensuciar el sistema.
3. **Gestión moderna de proyectos (PEP 621 / PEP 735)** basada en [`pyproject.toml`](../pyproject.toml) y bloqueo determinista en [`uv.lock`](../uv.lock).
4. **Ejecución hermética con `uv run`**: no es obligatorio activar/desactivar entornos manualmente; `uv run` garantiza que cualquier script se ejecute en el entorno del proyecto.

***

## 🐍 1. Gestión de versiones de Python

`uv` puede descargar y gestionar múltiples versiones de CPython o PyPy de forma autónoma sin necesidad de permisos de administrador:

```bash
# Instalar la versión oficial del máster (Python 3.12)
uv python install 3.12

# Listar versiones instaladas en tu equipo y disponibles para descargar
uv python list

# Fijar la versión activa en el repositorio (crea un archivo .python-version)
uv python pin 3.12
```

***

## 📦 2. Ciclo de vida del proyecto y sincronización

El archivo [`pyproject.toml`](../pyproject.toml) define los metadatos y librerías declarativas del proyecto.

### A. Sincronizar el entorno (`uv sync`)

Cuando clonas un proyecto o cambias de rama, no necesitas instalar paquetes uno a uno:

```bash
# Crea automáticamente el entorno .venv e instala las dependencias exactas de uv.lock
uv sync
```

Para incluir herramientas auxiliares de desarrollo (linters, testers, Jupyter Lab):

```bash
uv sync --all-groups
```

### B. Añadir o quitar librerías

No uses `pip install` dentro del proyecto. Deja que `uv` gestione el grafo de dependencias y actualice [`pyproject.toml`](../pyproject.toml) y [`uv.lock`](../uv.lock):

```bash
# Añadir dependencias al proyecto principal
uv add pandas seaborn matplotlib

# Añadir dependencias al grupo de desarrollo (dev)
uv add --group dev pytest ruff

# Eliminar una dependencia
uv remove seaborn
```

***

## 🚀 3. Ejecución de código con `uv run`

Olvídate de scripts de activación (`activate.ps1` o `source .venv/bin/activate`). El comando `uv run` inspecciona el directorio actual, localiza el `.venv` y ejecuta el comando dentro del contexto aislado:

```bash
# Ejecutar un módulo Python
uv run python -m src.app.train

# Ejecutar un script directamente
uv run python test_script.py

# Lanzar Jupyter Lab con el kernel del proyecto activo
uv run jupyter lab

# Ejecutar linter de código
uv run ruff check .
```

> [!TIP]
> Si deseas activar el entorno en tu terminal para una sesión interactiva tradicional:
>
> * **Windows (PowerShell)**: `.venv\Scripts\Activate.ps1`
> * **macOS / Linux**: `source .venv/bin/activate`

***

## 🛠️ 4. Herramientas efímeras con `uvx`

¿Necesitas ejecutar una herramienta de Python (como un linter, formateador o visor de datos) sin instalarla permanentemente en las dependencias de tu proyecto? Usa `uvx`:

```bash
# Ejecutar ruff sin añadirlo a tu entorno
uvx ruff format .

# Lanzar un servidor temporal de documentación
uvx mkdocs serve
```

***

## 🔄 5. Tabla de equivalencias: `uv` vs `Conda` vs `Pip/Venv`

| Tarea                  | `uv` (Estándar MUIA)                           | `Conda` (Tradicional)         | `pip` + `venv`                    |
| :--------------------- | :--------------------------------------------- | :---------------------------- | :-------------------------------- |
| **Instalar Python**    | `uv python install 3.12`                       | `conda install python=3.12`   | Descarga manual de instalador     |
| **Crear entorno**      | `uv sync` o `uv venv`                          | `conda create -n env`         | `python -m venv .venv`            |
| **Activar entorno**    | No necesario (`uv run`) o `.venv/bin/activate` | `conda activate env`          | `source .venv/bin/activate`       |
| **Instalar librería**  | `uv add numpy`                                 | `conda install numpy`         | `pip install numpy`               |
| **Añadir dev-dep**     | `uv add --group dev pytest`                    | *(No estandarizado)*          | `pip install pytest`              |
| **Reinstalar todo**    | `uv sync`                                      | `conda env create -f env.yml` | `pip install -r requirements.txt` |
| **Actualizar paquete** | `uv lock --upgrade-package numpy`              | `conda update numpy`          | `pip install --upgrade numpy`     |
| **Borrar entorno**     | Eliminar carpeta `.venv`                       | `conda env remove -n env`     | Eliminar carpeta `.venv`          |

***

Continúa con: **[04. Entornos Aislados para Repositorios Basados en Agentes IA](./04_agent_environments.md)**.
