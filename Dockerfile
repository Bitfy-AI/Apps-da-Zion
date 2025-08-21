# Dockerfile - ZION N8N Stack com Langfuse
FROM n8nio/n8n:latest

# Build arguments
ARG N8N_VERSION="latest"
ARG BUILD_DATE
ARG VCS_REF

# Labels
LABEL org.opencontainers.image.title="ZION N8N with Langfuse" \
      org.opencontainers.image.description="n8n turbinado com Langfuse e ferramentas extras da comunidade ZION" \
      org.opencontainers.image.vendor="ZION Community" \
      org.opencontainers.image.version="${N8N_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      maintainer="ZION Community"

# Mudar para root para instalações
USER root

# Instalar ferramentas do sistema (sem Python)
RUN apk add --no-cache \
    git \
    curl \
    wget \
    jq \
    ffmpeg \
    imagemagick \
    gcc \
    g++ \
    make \
    libc-dev \
    postgresql-client \
    mysql-client \
    redis \
    zip \
    unzip \
    nodejs \
    npm \
    && rm -rf /var/cache/apk/*

# Atualizar npm para última versão
RUN npm install -g npm@latest

# Instalar Langfuse e dependências relacionadas a LLMs
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install --save \
    langfuse \
    langfuse-langchain \
    @langfuse/node \
    langchain \
    @langchain/core \
    @langchain/community \
    @langchain/openai \
    @langchain/anthropic \
    openai \
    @anthropic-ai/sdk \
    zod \
    uuid

# Instalar outras bibliotecas úteis para IA/LLM
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install --save \
    pdf-parse \
    mammoth \
    cheerio \
    tiktoken \
    js-yaml \
    jsonschema

# Criar diretório para nodes customizados
RUN mkdir -p /home/node/.n8n/custom

# Criar diretório para configurações do Langfuse
RUN mkdir -p /home/node/.n8n/langfuse

# Configurações ZION
ENV GENERIC_TIMEZONE="America/Sao_Paulo" \
    TZ="America/Sao_Paulo" \
    NODE_OPTIONS="--max-old-space-size=4096" \
    N8N_DIAGNOSTICS_ENABLED="false" \
    N8N_VERSION_NOTIFICATIONS_ENABLED="true" \
    N8N_HIRING_BANNER_ENABLED="false" \
    N8N_PERSONALIZATION_ENABLED="false" \
    ZION_VERSION="${N8N_VERSION}" \
    # Configurações Langfuse (podem ser sobrescritas)
    LANGFUSE_PUBLIC_KEY="" \
    LANGFUSE_SECRET_KEY="" \
    LANGFUSE_HOST="https://cloud.langfuse.com" \
    LANGFUSE_ENABLED="true"

# Criar script de healthcheck
RUN echo '#!/bin/sh' > /healthcheck.sh && \
    echo 'curl -f http://localhost:5678/healthz 2>/dev/null || exit 1' >> /healthcheck.sh && \
    chmod +x /healthcheck.sh

# Script de inicialização para configurar Langfuse
RUN cat > /init-langfuse.sh << 'EOF'
#!/bin/sh
echo "🚀 Inicializando ZION N8N com Langfuse..."
if [ ! -z "$LANGFUSE_PUBLIC_KEY" ] && [ ! -z "$LANGFUSE_SECRET_KEY" ]; then
    echo "✅ Langfuse configurado"
else
    echo "⚠️  Langfuse keys não configuradas - configure LANGFUSE_PUBLIC_KEY e LANGFUSE_SECRET_KEY"
fi
exec n8n
EOF
RUN chmod +x /init-langfuse.sh

# Ajustar permissões
RUN chown -R node:node /home/node/.n8n

# Voltar para usuário node
USER node

# Porta padrão
EXPOSE 5678

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD /healthcheck.sh

# Volume para dados persistentes
VOLUME ["/home/node/.n8n"]

# Comando padrão com script de inicialização
CMD ["/init-langfuse.sh"]
