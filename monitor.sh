#!/bin/bash

# ============================================
# ZION N8N - Monitor de Versões e Status
# ============================================

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configurações
DOCKER_IMAGE="zion/n8n"
GITHUB_REPO="zion/n8n"
N8N_OFFICIAL="n8n-io/n8n"

# Banner
show_banner() {
    echo -e "${PURPLE}"
    cat << "EOF"
╔══════════════════════════════════════════╗
║         ZION N8N - Version Monitor       ║
╚══════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Verificar versão do n8n oficial
check_n8n_version() {
    echo -e "${CYAN}🔍 Verificando n8n oficial...${NC}"
    
    N8N_LATEST=$(curl -s "https://api.github.com/repos/${N8N_OFFICIAL}/releases/latest" | jq -r .tag_name)
    N8N_LATEST_CLEAN=${N8N_LATEST#n8n@}
    N8N_LATEST_CLEAN=${N8N_LATEST_CLEAN#v}
    
    echo -e "  📦 Última versão: ${GREEN}${N8N_LATEST_CLEAN}${NC}"
    
    # Data do release
    N8N_RELEASE_DATE=$(curl -s "https://api.github.com/repos/${N8N_OFFICIAL}/releases/latest" | jq -r .published_at | cut -d'T' -f1)
    echo -e "  📅 Lançado em: ${N8N_RELEASE_DATE}"
}

# Verificar nossa versão
check_our_version() {
    echo -e "\n${CYAN}🐳 Verificando ZION/N8N...${NC}"
    
    # Verificar no Docker Hub
    DOCKER_TAGS=$(curl -s "https://hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags?page_size=10" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        # Pegar tag latest
        LATEST_TAG=$(echo $DOCKER_TAGS | jq -r '.results[] | select(.name=="latest") | .name' 2>/dev/null)
        
        # Pegar versões
        echo -e "  📋 Tags disponíveis:"
        echo $DOCKER_TAGS | jq -r '.results[].name' 2>/dev/null | head -5 | while read tag; do
            if [ "$tag" == "latest" ]; then
                echo -e "    • ${GREEN}$tag${NC} (principal)"
            elif [ "$tag" == "$N8N_LATEST_CLEAN" ]; then
                echo -e "    • ${GREEN}$tag${NC} ✅ (atualizada)"
            else
                echo -e "    • $tag"
            fi
        done
        
        # Última atualização
        LAST_UPDATED=$(echo $DOCKER_TAGS | jq -r '.results[0].last_updated' 2>/dev/null | cut -d'T' -f1)
        echo -e "  📅 Última build: ${LAST_UPDATED}"
    else
        echo -e "  ${RED}❌ Não foi possível acessar Docker Hub${NC}"
    fi
}

# Verificar GitHub Actions
check_github_actions() {
    echo -e "\n${CYAN}⚙️  Verificando GitHub Actions...${NC}"
    
    # Últimas runs
    WORKFLOW_RUNS=$(curl -s "https://api.github.com/repos/${GITHUB_REPO}/actions/runs?per_page=5" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo -e "  📊 Últimas builds:"
        echo $WORKFLOW_RUNS | jq -r '.workflow_runs[] | "\(.status) - \(.conclusion // "running") - \(.created_at | split("T")[0])"' 2>/dev/null | head -3 | while read run; do
            if [[ $run == *"completed - success"* ]]; then
                echo -e "    ✅ $run"
            elif [[ $run == *"in_progress"* ]] || [[ $run == *"running"* ]]; then
                echo -e "    🔄 $run"
            else
                echo -e "    ❌ $run"
            fi
        done
    else
        echo -e "  ${YELLOW}⚠️  Repo privado ou sem acesso${NC}"
    fi
}

# Comparar versões
compare_versions() {
    echo -e "\n${CYAN}📊 Análise de Status:${NC}"
    
    # Verificar se precisamos atualizar
    DOCKER_TAGS=$(curl -s "https://hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags" 2>/dev/null)
    
    if echo $DOCKER_TAGS | grep -q "\"name\":\"$N8N_LATEST_CLEAN\""; then
        echo -e "  ${GREEN}✅ ZION/N8N está ATUALIZADO!${NC}"
        echo -e "  Versão: ${GREEN}$N8N_LATEST_CLEAN${NC}"
    else
        echo -e "  ${YELLOW}⚠️  Nova versão disponível!${NC}"
        echo -e "  n8n oficial: ${GREEN}$N8N_LATEST_CLEAN${NC}"
        echo -e "  ZION/N8N: ${YELLOW}Aguardando build automático${NC}"
        echo -e "  ${BLUE}ℹ️  A build automática ocorre 2x ao dia (00:00 e 12:00 UTC)${NC}"
    fi
}

# Verificar container local
check_local_container() {
    echo -e "\n${CYAN}🖥️  Verificando instalação local...${NC}"
    
    if command -v docker &> /dev/null; then
        # Verificar se tem container rodando
        CONTAINER=$(docker ps --filter "ancestor=${DOCKER_IMAGE}" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" 2>/dev/null | tail -n +2)
        
        if [ ! -z "$CONTAINER" ]; then
            echo -e "  ${GREEN}✅ Container rodando:${NC}"
            echo "    $CONTAINER"
            
            # Verificar versão do container
            CONTAINER_NAME=$(echo $CONTAINER | awk '{print $1}')
            CONTAINER_VERSION=$(docker exec $CONTAINER_NAME n8n --version 2>/dev/null || echo "unknown")
            echo -e "    Versão n8n: ${CYAN}$CONTAINER_VERSION${NC}"
        else
            echo -e "  ${YELLOW}ℹ️  Nenhum container ZION/N8N rodando${NC}"
        fi
        
        # Verificar imagem local
        LOCAL_IMAGE=$(docker images ${DOCKER_IMAGE} --format "table {{.Repository}}:{{.Tag}}\t{{.CreatedSince}}" 2>/dev/null | tail -n +2 | head -1)
        if [ ! -z "$LOCAL_IMAGE" ]; then
            echo -e "  📦 Imagem local: $LOCAL_IMAGE"
        fi
    else
        echo -e "  ${YELLOW}⚠️  Docker não instalado${NC}"
    fi
}

# Comandos úteis
show_commands() {
    echo -e "\n${CYAN}🚀 Comandos Úteis:${NC}"
    echo -e "${GREEN}Atualizar para última versão:${NC}"
    echo "  docker pull ${DOCKER_IMAGE}:latest"
    echo "  docker-compose down && docker-compose up -d"
    echo ""
    echo -e "${GREEN}Forçar build manual (se tiver acesso):${NC}"
    echo "  gh workflow run auto-build.yml -f force_build=true"
    echo ""
    echo -e "${GREEN}Ver todas as tags disponíveis:${NC}"
    echo "  docker run --rm curlimages/curl -s https://hub.docker.com/v2/repositories/${DOCKER_IMAGE}/tags | jq '.results[].name'"
}

# Menu principal
main_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}Escolha uma opção:${NC}"
        echo "  1) Verificação completa"
        echo "  2) Apenas versões"
        echo "  3) Status do GitHub Actions"
        echo "  4) Verificar instalação local"
        echo "  5) Comandos úteis"
        echo "  6) Monitoramento contínuo (atualiza a cada 60s)"
        echo "  0) Sair"
        echo ""
        read -p "Opção: " choice
        
        case $choice in
            1)
                clear
                show_banner
                check_n8n_version
                check_our_version
                check_github_actions
                compare_versions
                check_local_container
                echo ""
                read -p "Pressione ENTER para continuar..."
                ;;
            2)
                clear
                show_banner
                check_n8n_version
                check_our_version
                compare_versions
                echo ""
                read -p "Pressione ENTER para continuar..."
                ;;
            3)
                clear
                show_banner
                check_github_actions
                echo ""
                read -p "Pressione ENTER para continuar..."
                ;;
            4)
                clear
                show_banner
                check_local_container
                echo ""
                read -p "Pressione ENTER para continuar..."
                ;;
            5)
                clear
                show_banner
                show_commands
                echo ""
                read -p "Pressione ENTER para continuar..."
                ;;
            6)
                clear
                echo -e "${GREEN}Monitoramento iniciado (CTRL+C para parar)${NC}"
                while true; do
                    clear
                    show_banner
                    echo -e "${YELLOW}$(date '+%Y-%m-%d %H:%M:%S')${NC}"
                    echo ""
                    check_n8n_version
                    check_our_version
                    compare_versions
                    check_local_container
                    echo ""
                    echo -e "${CYAN}Próxima atualização em 60 segundos...${NC}"
                    sleep 60
                done
                ;;
            0)
                echo -e "${GREEN}Até logo!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Opção inválida!${NC}"
                sleep 1
                ;;
        esac
        clear
    done
}

# Execução rápida se passar parâmetro
if [ "$1" == "--check" ] || [ "$1" == "-c" ]; then
    check_n8n_version
    check_our_version
    compare_versions
elif [ "$1" == "--local" ] || [ "$1" == "-l" ]; then
    check_local_container
elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "Uso: $0 [opção]"
    echo "  --check, -c   : Verificação rápida de versões"
    echo "  --local, -l   : Verificar instalação local"
    echo "  --help, -h    : Mostrar esta ajuda"
    echo "  (sem opção)   : Menu interativo"
else
    # Menu interativo
    clear
    main_menu
fi
