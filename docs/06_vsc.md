[Back to `README.md`](../README.md)

# 💻 6) Visual Studio Code & Ecosistema de Extensiones 2027

**Visual Studio Code (VS Code)** es el entorno de desarrollo integrado (IDE) recomendado para el Máster. En la edición 2027 trabajamos con **VS Code de forma nativa**, abriendo directamente los repositorios locales sin necesidad de capas intermedias.

---

## 🚀 1. Apertura del Proyecto

Una vez clonado tu repositorio en tu carpeta de trabajo (`~/code/ML-Project`), puedes abrirlo en VS Code instantáneamente desde la línea de comandos:

- En **Windows (PowerShell)**:
  ```powershell
  cd ~/code/ML-Project
  code .
  ```
- En **macOS (Terminal)**:
  ```bash
  cd ~/code/ML-Project
  code .
  ```

*(O bien abre VS Code y selecciona **File ➔ Open Folder** y elige el directorio del repositorio).*

---

## 🧩 2. Extensiones Recomendadas para Machine Learning e IA

Instala estas extensiones desde el panel lateral de Extensiones (`Ctrl+Shift+X` en Windows / `Cmd+Shift+X` en macOS):

### 🐍 Desarrollo Python y Entornos
- **Python** (`ms-python.python`): Soporte central para lenguaje, autocompletado y exploración de tests.
- **Pylance** (`ms-python.vscode-pylance`): Motor de lenguaje de alto rendimiento con chequeo estático de tipos.
- **Python Debugger** (`ms-python.debugpy`): Depuración profesional con puntos de interrupción (*breakpoints*), inspección de variables y pila de llamadas.
- **UV Toolkit**: Extensión oficial para el ecosistema **uv**. Detecta automáticamente el entorno `.venv` del proyecto y permite gestionar paquetes y lockfiles directamente desde la interfaz.

### 🤖 Contenedores y Sandbox
- **Docker** (`ms-azuretools.vscode-docker`): Gestión visual de imágenes, contenedores y volúmenes.
- **Dev Containers** (`ms-vscode-remote.remote-containers`): Permite abrir una ventana de VS Code donde todo el entorno de ejecución es el contenedor Docker (ideal para ejecutar flujos de agentes en sandbox).

### 📊 Ciencia de Datos y Experimentación
- **Jupyter** (`ms-toolsai.jupyter`): Ejecución y visualización interactiva de Jupyter Notebooks (`.ipynb`) dentro del propio editor, conectándose directamente al kernel de `.venv`.

### 🐙 Control de Versiones
- **Git Graph** (`mhutchie.git-graph`): Visualización gráfica interactiva del árbol de ramas y commits de Git.
- **Git History** (`donjayamanne.githistory`): Consulta rápida del histórico de cambios y diferencias línea a línea sobre cualquier archivo.

---

## 🎯 3. Selección del Intérprete Python en VS Code

Una vez ejecutado `uv sync` en la raíz del proyecto:
1. Abre cualquier archivo Python (ej. [`src/app/train.py`](../src/app/train.py)).
2. Pulsa `Ctrl+Shift+P` (Windows) o `Cmd+Shift+P` (macOS) y escribe:
   `Python: Select Interpreter`
3. Selecciona el intérprete que apunta a la carpeta `.venv` de tu proyecto:
   - En Windows: `.\.venv\Scripts\python.exe`
   - En macOS: `./.venv/bin/python`

A partir de ese momento, el terminal integrado de VS Code utilizará el entorno del proyecto automáticamente para sugerencias, linting y ejecución de notebooks.

---

Continúa con: [**07. Automatización de Tareas con Make**](./07_make.md).
