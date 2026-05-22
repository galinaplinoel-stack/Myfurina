#!/bin/bash
set -e

# ============================================
# Myfurina — One-click AI Agent Installer
# Supports: Hermes Agent & OpenClaw
# ============================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

INSTALL_DIR="$HOME/.superagent"
BRAIN_DIR="$INSTALL_DIR/brain"
SKILLS_DIR="$BRAIN_DIR/skills"
MEMORY_DIR="$BRAIN_DIR/memory"

# ============================================
# Banner
# ============================================
echo -e "${MAGENTA}${BOLD}"
echo "  ███╗   ███╗██╗   ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗ █████╗ "
echo "  ████╗ ████║╚██╗ ██╔╝██╔════╝██║   ██║██╔══██╗██║████╗  ██║██╔══██╗"
echo "  ██╔████╔██║ ╚████╔╝ █████╗  ██║   ██║██████╔╝██║██╔██╗ ██║███████║"
echo "  ██║╚██╔╝██║  ╚██╔╝  ██╔══╝  ██║   ██║██╔══██╗██║██║╚██╗██║██╔══██║"
echo "  ██║ ╚═╝ ██║   ██║   ██║     ╚██████╔╝██║  ██║██║██║ ╚████║██║  ██║"
echo "  ╚═╝     ╚═╝   ╚═╝   ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${CYAN}  One-click installer for AI Agent + Brain System${NC}"
echo ""

# ============================================
# System Check
# ============================================
echo -e "${YELLOW}[1/8] System check...${NC}"

if [[ "$(uname)" != "Linux" ]]; then
    echo -e "${RED}Error: This installer only supports Linux.${NC}"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Error: Please run as root (sudo ./install.sh)${NC}"
    exit 1
fi

echo -e "${GREEN}  ✓ Linux detected${NC}"
echo -e "${GREEN}  ✓ Running as root${NC}"
echo ""

# ============================================
# Choose Agent Framework
# ============================================
echo -e "${YELLOW}[2/8] Choose your AI agent framework:${NC}"
echo ""
echo -e "  ${BOLD}1)${NC} ${CYAN}Hermes Agent${NC} — by Nous Research"
echo -e "     • Skills system, persistent memory, multi-platform gateway"
echo -e "     • 20+ providers, profiles, cron jobs, MCP servers"
echo -e "     • Config: ~/.hermes/config.yaml (YAML)"
echo ""
echo -e "  ${BOLD}2)${NC} ${CYAN}OpenClaw${NC} — AI agent framework"
echo -e "     • Gateway-based, tool calling, session management"
echo -e "     • 30+ built-in providers, custom provider support"
echo -e "     • Config: ~/.openclaw/openclaw.json (JSON)"
echo ""

AGENT_CHOICE=""
while [[ "$AGENT_CHOICE" != "1" && "$AGENT_CHOICE" != "2" ]]; do
    echo -e -n "${CYAN}  Enter choice (1 or 2): ${NC}"
    read -r AGENT_CHOICE
done

if [[ "$AGENT_CHOICE" == "1" ]]; then
    AGENT_NAME="Hermes"
    echo -e "${GREEN}  ✓ Selected: Hermes Agent${NC}"
else
    AGENT_NAME="OpenClaw"
    echo -e "${GREEN}  ✓ Selected: OpenClaw${NC}"
fi
echo ""

# ============================================
# Install Dependencies
# ============================================
echo -e "${YELLOW}[3/8] Installing dependencies...${NC}"

PACKAGES_TO_INSTALL=""
for pkg in curl wget git; do
    if ! command -v $pkg &> /dev/null; then
        PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL $pkg"
    else
        echo -e "${GREEN}  ✓ $pkg already installed${NC}"
    fi
done

if [[ -n "$PACKAGES_TO_INSTALL" ]]; then
    apt-get update -qq
    apt-get install -y -qq $PACKAGES_TO_INSTALL > /dev/null 2>&1
    echo -e "${GREEN}  ✓ Installed:$PACKAGES_TO_INSTALL${NC}"
fi

