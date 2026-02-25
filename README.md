# Qwen Code + Opencode Agent Configuration Package

Unified agent configurations for **both Qwen Code and opencode**. Install all your custom agents on any machine with a single command.

## 🚀 Quick Install

### Option 1: npm (Recommended)

```bash
npm install -g opencode-agent-config
```

Or if you prefer bun:

```bash
bun install -g opencode-agent-config
```

### Option 2: Direct Script (Unified Installer)

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/opencode-agent-config/main/install-unified.sh | bash
```

**This installs for both Qwen Code AND Opencode simultaneously!**

### Option 3: Git Clone

```bash
git clone https://github.com/yourusername/opencode-agent-config.git
cd opencode-agent-config
npm install -g .
```

## 📦 What's Included

| Component | Description | Location |
|-----------|-------------|----------|
| **Agents** | 18+ specialized AI agents | `~/.agent-link/agents/` |
| **Skills** | Domain-specific knowledge | `~/.agent-link/skills/` |
| **Rules** | Coding standards & guidelines | `~/.agent-link/rules/` |
| **Workflows** | Automated workflows | `~/.agent-link/workflows/` |
| **MCP Config** | Model Context Protocol config | `~/.opencode/mcp_config.json` |

## 🎯 Available Agents

| Agent | Purpose |
|-------|---------|
| `mobile-developer` | React Native & Flutter development |
| `backend-specialist` | Backend API & server development |
| `frontend-specialist` | Frontend UI/UX development |
| `devops-engineer` | CI/CD, containers, cloud infrastructure |
| `database-architect` | Database design & optimization |
| `security-auditor` | Security analysis & auditing |
| `penetration-tester` | Penetration testing & vulnerability assessment |
| `documentation-writer` | Technical documentation |
| `code-archaeologist` | Legacy code analysis |
| `performance-optimizer` | Performance profiling & optimization |
| `qa-automation-engineer` | Test automation |
| `test-engineer` | Testing strategies |
| `product-manager` | Product management |
| `product-owner` | Agile product ownership |
| `project-planner` | Project planning & estimation |
| `seo-specialist` | SEO optimization |
| `explorer-agent` | Code exploration |
| `orchestrator` | Multi-agent coordination |
| `game-developer` | Game development |

## 🛠️ Manual Installation

If you prefer manual setup:

```bash
# Create directories
mkdir -p ~/.opencode/{agents,skills,rules}
mkdir -p ~/.agent-link/{agents,skills,rules,workflows}

# Copy files
cp -r agents/* ~/.agent-link/agents/
cp -r skills/* ~/.agent-link/skills/
cp -r rules/* ~/.agent-link/rules/

# Create symlinks
for f in ~/.agent-link/agents/*.md; do
    ln -s "$f" ~/.opencode/agents/$(basename "$f")
done
```

## 🔄 Updating

### npm installed:
```bash
npm update -g opencode-agent-config
```

### Git installed:
```bash
cd opencode-agent-config
git pull
npm install -g .
```

## 🗑️ Uninstall

```bash
# Remove agent-link
rm -rf ~/.agent-link

# Remove opencode configs
rm -rf ~/.opencode

# Uninstall npm package
npm uninstall -g opencode-agent-config
```

## 📋 Prerequisites

- **opencode CLI** (auto-installed if missing)
- **Node.js** 18+ (for npm installation)
- **bash** 4.0+ (for script installation)
- **python3** (for tools format fixing)

## 🔧 Configuration

### MCP Config

The package includes a pre-configured `mcp_config.json`. Customize it at:
- `~/.opencode/mcp_config.json`
- `~/.agent-link/mcp_config.json`

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `OPENCODE_DIR` | Opencode config directory | `~/.opencode` |
| `AGENT_LINK_DIR` | Agent link directory | `~/.agent-link` |

## 📁 Installed Structure

```
~/.opencode/
├── agents/           # Symlinks to agent files
├── skills/           # Skill definitions
├── rules/            # Coding rules
├── bin/              # CLI tools
└── mcp_config.json   # MCP configuration

~/.agent-link/
├── agents/           # Agent definition files
├── skills/           # Skill knowledge base
├── rules/            # Rule definitions
├── workflows/        # Automated workflows
├── scripts/          # Utility scripts
├── .shared/          # Shared resources
└── mcp_config.json   # MCP configuration
```

## 🐛 Troubleshooting

### Agents not loading

1. Check symlinks: `ls -la ~/.opencode/agents/`
2. Verify agent files: `ls -la ~/.agent-link/agents/`
3. Restart opencode

### Permission errors

```bash
chmod -R 755 ~/.agent-link
chmod -R 755 ~/.opencode
```

### Tools format error

The installer automatically fixes the tools format. If you see errors:

```bash
python3 -c "
import os, re
agents_dir = os.path.expanduser('~/.agent-link/agents')
for f in os.listdir(agents_dir):
    if f.endswith('.md'):
        path = os.path.join(agents_dir, f)
        content = open(path).read()
        m = re.search(r'^tools:\s*\[([^\]]+)\]', content, re.MULTILINE)
        if m:
            tools = [t.strip() for t in m.group(1).split(',')]
            new = 'tools:\n' + '\n'.join([f'  {t}: true' for t in tools])
            content = content[:m.start()] + new + content[m.end():]
            open(path, 'w').write(content)
"
```

## 📄 License

MIT License - See LICENSE file for details

## 🤝 Contributing

1. Fork the repository
2. Make your changes
3. Test the installer
4. Submit a pull request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/opencode-agent-config/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/opencode-agent-config/discussions)

---

**Made with ❤️ for the opencode community**
