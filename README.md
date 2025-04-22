# Actions-apt-cleaner

![License](https://img.shields.io/github/license//Actions-apt-cleaner)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status//Actions-apt-cleaner/cleanup.yml?label=Auto%20Clean)

> 🧹 Automatically clean up unnecessary `apt` packages using GitHub Actions.

## ✨ About

`Actions-apt-cleaner` is a simple GitHub Actions workflow that runs automatically to clean up unused `apt` packages and dependencies from your Linux system. It's useful for:

- Keeping CI build images clean and minimal
- Reducing unnecessary package bloat
- Automating periodic system maintenance

## 🛠 How It Works

This project uses GitHub Actions to:

1. Run `apt autoremove`
2. Run `apt clean`
3. Optionally run `apt update && apt upgrade` before cleanup

All steps are automated via a GitHub Actions workflow file.

## 📁 Directory Structure

```bash
.
├── .github
│   └── workflows
│       └── cleanup.yml  # Main automation script
├── LICENSE
└── README.md