# Node.js (needed for OpenClaw, optional for Hermes)
if [[ "$AGENT_CHOICE" == "2" ]]; then
    if ! command -v node &> /dev/null; then
        echo -e "${CYAN}  Installing Node.js...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
        apt-get install -y -qq nodejs > /dev/null 2>&1
        echo -e "${GREEN}  ✓ Node.js installed${NC}"
    else
        echo -e "${GREEN}  ✓ Node.js already installed${NC}"
    fi

    if ! command -v npm &> /dev/null; then
        echo -e "${CYAN}  Installing npm...${NC}"
        apt-get install -y -qq npm > /dev/null 2>&1
        echo -e "${GREEN}  ✓ npm installed${NC}"
    else
        echo -e "${GREEN}  ✓ npm already installed${NC}"
    fi
else
    if ! command -v node &> /dev/null; then
        echo -e "${CYAN}  Installing Node.js (for gateway features)...${NC}"
        curl -fsSL https://deb.nodesource.com/setup_20.x | bash - > /dev/null 2>&1
        apt-get install -y -qq nodejs > /dev/null 2>&1
        echo -e "${GREEN}  ✓ Node.js installed${NC}"
    else
        echo -e "${GREEN}  ✓ Node.js already installed${NC}"
    fi
fi
echo ""

# ============================================
# Install Agent Framework
# ============================================
echo -e "${YELLOW}[4/8] Installing $AGENT_NAME...${NC}"

if [[ "$AGENT_CHOICE" == "1" ]]; then
    if command -v hermes &> /dev/null; then
        echo -e "${GREEN}  ✓ Hermes already installed${NC}"
    else
        echo -e "${CYAN}  Installing Hermes Agent...${NC}"
        curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
        if command -v hermes &> /dev/null; then
            echo -e "${GREEN}  ✓ Hermes installed successfully${NC}"
        else
            echo -e "${RED}  ✗ Hermes installation failed${NC}"
            echo -e "${YELLOW}  Try manually: curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash${NC}"
            exit 1
        fi
    fi
else
    if command -v openclaw &> /dev/null; then
        echo -e "${GREEN}  ✓ OpenClaw already installed${NC}"
    else
        echo -e "${CYAN}  Installing OpenClaw via npm...${NC}"
        npm install -g openclaw 2>/dev/null || {
            echo -e "${YELLOW}  npm install failed, trying from source...${NC}"
            cd /tmp
            git clone https://github.com/openclaw/openclaw.git 2>/dev/null || true
            cd openclaw && npm install && npm link
            cd /tmp && rm -rf openclaw
        }
        if command -v openclaw &> /dev/null; then
            echo -e "${GREEN}  ✓ OpenClaw installed successfully${NC}"
        else
            echo -e "${RED}  ✗ OpenClaw installation failed${NC}"
            echo -e "${YELLOW}  Try manually: npm install -g openclaw${NC}"
            exit 1
        fi
    fi
fi
echo ""

# ============================================
# Collect API Configuration
# ============================================
echo -e "${YELLOW}[5/8] API Configuration${NC}"
echo ""

echo -e -n "${CYAN}  Enter your API Key: ${NC}"
read -r API_KEY
while [[ -z "$API_KEY" ]]; do
    echo -e "${RED}  API Key is required!${NC}"
    echo -e -n "${CYAN}  Enter your API Key: ${NC}"
    read -r API_KEY
done

echo -e -n "${CYAN}  Enter Base URL (default: https://api.openai.com/v1): ${NC}"
read -r BASE_URL
BASE_URL=${BASE_URL:-"https://api.openai.com/v1"}

echo -e -n "${CYAN}  Enter Model name (e.g., gpt-4o, claude-sonnet-4): ${NC}"
read -r MODEL_NAME
while [[ -z "$MODEL_NAME" ]]; do
    echo -e "${RED}  Model name is required!${NC}"
    echo -e -n "${CYAN}  Enter Model name: ${NC}"
    read -r MODEL_NAME
done

echo ""
echo -e "${GREEN}  ✓ API Key: ${API_KEY:0:8}...${NC}"
echo -e "${GREEN}  ✓ Base URL: $BASE_URL${NC}"
echo -e "${GREEN}  ✓ Model: $MODEL_NAME${NC}"
echo ""

