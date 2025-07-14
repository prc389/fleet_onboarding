#!/bin/bash

# --- Ubuntu System Setup Script ---
# This script automates the process of updating and upgrading Ubuntu,
# installing Node.js, npm, curl, and a .deb package.

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting Ubuntu system setup..."

# 1. Update and Upgrade System Packages
echo "--- Step 1: Updating and upgrading system packages ---"
sudo apt update -y
sudo apt upgrade -y
echo "System packages updated and upgraded."

# 2. Install Curl (if not already installed)
echo "--- Step 2: Installing curl ---"
if ! command -v curl &> /dev/null
then
    sudo apt install curl -y
    echo "Curl installed."
else
    echo "Curl is already installed."
fi

# 3. Install Node.js (LTS version) and npm
# We use NodeSource to get the latest LTS version of Node.js
echo "--- Step 3: Installing Node.js (LTS) and npm ---"
# Check if Node.js is already installed
if ! command -v node &> /dev/null
then
    # Add NodeSource Node.js LTS repository
    # This command fetches the setup script for the current LTS version and pipes it to bash.
    # Replace 'node_20.x' with your desired LTS version (e.g., 'node_18.x', 'node_22.x') if needed.
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    echo "Node.js and npm installed."
else
    echo "Node.js is already installed."
fi

# Verify Node.js and npm installation
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"

# 4. Install fleet.deb
# IMPORTANT: Replace 'YOUR_FLEET_DEB_DOWNLOAD_URL' with the actual download URL for fleet.deb
# If you have the file locally, you can skip the wget part and just run dpkg.
echo "--- Step 4: Downloading and installing fleet.deb ---"
FLEET_DEB_URL="YOUR_FLEET_DEB_DOWNLOAD_URL" # <<<--- REPLACE THIS WITH THE ACTUAL URL
FLEET_DEB_FILE="fleet.deb"

if [ "$FLEET_DEB_URL" = "YOUR_FLEET_DEB_DOWNLOAD_URL" ]; then
    echo "WARNING: Please replace 'YOUR_FLEET_DEB_DOWNLOAD_URL' with the actual URL for fleet.deb."
    echo "Skipping fleet.deb download and installation for now."
else
    echo "Attempting to download $FLEET_DEB_URL..."
    wget -O "$FLEET_DEB_FILE" "$FLEET_DEB_URL"

    if [ -f "$FLEET_DEB_FILE" ]; then
        echo "Downloaded $FLEET_DEB_FILE. Installing..."
        sudo dpkg -i "$FLEET_DEB_FILE"
        echo "Running apt --fix-broken install to resolve any dependencies..."
        sudo apt --fix-broken install -y
        echo "$FLEET_DEB_FILE installed."
    else
        echo "Failed to download $FLEET_DEB_FILE. Please check the URL and your internet connection."
    fi
fi

echo "All specified tasks completed!"
echo "You may need to reboot your system for some changes to take full effect."
