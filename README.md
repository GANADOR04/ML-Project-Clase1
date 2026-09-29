# ML Project Template — MUIA (Edición 2027)

Plantilla base y guía de referencia del **Stack Tecnológico Oficial** del Máster Universitario en Inteligencia Artificial (MUIA) de la Universidad Loyola.

Este repositorio está diseñado bajo el principio **All-In-One-Day**: permitir que cualquier estudiante configure su entorno de trabajo completo en su primer día y disponga de una estructura profesional, modular y reproducible para todas las asignaturas del máster.

***

## 🧭 Índice de Guías del Stack Tecnológico

La documentación detallada paso a paso se encuentra organizada de forma modular en el directorio [`docs/`](./docs/):

1. **[01. Setup del Sistema Operativo](./docs/01_setup_os.md)**: Configuración nativa sin capas intermedias en **Windows 10/11** (PowerShell + Windows Terminal) y **macOS** (zsh + Homebrew).
2. **[02. Setup Dual de Git (GitHub & GitLab)](./docs/02_git_dual_setup.md)**: Gestión unificada de claves SSH (`~/.ssh/config`) para GitHub (plantillas y portafolio público) y GitLab (plataforma docente Loyola y entregas).
3. **[03. Gestión de Python y Dependencias con `uv`](./docs/03_uv_python.md)**: Uso del gestor ultrarrápido `uv`, flujo con `pyproject.toml` / `uv.lock`, comandos `uv sync`, `uv run` y tabla de equivalencias con Conda.
4. **[04. Entornos Aislados para Repositorios Basados en Agentes IA](./docs/04_agent_environments.md)**: Estrategia de seguridad y contención (*blast radius*) para asistentes y agentes de código (Claude Code, Cursor, Antigravity): Baseline hermético con `uv` y Sandbox robusto con Docker.
5. **[05. Docker Setup & Quick Start](./docs/05_docker.md)**: Contenedores reproducibles con Docker Desktop (CPU y aceleración GPU con NVIDIA en Windows).
6. **[06. Visual Studio Code & Extensiones 2027](./docs/06_vsc.md)**: Configuración de VS Code nativo, selección del intérprete `.venv` y extensiones esenciales de IA, ML y Python.
7. **[07. Automatización de Tareas con Make](./docs/07_make.md)**: Explicación del `Makefile` multiplataforma y tabla de comandos equivalentes directos con `uv run`.

***

## ⚡ Quickstart All-In-One-Day

### 1. Instalación de herramientas base en el Sistema Operativo

<details open>
<summary><b>🪟 Windows (Nativo en PowerShell)</b></summary>

Abre una consola de **PowerShell** y ejecuta los dos siguientes comandos para instalar `Git`:

```powershell
# Habilitar ejecucion de scripts de usuario
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Instalar Git
winget install --id Git.Git -e --source winget
```

> [!NOTE]
> Alternativamente puedes descargar el instalador desde [git-scm](https://git-scm.com/install/windows)

A continuación, el gestor de Python:

```powershell
# Instalar uv (gestor de Python)
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Y finalmente `make` para la ejecución automatiza de scripts:

````powershell
# (Opcional recomendado) Instalar Make
winget install ezwinports.make

*Cierra y vuelve a abrir PowerShell tras la instalación.*

<br />

</details>

<details>
<summary><b>🍎 macOS (Terminal / zsh)</b></summary>

Abre **Terminal** y ejecuta con Homebrew:

```bash
brew install git make uv
````

</details>

### 2. Clonación del Repositorio

```bash
# Crea tu directorio de trabajo personal
mkdir -p ~/code
cd ~/code

# Clona la plantilla del Máster
git clone https://github.com/loyola-masters/ml-project-template-2027.git ML-Project
cd ML-Project
```

<br />

### 3. Setup, Test y Entrenamiento en 1 minuto

Puedes utilizar `make` o los comandos directos de `uv`:

#### Opción A: Usando `make`

```bash
make setup   # Descarga Python 3.12 y sincroniza dependencias en .venv
make test    # Smoke test rapido de validacion del entorno
make train   # Entrena el modelo de referencia (DecisionTree sobre Iris)
```

#### Opción B: Usando `uv` directamente

```bash
uv sync                                    # Crea .venv e instala dependencias exactas
uv run python -c "import sklearn; print('OK sklearn', sklearn.__version__)"
uv run python -m src.app.train            # Ejecuta el script de entrenamiento
```

Salida esperada del entrenamiento:

```text
Running Iris training: train.py...
accuracy=1.0000
artefactos en: runs/2027xxxx_xxxxxx
```

El modelo entrenado (`model.joblib`) y sus métricas (`metrics.json`) se almacenan automáticamente en la carpeta `runs/`.

***

## 🗂️ Estructura del Repositorio

```text
.
├── configs/
│   └── config.yaml           # Parametrización del modelo y entrenamiento
├── data/                     # Datasets locales (ignorado en Git)
├── docs/                     # 7 Guias tematicas del stack tecnologico
├── runs/                     # Artefactos y metricas de ejecuciones (ignorado en Git)
├── src/
│   ├── app/
│   │   ├── __init__.py
│   │   └── train.py          # Script de entrenamiento modular
│   └── .env.example          # Plantilla de variables de entorno y API keys
├── .gitignore                # Exclusiones de Git (datos, caches, venvs, secretos)
├── Dockerfile                # Imagen reproducible CPU / Sandbox seguro de agentes
├── Dockerfile_gpu            # Imagen con aceleracion NVIDIA CUDA + PyTorch
├── Makefile                  # Recetas de automatizacion estandarizadas
├── pyproject.toml            # Especificacion de dependencias (PEP 621 / PEP 735)
├── README.md                 # Portal de bienvenida y On-Boarding
└── uv.lock                   # Bloqueo determinista de versiones
```

***

## 🤖 Novedad 2027: Repositorios y Entornos para Agentes IA

En esta edición introducimos directrices para repositorios donde operan asistentes o agentes de código autónomos (Claude Code, Cursor, Antigravity, OpenDevin, LangGraph):

* **Baseline con `uv`**: Todo agente debe ejecutar comandos a través de `uv run <comando>` para garantizar que opere dentro de `.venv` y no contamine el sistema ni modifique librerías globales.
* **Sandbox con Docker**: Para ejecuciones donde el agente disponga de permisos de shell amplios o consumo de recursos elevado, se proporciona un sandbox cerrado sin privilegios de root (`ml-agent-sandbox`).
* Consulta la guía completa en **[`docs/04_agent_environments.md`](./docs/04_agent_environments.md)**.

***

## ❓ Preguntas Frecuentes y Resolución de Problemas

* **`uv: command not found` en Windows**:
  * Asegúrate de haber cerrado y reabierto PowerShell tras la instalación para que reconozca el nuevo `PATH` (`$HOME\.local\bin`).
* **Error de permisos al ejecutar scripts en PowerShell (`PSSecurityException`)**:
  * Ejecuta: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`.
* **`Permission denied (publickey)` con GitHub o GitLab**:
  * Revisa la configuración de tus claves y el archivo `~/.ssh/config` siguiendo la guía **[02. Setup Dual de Git](./docs/02_git_dual_setup.md)**.
* **¿Cómo abro un Jupyter Notebook con el entorno del proyecto?**:
  * Ejecuta `uv run jupyter lab` o abre el archivo `.ipynb` directamente en VS Code y selecciona el kernel de `.venv`.

***

Universidad Loyola — Máster Universitario en Inteligencia Artificial (MUIA).