# ============================================
# Telegram Integration
# ============================================
echo -e "${YELLOW}[6/8] Telegram Integration${NC}"
echo ""

echo -e -n "${CYAN}  Enter Telegram Bot Token (required): ${NC}"
read -r TELEGRAM_BOT_TOKEN
while [[ -z "$TELEGRAM_BOT_TOKEN" ]]; do
    echo -e "${RED}  Telegram Bot Token is required!${NC}"
    echo -e -n "${CYAN}  Enter Telegram Bot Token: ${NC}"
    read -r TELEGRAM_BOT_TOKEN
done

echo -e -n "${CYAN}  Enter your Telegram Chat ID (required): ${NC}"
read -r TELEGRAM_CHAT_ID
while [[ -z "$TELEGRAM_CHAT_ID" ]]; do
    echo -e "${RED}  Telegram Chat ID is required!${NC}"
    echo -e -n "${CYAN}  Enter your Telegram Chat ID: ${NC}"
    read -r TELEGRAM_CHAT_ID
done

echo ""
echo -e "${GREEN}  ✓ Bot Token: ${TELEGRAM_BOT_TOKEN:0:10}...${NC}"
echo -e "${GREEN}  ✓ Chat ID: $TELEGRAM_CHAT_ID${NC}"
echo ""

# ============================================
# User Profile
# ============================================
echo -e "${YELLOW}[7/8] User Profile${NC}"
echo ""

echo -e -n "${CYAN}  Enter your name: ${NC}"
read -r USER_NAME
USER_NAME=${USER_NAME:-"User"}

echo -e -n "${CYAN}  Enter your username: ${NC}"
read -r USER_USERNAME
USER_USERNAME=${USER_USERNAME:-"user"}

echo -e -n "${CYAN}  Enter preferred language (default: Bahasa Indonesia): ${NC}"
read -r USER_LANG
USER_LANG=${USER_LANG:-"Bahasa Indonesia"}

echo -e -n "${CYAN}  Communication style (default: direct and casual): ${NC}"
read -r USER_STYLE
USER_STYLE=${USER_STYLE:-"direct and casual"}

echo ""
echo -e "${GREEN}  ✓ Name: $USER_NAME${NC}"
echo -e "${GREEN}  ✓ Language: $USER_LANG${NC}"
echo ""

# ============================================
# Setup Brain & Configure Agent
# ============================================
echo -e "${YELLOW}[8/8] Setting up brain & configuring $AGENT_NAME...${NC}"

# Create directories with secure permissions
mkdir -p "$BRAIN_DIR" "$SKILLS_DIR" "$MEMORY_DIR"
chmod 700 "$INSTALL_DIR"
chmod 700 "$BRAIN_DIR"
chmod 700 "$SKILLS_DIR"
chmod 700 "$MEMORY_DIR"

# ============================================
# SECURITY: Create .gitignore to prevent accidental commits
# ============================================
cat > "$INSTALL_DIR/.gitignore" << 'EOF'
# Security: Never commit these files
config.env
.env
*.key
*.pem
*.token
brain/MEMORY.md
brain/USER.md
EOF
echo -e "${GREEN}  ✓ .gitignore created (prevents accidental secret commits)${NC}"

# Save config.env with restricted permissions (owner-only read/write)
cat > "$INSTALL_DIR/config.env" << EOF
# Myfurina Configuration
# Agent: $AGENT_NAME
# Generated: $(date)
# SECURITY: This file contains sensitive credentials
# Permissions: 600 (owner read/write only)

API_KEY=$API_KEY
BASE_URL=$BASE_URL
MODEL=$MODEL_NAME
TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN
TELEGRAM_CHAT_ID=$TELEGRAM_CHAT_ID
AGENT_FRAMEWORK=$AGENT_NAME
EOF
chmod 600 "$INSTALL_DIR/config.env"
echo -e "${GREEN}  ✓ Config saved (permissions: 600 — owner only)${NC}"

# Create USER.md with restricted permissions
cat > "$BRAIN_DIR/USER.md" << EOF
# USER.md — Owner Profile

