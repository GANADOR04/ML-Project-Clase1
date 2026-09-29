# syntax=docker/dockerfile:1.7

# Imagen oficial con Python 3.12 + uv preinstalado (Debian 12 "bookworm" slim)
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Añadir utilidades basicas de desarrollo y make
RUN apt-get update && \
    apt-get install -y --no-install-recommends make git curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Optimizaciones recomendadas por Astral
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_PREFERENCE=only-managed

# Directorio de trabajo en el contenedor
WORKDIR /workspace

# 1) Copiar metadatos para aprovechar la cache de capas de Docker
COPY pyproject.toml uv.lock* Makefile ./

# 2) Instalar dependencias reproducibles con uv sync
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-cache

# Asegurar que el entorno virtual .venv este en el PATH
ENV PATH="/workspace/.venv/bin:${PATH}"

# 3) Copiar el codigo fuente y configuraciones del proyecto
COPY src/ ./src/
COPY configs/ ./configs/

# 4) Seguridad y Sandbox de Agentes: usuario no-root 'app'
RUN groupadd -r app && useradd -r -g app -m app && \
    mkdir -p /workspace/runs && \
    chown -R app:app /workspace
USER app

# Comando por defecto: verificar entorno y ejecutar pipeline de prueba
CMD ["uv", "run", "python", "-m", "src.app.train"]
