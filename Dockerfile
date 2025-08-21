# Dockerfile - ZION N8N Stack
# ============================================
# Build inteligente com versionamento
# ============================================

# Sempre usa a última versão do n8n
FROM n8nio/n8n:latest

# Build arguments para metadata
ARG N8N_VERSION="latest"
ARG BUILD_DATE
ARG VCS_REF

# Labels para rastreamento
LABEL org.opencontainers.image.title="ZION N8N" \
      org.opencontainers.image.description="n8n turbinado com ferramentas extras da comunidade ZION" \
      org.opencontainers.image.vendor="ZION Community" \
      org.opencontainers.image.version="${N8N_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.source="https://github.com/zion/n8n" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.licenses="MIT" \
      maintainer="ZION Community <community@zion.dev>"

# Mudar para root para instalações
USER root

# Instalar ferramentas do sistema
RUN apk add --no-cache \
    # Essenciais
    python3 \
    py3-pip \
    git \
    curl \
    wget \
    jq \
    # Processamento de mídia
    ffmpeg \
    imagemagick \
    # Build tools (para alguns pacotes Python)
    gcc \
    g++ \
    make \
    python3-dev \
    musl-dev \
    libffi-dev \
    # Extras úteis
    chromium \
    chromium-chromedriver \
    postgresql-client \
    mysql-client \
    redis \
    zip \
    unzip \
    && rm -rf /var/cache/apk/*

# Instalar bibliotecas Python populares
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir \
    # Data Science
    pandas \
    numpy \
    # Web Scraping
    requests \
    beautifulsoup4 \
    selenium \
    playwright \
    scrapy \
    # APIs e Integrações
    openai \
    anthropic \
    google-api-python-client \
    tweepy \
    python-telegram-bot \
    discord.py \
    slack-sdk \
    # Utilidades
    python-dotenv \
    pyyaml \
    jsonschema \
    python-dateutil \
    pytz \
    # Banco de dados
    psycopg2-binary \
    pymongo \
    redis \
    sqlalchemy

# Instalar Playwright browsers (opcional - comentar se não precisar)
# RUN playwright install chromium

# Criar diretório para nodes customizados
RUN mkdir -p /home/node/.n8n/custom

# Configurações padrão ZION
ENV GENERIC_TIMEZONE="America/Sao_Paulo" \
    TZ="America/Sao_Paulo" \
    # Performance
    NODE_OPTIONS="--max-old-space-size=2048" \
    # n8n configs
    N8N_DIAGNOSTICS_ENABLED="false" \
    N8N_VERSION_NOTIFICATIONS_ENABLED="true" \
    N8N_HIRING_BANNER_ENABLED="false" \
    N8N_PERSONALIZATION_ENABLED="false" \
    # Custom branding
    N8N_CUSTOM_HEADER="Powered by ZION Community" \
    # Versão para tracking
    ZION_VERSION="${N8N_VERSION}"

# Script de healthcheck customizado
COPY --chown=node:node healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

# Se tiver nodes customizados, copiar aqui
# COPY --chown=node:node ./custom-nodes /home/node/.n8n/custom

# Voltar para usuário node
USER node

# Porta padrão
EXPOSE 5678

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD /healthcheck.sh || exit 1

# Volume para dados persistentes
VOLUME ["/home/node/.n8n"]

# Comando padrão
CMD ["n8n"]

# ============================================
# ARQUIVO: healthcheck.sh
# ============================================
# Criar este arquivo separado no repo:

#!/bin/sh
# Healthcheck customizado ZION
if curl -f http://localhost:5678/healthz 2>/dev/null; then
    echo "✅ ZION N8N is healthy"
    exit 0
else
    echo "❌ ZION N8N is not responding"
    exit 1
fi
