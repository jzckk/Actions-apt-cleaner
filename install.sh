#!/bin/bash

set -e

echo "=============================="
echo "   Actions-apt-cleaner 初始化"
echo "=============================="

WORKDIR="/tmp/apt-cleaner"
mkdir -p "$WORKDIR"
cd "$WORKDIR" || exit 1

echo "[1] 下载清理脚本..."
if ! curl -fsSL -o apt-clean.sh https://raw.githubusercontent.com/jzckk/Actions-apt-cleaner/main/scripts/apt-clean.sh; then
  echo "❌ 下载失败，请检查网络连接或脚本 URL 是否正确。"
  exit 1
fi

chmod +x apt-clean.sh

echo "[2] 执行清理脚本..."
if ! sudo ./apt-clean.sh; then
  echo "❌ 清理脚本执行失败，请检查脚本内容或系统权限设置。"
  exit 1
fi

echo "✅ 清理完成。系统已优化。"

# 清理临时文件
cd ~
rm -rf "$WORKDIR"
