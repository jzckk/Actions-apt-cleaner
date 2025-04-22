#!/bin/bash
set -euo pipefail

# ========= 配置 ========= #
BIN_DIR="/usr/local/bin"
CONF_DIR="/etc/apt-cleaner"
LOGROTATE_CONF="/etc/logrotate.d/apt-cleaner"
CRON_FILE="/etc/cron.d/apt-cleaner"
SCRIPT_URL_BASE="https://raw.githubusercontent.com/jzckk/Actions-apt-cleaner/main"

# ========= 颜色与图标 ========= #
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'
INFO="${CYAN}ℹ${NC}"
STEP="${YELLOW}➤${NC}"
OK="${GREEN}✔${NC}"
ERR="${RED}✖${NC}"

# ========= 检查系统 ========= #
check_os() {
    echo -e "${STEP} 检查系统兼容性..."
    if ! grep -qEi 'ubuntu|debian' /etc/os-release; then
        echo -e "${ERR} 当前系统不受支持，仅限 Ubuntu/Debian" >&2
        exit 1
    fi
    echo -e "${OK} 系统兼容"
}

# ========= 安装依赖 ========= #
install_deps() {
    echo -e "${STEP} 安装系统依赖..."
    apt-get update -qq
    apt-get install -qq -y cron logrotate curl
    echo -e "${OK} 依赖安装完成"
}

# ========= 下载脚本 ========= #
deploy_scripts() {
    echo -e "${STEP} 部署核心脚本..."
    mkdir -p "$CONF_DIR"

    curl -fsSL "$SCRIPT_URL_BASE/scripts/clean.sh" -o "$BIN_DIR/apt-cleaner"
    chmod +x "$BIN_DIR/apt-cleaner"

    curl -fsSL "$SCRIPT_URL_BASE/scripts/uninstall.sh" -o "$BIN_DIR/apt-cleaner-uninstall"
    chmod +x "$BIN_DIR/apt-cleaner-uninstall"

    curl -fsSL "$SCRIPT_URL_BASE/config/exclude.list" -o "$CONF_DIR/exclude.list"

    echo -e "${OK} 脚本部署完成"
}

# ========= 配置日志轮转 ========= #
setup_logrotate() {
    echo -e "${STEP} 配置日志轮转..."
    cat > "$LOGROTATE_CONF" <<EOF
/var/log/apt-cleaner/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 640 root root
}
EOF
    echo -e "${OK} 日志轮转配置完成"
}

# ========= 配置定时任务 ========= #
setup_cron() {
    echo -e "${STEP} 设置每日定时任务..."
    echo "30 3 * * * root $BIN_DIR/apt-cleaner" > "$CRON_FILE"
    chmod 644 "$CRON_FILE"
    echo -e "${OK} 已添加至 crontab（每天凌晨 3:30）"
}

# ========= 展示结果 ========= #
show_result() {
    echo -e "\n${GREEN}🎉 安装完成！${NC}"
    echo -e "${INFO} 使用方式："
    echo -e "  🧹 手动清理：       ${GREEN}sudo apt-cleaner${NC}"
    echo -e "  🗑️ 卸载工具：       ${GREEN}sudo apt-cleaner-uninstall${NC}"
    echo -e "  📄 查看日志：       ${GREEN}tail -f /var/log/apt-cleaner/latest.log${NC}"
    echo -e "\n${INFO} 定时任务状态："
    systemctl status cron | grep "Active:" || echo -e "${YELLOW}cron 服务未运行${NC}"
}

# ========= 主流程 ========= #
main() {
    echo -e "${CYAN}🚀 开始安装 APT Cleaner${NC}"
    check_os
    install_deps
    deploy_scripts
    setup_logrotate
    setup_cron
    show_result
}

main
