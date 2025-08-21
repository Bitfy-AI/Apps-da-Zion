# 🚀 ZION N8N - Smart Auto Builder

## ✨ O que o Smart Builder faz:

1. **Verifica** a versão do n8n oficial 2x por dia
2. **Compara** com a versão que já buildamos
3. **Só builda se necessário** (economia de recursos)
4. **Tageia corretamente** com a versão do n8n
5. **Notifica** a comunidade quando houver update
6. **Multi-arquitetura** (amd64 e arm64)

## 📁 Estrutura Final

```
zion-n8n/
├── .github/
│   └── workflows/
│       └── auto-build.yml    # Smart builder
├── Dockerfile                 # Com versionamento
├── healthcheck.sh            # Script de health
├── monitor.sh                # Script de monitoramento
├── docker-compose.yml        # Para a comunidade
└── README.md
```

## 🎯 Setup Completo (5 minutos)

### 1️⃣ Criar Repositório

```bash
# Criar e entrar no diretório
mkdir zion-n8n && cd zion-n8n

# Inicializar git
git init
```

### 2️⃣ Copiar os Arquivos

1. **Dockerfile** (artifact: `zion-dockerfile-smart`)
2. **auto-build.yml** (artifact: `zion-smart-builder`) 
3. **monitor.sh** (artifact: `zion-monitor-script`)

### 3️⃣ Criar healthcheck.sh

```bash
cat > healthcheck.sh << 'EOF'
#!/bin/sh
if curl -f http://localhost:5678/healthz 2>/dev/null; then
    echo "✅ ZION N8N is healthy"
    exit 0
else
    echo "❌ ZION N8N is not responding"
    exit 1
fi
EOF

chmod +x healthcheck.sh
```

### 4️⃣ Push para GitHub

```bash
# Adicionar arquivos
git add .
git commit -m "🚀 ZION N8N Smart Builder"

# Criar repo no GitHub
gh repo create zion-n8n --public --source=.

# Push
git push -u origin main
```

### 5️⃣ Configurar Secrets no GitHub

Vá em **Settings > Secrets and variables > Actions** e adicione:

| Secret | Valor | Obrigatório |
|--------|-------|-------------|
| `DOCKER_USERNAME` | seu_usuario | ✅ Sim |
| `DOCKER_PASSWORD` | sua_senha | ✅ Sim |
| `TELEGRAM_TOKEN` | token_bot | ❌ Opcional |
| `TELEGRAM_CHAT_ID` | @canal | ❌ Opcional |
| `DISCORD_WEBHOOK` | url_webhook | ❌ Opcional |

## 🎮 Como Funciona

### Build Automático
- **Executa 2x ao dia** (00:00 e 12:00 UTC)
- **Verifica** se há nova versão do n8n
- **Só builda se necessário**

### Build Manual
```bash
# Via GitHub CLI
gh workflow run auto-build.yml -f force_build=true

# Ou pelo GitHub UI
Actions > ZION N8N Smart Build > Run workflow > force_build: true
```

### Monitoramento
```bash
# Verificar status
./monitor.sh --check

# Menu interativo
./monitor.sh

# Monitoramento contínuo
./monitor.sh
# Escolha opção 6
```

## 📊 Tags Criadas Automaticamente

Para cada versão nova, são criadas as tags:

- `zion/n8n:latest` - sempre a mais recente
- `zion/n8n:1.23.0` - versão específica do n8n
- `zion/n8n:1.23.0-20240115` - versão + data do build
- `zion/n8n:stable` - última versão estável (sem -beta)

## 🔔 Notificações

Quando houver nova versão, o sistema:

1. **Cria Release** no GitHub
2. **Notifica Telegram** (se configurado)
3. **Notifica Discord** (se configurado)
4. **Atualiza Docker Hub** com as tags

## 📈 Vantagens do Smart Builder

| Feature | Benefício |
|---------|-----------|
| **Build Inteligente** | Só builda quando necessário |
| **Versionamento Correto** | Tags com versão real do n8n |
| **Multi-arquitetura** | Funciona em ARM (Raspberry) |
| **Notificações** | Comunidade sempre informada |
| **Cache Otimizado** | Builds mais rápidas |
| **Healthcheck** | Monitora saúde do container |

## 🎯 Para a Comunidade

### Instalação Simples
```bash
# Última versão
docker run -d -p 5678:5678 zion/n8n:latest

# Versão específica
docker run -d -p 5678:5678 zion/n8n:1.23.0
```

### Sempre Atualizado
```bash
# Pull da nova versão
docker pull zion/n8n:latest

# Restart
docker-compose restart
```

## 🛠 Customizações Extras

### Adicionar mais ferramentas no Dockerfile:
```dockerfile
RUN apk add --no-cache \
    sua-ferramenta \
    outro-pacote

RUN pip3 install \
    seu-modulo-python
```

### Ajustar frequência de verificação:
```yaml
schedule:
  - cron: '0 */4 * * *'  # A cada 4 horas
```

### Adicionar mais notificações:
```yaml
- name: Email
  uses: dawidd6/action-send-mail@v3
  with:
    to: comunidade@zion.dev
    subject: Nova versão ZION/N8N
```

## ✅ Checklist Final

- [ ] Repositório criado no GitHub
- [ ] Arquivos copiados (Dockerfile, workflows, etc)
- [ ] Secrets configurados (Docker Hub credentials)
- [ ] Primeiro push feito
- [ ] GitHub Actions rodando
- [ ] Imagem disponível no Docker Hub
- [ ] Comunidade notificada

## 🚀 Resultado

Você terá:
- ✅ **Build automático** apenas quando necessário
- ✅ **Versionamento correto** com tags do n8n
- ✅ **Zero manutenção** após configurar
- ✅ **Comunidade feliz** com updates automáticos
- ✅ **Economia de recursos** (não builda à toa)

---

## 💡 Dica Pro

Use o badge no README da comunidade:

```markdown
[![ZION N8N Version](https://img.shields.io/docker/v/zion/n8n/latest?label=ZION%20N8N)](https://hub.docker.com/r/zion/n8n)
[![Build Status](https://github.com/zion/n8n/actions/workflows/auto-build.yml/badge.svg)](https://github.com/zion/n8n/actions)
```

Isso mostra sempre a versão atual e o status do build! 🎯
