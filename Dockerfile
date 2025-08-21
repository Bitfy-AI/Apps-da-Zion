FROM n8nio/n8n:latest

# Stack Zion - Customizações
USER root

# Ferramentas essenciais
RUN apk add --no-cache \
    python3 \
    py3-pip \
    git \
    curl \
    jq \
    ffmpeg

# Bibliotecas Python para automação
RUN pip3 install \
    pandas \
    requests \
    beautifulsoup4 \
    openai

# Configurações Zion
ENV GENERIC_TIMEZONE="America/Sao_Paulo"
ENV TZ="America/Sao_Paulo"
ENV N8N_CUSTOM_BRAND="Zion"

USER node
EXPOSE 5678
