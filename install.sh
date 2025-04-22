#!/bin/bash

# 检查是否root用户，否则尝试sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "⚠️ 需要root权限，尝试使用sudo..."
    sudo -v || { echo "❌ 无法获取sudo权限"; exit 1; }
fi

# 记录清理前的磁盘空间
echo "📊 清理前磁盘使用情况:"
df -h /var/cache/apt/

# 执行清理
echo "🧹 正在清理APT缓存..."
apt-get clean -y || { echo "❌ APT清理失败"; exit 1; }

# 记录清理后的磁盘空间
echo "✅ 清理完成！"
echo "📊 清理后磁盘使用情况:"
df -h /var/cache/apt/
