#!/bin/bash

# =============================================================================
# Qwen Code + Opencode Unified One-Line Installer
# Usage: curl -fsSL [URL] | bash
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
log_qwen() { echo -e "${MAGENTA}🤖 $1${NC}"; }
log_opencode() { echo -e "${CYAN}🔷 $1${NC}"; }

# Configuration
QWEN_DIR="$HOME/.qwen"
OPENCODE_DIR="$HOME/.opencode"
AGENT_LINK_DIR="$HOME/.agent-link"
REPO_URL="https://github.com/yourusername/opencode-agent-config/archive/main.tar.gz"

echo ""
echo "================================================================="
echo "   🤖 Qwen Code + 🔷 Opencode Unified Installer"
echo "================================================================="
echo ""

# Check prerequisites
log_info "Checking prerequisites..."

if ! command -v curl &> /dev/null; then
    log_error "curl is required but not installed"
    exit 1
fi

if ! command -v opencode &> /dev/null; then
    log_opencode "opencode CLI not found. Installing..."
    if command -v npm &> /dev/null; then
        npm install -g @opencode/cli 2>/dev/null || true
    elif command -v bun &> /dev/null; then
        bun install -g @opencode/cli 2>/dev/null || true
    fi
    log_success "opencode CLI setup attempted"
else
    log_opencode "opencode CLI is already installed"
fi

# Backup existing
echo ""
log_info "Creating backups..."
for dir in "$QWEN_DIR" "$OPENCODE_DIR" "$AGENT_LINK_DIR"; do
    if [ -d "$dir" ]; then
        BACKUP_DIR="${dir}.backup.$(date +%Y%m%d%H%M%S)"
        cp -r "$dir" "$BACKUP_DIR"
    fi
done
log_success "Backups created"

# Create directories
log_info "Creating directories..."
mkdir -p "$QWEN_DIR"/{agents,skills,rules,bin}
mkdir -p "$OPENCODE_DIR"/{agents,skills,rules,bin}
mkdir -p "$AGENT_LINK_DIR"/{agents,skills,rules,workflows,scripts,.shared}
log_success "Directories created"

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

[ -d "$EXTRACTED_DIR/agents" ] && cp -r "$EXTRACTED_DIR/agents/"* "$AGENT_LINK_DIR/agents/"
[ -d "$EXTRACTED_DIR/skills" ] && cp -r "$EXTRACTED_DIR/skills/"* "$AGENT_LINK_DIR/skills/"
[ -d "$EXTRACTED_DIR/rules" ] && cp -r "$EXTRACTED_DIR/rules/"* "$AGENT_LINK_DIR/rules/"
[ -d "$EXTRACTED_DIR/workflows" ] && cp -r "$EXTRACTED_DIR/workflows/"* "$AGENT_LINK_DIR/workflows/"
[ -d "$EXTRACTED_DIR/.shared" ] && cp -r "$EXTRACTED_DIR/.shared/"* "$AGENT_LINK_DIR/.shared/"

if [ -f "$EXTRACTED_DIR/mcp_config.json" ]; then
    cp "$EXTRACTED_DIR/mcp_config.json" "$AGENT_LINK_DIR/"
    cp "$EXTRACTED_DIR/mcp_config.json" "$QWEN_DIR/"
    cp "$EXTRACTED_DIR/mcp_config.json" "$OPENCODE_DIR/"
fi

log_success "Files copied"

# Create symlinks for both Qwen and Opencode
echo ""
log_qwen "Setting up Qwen Code..."

# Symlink agents
for agent_file in "$AGENT_LINK_DIR/agents/"*.md; do
    [ -f "$agent_file" ] && ln -sf "$agent_file" "$QWEN_DIR/agents/$(basename "$agent_file")"
done

# Symlink skills, rules, workflows directories
[ -d "$AGENT_LINK_DIR/skills" ] && ln -sf "$AGENT_LINK_DIR/skills" "$QWEN_DIR/skills"
[ -d "$AGENT_LINK_DIR/rules" ] && ln -sf "$AGENT_LINK_DIR/rules" "$QWEN_DIR/rules"
[ -d "$AGENT_LINK_DIR/workflows" ] && ln -sf "$AGENT_LINK_DIR/workflows" "$QWEN_DIR/workflows"

log_success "Qwen Code symlinks created"

log_opencode "Setting up Opencode..."

# Symlink agents
for agent_file in "$AGENT_LINK_DIR/agents/"*.md; do
    [ -f "$agent_file" ] && ln -sf "$agent_file" "$OPENCODE_DIR/agents/$(basename "$agent_file")"
done

# Symlink skills, rules, workflows directories
[ -d "$AGENT_LINK_DIR/skills" ] && ln -sf "$AGENT_LINK_DIR/skills" "$OPENCODE_DIR/skills"
[ -d "$AGENT_LINK_DIR/rules" ] && ln -sf "$AGENT_LINK_DIR/rules" "$OPENCODE_DIR/rules"
[ -d "$AGENT_LINK_DIR/workflows" ] && ln -sf "$AGENT_LINK_DIR/workflows" "$OPENCODE_DIR/workflows"

log_success "Opencode symlinks created"

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
echo ""
log_info "Verifying installation..."
qwen_count=$(ls -1 "$QWEN_DIR/agents/"*.md 2>/dev/null | wc -l)
opencode_count=$(ls -1 "$OPENCODE_DIR/agents/"*.md 2>/dev/null | wc -l)

log_qwen "$qwen_count agents for Qwen Code"
log_opencode "$opencode_count agents for Opencode"

# Summary
echo ""
echo "================================================================="
echo -e "${GREEN}✅ Unified Installation Complete!${NC}"
echo "================================================================="
echo ""
echo "📁 Installed:"
echo -e "   ${MAGENTA}🤖 Qwen Code:${NC}   $QWEN_DIR"
echo -e "   ${CYAN}🔷 Opencode:${NC}   $OPENCODE_DIR"
echo -e "   ${BLUE}📦 Shared:${NC}     $AGENT_LINK_DIR"
echo ""
echo "🚀 Next steps:"
echo "   1. Restart terminal: source ~/.zshrc"
echo "   2. Qwen: Open VS Code with Qwen extension"
echo "   3. Opencode: Run 'opencode' in project directory"
echo ""
echo "================================================================="
echo ""
