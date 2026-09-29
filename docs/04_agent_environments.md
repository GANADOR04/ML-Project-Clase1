[Back to `README.md`](../README.md)

# 🤖 4) Entornos Aislados para Repositorios Basados en Agentes de IA

En el panorama actual de la Inteligencia Artificial (2026/2027), los **flujos de trabajo asistidos y orquestados por agentes de código** (como Claude Code, Cursor, Antigravity, OpenDevin, o frameworks como LangGraph y AutoGen) son parte integral del desarrollo de software y Machine Learning.

A diferencia del desarrollo tradicional donde un humano escribe cada línea, los agentes de IA **leen, escriben y ejecutan código y comandos de terminal de forma autónoma**. Esta capacidad exige una arquitectura de **entornos aislados** para proteger el sistema anfitrión y garantizar la reproducibilidad.

---

## 🛡️ ¿Por qué es crítico el aislamiento en repositorios con Agentes?

1. **Control del *Blast Radius* (Radio de Explosión)**: Un agente con acceso al terminal puede ejecutar scripts que consuman memoria de forma descontrolada, creen bucles infinitos, descarguen ficheros pesados o modifiquen archivos fuera del alcance del proyecto.
2. **Prevención de Contaminación de Dependencias**: Los agentes a menudo intentan instalar paquetes auxiliares para resolver errores. Si no se aísla el entorno, podrían degradar o alterar librerías globales del sistema operativo.
3. **Gestión Segura de Secretos y API Keys**: Los agentes necesitan credenciales (claves de Gemini, OpenAI, Anthropic, Hugging Face), pero dichas credenciales jamás deben quedar expuestas al control de versiones ni a llamadas de depuración de terceros.

Para resolver este desafío, en el Máster adoptamos una **estrategia de dos niveles**:

- **Nivel 1 (Baseline)**: Aislamiento nativo ultrarrápido con **`uv`**.
- **Nivel 2 (Alternativa Robusta)**: Aislamiento total en sandbox contenedorizado con **Docker**.

---

## ⚡ Nivel 1: Baseline con `uv` (Aislamiento de Proyecto)

Para el día a día y tareas de desarrollo estándar con agentes en tu propio equipo, `uv` proporciona una barrera de aislamiento eficiente, ligera y sin coste de rendimiento.

### 1. Entorno Virtual Hermético

Al ejecutar `uv sync`, se genera un directorio `.venv` estrictamente aislado. `uv` no utiliza el Python del sistema operativo ni modifica variables globales:

```bash
# Garantizar que el entorno esté alineado con el lockfile
uv sync --frozen
```

### 2. Ejecución Estricta mediante `uv run`

Cualquier orden enviada por un agente o ejecutada para validar su trabajo debe canalizarse a través de `uv run`:

```bash
# El comando se ejecuta encapsulado en el entorno virtual del proyecto
uv run python -m src.app.train
```

> [!IMPORTANT]
> **Instrucción canónica para Agentes (System Prompt / Directivas)**:
> Cuando configures un asistente o agente para trabajar en este repositorio, debes incluir en sus instrucciones:
> *"Always execute Python scripts and tests using `uv run <command>`. Never invoke bare `python` or `pip install` directly."*

### 3. Herramientas Auxiliares Efímeras (`uvx`)

Si el agente requiere validar sintaxis, formatear código o ejecutar linters, no debe añadir esas dependencias al proyecto de producción. Debe ejecutarlas de forma efímera:

```bash
uvx ruff check .
uvx ruff format .
```

### 4. Blindaje de Secretos con `.env`

1. Mantén siempre el archivo `.env` registrado en [`.gitignore`](../.gitignore).
2. Proporciona un archivo [`.env.example`](../src/.env.example) con variables dummy para que los agentes conozcan los nombres de las variables requeridas sin exponer los tokens reales:
   ```bash
   # .env.example
   GEMINI_API_KEY=tu_clave_aqui
   ANTHROPIC_API_KEY=tu_clave_aqui
   ```

---

## 🐳 Nivel 2: Alternativa Robusta con Docker (Sandbox Total)

Cuando un agente de IA tiene autonomía completa para ejecutar comandos de terminal, clonar repositorios de terceros, realizar *web scraping* o evaluar código no confiable, el aislamiento de proceso no es suficiente: se requiere un **sandbox a nivel de sistema operativo con Docker**.

### 1. ¿Qué nos aporta el Sandbox de Docker?

- **Aislamiento de Filesystem**: El contenedor solo tiene visibilidad del directorio montado (`/workspace`). Los discos del host (`C:\` en Windows o `/Users/` en macOS) son totalmente inaccesibles.
- **Usuario sin privilegios de administrador (`app`)**: El agente opera como usuario regular, imposibilitando modificaciones en el sistema operativo base.
- **Límites de CPU y Memoria**: Evita bloqueos del equipo si el agente lanza un script con consumo desmedido de RAM o cómputo.
- **Entorno Desechable**: Cada sesión arranca con un estado limpio gracias al modificador `--rm`.

### 2. Puesta en marcha del Sandbox para Agentes

1. **Construir la imagen del sandbox**:

   ```bash
   docker build -t ml-agent-sandbox -f Dockerfile .
   ```
2. **Lanzar el contenedor interactivo para el Agente**:

   > [!WARNING]
   > En **Windows**, montar `-v ${PWD}:/workspace` expone el `.venv` nativo de Windows al
   > contenedor Linux. `uv` lo detecta como incompatible y lo **sobreescribe con symlinks POSIX**
   > (`.venv/lib64 -> lib`). Al volver a Windows, NTFS bloquea su eliminación con
   > `Acceso denegado (os error 5)`. Para evitarlo, añade siempre `-v /workspace/.venv`
   > para que el contenedor use el `.venv` Linux precocinado en la imagen, sin tocar el host.

   - En **Windows (PowerShell)**:
     ```powershell
     docker run -it --rm `
       --name agent-sandbox `
       --cpus="4.0" `
       --memory="8g" `
       -v ${PWD}:/workspace `
       -v /workspace/.venv `
       -w /workspace `
       ml-agent-sandbox bash
     ```
   - En **macOS**:
     ```bash
     docker run -it --rm \
       --name agent-sandbox \
       --cpus="4.0" \
       --memory="8g" \
       -v $(pwd):/workspace \
       -v /workspace/.venv \
       -w /workspace \
       ml-agent-sandbox bash
     ```

Dentro de este contenedor, el agente puede compilar, entrenar y ejecutar pruebas con total libertad y seguridad.

---

## 📊 Matriz Comparativa: ¿Cuándo utilizar cada enfoque?


| Característica                | Baseline (`uv`)                                      | Sandbox Robusto (`Docker`)                                    |
| :------------------------------- | :----------------------------------------------------- | :-------------------------------------------------------------- |
| **Nivel de Aislamiento**       | Dependencias y librerías Python                     | Sistema Operativo, Red y Filesystem completos                 |
| **Velocidad de Arranque**      | Instantánea (< 100 ms)                              | Rápida (~1-2 s) tras build inicial                           |
| **Uso de Recursos**            | Mínimo (sin sobrecarga)                             | Moderado (motor Docker)                                       |
| **Seguridad de Archivos Host** | Acceso a nivel del usuario de sesión                | Completamente aislados (solo directorio montado)              |
| **Ideal para...**              | Desarrollo diario, Pair-Programming, scripts locales | Agentes autónomos, ejecución de código externo no auditado |

---

Continúa con: [**05. Docker Setup & Quick Start**](./05_docker.md).
