[Back to `README.md`](../README.md)

# 🐙🦊 2) Setup Dual de Git: GitHub & GitLab

A lo largo del Máster trabajaremos simultáneamente con dos plataformas de control de versiones complementarias:

1. **GitHub**:
   - Plataforma de referencia para el código *Open Source*.
   - Alojamiento de la plantilla oficial de proyectos ([`loyola-masters/ml-project-template`](https://github.com/loyola-masters/ml-project-template)).
   - Portafolio público personal y profesional de cada estudiante.
2. **GitLab**:
   - Plataforma docente e interna de la Universidad Loyola.
   - Entrega de prácticas, proyectos de fin de asignatura y evaluación continua.
   - Repositorios privados de equipo y pipelines de Integración Continua (CI/CD).

A continuación configuraremos tu equipo con un **esquema paralelo de claves SSH y configuración multi-host** (`~/.ssh/config`), compatible de forma idéntica en **Windows nativo** y **macOS**.

---

## 🔑 1. Creación de cuentas y claves SSH dedicadas

Por buenas prácticas de seguridad e higiene de credenciales, utilizaremos un par de claves criptográficas moderno (`ed25519`) independiente para cada plataforma.

> [!NOTE]
> En **Windows PowerShell**, la ruta `~/.ssh/` se resuelve automáticamente a `C:\Users\<TuUsuario>\.ssh\`.
> En **macOS**, se resuelve a `/Users/<TuUsuario>/.ssh/`.

Abre tu terminal (PowerShell en Windows o Terminal en macOS) y ejecuta:

```bash
# 1. Asegurar la existencia del directorio .ssh
mkdir -p ~/.ssh

# 2. Generar clave para GitHub
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_github -C "tu_email@loyola.es"

# 3. Generar clave para GitLab
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_gitlab -C "tu_email@loyola.es"
```
*(Pulsa Enter cuando te solicite contraseña / passphrase para dejarla sin contraseña o introduce una si prefieres protegerla).*

---

## 📋 2. Registrar las claves públicas en cada plataforma

### Para GitHub:
1. Muestra el contenido de la clave pública:
   ```bash
   cat ~/.ssh/id_ed25519_github.pub
   ```
2. Inicia sesión en [GitHub](https://github.com) y ve a:
   👉 **Settings** (esquina superior derecha en tu avatar) ➔ **SSH and GPG keys** ➔ **New SSH key**.
3. Ponle un título descriptivo (ej. `Portatil Windows Loyola` o `MacBook M3`) y pega el contenido copiado.

### Para GitLab:
1. Muestra el contenido de la clave pública:
   ```bash
   cat ~/.ssh/id_ed25519_gitlab.pub
   ```
2. Inicia sesión en [GitLab](https://gitlab.com) y ve a:
   👉 **Preferences / Settings** (en tu perfil) ➔ **SSH Keys** ➔ **Add new key**.
3. Pega la clave pública, asigna un título y guarda los cambios.

---

## ⚙️ 3. Configurar el enrutamiento multi-host (`~/.ssh/config`)

Para que `git` sepa automáticamente qué clave privada utilizar al comunicarse con GitHub y cuál con GitLab sin preguntarte ni colisionar, configuramos el archivo `~/.ssh/config`.

Crea o edita el archivo `~/.ssh/config`:

- En **Windows (PowerShell)**:
  ```powershell
  notepad ~/.ssh/config
  ```
- En **macOS**:
  ```bash
  nano ~/.ssh/config
  ```

Pega exactamente el siguiente bloque de configuración:

```sshconfig
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes

Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519_gitlab
    IdentitiesOnly yes
```

Guarda y cierra el archivo.

---

## 🧪 4. Verificar la conexión dual

Comprueba la autenticación con ambas plataformas desde tu terminal:

```bash
# Comprobación GitHub
ssh -T git@github.com

# Comprobación GitLab
ssh -T git@gitlab.com
```

Las respuestas esperadas son:
- **GitHub**: `Hi <tu_usuario>! You've successfully authenticated, but GitHub does not provide shell access.`
- **GitLab**: `Welcome to GitLab, @<tu_usuario>!`

Si ves ambos mensajes, la configuración dual está funcionando al 100%.

---

## 🔄 5. Flujo de trabajo: De la plantilla en GitHub a tu proyecto en GitLab

Cuando comiences un nuevo proyecto o práctica del máster:

1. **Clonar la plantilla desde GitHub**:
   ```bash
   # Crea tu carpeta de trabajo personal
   mkdir -p ~/code
   cd ~/code

   # Clona la plantilla oficial
   git clone git@github.com:loyola-masters/ml-project-template.git ML-Project
   cd ML-Project
   ```

2. **Crear tu repositorio privado en GitLab**:
   - Entra en [GitLab](https://gitlab.com) y crea un nuevo proyecto en blanco (ej. `ML-Project`).
   - Copia la URL SSH del nuevo repositorio (ej. `git@gitlab.com:tu_usuario/ML-Project.git`).

3. **Reorientar el repositorio a GitLab**:
   - Cambia el origen para que tus cambios suban a tu repositorio de GitLab:
     ```bash
     git remote set-url origin git@gitlab.com:tu_usuario/ML-Project.git
     ```
   - (Opcional) Si quieres mantener la plantilla oficial como referencia remota para recibir actualizaciones:
     ```bash
     git remote add upstream git@github.com:loyola-masters/ml-project-template.git
     ```

4. **Publicar tu código en GitLab**:
   ```bash
   git push -u origin main
   ```

---

## 📌 6. Comandos habituales de Git en el día a día

```bash
# Ver cambios pendientes
git status

# Crear y cambiar a una rama de trabajo nueva
git switch -c feat/preprocesado-datos

# Añadir ficheros al staging
git add src/data/preprocess.py

# Crear commit descriptivo
git commit -m "feat(data): añade normalización y limpieza de nulos"

# Subir rama a remoto
git push -u origin feat/preprocesado-datos
```

Continúa con: [**03. Gestión de Python y Dependencias con `uv`**](./03_uv_python.md).
