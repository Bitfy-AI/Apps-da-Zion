FROM n8nio/n8n:latest

USER root

RUN apk add --no-cache git curl

# Instalar APENAS Langfuse (que definitivamente existe)
RUN npm install -g langfuse --unsafe-perm

ENV NODE_FUNCTION_ALLOW_EXTERNAL=*
ENV NODE_PATH=/usr/local/lib/node_modules
ENV TZ=America/Sao_Paulo

USER node

CMD ["n8n"]
