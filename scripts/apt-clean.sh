#!/bin/bash

LOG_FILE="/tmp/apt-clean.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=========================="
echo " APT Cleaner Script Start"
echo "=========================="

echo "[Step 1] 更新软件包列表"
sudo apt update

echo "[Step 2] 移除无用软件包"
sudo apt autoremove -y

echo "[Step 3] 清理缓存"
sudo apt clean

echo "[Step 4] 当前磁盘使用情况："
df -h /

echo "=========================="
echo " APT Cleaner Script Done"
echo "=========================="