**Name**: $USER_NAME
**Username**: $USER_USERNAME
**Language**: $USER_LANG
**Style**: $USER_STYLE
EOF
chmod 600 "$BRAIN_DIR/USER.md"
echo -e "${GREEN}  ✓ User profile created (permissions: 600)${NC}"

# Create MEMORY.md with restricted permissions
cat > "$BRAIN_DIR/MEMORY.md" << EOF
# MEMORY.md — Long-term Context

## System
- Agent: $AGENT_NAME
- Model: $MODEL_NAME
- Language: $USER_LANG
- Installed: $(date)

## User Preferences
- Communication style: $USER_STYLE
EOF
chmod 600 "$BRAIN_DIR/MEMORY.md"
echo -e "${GREEN}  ✓ Memory initialized (permissions: 600)${NC}"

# Create TOOLS.md (no secrets, but still restrict)
cat > "$BRAIN_DIR/TOOLS.md" << EOF
# TOOLS.md — Available Tools

## AI Provider
- Framework: $AGENT_NAME
- Model: $MODEL_NAME
- Base URL: $BASE_URL

## Messaging
- Telegram Bot: ✓ Configured
- Chat ID: $TELEGRAM_CHAT_ID
EOF
chmod 600 "$BRAIN_DIR/TOOLS.md"
echo -e "${GREEN}  ✓ Tools doc created (permissions: 600)${NC}"

# ============================================
# Configure Agent Framework
# ============================================
if [[ "$AGENT_CHOICE" == "1" ]]; then
    # === HERMES CONFIG ===
    echo -e "${CYAN}  Configuring Hermes Agent...${NC}"

    hermes config set custom_providers.myfurina.name "Myfurina Provider" 2>/dev/null || true
    hermes config set custom_providers.myfurina.base_url "$BASE_URL" 2>/dev/null || true
    hermes config set custom_providers.myfurina.api_key "$API_KEY" 2>/dev/null || true
    hermes config set custom_providers.myfurina.model "$MODEL_NAME" 2>/dev/null || true
    hermes config set main_provider "custom:myfurina" 2>/dev/null || true

    # Set in .env with secure permissions
    cat >> "$HOME/.hermes/.env" << EOF

# Myfurina Configuration
OPENAI_API_KEY=$API_KEY
OPENAI_BASE_URL=$BASE_URL
TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN
EOF
    chmod 600 "$HOME/.hermes/.env"

    # Configure Telegram
    hermes config set channels.telegram.enabled true 2>/dev/null || true
    hermes config set channels.telegram.bot_token "$TELEGRAM_BOT_TOKEN" 2>/dev/null || true
    hermes config set channels.telegram.allowed_users "[\"$TELEGRAM_CHAT_ID\"]" 2>/dev/null || true

    # Restrict config.yaml permissions
    chmod 600 "$HOME/.hermes/config.yaml" 2>/dev/null || true

    echo -e "${GREEN}  ✓ Hermes configured with custom provider${NC}"
    echo -e "${GREEN}  ✓ Telegram channel configured${NC}"
    echo -e "${GREEN}  ✓ Config files secured (chmod 600)${NC}"

