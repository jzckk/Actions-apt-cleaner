#!/bin/bash
set -eo pipefail

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
    echo "剩余空间不足${MIN_SPACE_GB}GB，清理已终止！"
    exit 1
fi

# 模拟运行模式
DRY_RUN=0
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=1
    echo "=== 模拟运行模式 ==="
fi

# 内核清理逻辑
clean_kernels() {
    current_kernel=$(uname -r | sed 's/-.*//')
    echo "当前运行内核: $current_kernel"
    
    all_kernels=($(dpkg -l | awk '/linux-image-[0-9]/ {print $2}' | sort -Vr))
    keep_list=("${all_kernels[0]}" "${all_kernels[1]}")
    
    for kernel in "${all_kernels[@]}"; do
        if [[ " ${keep_list[@]} " =~ " $kernel " ]] || [[ " ${EXCLUDE_PKGS[@]} " =~ " $kernel " ]]; then
            echo "保留内核: $kernel"
            continue
        fi
        
        if [ $DRY_RUN -eq 1 ]; then
            echo "[模拟] 将移除内核: $kernel"
        else
            echo "正在移除内核: $kernel"
            apt-get purge -y "$kernel"
        fi
    done
}

# 主清理流程
main_clean() {
    echo "=== 开始清理 $(date '+%F %T') ==="
    
    # APT清理
    if [ $DRY_RUN -eq 1 ]; then
        apt autoremove --dry-run
        apt clean --dry-run
    else
        apt autoremove -y
        apt clean
    fi
    
    # 内核清理
    clean_kernels
    
    # 临时文件清理（保留48小时内）
    find /tmp /var/tmp -type f -mtime +2 -delete
    
    echo "=== 清理完成 ==="
    df -h /
}

main_clean
