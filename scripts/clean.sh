#!/bin/bash
set -eo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

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

# 伪进度条函数
progress_bar() {
    local msg=$1
    echo -ne "${CYAN}${msg}${NC} ["
    for i in {1..20}; do
        echo -ne "#"
        sleep 0.03
    done
    echo "] ✅"
}

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
    echo -e "${YELLOW}正在检查系统中不再需要的包和缓存...${NC}"
    progress_bar "分析系统包"
    if [ $DRY_RUN -eq 1 ]; then
        apt autoremove --dry-run
        apt clean --dry-run
    else
        apt autoremove -y | sed \
            -e 's/Reading package lists.../正在读取软件包列表.../' \
            -e 's/Building dependency tree.../正在构建依赖关系树.../' \
            -e 's/Reading state information.../正在读取状态信息.../'
        apt clean
    fi

    clean_kernels

    echo -e "\n${CYAN}========== 清理临时文件 ==========${NC}"
    echo -e "${YELLOW}正在删除超过48小时的临时文件...${NC}"
    progress_bar "扫描临时目录"
    find /tmp /var/tmp -type f -mtime +2 -print -delete

    echo -e "\n${GREEN}✅ 清理完成！当前磁盘使用情况：${NC}"
    df -h /

    echo -e "\n📁 日志已保存至：${BOLD}${LOG_FILE}${NC}"
}

main_clean
