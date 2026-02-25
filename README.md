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
curl -fsSL https://raw.githubusercontent.com/VacoBinarySemanticsLLP/opencode-package/main/install-unified.sh | bash
```

**This installs for both Qwen Code AND Opencode simultaneously!**

### Option 3: Git Clone

```bash
git clone https://github.com/VacoBinarySemanticsLLP/opencode-package.git
cd opencode-package
npm install -g .
```

## 📦 What's Included

| Component | Description | Location |
|-----------|-------------|----------|
| **Agents** | 20 specialized AI agents | `~/.agent-link/agents/` |
| **Skills** | 37 domain-specific knowledge bases | `~/.agent-link/skills/` |
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
| `debugger` | Debugging specialist |

## 🛠️ Manual Installation

If you prefer manual setup:

```bash
# Create directories
mkdir -p ~/.qwen/{agents,skills,rules,bin}
mkdir -p ~/.opencode/{agents,skills,rules,bin}
mkdir -p ~/.agent-link/{agents,skills,rules,workflows}

# Copy files
cp -r agents/* ~/.agent-link/agents/
cp -r skills/* ~/.agent-link/skills/
cp -r rules/* ~/.agent-link/rules/
cp -r workflows/* ~/.agent-link/workflows/

# Create symlinks for Qwen
ln -s ~/.agent-link/agents/*.md ~/.qwen/agents/
ln -s ~/.agent-link/skills ~/.qwen/skills
ln -s ~/.agent-link/rules ~/.qwen/rules
ln -s ~/.agent-link/workflows ~/.qwen/workflows

# Create symlinks for Opencode
ln -s ~/.agent-link/agents/*.md ~/.opencode/agents/
ln -s ~/.agent-link/skills ~/.opencode/skills
ln -s ~/.agent-link/rules ~/.opencode/rules
ln -s ~/.agent-link/workflows ~/.opencode/workflows
```

## 🔄 Updating

### If installed via npm:
```bash
npm update -g opencode-agent-config
```

### If installed via script:
```bash
curl -fsSL https://raw.githubusercontent.com/VacoBinarySemanticsLLP/opencode-package/main/install-unified.sh | bash
```

### Fix missing symlinks (if needed):
```bash
curl -fsSL https://raw.githubusercontent.com/VacoBinarySemanticsLLP/opencode-package/main/scripts/fix-skills-symlink.sh | bash
```

## 🗑️ Uninstall

```bash
# Remove configurations
rm -rf ~/.agent-link
rm -rf ~/.qwen
rm -rf ~/.opencode

# Uninstall npm package
npm uninstall -g opencode-agent-config
```

## 📋 Prerequisites

- **Qwen Code CLI** or **VS Code with Qwen extension**
- **opencode CLI** (auto-installed if missing)
- **Node.js** 18+ (for npm installation)
- **bash** 4.0+ (for script installation)
- **python3** (for tools format fixing)

## 🔧 Configuration

### MCP Config

The package includes a pre-configured `mcp_config.json`. Customize it at:
- `~/.opencode/mcp_config.json`
- `~/.qwen/mcp_config.json`
- `~/.agent-link/mcp_config.json`

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `QWEN_DIR` | Qwen config directory | `~/.qwen` |
| `OPENCODE_DIR` | Opencode config directory | `~/.opencode` |
| `AGENT_LINK_DIR` | Agent link directory | `~/.agent-link` |

## 📁 Installed Structure

```
~/.qwen/
├── agents/           # Symlinks to agent files
├── skills/           # Symlink to skill definitions
├── rules/            # Symlink to rule definitions
├── workflows/        # Symlink to workflows
└── mcp_config.json   # MCP configuration

~/.opencode/
├── agents/           # Symlinks to agent files
├── skills/           # Symlink to skill definitions
├── rules/            # Symlink to rule definitions
├── workflows/        # Symlink to workflows
└── mcp_config.json   # MCP configuration

~/.agent-link/
├── agents/           # Agent definition files (source)
├── skills/           # Skill knowledge base (source)
├── rules/            # Rule definitions (source)
├── workflows/        # Workflow definitions (source)
├── scripts/          # Utility scripts
├── .shared/          # Shared resources
└── mcp_config.json   # MCP configuration (source)
```

## 🐛 Troubleshooting

### Agents not loading

1. Check symlinks: `ls -la ~/.qwen/agents/` and `ls -la ~/.opencode/agents/`
2. Verify agent files: `ls -la ~/.agent-link/agents/`
3. Restart Qwen Code or opencode

### Skills not found

Run the fix script:
```bash
curl -fsSL https://raw.githubusercontent.com/VacoBinarySemanticsLLP/opencode-package/main/scripts/fix-skills-symlink.sh | bash
```

### Permission errors

```bash
chmod -R 755 ~/.agent-link
chmod -R 755 ~/.qwen
chmod -R 755 ~/.opencode
```

### Tools format error

The installer automatically fixes the tools format. If you see errors manually fix:
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

- **Issues**: [GitHub Issues](https://github.com/VacoBinarySemanticsLLP/opencode-package/issues)
- **Repository**: [GitHub](https://github.com/VacoBinarySemanticsLLP/opencode-package)

---

**Made with ❤️ by Highspring India LLP for the Qwen Code and Opencode community**
