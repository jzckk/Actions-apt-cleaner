#!/bin/bash

echo "=========================="
echo " APT Cleaner Script Start"
echo "=========================="

echo "[Step 1] Update package lists"
sudo apt update

echo "[Step 2] Remove unused packages"
sudo apt autoremove -y

echo "[Step 3] Clean up cache"
sudo apt clean

echo "[Step 4] Disk usage after cleaning:"
df -h /

echo "=========================="
echo " APT Cleaner Script Done"
echo "=========================="
