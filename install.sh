#!/bin/bash
# Install script for Actions-apt-cleaner

# Download and execute the clean_apt_cache.sh script
curl -sSL https://raw.githubusercontent.com/jzckk/Actions-apt-cleaner/main/clean_apt_cache.sh -o clean_apt_cache.sh

# Make it executable
chmod +x clean_apt_cache.sh

# Execute the script
./clean_apt_cache.sh
