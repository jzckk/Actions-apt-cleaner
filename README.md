# 🔄 APT Auto Cleaner

[![GitHub License](https://img.shields.io/github/license/jzckk/Actions-apt-cleaner)](https://github.com/jzckk/Actions-apt-cleaner/blob/main/LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/jzckk/Actions-apt-cleaner)](https://github.com/jzckk/Actions-apt-cleaner/stargazers)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/jzckk/Actions-apt-cleaner/clean.yml)](https://github.com/jzckk/Actions-apt-cleaner/actions)

专为 VPS 和嵌入式设备设计的自动化清理工具，通过智能清理 APT 缓存和旧内核，帮助节省磁盘空间并保持系统健康。

## ✨ 功能特性

- **自动化清理**：每日定时执行 `apt autoremove` 和 `apt clean`
- **安全防护**：
  - 保留当前运行内核及最近 2 个版本
  - 禁止在磁盘空间 <5GB 时执行清理
  - 支持自定义软件包排除列表
- **智能报告**：
  - 清理前后磁盘空间对比
  - 可追踪的详细日志记录
- **多模式运行**：
  - 模拟运行 (`--dry-run`) 预览操作
  - 本地定时任务 / GitHub Actions 远程执行

## 🚀 快速安装

### 一键部署（推荐）
```bash
# 标准安装（需要 root 权限）
sudo bash <(curl -sL https://raw.githubusercontent.com/jzckk/Actions-apt-cleaner/main/install.sh)

# 国内镜像加速安装
sudo bash <(curl -sL https://ghproxy.com/https://raw.githubusercontent.com/jzckk/Actions-apt-cleaner/main/install.sh)
