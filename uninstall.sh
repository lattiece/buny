#!/bin/bash

# buny uninstallation script
# Removes buny from /usr/local/bin/buny

set -e

INSTALL_DIR="/usr/local/bin"
INSTALL_PATH="$INSTALL_DIR/buny"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo"
    exit 1
fi

# Check if buny is installed
if [ ! -f "$INSTALL_PATH" ]; then
    echo "buny is not installed at $INSTALL_PATH"
    exit 0
fi

# Remove buny
echo "Removing buny from $INSTALL_PATH..."
rm -f "$INSTALL_PATH"

# Remove automatic execution from shell config files
echo "Removing automatic execution from shell configuration files..."
SHELL_FILES=("$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.zshrc" "$HOME/.profile")

for shell_file in "${SHELL_FILES[@]}"; do
    if [ -f "$shell_file" ]; then
        # Remove buny-related lines (cross-platform sed)
        if [ "$(uname)" = "Darwin" ]; then
            sed -i '' '/# buny - Trust Fate, Embrace the Unknown/,/^fi$/d' "$shell_file"
        else
            sed -i '/# buny - Trust Fate, Embrace the Unknown/,/^fi$/d' "$shell_file"
        fi
        echo "  Cleaned $shell_file"
    fi
done

echo "buny has been uninstalled successfully!"
