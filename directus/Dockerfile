# ZION Directus - Imagem Otimizada
FROM directus/directus:latest

USER root

# Instalar ferramentas adicionais úteis
RUN apk add --no-cache \
    git \
    curl \
    python3 \
    py3-pip \
    ffmpeg \
    imagemagick \
    vips \
    postgresql-client \
    mysql-client

# Instalar extensões globais úteis (opcional)
RUN npm install -g \
    @directus/extension-toolkit \
    pm2 \
    --unsafe-perm || true && \
    npm cache clean --force

# Configurações de ambiente otimizadas
ENV NODE_ENV=production \
    NODE_OPTIONS="--max-old-space-size=4096" \
    TZ=America/Sao_Paulo \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    # Performance
    CACHE_ENABLED=true \
    CACHE_TTL=1m \
    CACHE_AUTO_PURGE=true \
    # Uploads
    STORAGE_LOCATIONS=local \
    STORAGE_LOCAL_DRIVER=local \
    STORAGE_LOCAL_ROOT=/directus/uploads \
    # Rate Limiting
    RATE_LIMITER_ENABLED=true \
    RATE_LIMITER_POINTS=100 \
    RATE_LIMITER_DURATION=60 \
    # Segurança
    CORS_ENABLED=true \
    CORS_ORIGIN=true \
    # Logs
    LOG_LEVEL=info \
    LOG_STYLE=pretty

# Criar diretórios necessários
RUN mkdir -p /directus/uploads && \
    mkdir -p /directus/extensions && \
    mkdir -p /directus/database && \
    chown -R node:node /directus

USER node

EXPOSE 8055

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8055/server/health || exit 1

# O CMD já está definido na imagem base
