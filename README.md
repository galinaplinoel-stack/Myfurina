# Myfurina

<div align="center">

**One-click AI Agent Installer + Multi-Agent Orchestration**

Choose between **Hermes Agent** or **OpenClaw** — both fully supported.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-linux-lightgrey.svg)]()
[![Shell](https://img.shields.io/badge/shell-bash-green.svg)]()

</div>

---

## What is Myfurina?

Myfurina is a **complete AI agent management system**:

- 🤖 **One-click installer** — Hermes Agent or OpenClaw
- 🧠 **Brain System** — SOUL.md, skills, memory, user profile
- 📱 **Telegram Integration** — Chat with your agent via Telegram
- 🔀 **Multi-Agent Orchestration** — Run multiple agents simultaneously
- 📊 **Monitoring Dashboard** — Real-time web dashboard for all agents
- 🔒 **Security Hardened** — Proper file permissions, .gitignore, secure temp files

## Quick Start

### Prerequisites

- Linux (Ubuntu/Debian recommended)
- Root access (sudo)
- API Key (from any provider)
- Telegram Bot Token & Chat ID

### Installation

```bash
# Clone the repository
git clone https://github.com/galinaplinoel-stack/Myfurina.git
cd Myfurina

# Make installer executable
chmod +x install.sh

# Run installer
sudo ./install.sh
```

### What Happens During Installation?

1. **System check** — Verifies Linux and root access
2. **Choose framework** — Pick Hermes Agent or OpenClaw
3. **Install dependencies** — Node.js, npm, curl, git, python3
4. **Install agent** — Downloads & installs your chosen framework
5. **API config** — API key, base URL, model name
6. **Telegram setup** — Bot token & chat ID (required)
7. **User profile** — Name, username, language, style
8. **Brain setup** — Creates all brain files and configures the agent

## Multi-Agent Orchestration

Run multiple AI agents on the same VPS, each with its own:
- Configuration
- Telegram bot
- Model/provider
- Skills and memory

### Orchestrator Commands

```bash
# Install orchestrator (after running install.sh)
sudo cp myfurina /usr/local/bin/
sudo chmod +x /usr/local/bin/myfurina

# Create a new agent
myfurina create my-agent

# Start an agent
myfurina start my-agent

# Stop an agent
myfurina stop my-agent

# Restart an agent
myfurina restart my-agent

# View agent status
myfurina status my-agent

# List all agents
myfurina list

# View agent logs
myfurina logs my-agent

# Delete an agent
myfurina delete my-agent

# Start monitoring dashboard
myfurina dashboard
```

### Example: Running Multiple Agents

```bash
# Create agent 1: Customer Support
myfurina create support-bot
# Enter: GPT-4o, Telegram Bot A

# Create agent 2: Content Writer
myfurina create content-bot
# Enter: Claude Sonnet, Telegram Bot B

# Create agent 3: DevOps Assistant
myfurina create devops-bot
# Enter: DeepSeek, Telegram Bot C

# Start all agents
myfurina start support-bot
myfurina start content-bot
myfurina start devops-bot

# Check status
myfurina status
```

## Monitoring Dashboard

Real-time web dashboard to monitor all your agents.

```bash
# Start dashboard
myfurina dashboard

# Access at: http://localhost:8080
```

### Dashboard Features

- **Agent Overview** — Total, running, and stopped agents
- **Status Indicators** — Real-time running/stopped status
- **Agent Cards** — Model, chat ID, profile, creation date
- **Quick Actions** — Start, stop, view logs
- **Auto-refresh** — Updates every 10 seconds
- **Responsive** — Works on desktop and mobile

## Configuration

### Single Agent (After install.sh)

Config file: `~/.superagent/config.env`

- **API_KEY** — Your API key
- **BASE_URL** — API endpoint
- **MODEL** — Model name
- **TELEGRAM_BOT_TOKEN** — Telegram bot token
- **TELEGRAM_CHAT_ID** — Your Telegram chat ID

### Multi-Agent (Orchestrator)

Each agent uses a Hermes profile:

```bash
# View profile config
hermes -p <agent-name> config

# Edit profile config
hermes -p <agent-name> config edit

# Profile directory
~/.hermes/profiles/<agent-name>/
├── config.yaml
├── .env
├── brain/
├── skills/
├── sessions/
└── logs/
```

## Framework Comparison

| Feature | Hermes Agent | OpenClaw |
|---------|-------------|----------|
| **Config Format** | YAML (`~/.hermes/config.yaml`) | JSON (`~/.openclaw/openclaw.json`) |
| **Custom Providers** | `hermes config set` | `openclaw config patch --file` |
| **Providers** | 20+ built-in | 30+ built-in |
| **Skills System** | ✅ Built-in (curator, hub) | ❌ Manual |
| **Persistent Memory** | ✅ Multi-backend | ❌ Basic |
| **Profiles** | ✅ Multiple profiles | ❌ Single |
| **Cron Jobs** | ✅ Built-in scheduler | ❌ External |
| **MCP Servers** | ✅ Native support | ✅ Native support |

## Supported Providers

- **OpenAI** — `https://api.openai.com/v1` (GPT-4o, GPT-4)
- **Anthropic** — `https://api.anthropic.com/v1` (Claude 3.5, Claude 3)
- **OpenRouter** — `https://openrouter.ai/api/v1` (100+ models)
- **DeepSeek** — `https://api.deepseek.com/v1`
- **Groq** — `https://api.groq.com/v1` (Llama, Mixtral)
- **Gemini** — `https://generativelanguage.googleapis.com/v1`
- **Local** — `http://localhost:11434/v1` (Ollama)

## Brain Architecture

```
~/.superagent/brain/
├── SOUL.md          # Agent constitution
├── USER.md          # Your profile
├── MEMORY.md        # Long-term context
├── TOOLS.md         # Available tools
├── skills/
│   ├── m0.md        # Skill registry
│   ├── m1-m9.md     # Domain skills
│   └── x1-x3.md     # Meta skills
└── memory/
    └── [date].md    # Daily logs
```

## Commands Reference

### After Installation

```bash
# Start agent
~/.superagent/start.sh

# Stop agent
~/.superagent/stop.sh

# Edit config
nano ~/.superagent/config.env
```

### Hermes-Specific

```bash
# Gateway
hermes gateway start/stop/status/restart

# Config
hermes config edit
hermes config set KEY VALUE

# Profiles
hermes profile list/create/use/delete
```

### OpenClaw-Specific

```bash
# Gateway
openclaw gateway start/stop/status

# Config (custom providers MUST use patch)
openclaw config patch --file patch.json
```

## Security

- All config files: `chmod 600` (owner read/write only)
- All directories: `chmod 700` (owner access only)
- `.gitignore` prevents accidental secret commits
- Temp files securely wiped (`shred -u`)
- No secrets in start/stop scripts

## Troubleshooting

### Agent not responding

```bash
# Check config
cat ~/.superagent/config.env

# For Hermes
hermes gateway status
hermes gateway restart

# For OpenClaw
openclaw gateway status
openclaw gateway restart
```

### Multi-agent issues

```bash
# Check profile exists
hermes profile list

# Check profile config
hermes -p <name> config

# Check profile gateway
hermes -p <name> gateway status

# View logs
myfurina logs <name>
```

### Telegram Bot not working

```bash
# Test bot connection
curl "https://api.telegram.org/bot<YOUR_TOKEN>/getMe"

# Check config (Hermes)
cat ~/.hermes/config.yaml | grep -A5 "telegram:"
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License

---

<div align="center">

**Myfurina — Built for execution. 🔥**

[GitHub](https://github.com/galinaplinoel-stack/Myfurina) • [Issues](https://github.com/galinaplinoel-stack/Myfurina/issues)

</div>
