#!/bin/bash

# =============================================================================
# Opencode Agent Configuration Installer
# =============================================================================
# One-command installer for opencode agents, skills, and configurations
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
OPENCODE_DIR="$HOME/.opencode"
AGENT_LINK_DIR="$HOME/.agent-link"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"

# =============================================================================
# Helper Functions
# =============================================================================

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if opencode is installed
    if ! command -v opencode &> /dev/null; then
        log_warning "opencode CLI not found. Installing..."
        if command -v npm &> /dev/null; then
            npm install -g @opencode/cli
            log_success "opencode CLI installed"
        elif command -v bun &> /dev/null; then
            bun install -g @opencode/cli
            log_success "opencode CLI installed via bun"
        else
            log_error "npm or bun required. Please install Node.js first."
            exit 1
        fi
    else
        log_success "opencode CLI is already installed"
    fi
    
    # Check for required tools
    for cmd in curl git; do
        if ! command -v $cmd &> /dev/null; then
            log_error "$cmd is required but not installed"
            exit 1
        fi
    done
    log_success "All prerequisites met"
}

backup_existing() {
    if [ -d "$OPENCODE_DIR" ]; then
        BACKUP_DIR="$OPENCODE_DIR.backup.$(date +%Y%m%d%H%M%S)"
        log_info "Backing up existing opencode config to: $BACKUP_DIR"
        cp -r "$OPENCODE_DIR" "$BACKUP_DIR"
        log_success "Backup created"
    fi
    
    if [ -d "$AGENT_LINK_DIR" ]; then
        BACKUP_DIR="$AGENT_LINK_DIR.backup.$(date +%Y%m%d%H%M%S)"
        log_info "Backing up existing agent-link to: $BACKUP_DIR"
        cp -r "$AGENT_LINK_DIR" "$BACKUP_DIR"
        log_success "Backup created"
    fi
}

create_directories() {
    log_info "Creating directories..."
    mkdir -p "$OPENCODE_DIR"/{agents,skills,rules,bin}
    mkdir -p "$AGENT_LINK_DIR"/{agents,skills,rules,workflows,scripts}
    log_success "Directories created"
}

copy_files() {
    log_info "Copying agent configurations..."
    
    # Copy agents
    if [ -d "$PACKAGE_DIR/agents" ] && [ "$(ls -A $PACKAGE_DIR/agents 2>/dev/null)" ]; then
        cp -r "$PACKAGE_DIR/agents/"* "$AGENT_LINK_DIR/agents/"
        log_success "Agents copied"
    fi
    
    # Copy skills
    if [ -d "$PACKAGE_DIR/skills" ] && [ "$(ls -A $PACKAGE_DIR/skills 2>/dev/null)" ]; then
        cp -r "$PACKAGE_DIR/skills/"* "$AGENT_LINK_DIR/skills/"
        log_success "Skills copied"
    fi
    
    # Copy rules
    if [ -d "$PACKAGE_DIR/rules" ] && [ "$(ls -A $PACKAGE_DIR/rules 2>/dev/null)" ]; then
        cp -r "$PACKAGE_DIR/rules/"* "$AGENT_LINK_DIR/rules/"
        log_success "Rules copied"
    fi
    
    # Create symlinks in .opencode/agents
    log_info "Creating symlinks..."
    for agent_file in "$AGENT_LINK_DIR/agents/"*.md; do
        if [ -f "$agent_file" ]; then
            filename=$(basename "$agent_file")
            ln -sf "$agent_file" "$OPENCODE_DIR/agents/$filename"
        fi
    done
    log_success "Symlinks created"
}

copy_shared_configs() {
    log_info "Copying shared configurations..."
    
    # Copy MCP config
    if [ -f "$PACKAGE_DIR/mcp_config.json" ]; then
        cp "$PACKAGE_DIR/mcp_config.json" "$AGENT_LINK_DIR/"
        cp "$PACKAGE_DIR/mcp_config.json" "$OPENCODE_DIR/"
        log_success "MCP config copied"
    fi
    
    # Copy .shared folder if exists
    if [ -d "$PACKAGE_DIR/.shared" ]; then
        cp -r "$PACKAGE_DIR/.shared/"* "$AGENT_LINK_DIR/.shared/"
        log_success "Shared files copied"
    fi
}

fix_tools_format() {
    log_info "Fixing tools format in agent files..."
    
    # Use inline Python to fix all agent files
    python3 -c "
import os
import re

agents_dir = '$AGENT_LINK_DIR/agents'

for filename in os.listdir(agents_dir):
    if not filename.endswith('.md'):
        continue
    
    filepath = os.path.join(agents_dir, filename)
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    match = re.search(r'^tools:\s*\[([^\]]+)\]', content, re.MULTILINE)
    if match:
        tools_str = match.group(1)
        tools = [t.strip() for t in tools_str.split(',')]
        new_tools = 'tools:\n' + '\n'.join([f'  {tool}: true' for tool in tools])
        content = content[:match.start()] + new_tools + content[match.end():]
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

print('Tools format fixed in all agent files')
"
    log_success "Tools format fixed"
}

set_permissions() {
    log_info "Setting permissions..."
    chmod -R 755 "$AGENT_LINK_DIR/scripts" 2>/dev/null || true
    chmod +x "$OPENCODE_DIR/bin/"* 2>/dev/null || true
    log_success "Permissions set"
}

verify_installation() {
    log_info "Verifying installation..."
    
    # Check if agent files exist
    agent_count=$(ls -1 "$AGENT_LINK_DIR/agents/"*.md 2>/dev/null | wc -l)
    if [ "$agent_count" -gt 0 ]; then
        log_success "$agent_count agent files installed"
    else
        log_error "No agent files found"
        return 1
    fi
    
    # Check if skills exist
    skill_count=$(ls -1d "$AGENT_LINK_DIR/skills/"*/ 2>/dev/null | wc -l)
    if [ "$skill_count" -gt 0 ]; then
        log_success "$skill_count skill directories installed"
    else
        log_warning "No skill directories found"
    fi
    
    # Check symlinks
    symlink_count=$(ls -1 "$OPENCODE_DIR/agents/"*.md 2>/dev/null | wc -l)
    if [ "$symlink_count" -gt 0 ]; then
        log_success "$symlink_count symlinks created"
    else
        log_error "No symlinks found"
        return 1
    fi
    
    return 0
}

print_summary() {
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
}

# =============================================================================
# Main Installation Flow
# =============================================================================

main() {
    echo ""
    echo "================================================================="
    echo "   Opencode Agent Configuration Installer"
    echo "================================================================="
    echo ""
    
    check_prerequisites
    backup_existing
    create_directories
    copy_files
    copy_shared_configs
    fix_tools_format
    set_permissions
    
    if verify_installation; then
        print_summary
        exit 0
    else
        log_error "Installation verification failed"
        exit 1
    fi
}

# Run installer
main "$@"
