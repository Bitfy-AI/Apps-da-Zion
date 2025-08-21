# 🚀 ZION/N8N - Stack Automatizada

[![Auto Build](https://github.com/zion/n8n/actions/workflows/build.yml/badge.svg)](https://github.com/zion/n8n/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/zion/n8n)](https://hub.docker.com/r/zion/n8n)
[![Version](https://img.shields.io/docker/v/zion/n8n/latest?label=version)](https://hub.docker.com/r/zion/n8n/tags)
[![Zion Community](https://img.shields.io/badge/community-zion-purple)](https://t.me/zioncommunity)

> **n8n turbinado com ferramentas extras + atualização automática diária!**

## ⚡ Instalação Rápida

```bash
docker run -d \
  --name zion-n8n \
  -p 5678:5678 \
  -v zion_n8n_data:/home/node/.n8n \
  zion/n8n:latest
```

**Acesse:** http://localhost:5678

## 🐳 Docker Compose

```bash
# Baixar e rodar
curl -O https://raw.githubusercontent.com/zion/n8n/main/docker-compose.yml
docker-compose up -d
```

## 🎯 O que tem na Stack ZION?

### Base
- ✅ **n8n** sempre na última versão (atualiza todo dia automaticamente!)
- ✅ **Python 3** com pip
- ✅ **Git** para versionamento
- ✅ **FFmpeg** para processamento de mídia
- ✅ **ImageMagick** para manipulação de imagens

### Bibliotecas Python Incluídas
```python
pandas          # Análise de dados
requests        # Requisições HTTP
beautifulsoup4  # Web scraping
openai          # Integração com GPT
selenium        # Automação web
playwright      # Automação moderna
```

### Configurações Otimizadas
- 🇧🇷 Timezone Brasil configurado
- 🔧 Performance otimizada
- 🔐 Segurança reforçada
- 📦 Zero configuração necessária

## 🔄 Atualização

A imagem é **reconstruída automaticamente** todo dia com a última versão do n8n!

```bash
# Para atualizar sua instância
docker-compose pull
docker-compose up -d
```

## 📊 Variáveis de Ambiente

```yaml
# Básicas (já configuradas)
GENERIC_TIMEZONE: America/Sao_Paulo
TZ: America/Sao_Paulo

# Opcionais
N8N_ENCRYPTION_KEY: sua_chave_segura
N8N_BASIC_AUTH_USER: admin
N8N_BASIC_AUTH_PASSWORD: senha_forte
WEBHOOK_URL: https://seu-dominio.com/
```

## 🛠️ Personalização

### Quer adicionar algo?

1. Fork este repo
2. Edite o `Dockerfile`:

```dockerfile
# Adicione suas ferramentas
RUN apk add --no-cache sua-ferramenta

# Adicione suas libs Python
RUN pip3 install sua-lib
```

3. Push = Nova build automática!

### Nodes Customizados

Coloque seus nodes em `/zion-nodes` e eles serão incluídos automaticamente:

```dockerfile
COPY zion-nodes /home/node/.n8n/custom
```

## 🔗 Links Úteis

- 📦 [Docker Hub](https://hub.docker.com/r/zion/n8n)
- 💬 [Comunidade Zion](https://t.me/zioncommunity)
- 📚 [Documentação n8n](https://docs.n8n.io)
- 🐛 [Reportar Problema](https://github.com/zion/n8n/issues)

## 🏗️ Build Local

```bash
# Clone
git clone https://github.com/zion/n8n.git
cd n8n

# Build
docker build -t zion/n8n:local .

# Run
docker run -d -p 5678:5678 zion/n8n:local
```

## 📈 Status

- **Última Build:** ![Build Date](https://img.shields.io/docker/automated/zion/n8n)
- **Tamanho:** ![Image Size](https://img.shields.io/docker/image-size/zion/n8n/latest)
- **n8n Version:** ![n8n Version](https://img.shields.io/badge/dynamic/json?url=https://api.github.com/repos/n8n-io/n8n/releases/latest&label=n8n&query=$.tag_name)

## 🤝 Contribuindo

PRs são bem-vindos! 

```bash
# 1. Fork
# 2. Crie sua branch
git checkout -b feature/minha-feature

# 3. Commit
git commit -m "feat: adiciona X"

# 4. Push
git push origin feature/minha-feature

# 5. Abra um PR
```

## 📝 Licença

MIT - Use como quiser!

---

<div align="center">
  
**Feito com ❤️ pela Comunidade Zion**

[Telegram](https://t.me/zioncommunity) • [Discord](https://discord.gg/zion) • [GitHub](https://github.com/zion)

</div>
