#!/bin/sh

# Common color definitions
PURPLE='\033[0;35m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Common logger function
log() {
    level=$1
    message=$2
    color=$3
    
    if [ -z "$color" ]; then
        color="$NC"
    fi
    
    printf "${color}[$level]${NC} $message\n"
}

# Function to detect architecture
detect_architecture() {
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64)
            echo "amd64"
        ;;
        aarch64)
            echo "arm64"
        ;;
        riscv64)
            echo "riscv64"
        ;;
        *)
            log "ERROR" "NodeのCPUが対応していません。管理者にお尋ねください。: $ARCH" "$RED" >&2
            return 1
        ;;
    esac
}

# Function to print the main banner
print_main_banner() {
    printf "\033c"
    printf "${CYAN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}\n"
    printf "${CYAN}║                                                                               ║${NC}\n"
    printf "${CYAN}║                                ${GREEN}  ArkHost VPS${CYAN}　                                ║${NC}\n"
    printf "${CYAN}║                               ${DIM}© $(date +%Y) ${PURPLE}©ArkHost ${CYAN}                                ║${NC}\n"
    printf "${CYAN}║                                                                               ║${NC}\n"
    printf "${CYAN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}\n"
    printf "\n"
}

# Function to print the help banner
print_help_banner() {
    printf "${BLUE}                           ${WHITE}${BOLD}📋   使用可能なコマンド  📋${BLUE}                              ${NC}\n"
    printf "${BLUE}                                                                               ${NC}\n"
    printf "${BLUE}                                                                               ${NC}\n"
    printf "${BLUE}  ${CYAN}🧹  ${YELLOW}${BOLD}clear, cls${NC}        ${GREEN}▶  ${WHITE}ターミナルをリセットする${BLUE}                                 ${NC}\n"
    printf "${BLUE}  ${RED}🔌  ${YELLOW}${BOLD}exit${NC}              ${GREEN}▶  ${WHITE}このVPSをシャットダウン${BLUE}                                 ${NC}\n"
    printf "${BLUE}  ${PURPLE}📜  ${YELLOW}${BOLD}history${NC}           ${GREEN}▶  ${WHITE}コマンド履歴を表示する${BLUE}                              ${NC}\n"
    printf "${BLUE}  ${CYAN}🔄  ${YELLOW}${BOLD}reinstall${NC}         ${GREEN}▶  ${WHITE}OSを再インストール${BLUE}                       ${NC}\n"
    printf "${BLUE}  ${GREEN}🔐  ${YELLOW}${BOLD}install-ssh${NC}       ${GREEN}▶  ${WHITE}カスタムSSHサーバーをインストール${BLUE}                            ${NC}\n"
    printf "${BLUE}  ${BLUE}📊  ${YELLOW}${BOLD}status${NC}            ${GREEN}▶  ${WHITE}VPSの詳細ステータスを表示する${BLUE}                          ${NC}\n"
    printf "${BLUE}  ${YELLOW}💾  ${YELLOW}${BOLD}backup${NC}            ${GREEN}▶  ${WHITE}VPSのバックアップを作成する${BLUE}                      ${NC}\n"
    printf "${BLUE}  ${PURPLE}📥  ${YELLOW}${BOLD}restore${NC}           ${GREEN}▶  ${WHITE}過去のバックアップを復元する${BLUE}                         ${NC}\n"
    printf "${BLUE}  ${WHITE}❓  ${YELLOW}${BOLD}help${NC}              ${GREEN}▶  ${WHITE}このヘルプ画面を表示する${BLUE}                        ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}                          ${WHITE}${BOLD}🖥  GUI / リモートデスクトップ 🖥${BLUE}                            ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}  ${CYAN}💻  ${YELLOW}${BOLD}install-gui${NC}       ${GREEN}▶  ${WHITE}デスクトップ環境とVNCのインストール${BLUE}                    ${NC}\n"
    printf "${BLUE}  ${GREEN}🟢  ${YELLOW}${BOLD}start-vnc${NC}         ${GREEN}▶  ${WHITE}VNCを起動する${BLUE}                                     ${NC}\n"
    printf "${BLUE}  ${RED}🔴  ${YELLOW}${BOLD}stop-vnc${NC}          ${GREEN}▶  ${WHITE}VNCを停止する${BLUE}                                      ${NC}\n"
    printf "${BLUE}  ${GREEN}🌐  ${YELLOW}${BOLD}start-novnc${NC}       ${GREEN}▶  ${WHITE}noVNCを起動する（ブラウザ経由でのアクセス）${BLUE}                         ${NC}\n"
    printf "${BLUE}  ${RED}🌐  ${YELLOW}${BOLD}stop-novnc${NC}        ${GREEN}▶  ${WHITE}noVNCを停止する${BLUE}                                           ${NC}\n"
    printf "${BLUE}  ${GREEN}🚇  ${YELLOW}${BOLD}start-tunnel${NC}      ${GREEN}▶  ${WHITE}Cloudflareトンネルを開始する（パブリックURL）${BLUE}                 ${NC}\n"
    printf "${BLUE}  ${RED}🚇  ${YELLOW}${BOLD}stop-tunnel${NC}       ${GREEN}▶  ${WHITE}Cloudflareトンネルを停止する${BLUE}                               ${NC}\n"
    printf "${BLUE}  ${PURPLE}📊  ${YELLOW}${BOLD}gui-status${NC}        ${GREEN}▶  ${WHITE}GUIサーバーの状態を表示${BLUE}                               ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}                     ${DIM}💡 何かコマンドを入力して開始してください${BLUE}                   ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "${BLUE}                                                                                 ${NC}\n"
    printf "\n"
}
