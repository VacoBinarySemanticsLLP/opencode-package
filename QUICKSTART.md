# 🤖 Qwen Code + 🔷 Opencode - Unified Quick Start

## 🚀 Install on a New Machine (One Command)

### Unified Installer (Both Qwen AND Opencode)

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/opencode-agent-config/main/install-unified.sh | bash
```

**This single command installs configurations for:**
- ✅ Qwen Code (VS Code extension)
- ✅ Opencode (CLI tool)
- ✅ Shared agents, skills, and workflows

### Using npm

```bash
npm install -g opencode-agent-config@1.0.0
```

### Using bun

```bash
bun install -g opencode-agent-config
```

---

## 📦 What Gets Installed

| Platform | Location | Contents |
|----------|----------|----------|
| **Qwen Code** | `~/.qwen/agents/` | 20 agent symlinks |
| **Qwen Code** | `~/.qwen/skills/` | Skill definitions |
| **Qwen Code** | `~/.qwen/mcp_config.json` | MCP config |
| **Opencode** | `~/.opencode/agents/` | 20 agent symlinks |
| **Opencode** | `~/.opencode/skills/` | Skill definitions |
| **Opencode** | `~/.opencode/mcp_config.json` | MCP config |
| **Shared** | `~/.agent-link/` | Source files for both |

---

## 🎯 Available Agents (Both Platforms)

| Agent | Qwen | Opencode | Purpose |
|-------|------|----------|---------|
| `mobile-developer` | ✅ | ✅ | React Native & Flutter |
| `backend-specialist` | ✅ | ✅ | Backend API & server |
| `frontend-specialist` | ✅ | ✅ | Frontend UI/UX |
| `devops-engineer` | ✅ | ✅ | CI/CD, containers, cloud |
| `database-architect` | ✅ | ✅ | Database design |
| `security-auditor` | ✅ | ✅ | Security analysis |
| `documentation-writer` | ✅ | ✅ | Technical docs |
| `code-archaeologist` | ✅ | ✅ | Legacy code analysis |
| `performance-optimizer` | ✅ | ✅ | Performance tuning |
| `qa-automation-engineer` | ✅ | ✅ | Test automation |
| `orchestrator` | ✅ | ✅ | Multi-agent coordination |
| And 9 more... | ✅ | ✅ | Various specialties |

---

## 📋 Publish to npm (First Time Setup)

1. **Update package.json** with your username/repository

2. **Login to npm**
   ```bash
   npm login
   ```

3. **Publish**
   ```bash
   cd opencode-package
   npm publish
   ```

4. **Install anywhere**
   ```bash
   npm install -g opencode-agent-config
   ```

---

## 🔄 Update Package

After making changes:

```bash
# Copy latest data from your system
bash scripts/copy-data.sh

# Update version
npm version patch  # or minor/major

# Commit and push
git add .
git commit -m "Update configurations"
git push

# Publish to npm
npm publish
```

---

## ✅ Verify Installation

```bash
# Check Qwen agents
echo "Qwen agents: $(ls -1 ~/.qwen/agents/*.md | wc -l)"

# Check Opencode agents
echo "Opencode agents: $(ls -1 ~/.opencode/agents/*.md | wc -l)"

# Check shared skills
echo "Skills: $(ls -1d ~/.agent-link/skills/*/ | wc -l)"
```

**Expected output:**
```
Qwen agents: 20
Opencode agents: 20
Skills: 37
```

---

## 🗑️ Uninstall

```bash
# Remove all configurations
rm -rf ~/.agent-link
rm -rf ~/.qwen
rm -rf ~/.opencode

# Uninstall npm package
npm uninstall -g opencode-agent-config
```

---

## 🎓 Usage

### Qwen Code (VS Code)

1. Open VS Code with Qwen extension installed
2. Open any project
3. Agents auto-load based on context
4. Start chatting!

### Opencode (CLI)

```bash
# Navigate to your project
cd /path/to/your/project

# Launch opencode
opencode
```

---

## 🐛 Troubleshooting

### Agents not loading in Qwen Code

1. Check symlinks: `ls -la ~/.qwen/agents/`
2. Restart VS Code
3. Check Qwen extension settings

### Agents not loading in Opencode

1. Check symlinks: `ls -la ~/.opencode/agents/`
2. Restart terminal
3. Run `opencode --version` to verify installation

### Tools format error

The installer automatically fixes this. Manual fix:

```bash
python3 scripts/fix-tools-format.py
```

---

## 📁 Complete Package Structure

```
opencode-package/
├── install-unified.sh      # One-line unified installer
├── install.sh              # Opencode-only installer (legacy)
├── scripts/
│   ├── install-unified.sh  # Full unified installer
│   ├── install.sh          # Opencode-only installer
│   └── copy-data.sh        # Copy existing configs
├── agents/                 # 20 agent files
├── skills/                 # 37 skill directories
├── rules/                  # Coding rules
├── workflows/              # 12 workflow files
├── .shared/                # Shared resources
├── mcp_config.json         # MCP configuration
├── package.json            # npm package
├── README.md               # Full documentation
├── QUICKSTART.md           # This file
└── LICENSE                 # MIT License
```

---

**One package, two platforms, seamless experience!** 🎉
