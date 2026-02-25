#!/bin/bash

# =============================================================================
# Opencode Agent Config - One-Line Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/yourusername/opencode-agent-config/main/install.sh | bash
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Configuration
OPENCODE_DIR="$HOME/.opencode"
AGENT_LINK_DIR="$HOME/.agent-link"
REPO_URL="https://github.com/yourusername/opencode-agent-config/archive/main.tar.gz"

echo ""
echo "================================================================="
echo "   Opencode Agent Configuration Installer"
echo "================================================================="
echo ""

# Check prerequisites
log_info "Checking prerequisites..."

if ! command -v curl &> /dev/null; then
    log_error "curl is required but not installed"
    exit 1
fi

if ! command -v opencode &> /dev/null; then
    log_warning "opencode CLI not found. Installing..."
    if command -v npm &> /dev/null; then
        npm install -g @opencode/cli 2>/dev/null || log_warning "npm install failed, continuing..."
    elif command -v bun &> /dev/null; then
        bun install -g @opencode/cli 2>/dev/null || log_warning "bun install failed, continuing..."
    fi
    log_success "opencode CLI setup attempted"
else
    log_success "opencode CLI is already installed"
fi

# Backup existing
if [ -d "$OPENCODE_DIR" ]; then
    BACKUP_DIR="$OPENCODE_DIR.backup.$(date +%Y%m%d%H%M%S)"
    log_info "Backing up existing opencode config to: $BACKUP_DIR"
    cp -r "$OPENCODE_DIR" "$BACKUP_DIR"
fi

if [ -d "$AGENT_LINK_DIR" ]; then
    BACKUP_DIR="$AGENT_LINK_DIR.backup.$(date +%Y%m%d%H%M%S)"
    log_info "Backing up existing agent-link to: $BACKUP_DIR"
    cp -r "$AGENT_LINK_DIR" "$BACKUP_DIR"
fi

# Create directories
log_info "Creating directories..."
mkdir -p "$OPENCODE_DIR"/{agents,skills,rules,bin}
mkdir -p "$AGENT_LINK_DIR"/{agents,skills,rules,workflows,scripts,.shared}

# Download and extract
log_info "Downloading agent configurations..."
TEMP_DIR=$(mktemp -d)
curl -sL "$REPO_URL" -o "$TEMP_DIR/package.tar.gz"

if [ ! -f "$TEMP_DIR/package.tar.gz" ]; then
    log_error "Failed to download package"
    exit 1
fi

log_success "Downloaded successfully"

log_info "Extracting package..."
tar -xzf "$TEMP_DIR/package.tar.gz" -C "$TEMP_DIR"
EXTRACTED_DIR=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "opencode-agent-config-*" | head -1)

if [ -z "$EXTRACTED_DIR" ]; then
    log_error "Failed to extract package"
    exit 1
fi

# Copy files
log_info "Copying agent configurations..."

if [ -d "$EXTRACTED_DIR/agents" ]; then
    cp -r "$EXTRACTED_DIR/agents/"* "$AGENT_LINK_DIR/agents/"
fi

if [ -d "$EXTRACTED_DIR/skills" ]; then
    cp -r "$EXTRACTED_DIR/skills/"* "$AGENT_LINK_DIR/skills/"
fi

if [ -d "$EXTRACTED_DIR/rules" ]; then
    cp -r "$EXTRACTED_DIR/rules/"* "$AGENT_LINK_DIR/rules/"
fi

if [ -d "$EXTRACTED_DIR/workflows" ]; then
    cp -r "$EXTRACTED_DIR/workflows/"* "$AGENT_LINK_DIR/workflows/"
fi

if [ -d "$EXTRACTED_DIR/.shared" ]; then
    cp -r "$EXTRACTED_DIR/.shared/"* "$AGENT_LINK_DIR/.shared/"
fi

if [ -f "$EXTRACTED_DIR/mcp_config.json" ]; then
    cp "$EXTRACTED_DIR/mcp_config.json" "$AGENT_LINK_DIR/"
    cp "$EXTRACTED_DIR/mcp_config.json" "$OPENCODE_DIR/"
fi

log_success "Files copied"

# Create symlinks
log_info "Creating symlinks..."
for agent_file in "$AGENT_LINK_DIR/agents/"*.md; do
    if [ -f "$agent_file" ]; then
        filename=$(basename "$agent_file")
        ln -sf "$agent_file" "$OPENCODE_DIR/agents/$filename"
    fi
done
log_success "Symlinks created"

# Fix tools format
log_info "Fixing tools format..."
python3 -c "
import os, re
agents_dir = '$AGENT_LINK_DIR/agents'
for f in os.listdir(agents_dir):
    if f.endswith('.md'):
        path = os.path.join(agents_dir, f)
        content = open(path, 'r', encoding='utf-8').read()
        m = re.search(r'^tools:\s*\[([^\]]+)\]', content, re.MULTILINE)
        if m:
            tools = [t.strip() for t in m.group(1).split(',')]
            new_tools = 'tools:\n' + '\n'.join([f'  {tool}: true' for tool in tools])
            content = content[:m.start()] + new_tools + content[m.end():]
            open(path, 'w', encoding='utf-8').write(content)
"
log_success "Tools format fixed"

# Cleanup
rm -rf "$TEMP_DIR"

# Verify
log_info "Verifying installation..."
agent_count=$(ls -1 "$AGENT_LINK_DIR/agents/"*.md 2>/dev/null | wc -l)
symlink_count=$(ls -1 "$OPENCODE_DIR/agents/"*.md 2>/dev/null | wc -l)

if [ "$agent_count" -gt 0 ] && [ "$symlink_count" -gt 0 ]; then
    log_success "$agent_count agent files installed"
    log_success "$symlink_count symlinks created"
else
    log_error "Installation verification failed"
    exit 1
fi

# Summary
echo ""
echo "================================================================="
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo "================================================================="
echo ""
echo "📁 Installed locations:"
echo "   • Agent configs: $AGENT_LINK_DIR/agents"
echo "   • Skills:        $AGENT_LINK_DIR/skills"
echo "   • Rules:         $AGENT_LINK_DIR/rules"
echo "   • Opencode link: $OPENCODE_DIR/agents"
echo ""
echo "🚀 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc (or ~/.bashrc)"
echo "   2. Launch opencode in your project directory"
echo ""
echo "📦 To uninstall, run:"
echo "   rm -rf $AGENT_LINK_DIR"
echo "   rm -rf $OPENCODE_DIR"
echo ""
echo "================================================================="
echo ""
