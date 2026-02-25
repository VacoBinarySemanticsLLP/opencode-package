#!/bin/bash

# =============================================================================
# Unified Installer for Qwen Code AND Opencode
# =============================================================================
# Installs agent configurations for both Qwen Code and opencode simultaneously
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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"

echo ""
echo "================================================================="
echo "   🤖 Qwen Code + 🔷 Opencode Unified Installer"
echo "================================================================="
echo ""

# Check prerequisites
log_info "Checking prerequisites..."

if ! command -v opencode &> /dev/null; then
    log_opencode "opencode CLI not found. Installing..."
    if command -v npm &> /dev/null; then
        npm install -g @opencode/cli 2>/dev/null || log_warning "npm install failed, continuing..."
    elif command -v bun &> /dev/null; then
        bun install -g @opencode/cli 2>/dev/null || log_warning "bun install failed, continuing..."
    fi
    log_success "opencode CLI setup attempted"
else
    log_opencode "opencode CLI is already installed"
fi

# Check for qwen (usually comes with VS Code extension)
if command -v qwen &> /dev/null || [ -d "$QWEN_DIR" ]; then
    log_qwen "Qwen Code is available"
else
    log_warning "Qwen Code not detected. Install via VS Code extension if needed."
fi

# Backup existing configurations
echo ""
log_info "Creating backups..."

for dir in "$QWEN_DIR" "$OPENCODE_DIR" "$AGENT_LINK_DIR"; do
    if [ -d "$dir" ]; then
        BACKUP_DIR="${dir}.backup.$(date +%Y%m%d%H%M%S)"
        log_info "Backing up $dir → $BACKUP_DIR"
        cp -r "$dir" "$BACKUP_DIR"
    fi
done
log_success "Backups created"

# Create directories
echo ""
log_info "Creating directories..."

# Qwen directories
mkdir -p "$QWEN_DIR"/{agents,skills,rules,bin}

# Opencode directories
mkdir -p "$OPENCODE_DIR"/{agents,skills,rules,bin}

# Agent link (shared source)
mkdir -p "$AGENT_LINK_DIR"/{agents,skills,rules,workflows,scripts,.shared}

log_success "Directories created"

# Copy files from package
echo ""
log_info "Copying agent configurations..."

if [ -d "$PACKAGE_DIR/agents" ] && [ "$(ls -A $PACKAGE_DIR/agents 2>/dev/null)" ]; then
    cp -r "$PACKAGE_DIR/agents/"* "$AGENT_LINK_DIR/agents/"
    log_success "Agents copied: $(ls -1 $AGENT_LINK_DIR/agents/*.md | wc -l | xargs) files"
fi

if [ -d "$PACKAGE_DIR/skills" ] && [ "$(ls -A $PACKAGE_DIR/skills 2>/dev/null)" ]; then
    cp -r "$PACKAGE_DIR/skills/"* "$AGENT_LINK_DIR/skills/"
    log_success "Skills copied: $(ls -1d $AGENT_LINK_DIR/skills/*/ 2>/dev/null | wc -l | xargs) directories"
fi

if [ -d "$PACKAGE_DIR/rules" ] && [ "$(ls -A $PACKAGE_DIR/rules 2>/dev/null)" ]; then
    cp -r "$PACKAGE_DIR/rules/"* "$AGENT_LINK_DIR/rules/"
    log_success "Rules copied"
fi

if [ -d "$PACKAGE_DIR/workflows" ] && [ "$(ls -A $PACKAGE_DIR/workflows 2>/dev/null)" ]; then
    cp -r "$PACKAGE_DIR/workflows/"* "$AGENT_LINK_DIR/workflows/"
    log_success "Workflows copied"
fi

if [ -d "$PACKAGE_DIR/.shared" ] && [ "$(ls -A $PACKAGE_DIR/.shared 2>/dev/null)" ]; then
    cp -r "$PACKAGE_DIR/.shared/"* "$AGENT_LINK_DIR/.shared/"
    log_success "Shared files copied"
fi

