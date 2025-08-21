# ZION N8N com Langfuse - Dockerfile Otimizado
FROM n8nio/n8n:latest

USER root

# Dependências do sistema necessárias
RUN apk add --update --no-cache \
    git \
    curl \
    jq \
    ffmpeg \
    imagemagick \
    build-base \
    python3 \
    py3-pip

# Criar diretório para módulos customizados com permissões corretas
RUN mkdir -p /home/node/.n8n/nodes && \
    chown -R node:node /home/node/.n8n

# Instalar pacotes npm globalmente (necessário para n8n)
# Langfuse e dependências relacionadas
RUN npm install -g \
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
    uuid \
    tiktoken \
    js-yaml \
    jsonschema \
    --unsafe-perm

# Configurar NODE_PATH para incluir módulos globais
ENV NODE_PATH=/usr/local/lib/node_modules:$NODE_PATH

# Variáveis de ambiente para n8n e Langfuse
ENV NODE_FUNCTION_ALLOW_EXTERNAL=* \
    NODE_FUNCTION_ALLOW_BUILTIN=* \
    GENERIC_TIMEZONE=America/Sao_Paulo \
    TZ=America/Sao_Paulo \
    NODE_ENV=production \
    NODE_OPTIONS="--max-old-space-size=4096" \
    N8N_DIAGNOSTICS_ENABLED=false \
    N8N_VERSION_NOTIFICATIONS_ENABLED=true \
    N8N_PERSONALIZATION_ENABLED=false \
    # Configurações Langfuse (serão sobrescritas pelo docker-compose)
    LANGFUSE_ENABLED=true \
    LANGFUSE_HOST=https://cloud.langfuse.com

# Mudar de volta para o usuário node
USER node

# Expor porta padrão do n8n
EXPOSE 5678

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

# Comando padrão
CMD ["n8n"]