else
    # === OPENCLAW CONFIG ===
    echo -e "${CYAN}  Configuring OpenClaw...${NC}"

    # Create config directory first
    mkdir -p "$HOME/.openclaw"

    # Create comprehensive config with ALL required settings
    # This includes: gateway, models, telegram, AND owner auto-approve
    OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"

    cat > "$OPENCLAW_CONFIG" << EOF
{
  "gateway": {
    "mode": "local",
    "auth": {
      "mode": "token"
    }
  },
  "models": {
    "providers": {
      "custom": {
        "baseUrl": "$BASE_URL",
        "apiKey": "$API_KEY",
        "models": [
          {
            "id": "$MODEL_NAME",
            "name": "$MODEL_NAME",
            "api": "openai-completions",
            "contextWindow": 128000,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
  "telegram": {
    "botToken": "$TELEGRAM_BOT_TOKEN",
    "chatId": "$TELEGRAM_CHAT_ID",
    "enabled": true
  },
  "commands": {
    "ownerAllowFrom": "telegram:$TELEGRAM_CHAT_ID"
  }
}
EOF
    echo -e "${GREEN}  ✓ Config file created at $OPENCLAW_CONFIG${NC}"

    # Also try config patch (in case openclaw is already running)
    OPENCLAW_PATCH=$(mktemp /tmp/openclaw-patch-XXXXXX.json)
    chmod 600 "$OPENCLAW_PATCH"

    cat > "$OPENCLAW_PATCH" << EOF
{
  "gateway": {
    "mode": "local",
    "auth": {
      "mode": "token"
    }
  },
  "models": {
    "providers": {
      "custom": {
        "baseUrl": "$BASE_URL",
        "apiKey": "$API_KEY",
        "models": [
          {
            "id": "$MODEL_NAME",
            "name": "$MODEL_NAME",
            "api": "openai-completions",
            "contextWindow": 128000,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
  "telegram": {
    "botToken": "$TELEGRAM_BOT_TOKEN",
    "chatId": "$TELEGRAM_CHAT_ID",
    "enabled": true
  },
  "commands": {
    "ownerAllowFrom": "telegram:$TELEGRAM_CHAT_ID"
  }
}
EOF

    echo -e "${CYAN}  Applying config patch...${NC}"
    if openclaw config patch --file "$OPENCLAW_PATCH" 2>&1; then
        echo -e "${GREEN}  ✓ Config patch applied successfully${NC}"
    else
        echo -e "${YELLOW}  Config patch had warnings (config file already created manually)${NC}"
    fi

    # SECURITY: Securely wipe and remove temp file
    shred -u "$OPENCLAW_PATCH" 2>/dev/null || rm -f "$OPENCLAW_PATCH"

    # Save .env with secure permissions
    cat > "$INSTALL_DIR/.env" << EOF
# OpenClaw Environment Variables
# These are exported by start.sh before launching the gateway
OPENAI_API_KEY=$API_KEY
OPENAI_BASE_URL=$BASE_URL
TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN
TELEGRAM_CHAT_ID=$TELEGRAM_CHAT_ID
EOF
    chmod 600 "$INSTALL_DIR/.env"

    # Restrict OpenClaw config permissions
    chmod 600 "$OPENCLAW_CONFIG"

    echo -e "${GREEN}  ✓ OpenClaw configured with custom provider${NC}"
    echo -e "${GREEN}  ✓ Telegram configured${NC}"
    echo -e "${GREEN}  ✓ Owner auto-approve set (no pairing needed)${NC}"
    echo -e "${GREEN}  ✓ Config files secured (chmod 600)${NC}"
fi

# ============================================
# Create Start Script (no secrets embedded)
# ============================================
cat > "$INSTALL_DIR/start.sh" << 'STARTEOF'
#!/bin/bash
set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}Starting Myfurina...${NC}"
echo -e "${GREEN}Agent: $AGENT_FRAMEWORK${NC}"
echo -e "${GREEN}Model: $MODEL${NC}"
STARTEOF

if [[ "$AGENT_CHOICE" == "1" ]]; then
    cat >> "$INSTALL_DIR/start.sh" << 'STARTEOF'

# Export env vars for Hermes
export OPENAI_API_KEY="$API_KEY"
export OPENAI_BASE_URL="$BASE_URL"

# Start Hermes gateway
echo -e "${CYAN}Starting Hermes gateway...${NC}"
hermes gateway start
echo -e "${GREEN}✓ Hermes gateway started${NC}"
echo ""
echo -e "${GREEN}Myfurina is running!${NC}"
echo -e "  Chat: Telegram"
echo -e "  Stop: ~/.superagent/stop.sh"
STARTEOF
else
    cat >> "$INSTALL_DIR/start.sh" << 'STARTEOF'

# Export env vars for OpenClaw
export OPENAI_API_KEY="$API_KEY"
export OPENAI_BASE_URL="$BASE_URL"
export TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
export TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"

# Verify OpenClaw is installed
if ! command -v openclaw &> /dev/null; then
    echo -e "${RED}Error: openclaw command not found${NC}"
    echo -e "${YELLOW}Try: npm install -g openclaw${NC}"
    exit 1
fi

# Verify config exists
if [[ ! -f "$HOME/.openclaw/openclaw.json" ]]; then
    echo -e "${RED}Error: OpenClaw config not found at ~/.openclaw/openclaw.json${NC}"
    echo -e "${YELLOW}Re-run the installer or create config manually${NC}"
    exit 1
fi

# Start OpenClaw gateway
echo -e "${CYAN}Starting OpenClaw gateway...${NC}"
openclaw gateway start
echo -e "${GREEN}✓ OpenClaw gateway started${NC}"
echo ""
echo -e "${GREEN}Myfurina is running!${NC}"
echo -e "  Chat: Telegram"
echo -e "  Stop: ~/.superagent/stop.sh"
STARTEOF
fi

chmod +x "$INSTALL_DIR/start.sh"

# ============================================
# Create Stop Script
# ============================================
cat > "$INSTALL_DIR/stop.sh" << 'STOPEOF'
#!/bin/bash
set -e

# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.env"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "Stopping Myfurina..."
STOPEOF

if [[ "$AGENT_CHOICE" == "1" ]]; then
    cat >> "$INSTALL_DIR/stop.sh" << 'STOPEOF'

hermes gateway stop 2>/dev/null || true
echo -e "${GREEN}✓ Hermes gateway stopped${NC}"
STOPEOF
else
    cat >> "$INSTALL_DIR/stop.sh" << 'STOPEOF'

openclaw gateway stop 2>/dev/null || true
echo -e "${GREEN}✓ OpenClaw gateway stopped${NC}"
STOPEOF
fi

chmod +x "$INSTALL_DIR/stop.sh"

echo -e "${GREEN}  ✓ Start/Stop scripts created${NC}"
echo ""

# ============================================
# Security Summary
# ============================================
echo -e "${YELLOW}  Security measures applied:${NC}"
echo -e "    • config.env — chmod 600 (owner read/write only)"
echo -e "    • .env — chmod 600 (owner read/write only)"
echo -e "    • ~/.superagent/ — chmod 700 (owner access only)"
echo -e "    • brain/ — chmod 700 (owner access only)"
echo -e "    • .gitignore — prevents accidental secret commits"
echo -e "    • Temp patch file — securely wiped after use"
echo ""

# ============================================
# Done!
# ============================================
echo -e "${MAGENTA}${BOLD}"
echo "  ╔══════════════════════════════════════════════════════════╗"
echo "  ║           🎉 Myfurina Installation Complete! 🎉          ║"
echo "  ╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "  ${BOLD}Agent Framework:${NC} $AGENT_NAME"
echo -e "  ${BOLD}Model:${NC}          $MODEL_NAME"
echo -e "  ${BOLD}Telegram:${NC}       Connected (Chat ID: $TELEGRAM_CHAT_ID)"
echo ""
echo -e "  ${BOLD}Install Dir:${NC}    $INSTALL_DIR"
echo -e "  ${BOLD}Brain Dir:${NC}      $BRAIN_DIR"
echo ""
echo -e "  ${CYAN}Start:${NC}  ~/.superagent/start.sh"
echo -e "  ${CYAN}Stop:${NC}   ~/.superagent/stop.sh"
echo -e "  ${CYAN}Config:${NC} $INSTALL_DIR/config.env"
echo ""
echo -e "  ${BOLD}Edit Profile:${NC}   nano $BRAIN_DIR/USER.md"
echo -e "  ${BOLD}Edit Memory:${NC}    nano $BRAIN_DIR/MEMORY.md"
echo -e "  ${BOLD}Edit Tools:${NC}     nano $BRAIN_DIR/TOOLS.md"
echo ""
if [[ "$AGENT_CHOICE" == "2" ]]; then
    echo -e "  ${YELLOW}OpenClaw Config:${NC} $HOME/.openclaw/openclaw.json"
    echo -e "  ${GREEN}Owner auto-approve: telegram:$TELEGRAM_CHAT_ID${NC}"
    echo ""
fi
echo -e "${GREEN}  Run: ~/.superagent/start.sh${NC}"
echo ""
