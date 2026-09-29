[Back to `README.md`](../README.md)

# 🐳 5) Docker Setup & Quick Start

Docker permite empaquetar el entorno de desarrollo y ejecución de Machine Learning en **contenedores reproducibles y herméticos**.
Así, cualquier estudiante o colaborador ejecuta el proyecto con las **mismas versiones exactas** de librerías, dependencias del sistema y binarios compilados, con independencia de si su equipo corre Windows o macOS.

---

## 📦 1. Instalación de Docker Desktop

### En Windows (10 / 11)
1. Descarga **Docker Desktop para Windows** desde el sitio oficial: [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop) o vía `winget`:
   ```powershell
   winget install Docker.DockerDesktop
   ```
2. Durante la instalación, mantén activada la opción predeterminada *"Use the WSL 2 based engine"* (es el backend estándar de virtualización ligera de Windows para Docker).
3. Inicia la aplicación **Docker Desktop** desde el menú Inicio.
4. Abre PowerShell y comprueba que el motor responde:
   ```powershell
   docker --version
   docker run hello-world
   ```

### En macOS (Apple Silicon M1/M2/M3/M4 o Intel)
1. Descarga el instalador correspondiente a tu chip (Apple Silicon o Intel) desde [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop) o mediante Homebrew:
   ```bash
   brew install --cask docker
   ```
2. Abre la aplicación Docker en la carpeta `Aplicaciones`.
3. Comprueba en tu terminal:
   ```bash
   docker --version
   docker run hello-world
   ```

---

## 🚀 2. Quickstart del Proyecto con Docker (CPU)

En la raíz del repositorio se encuentra un [`Dockerfile`](../Dockerfile) optimizado para proyectos de ML con `uv`.

### A. Construir la imagen
```bash
docker build -t ml-template:latest -f Dockerfile .
```

### B. Lanzar un contenedor interactivo montando el código local

Al montar la carpeta actual, cualquier cambio que hagas en tus archivos de código desde el editor en Windows/macOS se reflejará instantáneamente dentro del contenedor:

> [!WARNING]
> En **Windows**, montar `-v ${PWD}:/workspace` sin proteger `.venv` puede causar que `uv`
> dentro del contenedor **sobreescriba el `.venv` de Windows con symlinks POSIX**, bloqueando
> `uv run` en el host con `Acceso denegado (os error 5)`. Añade siempre `-v /workspace/.venv`
> para que el contenedor use el `.venv` precocinado en la imagen.

- En **Windows (PowerShell)**:
  ```powershell
  docker run -it --rm -v ${PWD}:/workspace -v /workspace/.venv -w /workspace ml-template:latest bash
  ```

- En **macOS**:
  ```bash
  docker run -it --rm -v $(pwd):/workspace -v /workspace/.venv -w /workspace ml-template:latest bash
  ```

### C. Ejecutar el flujo de prueba dentro del contenedor
Una vez dentro del prompt del contenedor:

```bash
# Comprobar el entorno
uv run python -c "import sklearn; print('Docker OK:', sklearn.__version__)"

# Ejecutar el entrenamiento de prueba
uv run python -m src.app.train
```

Los artefactos resultantes quedarán guardados en tu carpeta local `runs/` gracias al volumen montado.

---

## ⚡ 3. Aceleración por Hardware (GPU con NVIDIA en Windows)

Si tu equipo con Windows dispone de una tarjeta gráfica NVIDIA dedicada, puedes aprovecharla directamente dentro de Docker usando [`Dockerfile_gpu`](../Dockerfile_gpu).

1. Asegúrate de tener actualizados los drivers oficiales de tu tarjeta gráfica NVIDIA en Windows (los controladores modernos de Windows incluyen compatibilidad directa con contenedores GPU).
2. Construye la imagen con soporte CUDA:
   ```powershell
   docker build -t ml-template:gpu -f Dockerfile_gpu .
   ```
3. Lanza el contenedor con el modificador `--gpus all`:
   ```powershell
   docker run --gpus all -it --rm -v ${PWD}:/workspace -w /workspace ml-template:gpu bash
   ```
4. Comprueba el acceso a la GPU desde Python dentro del contenedor:
   ```bash
   uv run python -c "import torch; print('CUDA disponible:', torch.cuda.is_available(), '| Dispositivo:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'No GPU')"
   ```

---

Continúa con: [**06. Visual Studio Code y Extensiones Recomendadas**](./06_vsc.md).
