# Myfurina

<div align="center">

**One-click installer for AI Agent + Brain System**

Choose between **Hermes Agent** or **OpenClaw** — both fully supported.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-linux-lightgrey.svg)]()
[![Shell](https://img.shields.io/badge/shell-bash-green.svg)]()

</div>

---

## What is Myfurina?

Myfurina is a **one-click installer** that sets up a complete AI agent with:

- 🤖 **Your choice of framework** — Hermes Agent OR OpenClaw
- 🧠 **Brain System** — SOUL.md, skills, memory, user profile
- 📱 **Telegram Bot** — Chat with your agent via Telegram
- 🔧 **Direct API Config** — API key, base URL, model langsung

### Framework Comparison

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
| **Gateway** | `hermes gateway` | `openclaw gateway` |
| **Install Method** | Official install script | npm / GitHub |

## Quick Start

### Prerequisites

- Linux (Ubuntu/Debian recommended)
- Root access (sudo)
- Internet connection
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
3. **Install dependencies** — Node.js, npm, curl, git
4. **Install agent** — Downloads & installs your chosen framework
5. **API config** — Asks for:
   - API Key (required)
   - Base URL (default: `https://api.openai.com/v1`)
   - Model name (e.g., `gpt-4o`, `claude-sonnet-4`)
6. **Telegram setup** — Bot token & chat ID (required)
7. **User profile** — Name, username, language, style
8. **Brain setup** — Creates all brain files and configures the agent

## After Installation

### Start Myfurina

```bash
~/.superagent/start.sh
```

### Stop Myfurina

```bash
~/.superagent/stop.sh
```

### Edit Your Profile

```bash
nano ~/.superagent/brain/USER.md
```

## Configuration

The installer creates a config file at:
```
~/.superagent/config.env
```

### Configuration Options

- **API_KEY** — Your API key from any provider
- **BASE_URL** — API endpoint (e.g., `https://api.openai.com/v1`)
- **MODEL** — Model name (e.g., `gpt-4o`)
- **TELEGRAM_BOT_TOKEN** — Telegram bot token
- **TELEGRAM_CHAT_ID** — Your Telegram chat ID
- **AGENT_FRAMEWORK** — `Hermes` or `OpenClaw`

### Supported Providers

- **OpenAI** — `https://api.openai.com/v1` (GPT-4o, GPT-4)
- **Anthropic** — `https://api.anthropic.com/v1` (Claude 3.5, Claude 3)
- **OpenRouter** — `https://openrouter.ai/api/v1` (100+ models)
- **DeepSeek** — `https://api.deepseek.com/v1`
- **Groq** — `https://api.groq.com/v1` (Llama, Mixtral)
- **Local** — `http://localhost:11434/v1` (Ollama)

## Brain Structure

```
~/.superagent/brain/
├── SOUL.md          # Agent constitution
├── USER.md          # Your profile
├── MEMORY.md        # Long-term context
├── TOOLS.md         # Available tools
├── skills/
│   ├── m0.md        # Skill registry
│   ├── m1.md        # Monetization
│   ├── m2.md        # VPS & DevOps
│   ├── m3.md        # Content creation
│   ├── m4.md        # Automation
│   ├── m5.md        # Data & analytics
│   ├── m6.md        # API integration
│   ├── m7.md        # AI & prompts
│   ├── m8.md        # File production
│   ├── m9.md        # Web & frontend
│   ├── x1.md        # Self-improvement
│   ├── x2.md        # Deep thinking
│   └── x3.md        # Debug & error
└── memory/
    └── [date].md    # Daily logs
```

## Framework-Specific Commands

### Hermes Agent

```bash
# Start gateway
hermes gateway start

# Stop gateway
hermes gateway stop

# Check status
hermes gateway status

# View config
hermes config

# Edit config
hermes config edit

# Set custom provider
hermes config set custom_providers.myfurina.base_url "https://api.example.com/v1"
hermes config set custom_providers.myfurina.api_key "your-key"
hermes config set custom_providers.myfurina.model "model-name"
hermes config set main_provider "custom:myfurina"
hermes gateway restart
```

### OpenClaw

```bash
# Start gateway
openclaw gateway start

# Stop gateway
openclaw gateway stop

# Check status
openclaw gateway status

# View config
openclaw config file

# Set custom provider (MUST use patch for custom providers!)
cat > /tmp/openclaw-patch.json << 'EOF'
{
  "models": {
    "providers": {
      "custom": {
        "baseUrl": "https://api.example.com/v1",
        "apiKey": "your-key",
        "models": [
          {
            "id": "model-name",
            "name": "Model Name",
            "api": "openai-completions",
            "contextWindow": 128000,
            "maxTokens": 8192
          }
        ]
      }
    }
  }
}
EOF
openclaw config patch --file /tmp/openclaw-patch.json
openclaw gateway restart
```

> ⚠️ **Important:** OpenClaw custom providers MUST use `openclaw config patch --file`, NOT `openclaw config set`. The `config set` command fails for custom providers because they require a `models` array.

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

### API Key issues

```bash
# Edit config
nano ~/.superagent/config.env

# For Hermes
hermes config set custom_providers.myfurina.api_key "new-key"
hermes gateway restart

# For OpenClaw
# Create new patch file with updated key, then:
openclaw config patch --file /tmp/openclaw-patch.json
openclaw gateway restart
```

### Telegram Bot not working

```bash
# Check bot token
cat ~/.superagent/config.env | grep TELEGRAM

# Test bot connection
curl "https://api.telegram.org/bot<YOUR_TOKEN>/getMe"
```

## Advanced Usage

### Switch Framework

If you want to switch from one framework to another, re-run the installer:
```bash
sudo ./install.sh
```

It will ask you to choose a new framework and reconfigure everything.

### Custom Skills

Add new skills to:
```
~/.superagent/brain/skills/
```

Follow the format:
```markdown
# m10 — [Skill Name]
---
## Operator Profile
[Description]

## [Main Section]
[Content]

## Constraints
- [Rules]
```

### Switch Provider

Edit config and reconfigure:
```bash
# Edit config
nano ~/.superagent/config.env

# For Hermes
hermes config set custom_providers.myfurina.base_url "https://new-provider.com/v1"
hermes config set custom_providers.myfurina.api_key "new-api-key"
hermes config set custom_providers.myfurina.model "new-model"
hermes gateway restart

# For OpenClaw
# Create patch file with new provider, then:
openclaw config patch --file /tmp/openclaw-patch.json
openclaw gateway restart
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
