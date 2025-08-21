# Use a imagem oficial do n8n
FROM n8nio/n8n:latest

# Temporariamente mude para root para instalar dependências
USER root

# Instalar dependências do sistema e npm em uma única camada
RUN apk add --no-cache git curl && \
    npm install -g langfuse \
    langfuse-langchain \ --unsafe-perm || true && \
    npm cache clean --force && \
    rm -rf /tmp/* /var/cache/apk/*

# Configurações de ambiente - COMPLETAS
ENV NODE_FUNCTION_ALLOW_EXTERNAL=* \
    NODE_FUNCTION_ALLOW_BUILTIN=* \
    NODE_PATH=/usr/local/lib/node_modules:/home/node/.n8n/nodes/node_modules \
    N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom" \
    EXECUTIONS_PROCESS=main \
    N8N_PERSONALIZATION_ENABLED=true \
    N8N_DIAGNOSTICS_ENABLED=false \
    N8N_VERSION_NOTIFICATIONS_ENABLED=false \
    N8N_TEMPLATES_ENABLED=true \
    N8N_METRICS=false \
    N8N_PUBLIC_API_DISABLED=false \
    GENERIC_TIMEZONE=America/Sao_Paulo \
    TZ=America/Sao_Paulo \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    N8N_BLOCK_ENV_ACCESS_IN_NODE=false \
    N8N_BLOCK_FILE_ACCESS_TO_N8N_FILES=false \
    N8N_DISABLE_PRODUCTION_MAIN_PROCESS=false \
    NODE_OPTIONS="--max-old-space-size=2048" \
    N8N_CUSTOM_EXTENSIONS_DISABLED=false \
    N8N_COMMUNITY_NODES_ENABLED=true

# Volte para o usuário node (padrão do n8n)
USER node

# A porta padrão do n8n
EXPOSE 5678

# NÃO sobrescreva o CMD - deixe o da imagem base
# O CMD já está configurado na imagem n8nio/n8n:latest