if [ -f "$PACKAGE_DIR/mcp_config.json" ]; then
    cp "$PACKAGE_DIR/mcp_config.json" "$AGENT_LINK_DIR/"
    cp "$PACKAGE_DIR/mcp_config.json" "$QWEN_DIR/"
    cp "$PACKAGE_DIR/mcp_config.json" "$OPENCODE_DIR/"
    log_success "MCP config copied"
fi

# Create symlinks for Qwen
echo ""
log_qwen "Setting up Qwen Code..."
for agent_file in "$AGENT_LINK_DIR/agents/"*.md; do
    if [ -f "$agent_file" ]; then
        filename=$(basename "$agent_file")
        ln -sf "$agent_file" "$QWEN_DIR/agents/$filename"
    fi
done
log_success "Qwen Code symlinks created"

# Create symlinks for Opencode
log_opencode "Setting up Opencode..."
for agent_file in "$AGENT_LINK_DIR/agents/"*.md; do
    if [ -f "$agent_file" ]; then
        filename=$(basename "$agent_file")
        ln -sf "$agent_file" "$OPENCODE_DIR/agents/$filename"
    fi
done
log_success "Opencode symlinks created"

# Fix tools format
echo ""
log_info "Fixing tools format in agent files..."
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

# Set permissions
log_info "Setting permissions..."
chmod -R 755 "$AGENT_LINK_DIR/scripts" 2>/dev/null || true
chmod +x "$QWEN_DIR/bin/"* 2>/dev/null || true
chmod +x "$OPENCODE_DIR/bin/"* 2>/dev/null || true
log_success "Permissions set"

# Verify installation
echo ""
log_info "Verifying installation..."

qwen_agents=$(ls -1 "$QWEN_DIR/agents/"*.md 2>/dev/null | wc -l)
opencode_agents=$(ls -1 "$OPENCODE_DIR/agents/"*.md 2>/dev/null | wc -l)
skills_count=$(ls -1d "$AGENT_LINK_DIR/skills/"*/ 2>/dev/null | wc -l)

if [ "$qwen_agents" -gt 0 ]; then
    log_qwen "$qwen_agents agent files for Qwen Code"
else
    log_error "Qwen Code agents not found"
fi

if [ "$opencode_agents" -gt 0 ]; then
    log_opencode "$opencode_agents agent files for Opencode"
else
    log_error "Opencode agents not found"
fi

if [ "$skills_count" -gt 0 ]; then
    log_success "$skills_count skill directories installed"
else
    log_warning "No skill directories found"
fi

# Summary
echo ""
echo "================================================================="
echo -e "${GREEN}✅ Unified Installation Complete!${NC}"
echo "================================================================="
echo ""
echo "📁 Installed locations:"
echo -e "   ${MAGENTA}🤖 Qwen Code:${NC}"
echo "      • Agents:  $QWEN_DIR/agents"
echo "      • Skills:  $QWEN_DIR/skills"
echo "      • Rules:   $QWEN_DIR/rules"
echo "      • Config:  $QWEN_DIR/mcp_config.json"
echo ""
echo -e "   ${CYAN}🔷 Opencode:${NC}"
echo "      • Agents:  $OPENCODE_DIR/agents"
echo "      • Skills:  $OPENCODE_DIR/skills"
echo "      • Rules:   $OPENCODE_DIR/rules"
echo "      • Config:  $OPENCODE_DIR/mcp_config.json"
echo ""
echo "   ${BLUE}📦 Shared Source:${NC}"
echo "      • Location: $AGENT_LINK_DIR"
echo ""
echo "🚀 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc (or ~/.bashrc)"
echo "   2. For Qwen Code: Open VS Code with Qwen extension"
echo "   3. For Opencode: Run 'opencode' in your project directory"
echo ""
echo "📦 To uninstall, run:"
echo "   rm -rf $AGENT_LINK_DIR"
echo "   rm -rf $QWEN_DIR"
echo "   rm -rf $OPENCODE_DIR"
echo ""
echo "================================================================="
echo ""
