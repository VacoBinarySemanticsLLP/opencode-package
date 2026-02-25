# 🤖 Qwen Code + 🔷 Opencode - Unified Quick Start

## 🚀 Install on a New Machine (One Command)

### Unified Installer (Both Qwen AND Opencode)

```bash
curl -fsSL https://raw.githubusercontent.com/VacoBinarySemanticsLLP/opencode-package/main/install-unified.sh | bash
```

**This single command installs configurations for:**
- ✅ Qwen Code (VS Code extension or CLI)
- ✅ Opencode (CLI tool)
- ✅ Shared agents, skills, and workflows

### Using npm

```bash
npm install -g opencode-agent-config
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
| **Qwen Code** | `~/.qwen/skills/` | 37 skill directories (symlink) |
| **Qwen Code** | `~/.qwen/rules/` | Rule files (symlink) |
| **Qwen Code** | `~/.qwen/workflows/` | 12 workflows (symlink) |
| **Qwen Code** | `~/.qwen/mcp_config.json` | MCP config |
| **Opencode** | `~/.opencode/agents/` | 20 agent symlinks |
| **Opencode** | `~/.opencode/skills/` | 37 skill directories (symlink) |
| **Opencode** | `~/.opencode/rules/` | Rule files (symlink) |
| **Opencode** | `~/.opencode/workflows/` | 12 workflows (symlink) |
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
| `game-developer` | ✅ | ✅ | Game development |
| `debugger` | ✅ | ✅ | Debugging specialist |
| And 7 more... | ✅ | ✅ | Various specialties |

**Total: 20 agents | 37 skills | 4 rules | 12 workflows**

---

## 🔄 Update Package

### For Users (npm installed):
```bash
npm update -g opencode-agent-config
```

### For Users (script installed):
```bash
curl -fsSL https://raw.githubusercontent.com/VacoBinarySemanticsLLP/opencode-package/main/install-unified.sh | bash
```

### For Maintainers (Publishing Updates):

```bash
# 1. Copy latest data from your system
bash scripts/copy-data.sh

# 2. Update version
npm version patch    # 1.0.0 -> 1.0.1 (bug fixes)
npm version minor    # 1.0.1 -> 1.1.0 (new features)
npm version major    # 1.1.0 -> 2.0.0 (breaking changes)

# 3. Commit and push
git add .
git commit -m "Update: [description]"
git push

# 4. Publish to npm
npm publish
```

---

## ✅ Verify Installation

```bash
# Check Qwen agents
echo "Qwen agents: $(ls -1 ~/.qwen/agents/*.md 2>/dev/null | wc -l)"

# Check Qwen skills
echo "Qwen skills: $(ls -1d ~/.qwen/skills/*/ 2>/dev/null | wc -l)"

# Check Opencode agents
echo "Opencode agents: $(ls -1 ~/.opencode/agents/*.md 2>/dev/null | wc -l)"

# Check shared skills
echo "Shared skills: $(ls -1d ~/.agent-link/skills/*/ 2>/dev/null | wc -l)"
```

**Expected output:**
```
Qwen agents: 20
Qwen skills: 37
Opencode agents: 20
Shared skills: 37
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

### Qwen Code (VS Code or CLI)

1. Open VS Code with Qwen extension OR run `qwen` in terminal
2. Open any project
3. Agents auto-load based on context
4. Start chatting!

**In-chat commands:**
```
/skills     # View available skills
/help       # View all commands
```

### Opencode (CLI)

```bash
# Navigate to your project
cd /path/to/your/project

# Launch opencode
opencode
```

---

## 🐛 Troubleshooting

### Skills not found in Qwen Code

Run the fix script:
```bash
curl -fsSL https://raw.githubusercontent.com/VacoBinarySemanticsLLP/opencode-package/main/scripts/fix-skills-symlink.sh | bash
```

### Agents not loading

1. Check symlinks: `ls -la ~/.qwen/agents/`
2. Verify source: `ls -la ~/.agent-link/agents/`
3. Restart Qwen Code or terminal

### Tools format error

The installer automatically fixes this. Manual fix:
```bash
python3 scripts/fix-tools-format.py
```

---

## 📁 Complete Package Structure

```
opencode-package/
├── install-unified.sh          # One-line unified installer
├── install.sh                  # Opencode-only installer (legacy)
├── scripts/
│   ├── install-unified.sh      # Full unified installer
│   ├── install.sh              # Opencode-only installer
│   ├── copy-data.sh            # Copy existing configs
│   └── fix-skills-symlink.sh   # Fix missing symlinks
├── agents/                     # 20 agent files
├── skills/                     # 37 skill directories
├── rules/                      # 4 rule files
├── workflows/                  # 12 workflow files
├── .shared/                    # Shared resources
├── mcp_config.json             # MCP configuration
├── package.json                # npm package
├── README.md                   # Full documentation
├── QUICKSTART.md               # This file
└── LICENSE                     # MIT License
```

---

**One package, two platforms, seamless experience!** 🎉
