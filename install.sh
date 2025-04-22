#!/bin/bash

echo "🧼 Starting apt cleanup..."

echo "📦 Updating and upgrading packages..."
apt update && apt upgrade -y

echo "🗑 Running autoremove..."
apt autoremove -y

echo "🧹 Cleaning apt cache..."
apt clean

echo "✅ Done. System cleaned!"
