#!/bin/bash

# Detect shell config file
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    echo "Unsupported shell. Please add alias manually."
    exit 1
fi

# Alias line
ALIAS_LINE="alias k='kubectl'"

# Check if already exists
if grep -Fxq "$ALIAS_LINE" "$SHELL_CONFIG"; then
    echo "Alias already exists in $SHELL_CONFIG"
else
    echo "$ALIAS_LINE" >> "$SHELL_CONFIG"
    echo "Alias added to $SHELL_CONFIG"
fi

# Reload shell config
source "$SHELL_CONFIG"

echo "Done! Now you can use 'k' instead of 'kubectl'"
