#!/bin/bash
set -euo pipefail

# 定义颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# 检测系统兼容性
check_os() {
    if ! grep -qEi 'ubuntu|debian' /etc/os-release; then
        echo -e "${RED}错误：仅支持 Ubuntu/Debian 系统${NC}" >&2
        exit 1
    fi
}

# 安装依赖
install_deps() {
    echo -e "${YELLOW}[1/5] 安装系统依赖...${NC}"
    apt-get update -qq
    apt-get install -qq -y cron logrotate curl
}

# 部署清理脚本
deploy_scripts() {
    echo -e "${YELLOW}[2/5] 下载核心脚本...${NC}"
    local bin_dir="/usr/local/bin"
    local conf_dir="/etc/apt-cleaner"
    
    mkdir -p "$conf_dir"
    
    # 下载主清理脚本
    curl -sL https://raw.githubusercontent.com/jzckk/Actions-apt-cleaner/main/clean.sh \
        -o "$bin_dir/apt-cleaner"
    chmod 755 "$bin_dir/apt-cleaner"
    
    # 下载配置文件
    curl -sL https://raw.githubusercontent.com/jzckk/Actions-apt-cleaner/main/config/exclude.list \
        -o "$conf_dir/exclude.list"
}

# 配置日志轮转
setup_logrotate() {
    echo -e "${YELLOW}[3/5] 配置日志管理...${NC}"
    cat > /etc/logrotate.d/apt-cleaner <<EOF
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
}

# 设置定时任务
setup_cron() {
    echo -e "${YELLOW}[4/5] 配置自动任务...${NC}"
    local cron_job="30 3 * * * root /usr/local/bin/apt-cleaner"
    
    if ! grep -qF "apt-cleaner" /etc/cron.d/apt-cleaner 2>/dev/null; then
        echo "$cron_job" > /etc/cron.d/apt-cleaner
        chmod 644 /etc/cron.d/apt-cleaner
    fi
}

# 完成提示
show_result() {
    echo -e "${GREEN}[5/5] 安装完成！${NC}"
    echo -e "\n${YELLOW}使用命令：${NC}"
    echo "手动清理：sudo apt-cleaner"
    echo "查看日志：tail -f /var/log/apt-cleaner/latest.log"
    echo -e "\n${YELLOW}定时任务配置：${NC}"
    systemctl status cron | grep "Active:"
}

# 主执行流程
main() {
    check_os
    install_deps
    deploy_scripts
    setup_logrotate
    setup_cron
    show_result
}

main
