# Actions-apt-cleaner

一个 GitHub Actions 自动化项目，用于定期清理 Ubuntu/Debian 系统中无用的软件包和缓存，节省磁盘空间，保持系统整洁。

## ✨ 功能
- 自动执行 `apt autoremove && apt clean`
- 每周定期运行，或可手动触发
- 日志输出清晰，便于排查
- 使用 Bash + GitHub Actions 实现，简单可靠

## 🚀 使用方式

1. Fork 本项目或复制结构
2. 在 GitHub Actions 页面手动触发 `Clean APT Cache`，或等待定时任务自动执行
3. 查看日志结果，确认清理是否成功

## 📁 项目结构

## 🧩 一键清理脚本（可用于 VPS / 本地）

无需克隆项目，只需一行命令：

```bash
bash <(curl -L -s https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/Actions-apt-cleaner/main/install.sh)
