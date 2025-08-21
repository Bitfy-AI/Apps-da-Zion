FROM directus/directus:latest

USER root

# Copia seu schema
COPY ./schema.json /directus/schema.json

# Cria um arquivo de script mais legível
RUN cat > /init.sh << 'EOF'
#!/bin/sh
echo "🚀 Iniciando Directus..."
npx directus bootstrap
echo "📋 Aplicando schema..."
npx directus schema apply --yes /directus/schema.json || true
echo "✅ Iniciando servidor..."
npx directus start
EOF

# Torna o script executável
RUN chmod +x /init.sh

USER node

# Quando o container iniciar, execute nosso script
ENTRYPOINT ["/init.sh"]
