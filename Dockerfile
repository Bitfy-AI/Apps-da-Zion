# n8n com Langfuse - Instalação Inteligente
FROM n8nio/n8n:latest

USER root

# Dependências do sistema
RUN apk add --update --no-cache \
    git \
    curl \
    jq \
    ffmpeg \
    imagemagick \
    build-base \
    python3 \
    py3-pip

# Script para instalar apenas pacotes que existem
RUN echo '#!/bin/sh' > /install-packages.sh && \
    echo 'for package in "$@"; do' >> /install-packages.sh && \
    echo '  echo "Tentando instalar: $package"' >> /install-packages.sh && \
    echo '  npm install -g "$package" --unsafe-perm 2>/dev/null && echo "✓ $package instalado" || echo "✗ $package falhou (pode não existir)"' >> /install-packages.sh && \
    echo 'done' >> /install-packages.sh && \
    chmod +x /install-packages.sh

# Tentar instalar pacotes (os que falharem serão ignorados)
RUN /install-packages.sh \
    langfuse \
    langfuse-langchain \
    langfuse-js \
    @langfuse/node \
    langchain \
    @langchain/core \
    @langchain/community \
    @langchain/openai \
    @langchain/anthropic \
    openai \
    @anthropic-ai/sdk \
    anthropic \
    zod \
    uuid \
    tiktoken \
    js-tiktoken \
    js-yaml \
    yaml \
    jsonschema

# Verificar o que foi instalado
RUN echo "Pacotes instalados:" && npm list -g --depth=0 2>/dev/null | grep -E "langfuse|langchain|openai|anthropic" || true

# Limpar
RUN rm /install-packages.sh

# Configuração
ENV NODE_FUNCTION_ALLOW_EXTERNAL=* \
    NODE_FUNCTION_ALLOW_BUILTIN=* \
    NODE_PATH=/usr/local/lib/node_modules \
    GENERIC_TIMEZONE=America/Sao_Paulo \
    TZ=America/Sao_Paulo \
    NODE_ENV=production \
    NODE_OPTIONS="--max-old-space-size=4096"

USER node

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

CMD ["n8n"]
