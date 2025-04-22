# Actions-apt-cleaner

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/jzckk/Actions-apt-cleaner/cleanup.yml)
![License](https://img.shields.io/github/license/jzckk/Actions-apt-cleaner)

一个自动化 APT 清理工具，适用于 Ubuntu/Debian 系统，可帮助你定期清理无用软件包和缓存，释放磁盘空间。支持 GitHub Actions 自动运行，也可本地一键执行。

## ✨ 功能

- 自动执行 `apt autoremove && apt clean`
- 支持 GitHub Actions 定时运行（每周）
- 清理日志可下载查看
- 提供一键执行入口

## 🚀 快速开始

### ✅ 方式一：在 GitHub Actions 中使用

1. Fork 本项目
2. 打开 Actions 页面，点击 `Run workflow` 即可立即执行
3. 或者等待每周定时清理
4. 执行后可下载清理日志

### ✅ 方式二：一键清理本地 VPS

无需克隆项目，只需执行：

```bash
bash <(curl -L -s https://raw.githubusercontent.com/jzckk/Actions-apt-cleaner/main/install.sh)
