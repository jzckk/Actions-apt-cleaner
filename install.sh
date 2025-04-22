#!/bin/bash

echo "=============================="
echo "   Actions-apt-cleaner 初始化"
echo "=============================="

WORKDIR="/tmp/apt-cleaner"
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit 1

echo "[1] 下载脚本..."
curl -L -o apt-clean.sh https://raw.githubusercontent.com/jzckk/Actions-apt-cleaner/main/scripts/apt-clean.sh

chmod +x apt-clean.sh

echo "[2] 执行清理..."
sudo ./apt-clean.sh

echo "✅ 清理完成。系统已优化。"
