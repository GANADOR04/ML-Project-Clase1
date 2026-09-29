[Back to `README.md`](../README.md)

# 💻 1) Setup del Sistema Operativo (Windows y macOS Nativos)

En el **Máster Universitario en Inteligencia Artificial (MUIA 2027)** trabajamos **directamente sobre el sistema operativo anfitrión**, eliminando capas de virtualización intermedias (como WSL en Windows) que introducen fricción innecesaria en la gestión de ficheros, variables de entorno, soporte de GPU y doble motor de contenedores.

Tanto en **Windows** como en **macOS**, el entorno de desarrollo se configura en pocos minutos con herramientas estándar del sector.

---

## 🪟 A. Configuración en Windows (10 / 11)

### 1. Terminal y Shell recomendada
Para una experiencia moderna con soporte UTF-8, pestañas y división de paneles:
- **Windows Terminal**: Viene preinstalado en Windows 11. En Windows 10 puedes instalarlo con:
  ```powershell
  winget install Microsoft.WindowsTerminal
  ```
- **PowerShell**: Puedes usar Windows PowerShell (integrado) o instalar la versión moderna **PowerShell 7**:
  ```powershell
  winget install --id Microsoft.Powershell --source winget
  ```

> [!TIP]
> **Habilitar ejecución de scripts en PowerShell**:
> Por seguridad por defecto Windows restringe la ejecución de scripts. Habilita los scripts de usuario ejecutando en una consola de PowerShell:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

---

### 2. Instalar Git for Windows
Instala Git a través del gestor oficial `winget`:

```powershell
winget install --id Git.Git -e --source winget
```

Tras la instalación, cierra y reabre la consola de terminal y comprueba:

```powershell
git --version
```

Configura tu identidad global (utiliza tu correo de la universidad o el que vayas a usar en GitHub/GitLab):

```powershell
git config --global user.name "Tu Nombre Completo"
git config --global user.email "tu_email@loyola.es"
git config --global init.defaultBranch main
```

---

### 3. Instalar `uv` (Gestor de Python de alto rendimiento)
Instala `uv` mediante el instalador oficial para Windows en PowerShell:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

El instalador colocará el binario en `$HOME\.local\bin` y actualizará automáticamente la variable `PATH` de usuario. Cierra y reabre tu terminal, y verifica:

```powershell
uv --version
```
*(Deberás ver una versión de `uv >= 0.5.0`)*.

---

### 4. Instalar `make` (Opcional pero muy recomendado)
Para poder ejecutar comandos directos como `make setup`, `make test` o `make train` en Windows:

```powershell
winget install ezwinports.make
```

Cierra y reabre la terminal y verifica:

```powershell
make --version
```

*(Si prefieres no instalar `make`, en este repositorio todos los comandos tienen su equivalente directo e idéntico con `uv run`)*.

---

## 🍎 B. Configuración en macOS (Apple Silicon / Intel)

### 1. Instalar Homebrew (Gestor de paquetes para macOS)
Si aún no lo tienes instalado, abre la aplicación **Terminal** y ejecuta:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Sigue las instrucciones que aparecen en pantalla al finalizar para agregar Homebrew al `PATH` de tu shell `zsh` (`~/.zprofile` o `~/.zshrc`).

---

### 2. Instalar Git, Make y uv
Con Homebrew instalado, ejecuta:

```bash
brew install git make uv
```

Comprueba que las herramientas están operativas:

```bash
git --version
make --version
uv --version
```

Configura tu identidad global de Git:

```bash
git config --global user.name "Tu Nombre Completo"
git config --global user.email "tu_email@loyola.es"
git config --global init.defaultBranch main
```

---

## ✅ Checklist de verificación rápida

Antes de pasar a la configuración de claves y repositorios, asegúrate de que al ejecutar estos tres comandos obtienes respuesta de versión sin errores:

| Comando | Windows (PowerShell) | macOS (Terminal/zsh) |
| :--- | :--- | :--- |
| **Git** | `git --version` | `git --version` |
| **uv** | `uv --version` | `uv --version` |
| **Make** | `make --version` | `make --version` |

¡Tu sistema operativo está listo! Pasa al siguiente paso: [**02. Setup Dual de Git (GitHub + GitLab)**](./02_git_dual_setup.md).
