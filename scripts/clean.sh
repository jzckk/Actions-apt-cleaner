#!/bin/bash
set -eo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# 加载配置
EXCLUDE_FILE="/etc/apt-cleaner/exclude.list"
declare -a EXCLUDE_PKGS
if [ -f "$EXCLUDE_FILE" ]; then
    mapfile -t EXCLUDE_PKGS < <(grep -vE '^#|^$' "$EXCLUDE_FILE")
fi

# 初始化日志
LOG_DIR="/var/log/apt-cleaner"
LOG_FILE="$LOG_DIR/clean-$(date +%Y%m%d).log"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

# 磁盘空间检查
MIN_SPACE_GB=5
current_space_gb=$(df / --output=avail -B1 | awk 'NR==2 {print $1/1024/1024/1024}')
if (( $(echo "$current_space_gb < $MIN_SPACE_GB" | bc -l) )); then
    echo -e "${RED}❌ 剩余空间不足 ${MIN_SPACE_GB}GB，清理已终止！${NC}"
    exit 1
fi

# 模拟运行模式
DRY_RUN=0
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=1
    echo -e "${YELLOW}🔍 模拟运行模式开启，仅显示将要执行的操作${NC}"
fi

# 内核清理逻辑
clean_kernels() {
    echo -e "\n${CYAN}========== 内核清理 ==========${NC}"
    current_kernel=$(uname -r | sed 's/-.*//')
    echo -e "${YELLOW}当前运行内核：${NC} $current_kernel"

    all_kernels=($(dpkg -l | awk '/linux-image-[0-9]/ {print $2}' | sort -Vr))
    keep_list=("${all_kernels[0]}" "${all_kernels[1]}")

    for kernel in "${all_kernels[@]}"; do
        if [[ " ${keep_list[@]} " =~ " $kernel " ]] || [[ " ${EXCLUDE_PKGS[@]} " =~ " $kernel " ]]; then
            echo -e "${GREEN}✔ 保留内核：$kernel${NC}"
            continue
        fi

        if [ $DRY_RUN -eq 1 ]; then
            echo -e "${YELLOW}🔸 [模拟] 将移除内核：$kernel${NC}"
        else
            echo -e "${RED}⚠ 正在移除内核：$kernel${NC}"
            apt-get purge -y "$kernel"
        fi
    done
}

# 主清理流程
main_clean() {
    echo -e "${CYAN}\n========== APT Cleaner 开始执行 $(date '+%F %T') ==========${NC}"

    echo -e "\n${CYAN}========== 清理无用软件包 ==========${NC}"
    if [ $DRY_RUN -eq 1 ]; then
        apt autoremove --dry-run
        apt clean --dry-run
    else
        apt autoremove -y
        apt clean
    fi

    clean_kernels

    echo -e "\n${CYAN}========== 清理临时文件 ==========${NC}"
    find /tmp /var/tmp -type f -mtime +2 -print -delete

    echo -e "\n${GREEN}✅ 清理完成！当前磁盘使用情况：${NC}"
    df -h /

    echo -e "\n📁 日志已保存至：${LOG_FILE}"
}

main_clean
