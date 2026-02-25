#!/bin/bash

# =============================================================================
# Package Data Copy Script
# Copies existing opencode/agent-link configurations into the package
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_DIR="$(dirname "$SCRIPT_DIR")"
AGENT_LINK_DIR="$HOME/.agent-link"
OPENCODE_DIR="$HOME/.opencode"

echo "Copying agent configurations to package..."

# Copy agents
echo "📦 Copying agents..."
rm -rf "$PACKAGE_DIR/agents/"*
cp -r "$AGENT_LINK_DIR/agents/"* "$PACKAGE_DIR/agents/"
echo "✅ Agents copied: $(ls -1 $PACKAGE_DIR/agents/*.md | wc -l) files"

# Copy skills
echo "📦 Copying skills..."
rm -rf "$PACKAGE_DIR/skills/"*
cp -r "$AGENT_LINK_DIR/skills/"* "$PACKAGE_DIR/skills/"
echo "✅ Skills copied: $(ls -1d $PACKAGE_DIR/skills/*/ | wc -l) directories"

# Copy rules
echo "📦 Copying rules..."
rm -rf "$PACKAGE_DIR/rules/"*
cp -r "$AGENT_LINK_DIR/rules/"* "$PACKAGE_DIR/rules/"
echo "✅ Rules copied"

# Copy workflows if exists
if [ -d "$AGENT_LINK_DIR/workflows" ]; then
    echo "📦 Copying workflows..."
    mkdir -p "$PACKAGE_DIR/workflows"
    cp -r "$AGENT_LINK_DIR/workflows/"* "$PACKAGE_DIR/workflows/"
    echo "✅ Workflows copied"
fi

# Copy .shared if exists
if [ -d "$AGENT_LINK_DIR/.shared" ]; then
    echo "📦 Copying .shared..."
    mkdir -p "$PACKAGE_DIR/.shared"
    cp -r "$AGENT_LINK_DIR/.shared/"* "$PACKAGE_DIR/.shared/"
    echo "✅ .shared copied"
fi

# Copy MCP config
if [ -f "$AGENT_LINK_DIR/mcp_config.json" ]; then
    echo "📦 Copying mcp_config.json..."
    cp "$AGENT_LINK_DIR/mcp_config.json" "$PACKAGE_DIR/"
    echo "✅ MCP config copied"
fi

echo ""
echo "================================================================="
echo "✅ Package data copy complete!"
echo "================================================================="
echo ""
echo "Package location: $PACKAGE_DIR"
echo ""
echo "Contents:"
echo "  • Agents:  $(ls -1 $PACKAGE_DIR/agents/*.md | wc -l | xargs) files"
echo "  • Skills:  $(ls -1d $PACKAGE_DIR/skills/*/ 2>/dev/null | wc -l | xargs) directories"
echo "  • Rules:   $(ls -1 $PACKAGE_DIR/rules/*.md 2>/dev/null | wc -l | xargs) files"
echo ""

# Show package size
PACKAGE_SIZE=$(du -sh "$PACKAGE_DIR" | cut -f1)
echo "Total package size: $PACKAGE_SIZE"
echo ""
