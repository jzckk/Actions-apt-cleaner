#!/bin/bash
set -eo pipefail

# 彩色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}⚙ 开始卸载 APT Cleaner...${NC}"

# 删除命令脚本
if [ -f "/usr/local/bin/apt-cleaner" ]; then
    rm -f /usr/local/bin/apt-cleaner
    echo -e "${GREEN}✔ 已移除命令链接：/usr/local/bin/apt-cleaner${NC}"
fi

# 删除卸载命令自身（延迟删除）
if [ -f "/usr/local/bin/apt-cleaner-uninstall" ]; then
    (sleep 1 && rm -f /usr/local/bin/apt-cleaner-uninstall) &
    echo -e "${GREEN}✔ 即将删除卸载命令：/usr/local/bin/apt-cleaner-uninstall${NC}"
fi

# 删除配置
if [ -d "/etc/apt-cleaner" ]; then
    rm -rf /etc/apt-cleaner
    echo -e "${GREEN}✔ 已删除配置目录：/etc/apt-cleaner${NC}"
fi

# 删除日志
if [ -d "/var/log/apt-cleaner" ]; then
    rm -rf /var/log/apt-cleaner
    echo -e "${GREEN}✔ 已删除日志目录：/var/log/apt-cleaner${NC}"
fi

# 删除定时任务
if [ -f "/etc/cron.d/apt-cleaner" ]; then
    rm -f /etc/cron.d/apt-cleaner
    echo -e "${GREEN}✔ 已删除定时任务：/etc/cron.d/apt-cleaner${NC}"
fi

echo -e "${GREEN}✅ APT Cleaner 已彻底卸载。${NC}"
