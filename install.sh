#!/bin/bash

# buny installation script
# Installs buny to /usr/local/bin/buny

set -e

INSTALL_DIR="/usr/local/bin"
BUNY_URL="https://raw.githubusercontent.com/lattiece/buny/main/buny"
INSTALL_PATH="$INSTALL_DIR/buny"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo"
    exit 1
fi

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "curl is required but not installed"
    exit 1
fi

# Check if buny is already installed
if [ -f "$INSTALL_PATH" ]; then
    echo "buny is already installed at $INSTALL_PATH"
    echo "Use 'buny' to run it or 'sudo buny uninstall' to remove it"
    exit 0
fi

# Download and install buny
echo "Downloading buny from $BUNY_URL..."
if ! curl -s -L "$BUNY_URL" -o "$INSTALL_PATH"; then
    echo "Failed to download buny"
    exit 1
fi

# Make it executable
chmod +x "$INSTALL_PATH"

# Ask if user wants automatic execution on terminal start
echo ""
echo "Enable automatic buny execution on terminal start?"
echo "    This will make buny run automatically every time you open a terminal!"
read -p "     Enable automatic execution? (y/N): " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Detect shell and add to appropriate config file
    SHELL_CONFIG=""
    
    if [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    elif [ -f "$HOME/.zshrc" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -f "$HOME/.profile" ]; then
        SHELL_CONFIG="$HOME/.profile"
    fi
    
    if [ -n "$SHELL_CONFIG" ]; then
        echo ""
        echo "Adding buny to $SHELL_CONFIG for automatic execution..."
        echo "" >> "$SHELL_CONFIG"
        echo "# buny - Trust Fate, Embrace the Unknown" >> "$SHELL_CONFIG"
        echo "# WARNING: This can crash your terminal at any moment!" >> "$SHELL_CONFIG"
        echo "if command -v buny &> /dev/null; then" >> "$SHELL_CONFIG"
        echo "    buny &" >> "$SHELL_CONFIG"
        echo "fi" >> "$SHELL_CONFIG"
        echo "" >> "$SHELL_CONFIG"
        echo "✓ Automatic execution enabled!"
        echo "buny will now run automatically every time you open a terminal!"
    else
        echo "Could not detect shell configuration file. Automatic execution not enabled."
    fi
fi

echo ""
echo "buny installed successfully!"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "You can now open a new terminal to experience buny automatically."
else
    echo "You can run 'buny' manually from anywhere in your terminal."
fi
echo "WARNING: buny can crash your terminal at any moment!"
