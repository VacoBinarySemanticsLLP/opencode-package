#!/bin/bash

# =============================================================================
# Fix Missing Skills Symlink
# Run this on machines where skills symlink is missing
# =============================================================================

set -e

QWEN_DIR="$HOME/.qwen"
OPENCODE_DIR="$HOME/.opencode"
AGENT_LINK_DIR="$HOME/.agent-link"

echo "Fixing skills symlink..."

# Check if agent-link/skills exists
if [ ! -d "$AGENT_LINK_DIR/skills" ]; then
    echo "❌ Error: $AGENT_LINK_DIR/skills does not exist"
    echo "Run the full installer first: bash scripts/install-unified.sh"
    exit 1
fi

# Fix Qwen skills symlink
if [ -d "$QWEN_DIR/skills" ]; then
    echo "Removing existing $QWEN_DIR/skills"
    rm -rf "$QWEN_DIR/skills"
fi
ln -sf "$AGENT_LINK_DIR/skills" "$QWEN_DIR/skills"
echo "✅ Created symlink: $QWEN_DIR/skills -> $AGENT_LINK_DIR/skills"

# Fix Opencode skills symlink
if [ -d "$OPENCODE_DIR" ]; then
    if [ -d "$OPENCODE_DIR/skills" ]; then
        echo "Removing existing $OPENCODE_DIR/skills"
        rm -rf "$OPENCODE_DIR/skills"
    fi
    ln -sf "$AGENT_LINK_DIR/skills" "$OPENCODE_DIR/skills"
    echo "✅ Created symlink: $OPENCODE_DIR/skills -> $AGENT_LINK_DIR/skills"
fi

# Fix rules symlink
if [ -d "$AGENT_LINK_DIR/rules" ]; then
    if [ -d "$QWEN_DIR/rules" ]; then
        rm -rf "$QWEN_DIR/rules"
    fi
    ln -sf "$AGENT_LINK_DIR/rules" "$QWEN_DIR/rules"
    echo "✅ Created symlink: $QWEN_DIR/rules -> $AGENT_LINK_DIR/rules"
    
    if [ -d "$OPENCODE_DIR" ]; then
        if [ -d "$OPENCODE_DIR/rules" ]; then
            rm -rf "$OPENCODE_DIR/rules"
        fi
        ln -sf "$AGENT_LINK_DIR/rules" "$OPENCODE_DIR/rules"
        echo "✅ Created symlink: $OPENCODE_DIR/rules -> $AGENT_LINK_DIR/rules"
    fi
fi

# Fix workflows symlink
if [ -d "$AGENT_LINK_DIR/workflows" ]; then
    if [ -d "$QWEN_DIR/workflows" ]; then
        rm -rf "$QWEN_DIR/workflows"
    fi
    ln -sf "$AGENT_LINK_DIR/workflows" "$QWEN_DIR/workflows"
    echo "✅ Created symlink: $QWEN_DIR/workflows -> $AGENT_LINK_DIR/workflows"
    
    if [ -d "$OPENCODE_DIR" ]; then
        if [ -d "$OPENCODE_DIR/workflows" ]; then
            rm -rf "$OPENCODE_DIR/workflows"
        fi
        ln -sf "$AGENT_LINK_DIR/workflows" "$OPENCODE_DIR/workflows"
        echo "✅ Created symlink: $OPENCODE_DIR/workflows -> $AGENT_LINK_DIR/workflows"
    fi
fi

echo ""
echo "================================================================="
echo "✅ Symlinks fixed!"
echo "================================================================="
echo ""
echo "Verify with:"
echo "  ls -la $QWEN_DIR/skills"
echo "  ls -la $OPENCODE_DIR/skills"
echo ""
